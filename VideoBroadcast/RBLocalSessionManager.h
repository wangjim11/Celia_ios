//
//  RBLocalSessionManager.h
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/14/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RBLocalSessionManager : NSObject
@property (nonatomic, weak) UIView *localSessionView;
+ (nonnull instancetype)sharedInstance;
- (void)prepare;
- (void)startRunning;
- (void)stopRunning;

@end
