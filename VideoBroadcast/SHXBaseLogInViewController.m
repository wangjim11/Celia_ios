//
//  SHXBaseLogInViewController.m
//  LoginApp
//
//  Created by Lin Zhou on 10/29/13.
//  Copyright (c) 2013 Infor Global Solutions. All rights reserved.
//

#import "SHXBaseLogInViewController.h"

#import "SHXButton.h"
#import "SHXSpriteLayer.h"
#import "UIColor+SohoXiColor.h"
#import "UIImage+UIImageTint.h"
#import "UIImage+SHXButtonImage.h"
#import "UIFont+UniversalFonts.h"
#import "SHXBaseLogInConstant.h"


@interface SHXBaseLogInViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIControl     *autoLayoutHolderView;
@property (nonatomic, strong) UIControl     *containerView;
@property (nonatomic, strong) UIImageView   *appImageView;
@property (nonatomic, strong) UILabel       *appNameLabel;
@property (nonatomic, strong) UILabel       *tmLabel;
@property (nonatomic, strong) UILabel       *copyrightLabel;

@property (nonatomic, strong) UIImageView   *userIcon;
@property (nonatomic, strong) UIImageView   *userBG;
@property (nonatomic, strong) UIImageView   *pwdIcon;
@property (nonatomic, strong) UIImageView   *pwdBG;
@property (nonatomic, strong) UIImageView   *cornerLogo;

@property (nonatomic, strong) UITextField   *userField;
@property (nonatomic, strong) UITextField   *pwdField;
@property (nonatomic, strong) UITextField   *currentField;
@property (nonatomic, strong) UIButton      *logInBtn;
@property (nonatomic, strong) UIButton      *retrievePwdBtn;
@property (nonatomic, strong) UIButton      *settingBtn;
@property (nonatomic, strong) SHXSpriteLayer   *loadingLayer;

@property (nonatomic, strong) NSTimer       *resetUITimer;

@property (nonatomic, strong) UIViewController  *settingsController;

@end

