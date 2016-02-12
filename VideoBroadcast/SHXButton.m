//
//  SHXButton.m
//  SohoXiButton
//
//  Created by Lin Zhou on 12/14/15.
//  Copyright © 2015 Infor Global Solutions. All rights reserved.
//

#import "SHXButton.h"
#import "UIImage+SHXButtonImage.m"
#import "UIColor+SohoXiColor.h"

@implementation SHXButton

+ (instancetype)sohoButtonWithStyle:(SOHOXIButtonStyle)buttonStyle {
    SHXButton *newBtn = [self buttonWithType:UIButtonTypeCustom];
    newBtn.buttonStyle = buttonStyle;
    newBtn.textVerticalPad = 0;
    newBtn.textHorizontalPad = 15;
    newBtn.autoCapitalizeTitle = YES;
    newBtn.titleEdgeInsets = UIEdgeInsetsMake(newBtn.textVerticalPad, newBtn.textHorizontalPad, newBtn.textVerticalPad, newBtn.textHorizontalPad);
    [[NSNotificationCenter defaultCenter] addObserver:newBtn
                                             selector:@selector(didChangePreferredFontSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    if (buttonStyle==SOHOXIButtonStyleTertiary) {
        [newBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [newBtn setTitleColor:[UIColor graphiteColor:5] forState:UIControlStateNormal];
        [newBtn setTitleColor:[UIColor graphiteColor:7] forState:UIControlStateHighlighted];
        newBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    }else if (buttonStyle==SOHOXIButtonStylePrimary ||
              buttonStyle==SOHOXIButtonStyleWarning ||
              buttonStyle==SOHOXIButtonStyleDestroy) {
        UIColor *bgColor = nil, *bgColorHighlighted = nil;
        if (buttonStyle==SOHOXIButtonStylePrimary) {
            bgColor = [UIColor azureColor];
            bgColorHighlighted = [UIColor azureColor:8];
        }else if (buttonStyle==SOHOXIButtonStyleWarning) {
            bgColor = [UIColor amberColor];
            bgColorHighlighted =[UIColor amberColor:8];
        }else{
            bgColor = [UIColor rubyColor];
            bgColorHighlighted = [UIColor rubyColor:8];
        }
        
        CGFloat cornerRadius = SHXBUTTON_IMAGE_DEFAULT_CORNOR_RADIUS;
        UIImage *bgImage = [[UIImage buttonImageWithColor:bgColor] stretchableImageWithLeftCapWidth:cornerRadius topCapHeight:cornerRadius];
        UIImage *bgImageHighlighted = [[UIImage buttonImageWithColor:bgColorHighlighted] stretchableImageWithLeftCapWidth:cornerRadius topCapHeight:cornerRadius];
        [newBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [newBtn setBackgroundImage:bgImageHighlighted forState:UIControlStateHighlighted];
        [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        newBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }else if (buttonStyle==SOHOXIButtonStyleSecondary) {
        UIColor *bgColor = [UIColor slateColor:4];
        UIColor *bgColorHighlighted = [UIColor slateColor:5];
        CGFloat cornerRadius = SHXBUTTON_IMAGE_DEFAULT_CORNOR_RADIUS;
        UIImage *bgImage = [[UIImage buttonImageWithColor:bgColor] stretchableImageWithLeftCapWidth:cornerRadius topCapHeight:cornerRadius];
        UIImage *bgImageHighlighted = [[UIImage buttonImageWithColor:bgColorHighlighted] stretchableImageWithLeftCapWidth:cornerRadius topCapHeight:cornerRadius];
        [newBtn  setBackgroundImage:bgImage forState:UIControlStateNormal];
        [newBtn setBackgroundImage:bgImageHighlighted forState:UIControlStateHighlighted];
        [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        newBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }
    
    return newBtn;
}

- (void)setTextHorizontalPad:(CGFloat)textHorizontalPad {
    _textHorizontalPad = textHorizontalPad;
    UIEdgeInsets insets = self.titleEdgeInsets;
    insets.left = _textHorizontalPad;
    insets.right = _textHorizontalPad;
    self.titleEdgeInsets = insets;
    [self setNeedsLayout];
}

- (void)setTextVerticalPad:(CGFloat)textVerticalPad {
    _textVerticalPad = textVerticalPad;
    UIEdgeInsets insets = self.titleEdgeInsets;
    insets.top = _textVerticalPad;
    insets.bottom = _textVerticalPad;
    self.titleEdgeInsets = insets;
    [self setNeedsLayout];
}

- (void)setButtonStyle:(SOHOXIButtonStyle)buttonStyle {
    _buttonStyle = buttonStyle;
}

- (void)didChangePreferredFontSize:(NSNotification *)notification {
    if (_buttonStyle==SOHOXIButtonStyleTertiary) {
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    }else if (_buttonStyle==SOHOXIButtonStylePrimary) {
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }else if (_buttonStyle==SOHOXIButtonStyleSecondary) {
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }
    [self setNeedsLayout];
}

#pragma mark - Overwrite

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    if (_autoCapitalizeTitle) {
        [super setTitle:[title uppercaseString] forState:state];
    }else{
        [super setTitle:title forState:state];
    }
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width+self.titleEdgeInsets.left+self.titleEdgeInsets.right, size.height+self.titleEdgeInsets.top+self.titleEdgeInsets.bottom);
}

@end

