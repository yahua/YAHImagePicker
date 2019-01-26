//
//  YAHPhotoTools.h
//  ImagePickerDemo
//
//  Created by yahua on 2017/12/7.
//  Copyright © 2017年 wangsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface YAHPhotoTools : NSObject

/**
 相册名称转换
 */
+ (NSString *)transFormPhotoTitle:(NSString *)englishName;

/**
 根据PHAsset对象获取照片信息   此方法会回调多次
 */
+ (PHImageRequestID)getPhotoForPHAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image,NSDictionary *info))completion;

/**
 根据PHAsset对象获取视频信息   
 */
+ (PHImageRequestID)getAVAssetWithPHAsset:(PHAsset *)asset progressHandler:(void (^)(PHAsset *asset, double progress))progressHandler completion:(void(^)(PHAsset *asset, AVAsset *avasset))completion failed:(void(^)(PHAsset *asset, NSDictionary *info))failed;

@end
