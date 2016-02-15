//
//  UIView+ViewConstraints.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/14/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "UIView+ViewConstraints.h"

@implementation UIView (ViewConstraints)

- (void)addConstraintsToFillSuperview {
    NSDictionary *views = NSDictionaryOfVariableBindings(self);
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:views]];
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:nil views:views]];
}

@end