@implementation SHXBaseLogInViewController
{
    BOOL _logInHasFailed;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialzation
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillDismiss)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIColor *backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = backgroundColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    _autoLayoutHolderView = [[UIControl alloc] initWithFrame:self.view.bounds];
    _autoLayoutHolderView.backgroundColor = [UIColor clearColor];
    _autoLayoutHolderView.translatesAutoresizingMaskIntoConstraints = NO;
    [_autoLayoutHolderView addTarget:self action:@selector(releaseKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_autoLayoutHolderView];
    // add auto layout
    [self anchorSubView:_autoLayoutHolderView toOccupySuperView:self.view];
    
    CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    //CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    CGFloat containerWidth = IS_IPAD?400.f:screenWidth-50.f;
    CGFloat containerHeight = IS_IPAD?330.f:280.f;
    
    _containerView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, containerWidth, containerHeight)];
    _containerView.backgroundColor = backgroundColor;
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addTarget:self action:@selector(releaseKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [_autoLayoutHolderView addSubview:_containerView];
    // add auto layout
    [self fixSizeOfView:_containerView toSize:CGSizeMake(containerWidth, containerHeight)];
    [self anchorSubView:_containerView inSuperView:_autoLayoutHolderView offset:CGPointMake(0, 30.f)];
    
    
    _appLabelString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    UIFont *appNameFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _appNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _appNameLabel.backgroundColor = [UIColor clearColor];
    _appNameLabel.font = appNameFont;
    _appNameLabel.textColor = [UIColor graphiteColorForTheme:SOHOXIThemeDark];
    _appNameLabel.textAlignment = NSTextAlignmentCenter;
    _appNameLabel.numberOfLines = 1;
    _appNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _appNameLabel.text = _appLabelString;
    [_autoLayoutHolderView addSubview:_appNameLabel];
    
    CGFloat verticalGap = IS_IPAD?50.f:30.f;
    NSDictionary *labelViewDict = @{@"view":_containerView, @"label":_appNameLabel};
    NSString *labelVisualFormat = [NSString stringWithFormat:@"V:[label]-%d-[view]", (int)verticalGap];
    NSArray *labelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:labelVisualFormat
                                                                        options:NSLayoutFormatAlignAllCenterX
                                                                        metrics:nil
                                                                          views:labelViewDict];
    [_autoLayoutHolderView addConstraints:labelConstraints];
    
    _appImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _appImageView.backgroundColor = [UIColor clearColor];
    _appImageView.contentMode = UIViewContentModeScaleAspectFit;
    _appImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_autoLayoutHolderView addSubview:_appImageView];
    NSDictionary *imaggViewDict = @{@"view":_containerView, @"imageView":_appImageView};
    NSString *imageVisualFormat = [NSString stringWithFormat:@"V:[imageView]-%d-[view]", (int)verticalGap];
    NSArray *imageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:imageVisualFormat
                                                                        options:NSLayoutFormatAlignAllCenterX
                                                                        metrics:nil
                                                                          views:imaggViewDict];
    [_autoLayoutHolderView addConstraints:imageConstraints];
    
    UIImage *image = [[UIImage buttonImageWithColor:[UIColor colorWithWhite:248.f/255.f alpha:1]] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *separator = [UIImage imageNamed:@"LogInLineBreak"];
    
    _userBG = [[UIImageView alloc] initWithImage:image];
    _userBG.frame = CGRectMake(0.f, 10.f, CGRectGetWidth(_containerView.frame), 44.f);
    _userBG.userInteractionEnabled = NO;
    [_containerView addSubview:_userBG];
    
    UIImageView *separator1 = [[UIImageView alloc] initWithImage:separator];
    separator1.frame = CGRectMake(35.f, roundf((CGRectGetHeight(_userBG.frame)-20)/2.f)+CGRectGetMinY(_userBG.frame), 1, 20);
    [_containerView addSubview:separator1];
    
    UIColor *tintColor = [UIColor colorWithWhite:200.f/255.f alpha:1.f];
    _userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogInUser" withColor:tintColor]];
    _userIcon.center = CGPointMake(20, _userBG.center.y);
    [_containerView addSubview:_userIcon];
    
    CGRect frame = CGRectMake(CGRectGetMaxX(separator1.frame)+10.f, CGRectGetMinY(_userBG.frame), CGRectGetWidth(_userBG.frame)-CGRectGetMaxX(separator1.frame)-15.f, CGRectGetHeight(_userBG.frame));
    _userField = [[UITextField alloc] initWithFrame:frame];
    _userField.tintColor = BLUE_COLOR;
    _userField.borderStyle = UITextBorderStyleNone;
    _userField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userField.adjustsFontSizeToFitWidth = YES;
    _userField.minimumFontSize = 9.f;
    _userField.textColor = TEXT_COLOR;
    _userField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _userField.placeholder = NSLocalizedStringFromTable(@"login_name", @"LoginStrings", nil);
    _userField.backgroundColor = [UIColor clearColor];
    _userField.returnKeyType = UIReturnKeyNext;
    _userField.autocorrectionType = UITextAutocorrectionTypeNo;
    _userField.delegate = self;
    [_containerView addSubview:_userField];
    
    _pwdBG = [[UIImageView alloc] initWithImage:image];
    _pwdBG.frame = CGRectMake(CGRectGetMinX(_userBG.frame), CGRectGetMaxY(_userField.frame)+10.f,
                              CGRectGetWidth(_userBG.frame), CGRectGetHeight(_userBG.frame));
    [_containerView addSubview:_pwdBG];
    
    UIImageView *separator2 = [[UIImageView alloc] initWithImage:separator];
    separator2.center = CGPointMake(separator1.center.x, _pwdBG.center.y);
    [_containerView addSubview:separator2];
    
    _pwdIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogInPwd" withColor:tintColor]];
    _pwdIcon.center = CGPointMake(_userIcon.center.x, _pwdBG.center.y);
    [_containerView addSubview:_pwdIcon];
    
    _pwdField = [[UITextField alloc] initWithFrame:_userField.frame];
    _pwdField.tintColor = BLUE_COLOR;
    _pwdField.textColor = TEXT_COLOR;
    _pwdField.center = CGPointMake(_userField.center.x, _pwdBG.center.y);
    _pwdField.borderStyle = UITextBorderStyleNone;
    _pwdField.secureTextEntry = YES;
    _pwdField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _pwdField.placeholder = NSLocalizedStringFromTable(@"login_pwd", @"LoginStrings", nil);
    _pwdField.backgroundColor = [UIColor clearColor];
    _pwdField.returnKeyType = UIReturnKeyGo;
    _pwdField.delegate = self;
    [_containerView addSubview:_pwdField];
    
    _logInBtn = ({
        SHXButton *btn = [SHXButton sohoButtonWithStyle:SOHOXIButtonStylePrimary];
        btn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        [btn setTitle:NSLocalizedStringFromTable(@"login_btn_title", @"LoginStrings", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(logInAction) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled = NO;
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [_containerView addSubview:btn];
        
        NSLayoutConstraint *topCN = [NSLayoutConstraint constraintWithItem:btn
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pwdField
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:30];
        [_containerView addConstraint:topCN];
        
        NSLayoutConstraint *heightCN = [NSLayoutConstraint constraintWithItem:btn
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:50];
        [_containerView addConstraint:heightCN];
        
        NSLayoutConstraint *leadingCN = [NSLayoutConstraint constraintWithItem:btn
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_pwdBG
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1
                                                                      constant:0];
        [_containerView addConstraint:leadingCN];
        
        NSLayoutConstraint *widthCN = [NSLayoutConstraint constraintWithItem:btn
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_pwdBG
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1
                                                                    constant:0];
        [_containerView addConstraint:widthCN];
        
        btn;
    });
    
    _showSettings = YES;
    if (_showSettings) {
        _settingBtn = ({
            SHXButton *btn = [SHXButton sohoButtonWithStyle:SOHOXIButtonStyleTertiary];
            btn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            [btn setTitle:NSLocalizedStringFromTable(@"register_btn_title", @"LoginStrings", nil)
                 forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(settingsAction) forControlEvents:UIControlEventTouchUpInside];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            [_containerView addSubview:btn];
            
            NSLayoutConstraint *topCN = [NSLayoutConstraint constraintWithItem:btn
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_logInBtn
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:10];
            [_containerView addConstraint:topCN];
            
            NSLayoutConstraint *centerXCN = [NSLayoutConstraint constraintWithItem:btn
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_logInBtn
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1
                                                                          constant:0];
            [_containerView addConstraint:centerXCN];
            
            btn;
        });
    }
    
    _retrievePwdBtn = ({
        SHXButton *btn = [SHXButton sohoButtonWithStyle:SOHOXIButtonStyleTertiary];
        btn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [btn setTitle:NSLocalizedStringFromTable(@"forgot_pwd_btn_title", @"LoginStrings", nil)
             forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(retrievePwdAction) forControlEvents:UIControlEventTouchUpInside];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [_containerView addSubview:btn];
        
        NSLayoutConstraint *topCN = [NSLayoutConstraint constraintWithItem:btn
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_settingBtn
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:5];
        [_containerView addConstraint:topCN];
        
        NSLayoutConstraint *centerXCN = [NSLayoutConstraint constraintWithItem:btn
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_settingBtn
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1
                                                                      constant:0];
        [_containerView addConstraint:centerXCN];
        
        btn;
    });
    _retrievePwdBtn.hidden = !_showForgotPWD;
    
    _showCopyRight = YES;
    _copyrightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _copyrightLabel.textColor = TEXT_COLOR;
    _copyrightLabel.backgroundColor = [UIColor clearColor];
    _copyrightLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    _copyrightLabel.textAlignment = NSTextAlignmentCenter;
    _copyrightLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_autoLayoutHolderView addSubview:_copyrightLabel];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY";
    NSString *year = [formatter stringFromDate:[NSDate date]];
    _copyrightLabel.text = [NSString stringWithFormat:@"© %@ Infor", year];
    [_copyrightLabel sizeToFit];
    
    NSDictionary *copyLabelDict = @{@"label":_copyrightLabel};
    NSArray *bottomCN = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-45-|" options:0 metrics:nil views:copyLabelDict];
    [_autoLayoutHolderView addConstraints:bottomCN];
    
    NSLayoutConstraint *horizontalCN = [NSLayoutConstraint constraintWithItem:_copyrightLabel
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_autoLayoutHolderView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.f
                                                                     constant:-35.f];
    [_autoLayoutHolderView addConstraint:horizontalCN];
    
    _showCornerLogo = YES;
    _cornerLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"InforLogo"]];
    _cornerLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [_autoLayoutHolderView addSubview:_cornerLogo];
    
    NSLayoutConstraint *logoHorizontalCN = [NSLayoutConstraint constraintWithItem:_cornerLogo attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_autoLayoutHolderView attribute:NSLayoutAttributeLeft multiplier:1.f constant:35.f];
    [_autoLayoutHolderView addConstraint:logoHorizontalCN];
    NSLayoutConstraint *logoVerticalCN = [NSLayoutConstraint constraintWithItem:_cornerLogo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_autoLayoutHolderView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-35.f];
    [_autoLayoutHolderView addConstraint:logoVerticalCN];
    
    self.appLabelImage = [UIImage imageNamed:@"logoPlaceholder"];
    /*
     NSArray *bottomCN = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-25-|" options:0 metrics:nil views:copyLabelDict];
     [_autoLayoutHolderView addConstraints:bottomCN];
     
     NSLayoutConstraint *xCenterCN = [NSLayoutConstraint constraintWithItem:copyrightLabel
     attribute:NSLayoutAttributeCenterX
     relatedBy:NSLayoutRelationEqual
     toItem:_autoLayoutHolderView
     attribute:NSLayoutAttributeCenterX
     multiplier:1.f
     constant:0];
     */
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if (!IS_IPAD) {
        if (self.traitCollection.verticalSizeClass==UIUserInterfaceSizeClassCompact) {
            [self shouldShowHeader:NO];
        }else if (self.traitCollection.verticalSizeClass==UIUserInterfaceSizeClassRegular) {
            [self shouldShowHeader:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_isLoading) {
        return NO;
    }
    
    _currentField = textField;
    if ([_resetUITimer isValid]) {
        [_resetUITimer invalidate];
        _resetUITimer = nil;
    }
    [self setIndicatoryColor:UIIndicatoryColorClear];
    _logInBtn.enabled = ([_userField hasText] && [_pwdField hasText]);
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIImageView *newView = nil;
    if (textField==_userField) {
        newView = _userBG;
    }else if (textField==_pwdField){
        newView = _pwdBG;
    }
    
    newView.layer.cornerRadius = 3.f;
    newView.layer.borderWidth = 1.f;
    newView.layer.borderColor = BLUE_COLOR.CGColor;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField==_userField) {
        _logInBtn.enabled = [newString length]>0 && [_pwdField hasText];
    }else if (textField==_pwdField) {
        _logInBtn.enabled = [newString length]>0 && [_userField hasText];
    }
    
    if ([string isEqualToString:@"\n"]) {
        if (textField==_userField) {
            [_pwdField becomeFirstResponder];
            return NO;
        }else if (textField==_pwdField) {
            [_pwdField resignFirstResponder];
            
            if (![_userField hasText]) {
                [self userNameMissingAction];
                _logInBtn.enabled = NO;
                return NO;
            }
            if (![_pwdField hasText]) {
                [self passwordMiddingAction];
                _logInBtn.enabled = NO;
                return NO;
            }
            
            [self logInAction];
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIView *bgView = nil;
    if (textField==_userField) {
        bgView = _userBG;
    }else if (textField==_pwdField){
        bgView = _pwdBG;
    }
    
    bgView.layer.cornerRadius = 3.f;
    bgView.layer.borderWidth = 1.f;
    bgView.layer.borderColor = [[UIColor clearColor] CGColor];
    
    _logInBtn.enabled = [_userField hasText] && [_pwdField hasText];
    
    if (_currentField==textField) {
        _currentField = nil;
    }
}

#pragma mark - Action Methods

- (void)userNameMissingAction {
    // do nothing, should be overwritten by subclass
}

- (void)passwordMiddingAction {
    // do nothing, should be overwritten by subclass
}

- (void)retrievePwdAction {
    // do nothing, should be overwritten by subclass
}

- (void)logInAction {
    // do basic verification, when overwritten by subclasses,
    // subclass should call super logInAction first
    if (_currentField!=nil) {
        [self releaseKeyboard];
    }
    
    [self startLoading];
    _nameString = [_userField.text copy];
    _pwdString = [_pwdField.text copy];
}

- (void)logInSuccessAction {
    [self doneLoading];
    
    if (_logInHasFailed) {
        _logInHasFailed = NO;
        [self setIndicatoryColor:UIIndicatoryColorClear];
    }
}

- (void)logInFailedAction {
    [self cancelLoading];
    
    _logInHasFailed = YES;
    _retrievePwdBtn.hidden = NO;
    [self setIndicatoryColor:UIIndicatoryColorRed];
    
    if ([_resetUITimer isValid]) {
        [_resetUITimer invalidate];
    }
    
    SEL selector = @selector(setIndicatoryColor:);
    UIIndicatoryColor color = UIIndicatoryColorClear;
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [inv setSelector:selector];
    [inv setTarget:self];
    [inv setArgument:&color atIndex:2];
    _resetUITimer = [NSTimer timerWithTimeInterval:2.f
                                        invocation:inv
                                           repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_resetUITimer forMode:NSRunLoopCommonModes];
}

- (UIViewController *)settingsViewController {
    // should be overwritten by subclasses if a settings view is needed
    return nil;
}

- (void)settingsAction {
    if (_currentField!=nil) {
        [self releaseKeyboard];
    }
    
    _settingsController = [self settingsViewController];
    if (_settingsController==nil) {
        return;
    }
    
    NSString *cancelTitle = NSLocalizedStringFromTable(@"cancel_btn_title", @"LoginStrings", nil);
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:cancelTitle
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(settingsCancel)];
    _settingsController.navigationItem.leftBarButtonItem = cancel;
    NSString *saveTitle = NSLocalizedStringFromTable(@"save_btn_title", @"LoginStrings", nil);
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:saveTitle
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(settingsSave)];
    _settingsController.navigationItem.rightBarButtonItem = save;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_settingsController];
    nav.navigationBarHidden = NO;
    nav.navigationBar.barTintColor = [UIColor azureColor];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *textAttributes = @{//NSFontAttributeName:[UIFont mediumFontWithSize:17],
                                     NSForegroundColorAttributeName:[UIColor whiteColor]};
    nav.navigationBar.titleTextAttributes = textAttributes;
    
    if (IS_IPAD) {
        UIControl *backView = [[UIControl alloc] initWithFrame:self.view.bounds];
        [backView addTarget:self action:@selector(settingsCancel) forControlEvents:UIControlEventTouchUpInside];
        backView.backgroundColor = [UIColor colorWithWhite:150.f/255.f alpha:.5f];
        backView.translatesAutoresizingMaskIntoConstraints = NO;
        [_autoLayoutHolderView addSubview:backView];
        [self anchorSubView:backView toOccupySuperView:_autoLayoutHolderView];
        
        [self addChildViewController:nav];
        CGFloat center_x = CGRectGetWidth(_autoLayoutHolderView.bounds)/2.f;
        CGFloat center_y = CGRectGetHeight(_autoLayoutHolderView.bounds)/2.f;
        nav.view.frame = CGRectMake(0, 0, CGRectGetWidth(_settingsController.view.bounds), CGRectGetHeight(_settingsController.view.bounds));
        nav.view.center = CGPointMake(center_x, CGRectGetHeight(backView.bounds));
        [backView addSubview:nav.view];
        
        [UIView animateWithDuration:.3f
                         animations:^{nav.view.center = CGPointMake(center_x, center_y);}
                         completion:^(BOOL finished) {
                             nav.view.translatesAutoresizingMaskIntoConstraints = NO;
                             [self fixSizeOfView:nav.view toSize:nav.view.bounds.size];
                             [self anchorSubView:nav.view inSuperView:backView offset:CGPointZero];
                         }];
    }else{
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)settingsSave {
//    if ([_settingsController canCancel]) {
//        [_settingsController save];
//        [self settingsDismiss];
//    }
}

