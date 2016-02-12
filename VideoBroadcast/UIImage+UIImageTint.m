//
//  UIImage+UIImageTint.m
//  LoginApp
//
//  Created by Lin Zhou on 10/30/13.
//  Copyright (c) 2013 Infor Global Solutions Inc, Alpharetta, USA. All rights reserved.
//

#import "UIImage+UIImageTint.h"

@implementation UIImage (UIImageTint)

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color
{
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContextWithOptions(img.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    BOOL ISIOS7 = [[[UIDevice currentDevice] systemVersion] floatValue]>=7.f;
    // set the blend mode to color burn, and the original image
    if (ISIOS7) {
        CGContextSetBlendMode(context, kCGBlendModeMultiply);
    }else{
        CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    }
    
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

@end
