//
//  YHPreSelectAssetCell.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/6.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

static const CGFloat YHPreSelectAssetCellWidth = 49;

@interface YAHPreSelectAssetCell : UICollectionViewCell

@property (nonatomic, strong) ALAsset *asset;

@end
