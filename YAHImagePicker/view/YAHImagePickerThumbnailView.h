//
//  YHImagePickerThumbnailView.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, YAHThumbnailType) {
    ThumbnailSingle,	// 单图模式
    ThumbnailMultiple	// 多图模式（目前为3张）
};

@interface YAHImagePickerThumbnailView : UIView

/**
 *    缩略图模式，默认为多图模式
 */
@property (nonatomic, assign) YAHThumbnailType thumbnailMode;

/**
 *    相册，用以多图模式或者单图模式，时间轴上取当前时间往前的若干张图片
 */
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

/**
 *    照片信息，用以单图模式
 */
@property (nonatomic, strong) ALAsset *asset;

@end
