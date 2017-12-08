//
//  YAHPhotoModel.h
//  ImagePickerDemo
//
//  Created by yahua on 2017/12/8.
//  Copyright © 2017年 wangsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface YAHPhotoModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *thumbImage;

@end
