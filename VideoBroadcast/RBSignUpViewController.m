//
//  RBSignUpViewController.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/10/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBSignUpViewController.h"
#import "AppDelegate.h"

#import "SHXButton.h"
#import "SHXSpriteLayer.h"
#import "UIColor+SohoXiColor.h"
#import "UIImage+UIImageTint.h"
#import "UIImage+SHXButtonImage.h"
#import "SHXBaseLogInConstant.h"

#import <Parse/Parse.h>

@interface RBSignUpViewController () <UITextFieldDelegate>
@property (nonatomic, assign) BOOL          isLoading;

@property (nonatomic, strong) UIControl     *autoLayoutHolderView;
@property (nonatomic, strong) UIControl     *containerView;
@property (nonatomic, strong) UILabel       *appNameLabel;
@property (nonatomic, strong) UILabel       *tmLabel;
@property (nonatomic, strong) UILabel       *copyrightLabel;

@property (nonatomic, strong) UIImageView   *userIcon;
@property (nonatomic, strong) UIImageView   *userBG;
@property (nonatomic, strong) UIImageView   *pwdIcon;
@property (nonatomic, strong) UIImageView   *pwdBG;

@property (nonatomic, strong) UITextField   *userField;
@property (nonatomic, strong) UITextField   *pwdField;
@property (nonatomic, strong) UITextField   *currentField;
@property (nonatomic, strong) UIButton      *signupBtn;
@property (nonatomic, strong) SHXSpriteLayer   *loadingLayer;

@property (nonatomic, strong) NSTimer       *resetUITimer;

@end


@implementation RBSignUpViewController {
    BOOL _logInHasFailed;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangePreferredContentSize:)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
        
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
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSignUp)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIColor *backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = backgroundColor;
    
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
    
    
    UIFont *appNameFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _appNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _appNameLabel.backgroundColor = [UIColor clearColor];
    _appNameLabel.font = appNameFont;
    _appNameLabel.textColor = [UIColor graphiteColorForTheme:SOHOXIThemeDark];
    _appNameLabel.textAlignment = NSTextAlignmentCenter;
    _appNameLabel.numberOfLines = 1;
    _appNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _appNameLabel.text = @"Sign Up";
    [_autoLayoutHolderView addSubview:_appNameLabel];
    
    CGFloat verticalGap = IS_IPAD?50.f:30.f;
    NSDictionary *labelViewDict = @{@"view":_containerView, @"label":_appNameLabel};
    NSString *labelVisualFormat = [NSString stringWithFormat:@"V:[label]-%d-[view]", (int)verticalGap];
    NSArray *labelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:labelVisualFormat
                                                                        options:NSLayoutFormatAlignAllCenterX
                                                                        metrics:nil
                                                                          views:labelViewDict];
    [_autoLayoutHolderView addConstraints:labelConstraints];
    
    UIImage *image = [[UIImage buttonImageWithColor:[UIColor colorWithWhite:248.f/255.f alpha:1]] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *separator = [UIImage imageNamed:@"LogInLineBreak"];
    
    // User name
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
    
    // Password
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
    
    _signupBtn = ({
        SHXButton *btn = [SHXButton sohoButtonWithStyle:SOHOXIButtonStylePrimary];
        btn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        [btn setTitle:@"Sign Up" forState:UIControlStateNormal];
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _signupBtn.enabled = ([_userField hasText] && [_pwdField hasText]);
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
        _signupBtn.enabled = [newString length]>0 && [_pwdField hasText];
    }else if (textField==_pwdField) {
        _signupBtn.enabled = [newString length]>0 && [_userField hasText];
    }
    
    if ([string isEqualToString:@"\n"]) {
        if (textField==_userField) {
            [_pwdField becomeFirstResponder];
            return NO;
        }else if (textField==_pwdField) {
            [_pwdField resignFirstResponder];
            
            if (![_userField hasText]) {
                [self userNameMissingAction];
                _signupBtn.enabled = NO;
                return NO;
            }
            if (![_pwdField hasText]) {
                [self passwordMissingAction];
                _signupBtn.enabled = NO;
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
    
    _signupBtn.enabled = [_userField hasText] && [_pwdField hasText];
    
    if (_currentField==textField) {
        _currentField = nil;
    }
}


#pragma mark - UI Action Methods

- (void)cancelSignUp {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)releaseKeyboard {
    _currentField = nil;
    
    [_userField resignFirstResponder];
    [_pwdField resignFirstResponder];
}

- (void)userNameMissingAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please provide a user name." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)passwordMissingAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please provide a password." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)roleMissingAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please pick a user role." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)logInAction {
    if (_currentField!=nil) {
        [self releaseKeyboard];
    }
    
    [self startLoading];
    
    __weak RBSignUpViewController *weakSelf = self;
    PFUser *user = [PFUser user];
    user.username = _userField.text;
    user.password = _pwdField.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [weakSelf logInSuccessAction];
        }else{
            [weakSelf logInFailedAction];
        }
    }];
}

- (void)logInSuccessAction {
    [self doneLoading];
    
    if (_logInHasFailed) {
        _logInHasFailed = NO;
        [self setIndicatoryColor:UIIndicatoryColorClear];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate updateRootViewController];
    }];
}

- (void)logInFailedAction {
    [self cancelLoading];
    
    _logInHasFailed = YES;
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

#pragma mark - Notification Handling

- (void)didChangePreferredContentSize:(NSNotification *)notification {
    _appNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _userField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _pwdField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _signupBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _copyrightLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    _tmLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
}

- (void)keyboardWillShow {
    [self pushBoundsUp:YES];
}

- (void)keyboardWillDismiss {
    [self pushBoundsUp:NO];
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
        _loadingLayer.frame = CGRectMake(_signupBtn.center.x-roundf(size.width/2.f), _signupBtn.center.y-roundf(size.height/2.f),
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
    
    [_signupBtn setTitle:@"" forState:UIControlStateNormal];
    _signupBtn.enabled = NO;
    _isLoading = YES;
}

- (void)cancelLoading {
    _loadingLayer.opacity = 0.f;
    [_loadingLayer removeAnimationForKey:LOADING_ANIM_KEY];
    
    [_signupBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
    _signupBtn.enabled = YES;
    _isLoading = NO;
}

- (void)doneLoading {
    _loadingLayer.opacity = 0.f;
    [_loadingLayer removeAnimationForKey:LOADING_ANIM_KEY];
    
    [_signupBtn setTitle:@"" forState:UIControlStateNormal];
    _signupBtn.enabled = NO;
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
