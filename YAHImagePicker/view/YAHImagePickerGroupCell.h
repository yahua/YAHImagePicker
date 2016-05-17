//
//  YHImagePickerGroupCell.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

static const CGFloat YHImagePickerGroupCellHeight = 80.0f;

@interface YAHImagePickerGroupCell : UITableViewCell

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end
