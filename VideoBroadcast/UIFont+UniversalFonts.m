//
//  UIFont+UniversalFonts.m
//  HMSMobile
//
//  Created by Lin Zhou on 4/9/13.
//  Copyright (c) 2013 Infor Global Solutions, New York, USA. All rights reserved.
//

#import "UIFont+UniversalFonts.h"

@implementation UIFont (UniversalFonts)

+ (UIFont *)regFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)boldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

+ (UIFont *)lightFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+ (UIFont *)mediumFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *)italicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Italic" size:size];
}

@end