- (void)settingsCancel {
//    if ([_settingsController canCancel]) {
//        [_settingsController cancel];
//        [self settingsDismiss];
//    }
}

- (void)settingsDismiss {
    if (IS_IPAD) {
        UIControl *control;
        for (UIView *subView in [_autoLayoutHolderView subviews]) {
            if ([subView isKindOfClass:[UIControl class]]) {
                control = (UIControl *)subView;
            }
        }
        
        [UIView animateWithDuration:.3f
                         animations:^{
                             control.alpha = 0.f;
                         } completion:^(BOOL finished) {
                             [control removeFromSuperview];
                         }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)releaseKeyboard {
    _currentField = nil;
    
    [_userField resignFirstResponder];
    [_pwdField resignFirstResponder];
}

#pragma mark - Accessor Methods

- (void)setShowTrademark:(BOOL)showTrademark {
    if (_appLabelImage!=nil) {
        return;
    }
    _showTrademark = showTrademark;
    if (_showTrademark) {
        if (_tmLabel==nil) {
            _tmLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _tmLabel.textColor = [UIColor graphiteColorForTheme:SOHOXIThemeDark];
            _tmLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
            _tmLabel.backgroundColor = [UIColor clearColor];
            _tmLabel.text = @"™";
            [_autoLayoutHolderView addSubview:_tmLabel];
            [_tmLabel sizeToFit];
            _tmLabel.translatesAutoresizingMaskIntoConstraints = NO;
        }
        NSDictionary *viewDict = @{@"appLabel":_appNameLabel, @"tmlabel":_tmLabel};
        NSString *visualFormat = @"H:[appLabel]-0-[tmlabel]";
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                       options:NSLayoutFormatAlignAllTop
                                                                       metrics:nil
                                                                         views:viewDict];
        [_autoLayoutHolderView addConstraints:constraints];
        
        _tmLabel.hidden = NO;
    }else{
        _tmLabel.hidden = YES;
    }
}

- (void)setShowSettings:(BOOL)showSettings {
    _showSettings = showSettings;
    _settingBtn.hidden = !_showSettings;
}

- (void)setShowForgotPWD:(BOOL)showForgotPWD {
    _showForgotPWD = showForgotPWD;
    _retrievePwdBtn.hidden = !_showForgotPWD;
}

- (void)setShowCornerLogo:(BOOL)showCornerLogo {
    _showCornerLogo = showCornerLogo;
    _cornerLogo.hidden = !_showCornerLogo;
}

- (void)setShowCopyRight:(BOOL)showCopyRight {
    _showCopyRight = showCopyRight;
    _copyrightLabel.hidden = !_showCopyRight;
}

- (void)setActionBtnTitle:(NSString *)actionBtnTitle {
    _actionBtnTitle = actionBtnTitle;
    [_logInBtn setTitle:actionBtnTitle forState:UIControlStateNormal];
}

- (void)setAppLabelImage:(UIImage *)appLabelImage {
    if ([_appLabelString length]>0) {
        _appLabelString = nil;
        _appNameLabel.text = nil;
    }
    
    _appLabelImage = appLabelImage;
    _appImageView.image = _appLabelImage;
}

- (void)setAppLabelString:(NSString *)appLabelString {
    if (_appLabelImage!=nil) {
        _appLabelImage = nil;
        _appImageView.image = nil;
    }
    _appLabelString = appLabelString;
    _appNameLabel.text = _appLabelString;
    [_appNameLabel sizeToFit];
    CGPoint center = _appNameLabel.center;
    center.x = roundf(CGRectGetWidth(self.view.frame)/2.f);
    _appNameLabel.center = center;
    self.showTrademark = _showTrademark;
}


#pragma mark - Notification Handling

- (void)keyboardWillShow {
    [self pushBoundsUp:YES];
}

- (void)keyboardWillDismiss {
    [self pushBoundsUp:NO];
}

- (void)didChangePreferredContentSize:(NSNotification *)notification {
    _appNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _userField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _pwdField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _logInBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _settingBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _retrievePwdBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _copyrightLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    _tmLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
}

#pragma mark - Helper Methods

- (void)startLoading {
    if (_isLoading) {
        return;
    }
    
    [self setIndicatoryColor:UIIndicatoryColorClear];
    
    if (!_loadingLayer) {
        _loadingLayer = [[SHXSpriteLayer alloc] init];
        _loadingLayer.backgroundColor = [[UIColor clearColor] CGColor];
        CGImageRef animationImage = [[UIImage imageNamed:@"LoadingAnimation"] CGImage];
        _loadingLayer.contents = (__bridge id)(animationImage);
        CGSize size = CGSizeMake(45, 15);
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGSize normalizedSize = CGSizeMake(scale*size.width/CGImageGetWidth(animationImage), scale*size.height/CGImageGetHeight(animationImage));
        _loadingLayer.bounds = CGRectMake(0, 0, size.width, size.height);
        _loadingLayer.contentsRect = CGRectMake(0, 0, normalizedSize.width, normalizedSize.height);
        _loadingLayer.frame = CGRectMake(_logInBtn.center.x-roundf(size.width/2.f), _logInBtn.center.y-roundf(size.height/2.f),
                                         size.width, size.height);
        [self.view.layer addSublayer:_loadingLayer];
    }
    
    _loadingLayer.opacity = 1.f;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"contentIndex"];
    anim.fromValue = [NSNumber numberWithInt:1];
    anim.toValue = [NSNumber numberWithInt:14];
    anim.duration = 1.0f;
    anim.repeatCount = HUGE_VALF;
    anim.autoreverses = NO;
    [_loadingLayer addAnimation:anim forKey:LOADING_ANIM_KEY];
    [_containerView.layer addSublayer:_loadingLayer];
    
    [_logInBtn setTitle:@"" forState:UIControlStateNormal];
    _logInBtn.enabled = NO;
    _settingBtn.enabled = NO;
    _isLoading = YES;
}

