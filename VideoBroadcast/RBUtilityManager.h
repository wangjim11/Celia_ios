//
//  RBUtilityManager.h
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/14/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBUtilityManager : NSObject
+ (instancetype)sharedInstance;
- (NSString *)deviceUID;
@end
