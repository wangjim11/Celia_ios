//
//  UIColor+SohoXiColor.h
//
//  Created by Lin Zhou on 7/7/15.
//  Copyright (c) 2015 Hook & Loop, Infor Global Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SOHOXIThemeLight = 0,
    SOHOXIThemeDark,
    SOHOXIThemeHightContrast
} SOHOXITheme;

@interface UIColor (SohoXiColor)

// standard colors
+ (UIColor *)azureColor;
+ (UIColor *)azureColor:(NSInteger)darkness;
+ (UIColor *)azureColorForTheme:(SOHOXITheme)theme;

+ (UIColor *)amberColor;
+ (UIColor *)amberColor:(NSInteger)darkness;
+ (UIColor *)amberColorForTheme:(SOHOXITheme)theme;

+ (UIColor *)amethystColor;
+ (UIColor *)amethystColor:(NSInteger)darkness;
+ (UIColor *)amethystColorForTheme:(SOHOXITheme)theme;

+ (UIColor *)turquoiseColor;
+ (UIColor *)turquoiseColor:(NSInteger)darkness;
+ (UIColor *)turquoiseColorForTheme:(SOHOXITheme)theme;

+ (UIColor *)rubyColor;
+ (UIColor *)rubyColor:(NSInteger)darkness;
+ (UIColor *)rubyColorForTheme:(SOHOXITheme)theme;

+ (UIColor *)emeraldColor;
+ (UIColor *)emeraldColor:(NSInteger)darkness;
+ (UIColor *)emeraldColorForTheme:(SOHOXITheme)theme;

+ (UIColor *)graphiteColor;
+ (UIColor *)graphiteColor:(NSInteger)darkness;
+ (UIColor *)graphiteColorForTheme:(SOHOXITheme)theme;

+ (UIColor *)slateColor;
+ (UIColor *)slateColor:(NSInteger)darkness;
+ (UIColor *)slateColorForTheme:(SOHOXITheme)theme;

// alert colors
+ (UIColor *)redAlertColor;
+ (UIColor *)orangeAlertColor;
+ (UIColor *)yellowAlertColor;
+ (UIColor *)greenAlertColor;

@end


