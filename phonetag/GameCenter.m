//
//  GameCenter.m
//  phonetag
//
//  Created by Brandon Phillips on 5/28/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

NSString *const ShowLogin = @"present_authentication_view_controller";
NSString *const HideLogin = @"hide_authentication_view_controller";

#import "GameCenter.h"
#import "PTStaticInfo.h"

@implementation GameCenter{
    BOOL _enableGameCenter;
}

+ (instancetype)sharedGameKitHelper
{
    static GameCenter *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameCenter alloc] init];
    });
    return sharedGameKitHelper;
}

- (id)init
{
    self = [super init];
    if (self) {
        _enableGameCenter = YES;
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        [self setLastError:error];
        
        if(viewController != nil) {
            [self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            _enableGameCenter = YES;
             NSLog(@"game center info: %@", localPlayer);
            NSString *userID = localPlayer.playerID;
            if ([userID rangeOfString:@"G:"].location == NSNotFound) {
                
            }else{
                userID = [userID stringByReplacingOccurrencesOfString:@"G:" withString:@""];
            }
            PTStaticInfo *staticUserInfo = [[PTStaticInfo alloc]init];
            //[staticUserInfo gamecenterId:userID username:localPlayer.alias fullname:localPlayer.displayName];

            [[NSNotificationCenter defaultCenter]
             postNotificationName:HideLogin
             object:self];
        } else {
            _enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController
{
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:ShowLogin
         object:self];
    }
}

- (void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@",
              [[_lastError userInfo] description]);
    }
}

@end
