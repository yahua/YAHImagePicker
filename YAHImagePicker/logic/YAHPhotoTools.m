//
//  YAHPhotoTools.m
//  ImagePickerDemo
//
//  Created by yahua on 2017/12/7.
//  Copyright © 2017年 wangsw. All rights reserved.
//

#import "YAHPhotoTools.h"

@implementation YAHPhotoTools

+ (PHImageRequestID)getPhotoForPHAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image,NSDictionary *info))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        
        if (downloadFinined && completion && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result,info);
            });
        }
    }];
}

/**
 相册名称转换
 */
+ (NSString *)transFormPhotoTitle:(NSString *)englishName {
    NSString *photoName;
    if ([englishName isEqualToString:@"Bursts"]) {
        photoName = @"连拍快照";
    }else if([englishName isEqualToString:@"Recently Added"]){
        photoName = @"最近添加";
    }else if([englishName isEqualToString:@"Screenshots"]){
        photoName = @"屏幕快照";
    }else if([englishName isEqualToString:@"Camera Roll"]){
        photoName = @"相机胶卷";
    }else if([englishName isEqualToString:@"Selfies"]){
        photoName = @"自拍";
    }else if([englishName isEqualToString:@"My Photo Stream"]){
        photoName = @"我的照片流";
    }else if([englishName isEqualToString:@"Videos"]){
        photoName = @"视频";
    }else if([englishName isEqualToString:@"All Photos"]){
        photoName = @"所有照片";
    }else if([englishName isEqualToString:@"Slo-mo"]){
        photoName = @"慢动作";
    }else if([englishName isEqualToString:@"Recently Deleted"]){
        photoName = @"最近删除";
    }else if([englishName isEqualToString:@"Favorites"]){
        photoName = @"个人收藏";
    }else if([englishName isEqualToString:@"Panoramas"]){
        photoName = @"全景照片";
    }else {
        photoName = englishName;
    }
    return photoName;
}

+ (PHImageRequestID)getAVAssetWithPHAsset:(PHAsset *)paAsset progressHandler:(void (^)(PHAsset *asset, double progress))progressHandler completion:(void(^)(PHAsset *asset, AVAsset *avasset))completion failed:(void(^)(PHAsset *asset, NSDictionary *info))failed {
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = NO;
    PHImageRequestID requestId = 0;
    requestId = [[PHImageManager defaultManager] requestAVAssetForVideo:paAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(paAsset,asset);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue] && ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]) {
                PHImageRequestID cloudRequestId = 0;
                PHVideoRequestOptions *cloudOptions = [[PHVideoRequestOptions alloc] init];
                cloudOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
                cloudOptions.networkAccessAllowed = YES;
                cloudOptions.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(paAsset,progress);
                        }
                    });
                };
                cloudRequestId = [[PHImageManager defaultManager] requestAVAssetForVideo:paAsset options:cloudOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && asset) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(paAsset,asset);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
                                //model.iCloudDownloading = NO;
                            }
                            if (failed) {
                                failed(paAsset,info);
                            }
                        });
                    }
                }];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    model.iCloudRequestID = cloudRequestId;
//                    if (startRequestIcloud) {
//                        startRequestIcloud(model,cloudRequestId);
//                    }
//                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
                        //model.iCloudDownloading = NO;
                    }
                    if (failed) {
                        failed(paAsset,info);
                    }
                });
            }
        }
    }];
    return requestId;
}

@end
