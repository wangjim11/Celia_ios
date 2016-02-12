//
//  SHXSpriteLayer.m
//  LoginApp
//
//  Created by Lin Zhou on 10/31/13.
//  Copyright (c) 2013 Infor Global Solutions. All rights reserved.
//

#import "SHXSpriteLayer.h"

@implementation SHXSpriteLayer

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return [key isEqualToString:@"contentIndex"];
}

- (void)display {
    NSUInteger currentSampleIndex = ((SHXSpriteLayer*)[self presentationLayer]).contentIndex;
    if (!currentSampleIndex) {
        return;
    }
    
    CGSize sampleSize = self.contentsRect.size;
    NSInteger row = (currentSampleIndex - 1) / ((NSInteger)(1/sampleSize.width));
    NSInteger col = (currentSampleIndex - 1) % ((NSInteger)(1/sampleSize.width));    
    self.contentsRect = CGRectMake(col*sampleSize.width, row*sampleSize.height,
                                   sampleSize.width, sampleSize.height);
}

+ (id < CAAction >)defaultActionForKey:(NSString *)aKey {
    if ([aKey isEqualToString:@"contentsRect"]) {
        return (id < CAAction >)[NSNull null];
    }
    
    return [super defaultActionForKey:aKey];
}

@end
