//
//  AppDelegate.m
//  phonetag
//
//  Created by Brandon Phillips on 5/28/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"basic_info, email, user_friends", nil];
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    cLocationManager = [[CLLocationManager alloc] init];
    cLocationManager.delegate = self;
    cLocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    cLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 10 m
    
    [cLocationManager startUpdatingLocation];
    myInfo = [PTStaticInfo sharedManager];
    
    if (myInfo.ptId){
        [self refreshArsenal];
        NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        [myInfo addVersion:versionNumber];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshArsenal)
                                                 name:@"purchaseditem" object:nil];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
       return YES;
}

- (void)refreshArsenal{
    arsenalArray = [[NSArray alloc]init];
    NSString *fullURL = [NSString stringWithFormat: @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=getuserarsenal&user=%@", myInfo.ptId];
    
    NSURLSession *userArsenalSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *userArsenalTask = [userArsenalSession dataTaskWithURL:[NSURL URLWithString:fullURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{

            NSError *error = nil;
            arsenalArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            [myInfo arsenal:arsenalArray];
            [self getArsenal];
            
        });
    }];
    
    [userArsenalTask resume];
}

- (void)getArsenal{
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=getarsenalstore";
    
    NSURLSession *arsenalStoreSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *arsenalStoreTask = [arsenalStoreSession dataTaskWithURL:[NSURL URLWithString:fullURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSError *error = nil;
            mainArsenalArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            NSLog(@"datastring %@", mainArsenalArray);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"arsenalRefresh" object:self];
            
        });
    }];
    
    [arsenalStoreTask resume];
}


- (void)locationManager:(CLLocationManager *)manager

    didUpdateToLocation:(CLLocation *)newLocation

           fromLocation:(CLLocation *)oldLocation

{
    
    // GEO FENCING STUFF
    
    static BOOL firstTime=TRUE;
    if(firstTime)
    {
        firstTime = FALSE;
        [self CheckThroughRegionsForHitLocation:newLocation];
        [self updateLocation: newLocation];
        //Stop Location Updation, we dont need it now.
        [cLocationManager stopUpdatingLocation];
    }
}


-(void)CheckThroughRegionsForHitLocation:(CLLocation *)newLocation{
    NSSet * monitoredRegions = cLocationManager.monitoredRegions;
    if(monitoredRegions)
    {
        [monitoredRegions enumerateObjectsUsingBlock:^(CLRegion *region,BOOL *stop)
         {
             NSString *identifer = region.identifier;
             CLLocationCoordinate2D centerCoords =region.center;
             CLLocationCoordinate2D currentCoords= CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude);
             CLLocationDistance radius = region.radius;

             NSNumber * currentLocationDistance =[self calculateDistanceInMetersBetweenCoord:currentCoords coord:centerCoords];
             [cLocationManager stopMonitoringForRegion:region];

             if([currentLocationDistance floatValue] < radius*10)
             {
                 
                 //stop Monitoring Region temporarily
                 
                 [self locationManager:cLocationManager didEnterRegion:region];
                 [cLocationManager stopMonitoringForRegion:region];

                 //start Monitoing Region again.
                 //[cLocationManager startMonitoringForRegion:region];
             }
         }];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!_didStartMonitoringRegion) {
        
        
        // Update Helper
        _didStartMonitoringRegion = YES;
        
        // Fetch Current Location
        CLLocation *location = [locations objectAtIndex:0];
        cLocation = location;
        [cLocationManager stopUpdatingLocation];
        if(myInfo.ptId){
            [self updateMineLocations];

        }
        [self CheckThroughRegionsForHitLocation:location];
        [self updateLocation: [locations objectAtIndex:0]];
    }
}

-(void)updateMineLocations{
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=getMineData";
    
    
    NSString *post = [NSString stringWithFormat: @"uid=%@", myInfo.ptId];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *mineRequest = [[NSMutableURLRequest alloc] init];
    [mineRequest setURL:[NSURL URLWithString:fullURL]];
    [mineRequest setHTTPMethod:@"POST"];
    [mineRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [mineRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [mineRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *mineSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *mineTask = [mineSession dataTaskWithRequest:mineRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            //NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSArray *fenceArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            for (NSDictionary *fence in fenceArray){
                 NSString *identifier = [fence valueForKey:@"userWhoDroppedTheMine"];
                
                if([identifier isEqualToString:myInfo.ptId]){

                }else{
                CLRegion *region = [self dictToRegion:fence];
                [self.geofences addObject:region];
                [cLocationManager startMonitoringForRegion:region];
                }
            }
            [self CheckThroughRegionsForHitLocation:cLocation];
        });
    }];
    
    [mineTask resume];
}






