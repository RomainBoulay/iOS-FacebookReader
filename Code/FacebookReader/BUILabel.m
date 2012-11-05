//
//  BUILabel.m
//  iOSBeautyKit
//
//  Created by Romain Boulay on 10/25/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "BUILabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Beauty.h"

@interface BUILabel()
- (void) refreshGradient;

@end

@implementation BUILabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        shadowRadius = DEFAULT_SHADOW_RADIUS;
        shadowOffset = DEFAULT_SHADOW_OFFSET;
        [self setShadowColor:DEFAULT_STROKE_COLOR];
        
        
        strokeSize = DEFAULT_STROKE_SIZE;
        strokeColor = DEFAULT_STROKE_COLOR;
        
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.layer.masksToBounds = NO;
        [self setShadowOffset:CGSizeZero];
    }
    return self;
}

- (void)setTextGradientColor:(UIColor*)color1 toColor:(UIColor*)color2 withAngle:(CGFloat) angle{
    if(!hasGradient){
        hasGradient = YES;
        colors = [[NSMutableDictionary alloc] init];
    }
    
    [colors setObject:color1 forKey:[NSNumber numberWithFloat:0.0]];
    [colors setObject:color2 forKey:[NSNumber numberWithFloat:1.0]];
    [self refreshGradient];
}
- (void)setShadowOffset:(CGSize)offset radius:(CGFloat)radius{
    shadowOffset = offset;
    shadowRadius = radius;
}

- (void)setStrokeColor:(UIColor*)color{
    strokeColor = color;
    strokeSize = 1;
}

- (void) drawTextInRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(shadowOffset.height != 0 || shadowOffset.width != 0 || shadowRadius != DEFAULT_SHADOW_RADIUS){
         CGContextSetShadowWithColor(context, shadowOffset, shadowRadius, [self.shadowColor CGColor]);
    }
    
    /*
    if (strokeSize > 0) {
        
        CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
        CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    }*/
    
    [super drawTextInRect:rect];
    
}


- (void) setText:(NSString *)text{
    [super setText:text];
    if(hasGradient)[self refreshGradient];
}

- (void) refreshGradient{
    CGSize sizeTofit = [self.text sizeWithFont:self.font];
    
    [self setTextColor:[UIColor gradientColorFrom:[[colors allValues] objectAtIndex:0]
                                               to:[[colors allValues] objectAtIndex:1]
                                        forHeight:sizeTofit.height]];
}

@end
