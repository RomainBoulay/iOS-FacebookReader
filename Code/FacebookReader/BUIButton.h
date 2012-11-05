//
//  BUIButton.h
//  iOSBeautyKit
//
//  Created by Romain Boulay on 10/23/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//


#define DEFAULT_TINT_COLOR [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]
#define DEFAULT_TEXT_COLOR [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]
#define DEFAULT_CORNER_RADIUS 4.0
#define DEFAULT_FONT_SIZE 15.0
#define DEFAULT_TEXTURE_BLENDING_MODE kCGBlendModeMultiply
#define DEFAULT_FONT_NAME @"TrebuchetMS-Bold"
#define GRADIENT_DARKER_COLOR_RATIO 10
#define GRADIENT_LIGHTER_COLOR_RATIO 10


#import <UIKit/UIKit.h>

@interface BUIButton : UIButton{
    
    UIColor* _tintColor;
    UIColor* _textColor;
    UIColor* _userDefinedBorderColor;
    CGFloat _cornerRadius;
    
    UIImage* _texture;
    CGBlendMode _textureBlendingMode;
    
}


- (UIColor*) getTintColor;
- (void) setTintColor:(UIColor *)tintColor;


- (UIColor*) getTextColor;
- (void) setTextColor:(UIColor *)textColor;

- (UIColor*) getBorderColor;
- (void) setBorderColor:(UIColor *)borderColor;

- (CGFloat) getCornerRadius;
- (void) setCornerRadius:(CGFloat)cornerRadius;

- (void) setTexture:(UIImage*)texture ;
- (void) setTexture:(UIImage*)texture withBlendingMode:(CGBlendMode) blendingMode;

@end
