//
//  RBUtilityManager.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/14/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBUtilityManager.h"
#import "UICKeyChainStore.h"

@interface RBUtilityManager ()
@property (nonatomic, strong) NSString  *deviceID;
@end

@implementation RBUtilityManager

+ (instancetype)sharedInstance {
    static RBUtilityManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RBUtilityManager alloc] initInternal];
    });
    return _sharedInstance;
}

- (instancetype)init {
    [NSException exceptionWithName:@"Use shared instance of RBUtilityManager" reason:@"" userInfo:nil];
    return nil;
}

- (instancetype)initInternal {
    self = [super init];
    if (self) {
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"RoboTex"];
        _deviceID = [keychain stringForKey:@"UUID"];
        if (![_deviceID length]) {
            CFUUIDRef theUUID = CFUUIDCreate(NULL);
            CFStringRef stringRef = CFUUIDCreateString(NULL, theUUID);
            _deviceID = [(__bridge NSString *)stringRef copy];
            CFRelease(theUUID);
            [keychain setString:_deviceID forKey:@"UUID"];
        }
    }
    return self;
}

- (NSString *)deviceUID {
    return _deviceID;
}

@end