- (void)cancelLoading {
    _loadingLayer.opacity = 0.f;
    [_loadingLayer removeAnimationForKey:LOADING_ANIM_KEY];
    
    [_logInBtn setTitle:NSLocalizedStringFromTable(@"login_btn_title", @"LoginStrings", nil)
               forState:UIControlStateNormal];
    _logInBtn.enabled = YES;
    _settingBtn.enabled = YES;
    _isLoading = NO;
}

- (void)doneLoading {
    _loadingLayer.opacity = 0.f;
    [_loadingLayer removeAnimationForKey:LOADING_ANIM_KEY];
    
    [_logInBtn setTitle:@"" forState:UIControlStateNormal];
    _logInBtn.enabled = NO;
    _settingBtn.enabled = NO;
    _retrievePwdBtn.enabled = NO;
    _isLoading = NO;
}

- (void)setIndicatoryColor:(UIIndicatoryColor)color {
    UIColor *tintColor, *boardColor, *textColor;
    if (color==UIIndicatoryColorClear) {
        tintColor = [UIColor colorWithWhite:200.f/255.f alpha:1.f];
        boardColor = [UIColor clearColor];
        textColor = TEXT_COLOR;
    }else if (color==UIIndicatoryColorRed) {
        tintColor = [UIColor redAlertColor];
        boardColor = [UIColor redAlertColor];
        textColor = [UIColor redAlertColor];
    }
    
    _pwdIcon.image = [UIImage imageNamed:@"LogInPwd" withColor:tintColor];
    _userIcon.image = [UIImage imageNamed:@"LogInUser" withColor:tintColor];
    _pwdBG.layer.borderColor = [boardColor CGColor];
    _userBG.layer.borderColor = [boardColor CGColor];
    _pwdField.textColor = textColor;
    _userField.textColor = textColor;
}

