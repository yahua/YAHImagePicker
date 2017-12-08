//
//  ViewController.m
//  ImagePickerDemo
//
//  Created by yahua on 16/5/17.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "ViewController.h"

#import "YAHImagePickerRootViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSArray *selectAssets;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 50, 200, 100);
    [button setTitle:@"相册" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(50, 200, 200, 100);
    [button2 setTitle:@"视频" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(clickDone2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

- (void)clickDone {
    
    YAHImagePickerRootViewController *picker = [[YAHImagePickerRootViewController alloc] init];
    picker.selectAssets = self.selectAssets;
    picker.imagePickerFilterType = YHImagePickerFilterTypePhotos;
    picker.dismissBlock = ^(YAHImagePickerRootViewController *vc) {
        
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    __weak __typeof(self)weakSelf = self;
    picker.sucessBlock = ^(YAHImagePickerRootViewController *vc, NSArray *assets) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.selectAssets = [assets copy];
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)clickDone2 {
    
    YAHImagePickerRootViewController *picker = [[YAHImagePickerRootViewController alloc] init];
    picker.imagePickerFilterType = YHImagePickerFilterTypeVideos;
    picker.dismissBlock = ^(YAHImagePickerRootViewController *vc) {
        
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    };
    picker.sucessBlock = ^(YAHImagePickerRootViewController *vc, NSArray *assets) {
        
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    };
    [self.view addSubview:picker.view];
    [self addChildViewController:picker];
}


@end
