//
//  BUIButton.m
//  iOSBeautyKit
//
//  Created by Romain Boulay on 10/23/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "BUIButton.h"
#import "BUILabel.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface BUIButton()

- (void)makeItBeautiful;
- (void)updateTextColor;

@end

@implementation BUIButton



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        self.frame = frame;
        
        _tintColor = DEFAULT_TINT_COLOR;
        _textColor = DEFAULT_TEXT_COLOR;
        _userDefinedBorderColor = nil;
        _cornerRadius = DEFAULT_CORNER_RADIUS;
        _textureBlendingMode = DEFAULT_TEXTURE_BLENDING_MODE;
        _texture = nil;
        
        [self setTitle:@" " forState:UIControlStateNormal];
        
        CGFloat fontSize = DEFAULT_FONT_SIZE;
        if(self.frame.size.height <= 25)fontSize = self.frame.size.height/3.0 * 2.0;
        
        //titleLabel = [[BUILabel alloc] initWithFrame:self.frame];
        [self.titleLabel setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:fontSize]];
        
        self.titleLabel.numberOfLines = 0;
        
        
        
        [self makeItBeautiful];
        
    }
    return self;
}


#pragma mark - Parameters

- (UIColor*)getTintColor{
    return _tintColor;
}

- (void)setTintColor:(UIColor *)tintColor{
    if([tintColor isEqual:_tintColor])return;
    _tintColor = tintColor;
    [self makeItBeautiful];
}


- (UIColor*)getTextColor{
    return _textColor;
}

- (void)setTextColor:(UIColor *)textColor{
    if([textColor isEqual:_textColor])return;
    _textColor = textColor;
    [self updateTextColor];
}

- (UIColor*)getBorderColor{
    return _userDefinedBorderColor;
}

- (void)setBorderColor:(UIColor *)borderColor{
    if([borderColor isEqual:_userDefinedBorderColor])return;
    _userDefinedBorderColor = borderColor;
    [self makeItBeautiful];
}

- (CGFloat)getCornerRadius{
    return _cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    if(cornerRadius == _cornerRadius)return;
    _cornerRadius = cornerRadius;
    [self makeItBeautiful];
}


- (void)setTexture:(UIImage*)texture{
    if(texture == _texture)return;
    _texture = texture;
    [self makeItBeautiful];
}
- (void)setTexture:(UIImage*)texture withBlendingMode:(CGBlendMode)blendingMode{
    _textureBlendingMode = blendingMode;
    [self setTexture:texture];
}



#pragma mark - Beautiful Magic


- (UIImage*)drawBackgroundFrom:(UIColor*)color1
                            to:(UIColor*)color2
               withBorderColor:(UIColor*)borderColor
              withCornerRadius:(CGFloat)cornerRadius
               withInnerShadow:(BOOL)innerShadow{
    
    CGFloat contentWidth = cornerRadius*2+2;
    
    if(_texture){
        contentWidth = self.frame.size.width;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(contentWidth, self.frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGContextScaleCTM(context, scaleFactor, scaleFactor);
    
    CGFloat radius = _cornerRadius / scaleFactor;
    CGFloat width = (contentWidth)/ scaleFactor;
    CGFloat height = self.frame.size.height / scaleFactor;
    
    UIGraphicsPushContext(context);
    
    
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, width, height)cornerRadius: radius];
    [roundedRectanglePath addClip];
    
    
    CGContextSaveGState(context);
    
    // Clip a smaller rounded corners path for the background to avoid aliasing overflow on borders
    CGFloat innerRadius = radius + 0.3 / scaleFactor;
    roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, width, height)cornerRadius: innerRadius];
    [roundedRectanglePath addClip];
    
    if(color1 == color2){
        CGFloat red, green, blue, alpha;
        [color1 getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBFillColor(context, red, green, blue, alpha);
        CGContextFillRect(context, CGRectMake(0, 0, width, height));
        CGColorSpaceRelease(colorSpace);
    }
    else{
        // Draw background gradient
        NSArray *gradientColors = (@[(id)color1.CGColor,(id)color2.CGColor]);
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)(gradientColors), NULL);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(width/2, 0), CGPointMake(width/2, height), 0);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    }
    
    if(_texture){
        CGContextSetBlendMode (context, _textureBlendingMode);
        CGImageRef image = [_texture CGImage];
        CGContextDrawTiledImage(context, CGRectMake(0, 0, _texture.size.width/ scaleFactor, _texture.size.height/ scaleFactor), image);
        CGContextSetBlendMode (context, kCGBlendModeNormal);
    }
    
    
    
    // Draw InnerShadow
    if(innerShadow){
        if(color1 == color2){
            CGContextSetRGBFillColor(context, 0,0,0,0.1);
        }
        else{
            CGContextSetRGBFillColor(context, 1,1,1,0.4);
        }
        
        CGFloat shadowSize = 1.0 / scaleFactor;
        CGFloat innerMargin = 1.0 / scaleFactor;
        width = width - innerMargin*2;
        CGContextTranslateCTM(context, innerMargin, innerMargin);
        
        CGContextMoveToPoint(context, 0.0, radius);
        
        CGContextAddArc(context, radius, radius, radius, M_PI, -M_PI / 2, 0); //STS fixed
        CGContextAddLineToPoint(context, width - radius, 0);
        
        CGContextAddArc(context, width - radius, radius, radius, -M_PI / 2, 0.0f, 0);
        CGContextAddLineToPoint(context, width , shadowSize + radius);
        
        CGContextAddArc(context, width - radius, shadowSize+ radius, radius, 0.0f,-M_PI / 2, 1);
        CGContextAddLineToPoint(context, radius, shadowSize);
        
        CGContextAddArc(context, radius, shadowSize + radius, radius, -M_PI / 2, M_PI, 1);
        
        CGContextFillPath(context);
        
        CGContextTranslateCTM(context, -innerMargin, -innerMargin);
    }
    
    CGContextRestoreGState(context);
    
    // Draw border
    [borderColor setStroke];
    roundedRectanglePath.lineWidth = 2.0 / scaleFactor;
    [roundedRectanglePath stroke];
    
    
    // pop context
    UIGraphicsPopContext();
    
    // get a UIImage from the image context
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    if(_texture){
        return backgroundImage;
    }
    
    // iOS 5 and older fallback, works with resizableImageWithCapInsests but logs errors on execution
    return ([UIImage respondsToSelector:@selector(resizableImageWithCapInsets:)])? [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, cornerRadius, self.frame.size.height, cornerRadius)] : [backgroundImage stretchableImageWithLeftCapWidth:cornerRadius topCapHeight:cornerRadius];;
}




