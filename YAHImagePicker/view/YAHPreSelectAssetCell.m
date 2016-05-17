//
//  YHPreSelectAssetCell.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/6.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHPreSelectAssetCell.h"

@interface YAHPreSelectAssetCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YAHPreSelectAssetCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Create a image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.layer.cornerRadius = 3;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

#pragma mark - setter
- (void)setAsset:(ALAsset *)asset {
    
    if (_asset != asset) {
        _asset = asset;
        
        // Update view
        UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
        self.imageView.image = image;
    }
}

@end
