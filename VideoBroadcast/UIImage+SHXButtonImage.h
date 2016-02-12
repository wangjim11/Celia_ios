//
//  UIImage+ButtonImage.h
//  LoginApp
//
//  Created by Lin Zhou on 8/31/15.
//  Copyright (c) 2015 Infor Global Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SHXBUTTON_IMAGE_DEFAULT_HEIGHT              44
#define SHXBUTTON_IMAGE_DEFAULT_CORNOR_RADIUS       4

@interface UIImage (SHXButtonImage)
+ (UIImage *)buttonImageWithColor:(UIColor *)color;
+ (UIImage *)buttonImageWithColor:(UIColor *)color height:(CGFloat)height;
+ (UIImage *)buttonImageWithColor:(UIColor *)color height:(CGFloat)height cornerRadius:(CGFloat)radius;
@end
