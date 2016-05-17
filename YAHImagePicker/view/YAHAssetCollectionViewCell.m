//
//  YHAssetCollectionViewCell.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHAssetCollectionViewCell.h"
#import "NSDate+YAHTimeInterval.h"

@interface YAHAssetCollectionViewCell ()

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *videoImage;
@property (nonatomic, assign) BOOL disabled;

@end

@implementation YAHAssetCollectionViewCell

- (id)init{
    if (self = [super init])
    {
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    // Image
    [self.image drawInRect:CGRectMake(0, 0, kThumbnailLength, kThumbnailLength)];
    
    // Video title
    if ([self.type isEqual:ALAssetTypeVideo])
    {
        CGFloat titleHeight = 20.0f;
        // Create a gradient from transparent to black
        CGFloat colors [] = {
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.8,
            0.0, 0.0, 0.0, 1.0
        };
        
        CGFloat locations [] = {0.0, 0.75, 1.0};
        
        CGColorSpaceRef baseSpace   = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient      = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
        
        CGContextRef context    = UIGraphicsGetCurrentContext();
        
        CGFloat height          = rect.size.height;
        CGPoint startPoint      = CGPointMake(CGRectGetMidX(rect), height - titleHeight);
        CGPoint endPoint        = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
        
        
        CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];

        [self.title drawAtPoint:CGPointMake(rect.size.width - titleSize.width - 2 , startPoint.y + (titleHeight - 12) / 2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                                                                                            NSForegroundColorAttributeName:[UIColor whiteColor]}];

        UIImage *videoIcon       = [UIImage imageNamed:@"CTAssetsPickerVideo"];
        [videoIcon drawAtPoint:CGPointMake(2, startPoint.y + (titleHeight - videoIcon.size.height) / 2)];
    }
    
   if (self.selected) {
       
        CGContextRef context    = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.3].CGColor);
        CGContextFillRect(context, rect);
       
        UIImage *checkedIcon     = [UIImage imageNamed:@"CTAssetsPickerChecked"];
        [checkedIcon drawAtPoint:CGPointMake(CGRectGetMaxX(rect) - checkedIcon.size.width, CGRectGetMaxY(rect)-checkedIcon.size.height)];
    }
}

#pragma mark - Public

- (void)bind:(ALAsset *)asset {
    
    self.asset  = asset;
    self.image  = [UIImage imageWithCGImage:asset.thumbnail];
    self.type   = [asset valueForProperty:ALAssetPropertyType];
    self.title  = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
}

@end
