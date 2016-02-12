//
//  UIImage+ButtonImage.m
//  LoginApp
//
//  Created by Lin Zhou on 8/31/15.
//  Copyright (c) 2015 Infor Global Solutions. All rights reserved.
//

#import "UIImage+SHXButtonImage.h"

@implementation UIImage (SHXButtonImage)

+ (UIImage *)buttonImageWithColor:(UIColor *)color {
    return [UIImage buttonImageWithColor:color height:SHXBUTTON_IMAGE_DEFAULT_HEIGHT cornerRadius:SHXBUTTON_IMAGE_DEFAULT_CORNOR_RADIUS];
}

+ (UIImage *)buttonImageWithColor:(UIColor *)color height:(CGFloat)height {
    return [UIImage buttonImageWithColor:color height:height cornerRadius:SHXBUTTON_IMAGE_DEFAULT_CORNOR_RADIUS];
}

+ (UIImage *)buttonImageWithColor:(UIColor *)color height:(CGFloat)height cornerRadius:(CGFloat)radius {
    if (height<radius*2+1) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(radius*2+1, height), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    
    CGContextMoveToPoint(context, 0, radius);
    CGContextAddArcToPoint(context, 0, 0, radius, 0, radius);
    CGContextAddLineToPoint(context, radius+1, 0);
    CGContextAddArcToPoint(context, radius*2+1, 0, radius*2+1, radius, radius);
    CGContextAddLineToPoint(context, radius*2+1, height-radius);
    CGContextAddArcToPoint(context, radius*2+1, height, radius+1, height, radius);
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArcToPoint(context, 0, height, 0, height-radius, radius);
    CGContextAddLineToPoint(context, 0, radius);
    CGContextFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
