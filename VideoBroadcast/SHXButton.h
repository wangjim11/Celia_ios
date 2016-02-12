//
//  SHXButton.h
//  SohoXiButton
//
//  Created by Lin Zhou on 12/14/15.
//  Copyright © 2015 Infor Global Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SOHOXIButtonStyle) {
    SOHOXIButtonStyleTertiary = 0,
    SOHOXIButtonStylePrimary,
    SOHOXIButtonStyleSecondary,
    SOHOXIButtonStyleWarning,
    SOHOXIButtonStyleDestroy
};

@interface SHXButton : UIButton
@property (nonatomic, readonly) SOHOXIButtonStyle buttonStyle;
@property (nonatomic, assign) CGFloat   textHorizontalPad;
@property (nonatomic, assign) CGFloat   textVerticalPad;
@property (nonatomic, assign) BOOL      autoCapitalizeTitle;
+ (instancetype)sohoButtonWithStyle:(SOHOXIButtonStyle)buttonStyle;

@end