- (void)makeItBeautiful{
    CGFloat hue, saturation, brightness, alpha;
    [_tintColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    CGFloat borderBrightness = brightness - 0.3;
    if(borderBrightness > 0.3)borderBrightness = 0.3;
    
    // BACKGROUND GRADIENT FOR NORMAL AND HIGHLIGHTED STATES (WITH BORDER AND INNER SHADOW)
    
    
    // Caclul a minimum brightness diference between darker and lighter tint color of 20%
    CGFloat darkerTintColorBrightness = brightness - 0.1;
    CGFloat lighterTintColorBrightness = brightness + 0.1;
    if(brightness + 0.1 > 1.0)darkerTintColorBrightness = 0.8;
    else if(brightness - 0.1 < 0)lighterTintColorBrightness = 0.2;
    
    UIColor* lighterTintColor = [UIColor colorWithHue:hue saturation:saturation-0.1*saturation brightness:lighterTintColorBrightness alpha:alpha];
    UIColor* darkerTintColor = [UIColor colorWithHue:hue saturation:saturation+0.25*saturation brightness:darkerTintColorBrightness alpha:alpha];
    
    UIColor* borderColor;
    if(_userDefinedBorderColor)borderColor = _userDefinedBorderColor;
    else borderColor = [UIColor colorWithHue:hue saturation:saturation brightness:borderBrightness alpha:(alpha+1.0)/2.0];
    
    
    [self setBackgroundImage:[self drawBackgroundFrom:lighterTintColor to:darkerTintColor withBorderColor:borderColor withCornerRadius:_cornerRadius withInnerShadow:YES] forState:UIControlStateNormal];
    [self setBackgroundImage:[self drawBackgroundFrom:darkerTintColor to:darkerTintColor withBorderColor:borderColor withCornerRadius:_cornerRadius withInnerShadow:NO] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[self drawBackgroundFrom:lighterTintColor to:lighterTintColor withBorderColor:borderColor withCornerRadius:_cornerRadius withInnerShadow:YES] forState:UIControlStateDisabled];
    
    
    [self setTitleColor:darkerTintColor forState:UIControlStateDisabled];
    [self setTitleShadowColor:[UIColor colorWithWhite:1.0 alpha:0.35] forState:UIControlStateNormal];
    
    [self updateTextColor];
    
    
    
    // SHADOW
    
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGPathMoveToPoint(cgPath, NULL, 0, _cornerRadius);
    CGPathAddArc(cgPath, NULL, _cornerRadius, _cornerRadius, _cornerRadius, M_PI, -M_PI / 2, 0);
    CGPathAddArcToPoint(cgPath, NULL, self.frame.size.width, 0, self.frame.size.width, _cornerRadius, _cornerRadius);
    CGPathAddArcToPoint(cgPath, NULL, self.frame.size.width, self.frame.size.height, self.frame.size.width-_cornerRadius, self.frame.size.height, _cornerRadius);
    CGPathAddArcToPoint(cgPath, NULL, 0, self.frame.size.height, 0, _cornerRadius, _cornerRadius);
    
    self.layer.shadowRadius = 0.0;
    self.layer.shadowOffset = CGSizeMake(0, 1.0);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithCGPath:cgPath].CGPath;
    CGPathRelease(cgPath);
}


- (void)updateTextColor{
    
    CGFloat hue, saturation, brightness, alpha;
    [_tintColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    // Setting line of dark shadow on top of the text supposing the text is not darker than its shadow
    if((brightness <= 0.9 || [_textColor isEqual:[UIColor whiteColor]])&& [self isEnabled]){
        [self setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor colorWithWhite:0.0 alpha:0.25] forState:UIControlStateNormal];
        [self.titleLabel setShadowOffset:CGSizeMake(0.0, -1.0)];
    }
    // Setting line of white shadow
    else{
        [self setTitleColor:_textColor forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor colorWithWhite:1.0 alpha:0.35] forState:UIControlStateNormal];
        [self.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    }
    
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    [self updateTextColor];
}


@end
