//
//  RBOPTSessionManager.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBOPTSessionManager.h"
#import "RBCloudManager.h"

@interface RBOPTSessionManager ()
@property (nonatomic, strong) NSString              *publisherSessionID;
@property (nonatomic, strong) OTSession             *publisherSession;
@property (nonatomic, strong) OTPublisher           *publisher;
@property (nonatomic, strong) OTSession             *subscriberSession;
@property (nonatomic, strong) OTSubscriber          *subscriber;
@property (nonatomic, strong) NSTimer               *subscriberTimer;
@end

@implementation RBOPTSessionManager

@end