- (void)shouldShowHeader:(BOOL)showHeader {
    if (_appImageView) {
        [_appImageView.layer removeAllAnimations];
        
        [UIView animateWithDuration:.3f animations:^{
            _appImageView.alpha = showHeader;
        }];
    }
    
    if (_appNameLabel) {
        [_appNameLabel.layer removeAllAnimations];
        
        [UIView animateWithDuration:.3f animations:^{
            _appNameLabel.alpha = showHeader;
        }];
    }
}

- (void)pushBoundsUp:(BOOL)isUp {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if (IS_IPAD &&
        orientation==UIDeviceOrientationPortrait) {
        return;
    }
    
    if (IS_IPAD &&
        (orientation==UIDeviceOrientationLandscapeLeft || orientation==UIDeviceOrientationLandscapeRight) &&
        CGRectGetMinY(self.view.bounds)>0 &&
        isUp) {
        return;
    }
    
    if ((!isUp && CGRectGetMinY(self.view.bounds)==0) ||
        (isUp && CGRectGetMinY(self.view.bounds)>0)) {
        return;
    }
    
    [self.view.layer removeAllAnimations];
    
    CGRect bounds = self.view.bounds;
    if (isUp) {
        CGFloat distance = IS_IPAD?IPAD_KEYBOARD_DISTANCE:IPHONE_KEYBOARD_DISTANCE;
        bounds.origin.y = distance;
    }else{
        bounds.origin.y = 0;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.view.bounds = bounds;
        if (IS_IOS7 && IS_IPHONE4) {
            _appNameLabel.alpha = isUp?0:1;
        }
    }];
}