-(void)updateLocation: (CLLocation*) location{
    NSString *lati = [[NSString alloc] initWithFormat:@"%g", location.coordinate.latitude];
    NSString *longi = [[NSString alloc] initWithFormat:@"%g", location.coordinate.longitude];
    [cLocationManager stopUpdatingLocation];
    NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSString *post = [NSString stringWithFormat: @"id=%@&lat=%@&longi=%@&v=%f", myInfo.ptId, lati, longi, [versionNumber floatValue]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=updateLocation";
    
    NSMutableURLRequest *registerRequest = [[NSMutableURLRequest alloc] init];
    [registerRequest setURL:[NSURL URLWithString:fullURL]];
    [registerRequest setHTTPMethod:@"POST"];
    [registerRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [registerRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [registerRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *registerSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *registerTask = [registerSession dataTaskWithRequest:registerRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:datastring forKey:@"currentVersion"];
            _didStartMonitoringRegion = FALSE;
        });
    }];
    
    [registerTask resume];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSString *post = [NSString stringWithFormat: @"uid=%@&bombid=%@", myInfo.ptId, region.identifier];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=hitMine";
    
    NSMutableURLRequest *enterRegionRequest = [[NSMutableURLRequest alloc] init];
    [enterRegionRequest setURL:[NSURL URLWithString:fullURL]];
    [enterRegionRequest setHTTPMethod:@"POST"];
    [enterRegionRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [enterRegionRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [enterRegionRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *enterRegionSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *enterRegionTask = [enterRegionSession dataTaskWithRequest:enterRegionRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            //NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        });
    }];
    
    [enterRegionTask resume];
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
}

- (NSNumber*)calculateDistanceInMetersBetweenCoord:(CLLocationCoordinate2D)coord1 coord:(CLLocationCoordinate2D)coord2 {
    NSInteger nRadius = 6371; // Earth's radius in Kilometers
    double latDiff = (coord2.latitude - coord1.latitude) * (M_PI/180);
    double lonDiff = (coord2.longitude - coord1.longitude) * (M_PI/180);
    double lat1InRadians = coord1.latitude * (M_PI/180);
    double lat2InRadians = coord2.latitude * (M_PI/180);
    double nA = pow ( sin(latDiff/2), 2 ) + cos(lat1InRadians) * cos(lat2InRadians) * pow ( sin(lonDiff/2), 2 );
    double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
    double nD = nRadius * nC;
    // convert to meters
    return @(nD*1000);
}

- (CLRegion*)dictToRegion:(NSDictionary*)dictionary
{
    NSString *identifier = [dictionary valueForKey:@"id"];
    CLLocationDegrees latitude = [[dictionary valueForKey:@"mineLat"] doubleValue];
    CLLocationDegrees longitude =[[dictionary valueForKey:@"mineLongi"] doubleValue];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationDistance regionRadius = [[dictionary valueForKey:@"radius"] doubleValue] *100;
    
    if(regionRadius > cLocationManager.maximumRegionMonitoringDistance)
    {
        regionRadius = cLocationManager.maximumRegionMonitoringDistance;
    }
    
    CLRegion * region =nil;
    
    region =  [[CLCircularRegion alloc] initWithCenter:centerCoordinate
                                                radius:regionRadius
                                            identifier:identifier];
    
    return  region;
}

- (void)locationManager:(CLLocationManager *)manager

       didFailWithError:(NSError *)error

{
    
    NSLog(@"Error: %@", [error description]);
    
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // Note this handler block should be the exact same as the handler passed to any open calls.
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
     }];
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        // Show the user the logged-in UI
        //[self userLoggedIn];
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
            if (error) {
                // Handle error
            }
            
            else {

            }
            FBRequest* friendsRequest = [FBRequest requestForMyFriends];

            [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                          NSDictionary* result,
                                                          NSError *error) {
                NSArray* friends = [result objectForKey:@"data"];
                for (NSDictionary<FBGraphUser>* friend in friends) {
                }
            }];
            
        }];
        
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            //[self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
// USER CANCELED LOGIN
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //[self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //[self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
        if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
            UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
            
            __block UIBackgroundTaskIdentifier background_task; //Create a task object
            
            background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
                [application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
                background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
                
                //System will be shutting down the app at any point in time now
            }];
            
            
            //Background tasks require you to use asyncrous tasks
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //Perform your tasks that your application requires
                
                //BACKGROUND MODE STARTED
                
                NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:240 target:self selector:@selector(bgTimerCalled) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
                [[NSRunLoop currentRunLoop] run];
                
                [application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
                background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
            });
        }
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *tokenString = [deviceToken description];
    
    tokenString = [tokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults]setObject:tokenString forKey:@"token"];
    
    if(myInfo.ptId){
        
    NSString *post = [NSString stringWithFormat: @"id=%@&pnid=%@", myInfo.ptId, tokenString];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=updatePushnotification";
    
    NSMutableURLRequest *registerRequest = [[NSMutableURLRequest alloc] init];
    [registerRequest setURL:[NSURL URLWithString:fullURL]];
    [registerRequest setHTTPMethod:@"POST"];
    [registerRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [registerRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [registerRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *registerSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *registerTask = [registerSession dataTaskWithRequest:registerRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        });
    }];
    
    [registerTask resume];
    }
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
	[self addMessageFromRemoteNotification:userInfo updateUI:YES];
}

- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
	NSString *alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Phone Tag!"
                                                      message:alertValue
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

-(void)bgTimerCalled
{
    [cLocationManager startUpdatingLocation];
    // Your Code
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
