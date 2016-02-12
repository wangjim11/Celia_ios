//
//  SHXBaseLogInConstant.h
//  SmartLock
//
//  Created by Lin Zhou on 12/28/15.
//  Copyright © 2015 Lin Zhou. All rights reserved.
//

#ifndef SHXBaseLogInConstant_h
#define SHXBaseLogInConstant_h

#define IS_LANDSCAPE                ([[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeLeft ||  \
[[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeRight)

#define IS_IOS7                     (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
#define IS_IPAD                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE4                  ((!IS_LANDSCAPE && CGRectGetHeight([[UIScreen mainScreen] bounds])<500) || \
(IS_LANDSCAPE && CGRectGetWidth([[UIScreen mainScreen] bounds])<500))
#define IS_IPHONE6                  ((!IS_LANDSCAPE && CGRectGetHeight([[UIScreen mainScreen] bounds])>600) || \
(IS_LANDSCAPE && CGRectGetWidth([[UIScreen mainScreen] bounds])>600))

#define TEXT_COLOR                  [UIColor graphiteColor]
#define BLUE_COLOR                  [UIColor azureColor]

#define IPAD_KEYBOARD_DISTANCE      100.f
#define IPHONE_KEYBOARD_DISTANCE    (IS_IPHONE4?(IS_LANDSCAPE?20:110):(IS_LANDSCAPE?(IS_IPHONE6?0:20):70))

#define LOADING_ANIM_KEY            @"LoadingAnimation"

typedef enum{
    UIIndicatoryColorClear = 0,
    UIIndicatoryColorRed
} UIIndicatoryColor;

#endif /* SHXBaseLogInConstant_h */
