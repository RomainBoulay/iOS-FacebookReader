//
//  UIColor+Beauty.m
//  iOSBeautyKit
//
//  Created by Romain Boulay on 10/24/12.
//  Copyright (c)2012 Romain Boulay. All rights reserved.
//

#import "UIColor+Beauty.h"

@implementation UIColor (Beauty)


+ (UIColor *)gradientColorFrom:(UIColor*)color1 to:(UIColor*)color2 forHeight:(CGFloat)height {
    
    UIGraphicsBeginImageContext(CGSizeMake(1, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray *gradientColors = (@[(id)color1.CGColor,(id)color2.CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(rgbColorspace, (CFArrayRef)(gradientColors), NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, height), 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(rgbColorspace);
    UIGraphicsPopContext();
    
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  [UIColor colorWithPatternImage:gradientImage];
}



@end
