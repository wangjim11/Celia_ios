//
//  SHXBaseLogInViewController.h
//  LoginApp
//
//  Created by Lin Zhou on 10/29/13.
//  Copyright (c) 2013 Infor Global Solutions, New York, USA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHXBaseLogInViewController : UIViewController

@property (nonatomic, strong) UIImage   *appLabelImage;
@property (nonatomic, strong) NSString  *appLabelString;

@property (nonatomic, assign) BOOL      showTrademark;
@property (nonatomic, assign) BOOL      showSettings;
@property (nonatomic, assign) BOOL      showForgotPWD;
@property (nonatomic, assign) BOOL      showCornerLogo;
@property (nonatomic, assign) BOOL      showCopyRight;
@property (nonatomic, assign) BOOL      isLoading;
@property (nonatomic, strong) NSString  *actionBtnTitle;
@property (nonatomic, strong, readonly) NSString *nameString;
@property (nonatomic, strong, readonly) NSString *pwdString;

// log in actions, should be overwritten by subclasses
- (void)userNameMissingAction;
- (void)passwordMiddingAction;
- (void)logInAction;
- (void)logInSuccessAction;
- (void)logInFailedAction;

// settings actions, should be overwritten by subclasses
- (UIViewController *)settingsViewController;
- (void)settingsAction;
- (void)settingsSave;
- (void)settingsCancel;

// forgot password
- (void)retrievePwdAction;

@end
