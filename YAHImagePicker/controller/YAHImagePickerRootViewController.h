//
//  YHImagePickerRootViewController.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAHImagePeckerAssetsData.h"

@class YAHImagePickerRootViewController;
@protocol YAHImagePickerRootViewControllerDelegate <NSObject>

- (void)yhImagePickerRootViewControllerDidCancel:(YAHImagePickerRootViewController *)picker;

- (void)yhImagePickerRootViewController:(YAHImagePickerRootViewController *)picker didSelectAssets:(NSArray *)assets;

- (void)yhImagePickerRootViewController:(YAHImagePickerRootViewController *)picker failedWithError:(NSError *)error;

@end

@interface YAHImagePickerRootViewController : UIViewController

@property (nonatomic, weak) id<YAHImagePickerRootViewControllerDelegate> delegate;
@property (nonatomic, copy) void(^dismissBlock)(YAHImagePickerRootViewController *vc);
@property (nonatomic, copy) void(^failureBlock)(YAHImagePickerRootViewController *vc, NSError *error);
@property (nonatomic, copy) void(^sucessBlock)(YAHImagePickerRootViewController *vc, NSArray<YAHPhotoModel *> *assets);

/**
 *  选中的asset（外部传入）， 读取的时候不是这个 使用sucessBlock回调读取选中的assets
 */
@property (nonatomic, copy) NSArray<YAHPhotoModel *> *selectAssets;
/**
 *  最大选取个数   默认9个
 */
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
/**
 *  照片过滤类型，默认为图片
 */
@property (nonatomic, assign) YAHImagePickerFilterType imagePickerFilterType;

@end

@interface YAHImagePickerRootViewController (camera)

+ (BOOL)isCameraDeviceAvailable;

/**
 *  相机是否被禁止
 */
+ (BOOL)canAccessCamera;

@end
