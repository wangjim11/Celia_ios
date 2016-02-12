//
//  UIFont+UniversalFonts.h
//  HMSMobile
//
//  Created by Lin Zhou on 4/9/13.
//  Copyright (c) 2013 Infor Global Solutions, New York, USA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BASIC_FONT_SIZE     16
#define KEY_FONT_SIZE       12
#define VALUE_FONT_SIZE     13

#define kBasicFont          [UIFont regFontWithSize:BASIC_FONT_SIZE]
#define kFieldNameFont      [UIFont regFontWithSize:KEY_FONT_SIZE]
#define kFieldValueFont     [UIFont regFontWithSize:VALUE_FONT_SIZE]

@interface UIFont (UniversalFonts)

+ (UIFont *)regFontWithSize:(CGFloat)size;
+ (UIFont *)boldFontWithSize:(CGFloat)size;
+ (UIFont *)lightFontWithSize:(CGFloat)size;
+ (UIFont *)mediumFontWithSize:(CGFloat)size;
+ (UIFont *)italicFontWithSize:(CGFloat)size;

@end
