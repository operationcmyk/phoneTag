//
//  AppDelegate.h
//  phonetag
//
//  Created by Brandon Phillips on 5/28/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PTStaticInfo.h"
#import <AudioToolbox/AudioServices.h>
#import <CoreLocation/CoreLocation.h>

    CLLocationManager *cLocationManager;
    PTStaticInfo *myInfo;
    CLLocation *cLocation;
    BOOL _didStartMonitoringRegion;
    NSArray *arsenalArray;
    NSArray *mainArsenalArray;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate, NSURLSessionDelegate>



@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *transactionArray;
@property (strong, nonatomic) NSMutableArray *geofences;

- (void)refreshArsenal;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
@end
