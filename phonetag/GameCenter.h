//
//  GameCenter.h
//  phonetag
//
//  Created by Brandon Phillips on 5/28/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

extern NSString *const ShowLogin;
extern NSString *const HideLogin;

@interface GameCenter : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;

@end
