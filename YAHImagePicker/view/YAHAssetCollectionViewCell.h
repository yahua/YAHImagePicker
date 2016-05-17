//
//  YHAssetCollectionViewCell.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YAHImagePickerDefines.h"

#define kThumbnailNumber  (KOrientationMaskPortrait?4:7)
#define kThumbnailLength  ((SCREEN_WIDTH-2*(kThumbnailNumber-1))/kThumbnailNumber)

@interface YAHAssetCollectionViewCell : UICollectionViewCell

- (void)bind:(ALAsset *)asset;

@end
