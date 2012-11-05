//
//  BUILabel.h
//  iOSBeautyKit
//
//  Created by Romain Boulay on 10/25/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//


#define DEFAULT_SHADOW_RADIUS 0.0
#define DEFAULT_SHADOW_OFFSET CGSizeZero
#define DEFAULT_SHADOW_COLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
#define DEFAULT_STROKE_SIZE 0.0
#define DEFAULT_STROKE_COLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]


#import <UIKit/UIKit.h>

@interface BUILabel : UILabel{
    
    NSMutableDictionary *colors;
    
    CGFloat shadowRadius;
    CGSize  shadowOffset;
    
    CGFloat strokeSize;
    UIColor *strokeColor;
    
    BOOL hasGradient;
}


- (void)setTextGradientColor:(UIColor*)color1 toColor:(UIColor*)color2 withAngle:(CGFloat) angle;
- (void)setShadowOffset:(CGSize)offset radius:(CGFloat)radius;
- (void)setStrokeColor:(UIColor*)color;

@end