- (void)anchorSubView:(UIView *)subView toOccupySuperView:(UIView *)superView {
    BOOL shouldAddConstraint = NO;
    for (UIView *aView in [superView subviews]) {
        if (aView==subView) {
            shouldAddConstraint = YES;
            break;
        }
    }
    if (!shouldAddConstraint) {
        return;
    }
    
    // width
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:subView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:superView
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1
                                                                        constant:0];
    [superView addConstraint:widthConstraint];
    
    // height
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:subView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:superView
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1
                                                                         constant:0];
    [superView addConstraint:heightConstraint];
    
    NSDictionary *viewDict = @{@"theSubView":subView};
    // leading/trailing edge
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[theSubView]-0-|" options:0 metrics:nil views:viewDict];
    [superView addConstraints:horizontal];
    
    // top/bottom edge
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[theSubView]-0-|" options:0 metrics:nil views:viewDict];
    [superView addConstraints:vertical];
}

- (void)anchorSubView:(UIView *)subView inSuperView:(UIView *)superView offset:(CGPoint)offset {
    // center x
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:subView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.f
                                                                          constant:roundf(offset.x)];
    [superView addConstraint:centerXConstraint];
    
    // center y
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:subView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.f
                                                                          constant:roundf(offset.y)];
    [superView addConstraint:centerYConstraint];
}

- (void)fixSizeOfView:(UIView *)aView toSize:(CGSize)size {
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:aView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:roundf(size.width)];
    [aView addConstraint:width];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:aView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:roundf(size.height)];
    [aView addConstraint:height];
}

@end
