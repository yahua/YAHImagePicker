//
//  YHImagePickerRootViewController.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHImagePickerRootViewController.h"
#import "YAHImagePickerViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface YAHImagePickerRootViewController ()

@property (nonatomic, strong) UINavigationController *nav;

@end

@implementation YAHImagePickerRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    YAHImagePickerViewController *vc = [[YAHImagePickerViewController alloc] init];
    __weak __typeof(self)weakSelf = self;
    vc.dismissBlock = ^() {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.dismissBlock) {
            strongSelf.dismissBlock(strongSelf);
        }else if ([strongSelf.delegate respondsToSelector:@selector(yhImagePickerRootViewControllerDidCancel:)]) {
            [strongSelf.delegate yhImagePickerRootViewControllerDidCancel:strongSelf];
        }
    };
    vc.failureBlock = ^(NSError *error) {
      
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.failureBlock) {
            strongSelf.failureBlock(strongSelf, error);
        }else if ([strongSelf.delegate respondsToSelector:@selector(yhImagePickerRootViewController:failedWithError:)]) {
            [strongSelf.delegate yhImagePickerRootViewController:strongSelf failedWithError:error];
        }
    };
    vc.sucessBlock = ^(NSArray *assets) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.sucessBlock) {
            strongSelf.sucessBlock(strongSelf, assets);
        }else if ([strongSelf.delegate respondsToSelector:@selector(yhImagePickerRootViewController:didSelectAssets:)]) {
            [strongSelf.delegate yhImagePickerRootViewController:strongSelf didSelectAssets:assets];
        }
    };
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.view addSubview:self.nav.view];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Custom Accessors

- (void)setSelectAssets:(NSArray *)selectAssets {
    
    _selectAssets = selectAssets;
    [[YAHImagePeckerAssetsData shareInstance] addAssetWithArray:selectAssets];
}

- (void)setMaximumNumberOfSelection:(NSInteger)maximumNumberOfSelection {
    
    _maximumNumberOfSelection = maximumNumberOfSelection;
    [YAHImagePeckerAssetsData shareInstance].maximumNumberOfSelection = maximumNumberOfSelection;
}

- (void)setImagePickerFilterType:(YAHImagePickerFilterType)imagePickerFilterType {
    
    _imagePickerFilterType = imagePickerFilterType;
    [YAHImagePeckerAssetsData shareInstance].filterType = imagePickerFilterType;
}

@end


@implementation YAHImagePickerRootViewController (camera)

+ (BOOL)isCameraDeviceAvailable {
    
    BOOL isHaveCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isHaveCamera) {
        isHaveCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    }
    return isHaveCamera;
}

+ (BOOL)canAccessCamera {
    
    // iOS7可以禁用相机，需要相机权限判断，判断相机是否开启;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        if((NSInteger)[AVCaptureDevice performSelector:(@selector(authorizationStatusForMediaType:)) withObject:AVMediaTypeVideo] == AVAuthorizationStatusDenied){
            return NO;
        }
    }
    
    return YES;
    
    //提示
//    NSString *appName = NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil);
//    NSString *message = [NSString stringWithFormat:@"请在iPad的\"设置-隐私-相机\"中允许%@访问您的相机",appName];
//    [[[UIAlertView alloc] initWithTitle:@"相机被禁用"
//                                message:message
//                               delegate:nil
//                      cancelButtonTitle:@"确定"
//                      otherButtonTitles:nil] show];
}

@end