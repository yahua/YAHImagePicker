//
//  YHImagePickerThumbnailView.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHImagePickerThumbnailView.h"

@interface YAHImagePickerThumbnailView ()

@property (nonatomic, copy) NSArray *thumbnailImages;

@end

@implementation YAHImagePickerThumbnailView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.thumbnailMode = ThumbnailMultiple;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    return CGSizeMake(70.0, 74.0);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    if (self.thumbnailMode == ThumbnailMultiple) {
        if ([self.thumbnailImages count] >= 3) {
            UIImage *thumbnailImage = [self.thumbnailImages objectAtIndex:2];
            
            CGRect thumbnailImageRect = CGRectMake(4.0, 0, 62.0, 62.0);
            CGContextFillRect(context, thumbnailImageRect);
            [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
        }
        
        if ([self.thumbnailImages count] >= 2) {
            UIImage *thumbnailImage = [self.thumbnailImages objectAtIndex:1];
            
            CGRect thumbnailImageRect = CGRectMake(2.0, 2.0, 66.0, 66.0);
            CGContextFillRect(context, thumbnailImageRect);
            [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
        }
    }
    
    if ([self.thumbnailImages count] >= 1) {
        UIImage *thumbnailImage = [self.thumbnailImages objectAtIndex:0];
        
        CGRect thumbnailImageRect = CGRectMake(0, 4.0, 70.0, 70.0);
        CGContextFillRect(context, thumbnailImageRect);
        [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
    }
}

#pragma mark - Custom Accessors

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup {
    
    if (!assetsGroup) {
        return;
    }
    
    _assetsGroup = assetsGroup;
    
    // 顺序将从最后一张开始计算（即显示最近一张照片开始，底下依次叠加最近第二张、第三张照片）
    NSInteger count = [assetsGroup numberOfAssets];
    NSIndexSet *indexs = nil;
    if (count >= 3) {
        indexs = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(count-3, 3)];
    } else {
        indexs = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count)];
    }
    
    // Extract three thumbnail images
    NSMutableArray *thumbnailImages = [NSMutableArray array];
    [assetsGroup enumerateAssetsAtIndexes:indexs
                                  options:0
                               usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                   if (result) {
                                       UIImage *thumbnailImage = [UIImage imageWithCGImage:[result thumbnail]];
                                       [thumbnailImages insertObject:thumbnailImage atIndex:0];
                                   } else {
                                       // 相册无媒体对象
                                       if (index == NSNotFound && [thumbnailImages count] == 0) {
                                           [thumbnailImages addObject:[UIImage imageWithCGImage:[assetsGroup posterImage]]];
                                       }
                                   }
                               }];
    self.thumbnailImages = [thumbnailImages copy];
    [self setNeedsDisplay];
}

- (void)setAsset:(ALAsset *)asset {
    
    if (!asset) {
        return;
    }
    _asset = asset;
    
    UIImage *thumbnailImage = [UIImage imageWithCGImage:[asset thumbnail]];
    self.thumbnailImages = @[thumbnailImage];
    [self setNeedsDisplay];
}

@end
