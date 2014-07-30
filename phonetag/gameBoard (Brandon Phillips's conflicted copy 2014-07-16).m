//
//  gameBoard.m
//  phonetag
//
//  Created by Christopher on 6/3/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "gameBoard.h"
#import "AppDelegate.h"

@interface gameBoard ()

@end

@implementation gameBoard

@synthesize mapView;


#pragma mark - locationServices
-(void)initLocationManager {
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 100 m
        // [locationManager startUpdatingLocation];
        [locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //NSLog(@"this is working");
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //NSLog(@"this isnt working");
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.07;
    span.longitudeDelta = 0.07;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    currentLocation = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    foundPlace++;
    
    if(foundPlace == 1){
        userLat = [[NSString alloc]initWithFormat:@"%f", location.latitude ];
        userLongi = [[NSString alloc]initWithFormat:@"%f", location.longitude];
        
        region.span = span;
        region.center = location;
        [aMapView setRegion:region animated:YES];
        NSLog(@"found you at long: %@ and lat: %@", userLongi, userLat);
        loadingMap.hidden = YES;
        
        if (topDoorBox.frame.origin.y == 0){
            NSLog(@"updating location!");
            myLocationUpdated = TRUE;
            [self openLoaderDoor];
        }
        //[self getAllBombs];
        //[self checkForHit];
        
        
    }
}


-(void)mapView:(MKMapView *)pMapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"regionChanges");
    //NSLog(@"mapView.region.span.latitudeDelta = %f",pMapView.region.span.latitudeDelta);
    for (id <MKAnnotation>annotation in pMapView.annotations) {
        // if it's the user location, just return nil.
        // try to retrieve an existing pin view first
        MKAnnotationView *pinView = [pMapView viewForAnnotation:annotation];
        //Format the pin view
        [self formatAnnotationView:pinView forMapView:pMapView];
        
    }
}
#define MERCATOR_RADIUS 85445659.44705395

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation {
    mapAnnotations *txts = [[mapAnnotations alloc] init];
    txts = annotation;
    MKAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        //if(madeAnnots == 1){[mapView removeAnnotation:pinView];}
        static NSString *defaultPinID = @"com.operationcmyk.pin";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        //pinView.pinColor = MKPinAnnotationColorPurple;
        pinView.canShowCallout = YES;
        CGRect resizeRect;
        UIImage *uiimage = [UIImage imageNamed:txts.subtitle];

        CGSize size = uiimage.size;
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        //[uiimage drawAtPoint:CGPointZero blendMode:kCGBlendModeColorBurn alpha:0.5];
        CGRect rect = CGRectMake(0, 0, uiimage.size.width, uiimage.size.height);
        //CGContextDrawImage(context, rect, uiimage.CGImage);
        float alphaNumber = 0.5;
        if([txts.title isEqualToString:@"homeBase"]){alphaNumber = 1;}
        if([txts.title isEqualToString:@"hit"]){alphaNumber = 1;}
        
        [uiimage drawAtPoint:CGPointZero blendMode:kCGBlendModeColorBurn alpha:alphaNumber];
        
        UIImage* flagImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        resizeRect.size = flagImage.size;
//        CGSize maxSize = CGRectInset(self.view.bounds,
//                                     [gameBoard annotationPadding],
//                                     [gameBoard annotationPadding]).size;
//        maxSize.height -= self.navigationController.navigationBar.frame.size.height + [gameBoard calloutHeight];
//        if (resizeRect.size.width > maxSize.width)
//            resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
//        if (resizeRect.size.height > maxSize.height)
//            resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
        
        //        resizeRect.origin = (CGPoint){0.0f, 0.0f};
        //       UIGraphicsBeginImageContext(resizeRect.size);
        //       [flagImage drawInRect:resizeRect];
        //       UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext();
        
        
       	UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
        myLabel.text = @"cites";
        
        pinView.image = flagImage;
        pinView.opaque = YES;
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //  double footnoteDistance = [txts.noteDistance doubleValue];
        CLLocationCoordinate2D cooords = currentLocation;
        
        //NSLog(@"this is the distance to the note %f", footnoteDistance);
    }
    else {
        [mapView.userLocation setTitle:@"hello"];
    }
    NSTimeInterval delayInterval = 0;
    [mapView setTransform:CGAffineTransformMakeScale(.9999, .9999)]; //iOS6 BUG WORKAROUND !!!!!!!
    
    
    return pinView;
    
}


- (void)formatAnnotationView:(MKAnnotationView *)pinView forMapView:(MKMapView *)aMapView {
    if (pinView)
    {
               // double zoomLevel = [aMapView getZoomLevel];
        double zoomLevel = (21 - round(log2(mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapView.bounds.size.width))));
        //        double scale = -1 * sqrt((double)(1 - pow((zoomLevel/20.0), 2.0))) + 1.1; // This is a circular scale function where at zoom level 0 scale is 0.1 and at zoom level 20 scale is 1.1
        NSLog(@"%f",zoomLevel);
        double scale = pow(((zoomLevel-7)/10),5); // This is a circular scale function where at zoom level 0 scale is 0.1 and at zoom level 20 scale is 1.1
        // Option #1
        NSLog(@"%@",[pinView.annotation subtitle]);
        
        UIImage *orangeImage = [UIImage imageNamed:[pinView.annotation subtitle]];
        CGRect resizeRect;
        //rescale image based on zoom level
        resizeRect.size.height = 300 * scale;
        resizeRect.size.width = 300  * scale ;
        NSLog(@"height =  %f, width = %f, zoomLevel = %f", resizeRect.size.height, resizeRect.size.width,zoomLevel );
        resizeRect.origin = (CGPoint){0,0};
         float alphaNumber = 0.5;
        UIGraphicsBeginImageContext(resizeRect.size);
        [orangeImage drawInRect:resizeRect];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();
        //[resizedImage drawInRect:resizeRect blendMode:kCGBlendModeColorBurn alpha:alphaNumber];

        pinView.image = resizedImage;
        
        
        
        //[UIView beginAnimations:@"UIBase Hide" context:nil];
        //[UIView setAnimationDuration:.01];
        
        //[UIView commitAnimations];
        //CGAffineTransform moveit = CGAffineTransformMakeScale(scale, scale);
        //pinView.transform = moveit;
        [pinView setNeedsDisplay];
        //NSLog(@"zoomlevel: %f   Scale: %f",zoomLevel,scale);
        // Option #2
        
    }
}

-(void)refreshAnnotationViews{
    
    
    for (id <MKAnnotation>annotation in mapView.annotations) {
        // if it's the user location, just return nil.
        if ([annotation isKindOfClass:[MKUserLocation class]])
            return;
        
        // handle our custom annotations
        //
        if ([annotation isKindOfClass:[MKPointAnnotation class]])
        {
            // try to retrieve an existing pin view first
            MKAnnotationView *pinView = [mapView viewForAnnotation:annotation];
            //Format the pin view
            [self formatAnnotationView:pinView forMapView:mapView];
        }
    }
    
}


#pragma mark - touch methods

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchRecognizer {
    NSLog(@"recognizedPinch");

    if (pinchRecognizer.state != UIGestureRecognizerStateChanged) {
    }
    
    MKMapView *aMapView = (MKMapView *)pinchRecognizer.view;
    
    for (id <MKAnnotation>annotation in aMapView.annotations) {
        // if it's the user location, just return nil.
        if ([annotation isKindOfClass:[MKUserLocation class]])
            return;
        
        // handle our custom annotations
        //
        if ([annotation isKindOfClass:[MKPointAnnotation class]])
        {
            // try to retrieve an existing pin view first
            MKAnnotationView *pinView = [aMapView viewForAnnotation:annotation];
            //Format the pin view
            [self formatAnnotationView:pinView forMapView:aMapView];
        }
    }
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    startLocation = pt;
    
}


- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    NSLog(@"YOUTCH");
    for (UIImageView *bomber in unusedBombs){
        CGRect frame = [bomber frame];
        if(pt.x>frame.origin.x && pt.x<(frame.origin.x+frame.size.width) && pt.y>frame.origin.y && pt.y<frame.origin.y+frame.size.height && !bombTouch){
            bombTouch = TRUE;
            activeBomb = bomber;
            crossHairs.hidden = FALSE;
        }
        if(bombTouch)
        {
            CGRect frame = [bomber frame];
            NSLog(@"This is the size of the bomb frame %f and %f",frame.size.width,frame.size.height);

            frame = CGRectMake(pt.x-75, pt.y-108, 150, 150);
            [activeBomb setFrame: frame];
            [crossHairs setFrame:CGRectMake(pt.x-100, pt.y-100, 200, 200)];
        }
    }
    for (UIImageView *bases in unPlacedBases){
        CGRect frame = [bases frame];
    
        NSLog(@"this is frame of the bases %f and pt %f",frame.size.height,pt.y);
        CGPoint basePoint = CGPointMake(frame.origin.x, frame.origin.y);
        basePoint = [indGameSetup convertPoint:basePoint toView:nil];
        if(pt.x>frame.origin.x && pt.x<(frame.origin.x+frame.size.width) && pt.y>frame.origin.y && pt.y<frame.origin.y+frame.size.height && !homeTouch){
            homeTouch = TRUE;
            activeBases = bases;
            crossHairs.hidden = FALSE;
        }
        if(homeTouch)
        {
            frame = CGRectMake(pt.x-(frame.size.width/2), pt.y-(frame.size.height/2), 150, 150);
            [activeBases setFrame: frame];
            [crossHairs setFrame:CGRectMake(frame.origin.x-25, frame.origin.y-25, 200, 200)];
        }
    }
    
    
    
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    startLocation = pt;
    pt.x = pt.x - 0;
    pt.y = pt.y - 109;
    
    if(bombTouch){
        activeBomb.hidden = TRUE;
        [unusedBombs removeObject:activeBomb];
        //NSLog(@"%d",unusedBombs.count);
        crossHairs.hidden = TRUE;
        [self addPin:&pt];
        
        bombTouch = FALSE;
    }
    if(homeTouch){
        activeBases.hidden = TRUE;
        [unPlacedBases removeObject:activeBases];
        
        crossHairs.hidden = TRUE;
        
        [self addBase:&pt];
        
        homeTouch = FALSE;
    }
    
    
}








#pragma mark - Gameplay - bombing and map placement






- (void)addPin:(CGPoint*)pt
{
    CGPoint tappedPoint = *pt;
    NSLog(@"Tapped At : %@",NSStringFromCGPoint(tappedPoint));
    CLLocationCoordinate2D coord= [mapView convertPoint:tappedPoint toCoordinateFromView:mapView];
    NSLog(@"lat  %f",coord.latitude);
    NSLog(@"long %f",coord.longitude);
    longi = [[NSString alloc]initWithFormat:@"%f",coord.longitude];
    lati = [[NSString alloc]initWithFormat:@"%f",coord.latitude];
    
	mapAnnotations* myAnnotation1=[[mapAnnotations alloc] init];
	
	myAnnotation1.coordinate=coord;
	myAnnotation1.title=@"bomb";
	myAnnotation1.subtitle=[NSString stringWithFormat:@"missile_%d.png",myPlayerNumber];
    myAnnotation1.pinImage=[NSString stringWithFormat:@"missile_%d.png",myPlayerNumber];
    
	[mapView addAnnotation:myAnnotation1];
    [self postDropBomb:1 dLat:[lati floatValue] dLong:[longi floatValue]];
    // add an annotation with coord
}

- (IBAction)dropMine:(id)sender{
    NSLog(@"dropp your mine!!");
    CCAlertView *alert = [[CCAlertView alloc]
                                                       initWithTitle:@"Phone Tag"
                                                        message:@"Do you want to drop a trip line where you are standing?"];
    [alert addButtonWithTitle:@"Ok" block:^{[self dropTheMineWhereTheyAreStanding];}];
    [alert addButtonWithTitle:@"Nope." block:NULL];
                                  [alert show];

}

-(void)dropTheMineWhereTheyAreStanding{
    mapAnnotations* mineAnnotation=[[mapAnnotations alloc] init];
	
	mineAnnotation.coordinate=CLLocationCoordinate2DMake([userLongi floatValue], [userLat floatValue]);
	mineAnnotation.title=@"mine";
	mineAnnotation.subtitle=@"mine.png";
    mineAnnotation.pinImage=@"mine.png";
    
    [self postDropBomb:2 dLat:[userLat floatValue] dLong:[userLongi floatValue]];
}

- (void)addBase:(CGPoint*)pt
{
    CGPoint tappedPoint = *pt;
    NSLog(@"Tapped At : %@",NSStringFromCGPoint(tappedPoint));
    CLLocationCoordinate2D coord= [mapView convertPoint:tappedPoint toCoordinateFromView:mapView];
    NSLog(@"lat  %f",coord.latitude);
    NSLog(@"long %f",coord.longitude);
    longi = [[NSString alloc]initWithFormat:@"%f",coord.longitude];
    lati = [[NSString alloc]initWithFormat:@"%f",coord.latitude];
    
	mapAnnotations* myAnnotation1=[[mapAnnotations alloc] init];
	
	myAnnotation1.coordinate=coord;
	myAnnotation1.title=@"homeBase";
	myAnnotation1.subtitle=[NSString stringWithFormat:@"base_%d.png",myPlayerNumber];
    myAnnotation1.pinImage=[NSString stringWithFormat:@"base_%d.png",myPlayerNumber];
    
	[mapView addAnnotation:myAnnotation1];
    if(unPlacedBases.count>0){
        NSLog(@"pt %f",pt->x);
        basesLocationString = [[NSString alloc]initWithFormat:@"%@,%@",lati,longi];
    }else{
        basesLocationString = [[NSString alloc]initWithFormat:@"%@,%@,%@",basesLocationString,lati,longi];
        [self buildBase:basesLocationString];
        
    }
    // add an annotation with coord
}




#pragma mark - gameplay updating


- (void)postDropBomb:(int)type dLat:(float)dropLat dLong:(float)dropLong{
    BOOL illegalHit = FALSE;
    CLLocation *currentBomb = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(dropLat, dropLong) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]];
    double radi = (0.1*0.621371192)*1000; // GET THE RADIUS OF THE BOMB LATER
    double baseRadius = (0.1*0.621371192)*1000;
    for (aBomb *aBombObject in aBombArray){
        
        CLLocation *bombLocation = [[CLLocation alloc] initWithLatitude:[aBombObject.lat floatValue] longitude:[aBombObject.longi floatValue]];
        double distance = [bombLocation distanceFromLocation:currentBomb];
        NSLog(@"distance: %f", distance);
        double combinedRadii = (radi) + (([aBombObject.radius floatValue]/2));
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-LL-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:aBombObject.dateBombed];
        NSLog(@"this is the date %@",date);
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:date
                                                              toDate:[NSDate date]
                                                             options:0];
        NSLog(@"this is the comparison %ld",(long)[components day]);
        
        
        
        //NSLog(@"combined radii: %f", combinedRadii);
        if ( distance < combinedRadii && [components day] < 1){
            NSLog(@" CONFIRMED distance: %f", distance);

            illegalHit = TRUE;
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Phone Tag"
                                                              message:@"You can't drop a bomb on a place that has already been bombed today!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
    NSLog(@"base array: %@", basesArray);
    for (CLLocation *baseLocation in basesArray){

        double distance = [baseLocation distanceFromLocation:currentBomb];
        NSLog(@"base distance: %f", distance);

        //NSLog(@"BASE distance: %f", distance);
        double combinedRadii = (radi) + (baseRadius);
        NSLog(@"base distance: %f and combinedRadius %f", distance,combinedRadii);

        //NSLog(@"combined BASE radii: %f", combinedRadii);
        if ( distance < combinedRadii ){
            illegalHit = TRUE;
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Phone Tag"
                                                              message:@"Well that was dumb. You can't bomb bases."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
    
    
    
    if (illegalHit == TRUE){
        
        // ILLEGAL HIT
        NSLog(@"you can't do that");
        
    }else{
    NSLog(@"this is your location %@, %@",lati,longi);
    NSString *post = [NSString stringWithFormat: @"gameid=%@&lat=%f&longi=%f&userid=%@&type=%d", gameid, dropLat, dropLong, myInfo.ptId,type];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=dropBomb";
    
    NSMutableURLRequest *dropBombRequest = [[NSMutableURLRequest alloc] init];
    [dropBombRequest setURL:[NSURL URLWithString:fullURL]];
    [dropBombRequest setHTTPMethod:@"POST"];
    [dropBombRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [dropBombRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [dropBombRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *dropBombSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dropBombTask = [dropBombSession dataTaskWithRequest:dropBombRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"drop bomb result: %@", datastring);
            NSError *error = nil;
            NSArray *hitResults = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            hitResultArray = [[NSMutableArray alloc]init];
            if (hitResults.count > 0){
                for (NSDictionary *hitUser in hitResults){
                    NSString *hitMessage = [[NSString alloc]init];
                    if ([[hitUser objectForKey:@"id"] isEqualToString:myInfo.ptId]){ // YOURSELF
                        if ([[hitUser objectForKey:@"kill"] integerValue] == 1){ // KILLED YOURSELF
                            hitMessage = @"You hit and killed yourself!";
                        }else{ // HIT YOURSELF
                            hitMessage = @"You should be more careful. You just hit yourself!";
                        }
                    }else{ // SOMEONE ELSE
                        if ([[hitUser objectForKey:@"kill"] integerValue] == 1){ // KILLED PLAYER
                            hitMessage = [NSString stringWithFormat:@"You hit and killed %@!", [hitUser objectForKey:@"uname"]];
                        }else{ // HIT PLAYER
                            hitMessage = [NSString stringWithFormat:@"You hit %@!", [hitUser objectForKey:@"uname"]];
                        }
                    }
                    int hitOrder = (int)[hitResults indexOfObject:hitUser];
                    UIView *hitResultView = [[UIView alloc]initWithFrame:CGRectMake(0, 280 - (50 *hitOrder),screenWidth , 50)];
                    hitResultView.backgroundColor = [UIColor whiteColor];
                    UILabel *hitResultLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, screenWidth - 40, 30)];
                    UIButton *hitResultCloseButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 30, 10, 20, 20)];
                    hitResultCloseButton.backgroundColor = [UIColor blackColor];
                    [hitResultCloseButton setTag:hitOrder];
                    [hitResultCloseButton addTarget:self action:@selector(closeHitResults:) forControlEvents:UIControlEventTouchUpInside];
                    [hitResultView addSubview:hitResultCloseButton];
                    
                    [hitResultLabel setTextAlignment:NSTextAlignmentCenter];
                    [hitResultLabel setText:hitMessage];
                    [hitResultView addSubview:hitResultLabel];
                    
                    [self.view insertSubview:hitResultView atIndex:99];
                    [hitResultArray addObject:hitResultView];
                }
            }
            
            [self getGameData:0];
        });
    }];
    
    [dropBombTask resume];
    //    if([datastring isEqualToString:@"baseHit"]){
    //        CCAlertView *alert = [[CCAlertView alloc]
    //                              initWithTitle:@"Phone Tag"
    //                              message:@"You can't bomb someones base. you just lost a bomb. wamp wamp."];
    //        [alert addButtonWithTitle:@"Ok" block:NULL];
    //        [alert show];
    //    }
    //    if([datastring isEqualToString:@"bombHit"]){
    //        CCAlertView *alert = [[CCAlertView alloc]
    //                              initWithTitle:@"Phone Tag"
    //                              message:@"Dont drop bombs in the same place. Its a shitty thing to do."];
    //        [alert addButtonWithTitle:@"Ok" block:NULL];
    //        [alert show];
    //    }
    
    
    
    }

    
}

- (IBAction)closeHitResults:(id)sender{
    for (UIView *resultView in hitResultArray){
        if ([hitResultArray indexOfObject:resultView] == [sender tag]){
            [resultView removeFromSuperview];
        }
    }
}


-(void)buildBase:(NSString*)homeBaseLoc{
    NSString *post = [NSString stringWithFormat: @"gameid=%@&homebasestring=%@&userid=%@", gameid, homeBaseLoc, myInfo.ptId];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=dropBase";
    
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
            NSLog(@"data string: %@", datastring);
            //[self refreshAnnotationViews];
        });
    }];
    
    [registerTask resume];
    
}


#pragma mark - Game Setup


-(void)getGameData: (NSString *)callback{
    
    NSMutableArray *gameWinners = [[NSMutableArray alloc]init];
    NSString *post = [NSString stringWithFormat: @"gid=%@&uid=%@", gameid, myInfo.ptId];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    basesArray = [[NSMutableArray alloc]init];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=gameDetail";
    NSLog(@"users and stuff %@ , %@", gameid,myInfo.ptId);
    NSMutableURLRequest *checkUsernameRequest = [[NSMutableURLRequest alloc] init];
    [checkUsernameRequest setURL:[NSURL URLWithString:fullURL]];
    [checkUsernameRequest setHTTPMethod:@"POST"];
    [checkUsernameRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [checkUsernameRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [checkUsernameRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *checkUsernameSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *checkUsernameTask = [checkUsernameSession dataTaskWithRequest:checkUsernameRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            NSLog(@"json array: %@", jsonArray);
            currentGame = [[aGame alloc]init];
            currentGame.regCode =[jsonArray objectForKey:@"code"];
            currentGame.totalPlayers = [jsonArray objectForKey:@"totalPlayers"];
            currentGame.gametype = [jsonArray objectForKey:@"gametype"];
            currentGame.winner = [jsonArray objectForKey:@"winner"];
            currentGame.initiated = [jsonArray objectForKey:@"initiated"];

            NSString *newArray =[jsonArray objectForKey:@"players"];
            NSData *data = [newArray dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *playerArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            currentGame.players = playerArray;
            
            int numberOfBases = 0;
            int playerOrder = 0;
            
            playerNumbers = [[NSMutableDictionary alloc]initWithCapacity:5];

            for(NSDictionary *player in playerArray){
                NSArray *arr = [[player objectForKey:@"bases"] componentsSeparatedByString:@","];
                NSLog(@"this is the array %@",arr);
                int pn =[playerArray indexOfObject:player];
                pn++;
                [playerNumbers setObject:[NSNumber numberWithInt:pn] forKey:[player objectForKey:@"playerId"]];
                NSLog(@"array check");
                
                if([[player objectForKey:@"playerId"]isEqualToString:myInfo.ptId]){
                    currentGame.bombsLeft = [player objectForKey:@"bombs"];
                    NSLog(@"player: %@", player);
                    playerOrder = (int)[playerArray indexOfObject:player];
                    playerOrder++;
                    myPlayerNumber = playerOrder;
                    if (arr.count>1){
                        basesSet = TRUE;
                    }else{
                        basesSet = FALSE;
                        numberOfBases = 2;
                    }
                    
                }
                
                if ([currentGame.initiated intValue]>0){
                    NSLog(@"base1 = %@, %@",arr[0],arr[1]);
                    CLLocationCoordinate2D baseALocation;
                    CLLocationCoordinate2D baseBLocation;
                    playerOrder = (int)[playerArray indexOfObject:player];
                    playerOrder++;
                    double baseALat = [arr[0] doubleValue];
                    double baseALong = [arr[1] doubleValue];
                    double baseBLat = [arr[2] doubleValue];
                    double baseBLong = [arr[3] doubleValue];
                    baseALocation.latitude = baseALat;
                    baseALocation.longitude = baseALong;
                    baseBLocation.latitude = baseBLat;
                    baseBLocation.longitude = baseBLong;
                    mapAnnotations *baseA = [[mapAnnotations alloc] init];
                    baseA.coordinate = baseALocation;
                    baseA.subtitle = [NSString stringWithFormat:@"base_%d.png",playerOrder];
                    mapAnnotations *baseB = [[mapAnnotations alloc] init];
                    baseB.coordinate = baseBLocation;
                    baseB.subtitle = [NSString stringWithFormat:@"base_%d.png",playerOrder];
                    [mapView addAnnotation:baseB];
                    [mapView addAnnotation:baseA];
                    CLLocation *currentALocation = [[CLLocation alloc]initWithLatitude:baseALocation.latitude longitude:baseALocation.longitude];
                    CLLocation *currentBLocation = [[CLLocation alloc]initWithLatitude:baseBLocation.latitude longitude:baseBLocation.longitude];
                    [basesArray addObject: currentALocation];
                    [basesArray addObject: currentBLocation];

                }else{
                    playerOrder = (int)[playerArray indexOfObject:player];
                    playerOrder++;
                    if(playerOrder == myPlayerNumber && basesSet){
                        NSLog(@"base1 = %@, %@",arr[0],arr[1]);
                         NSLog(@"base2 = %@, %@",arr[2],arr[3]);
                        CLLocationCoordinate2D baseALocation;
                        CLLocationCoordinate2D baseBLocation;

                        double baseALat = [arr[0] doubleValue];
                        double baseALong = [arr[1] doubleValue];
                        double baseBLat = [arr[2] doubleValue];
                        double baseBLong = [arr[3] doubleValue];
                        baseALocation.latitude = baseALat;
                        baseALocation.longitude = baseALong;
                        baseBLocation.latitude = baseBLat;
                        baseBLocation.longitude = baseBLong;
                        mapAnnotations *baseA = [[mapAnnotations alloc] init];
                        baseA.coordinate = baseALocation;
                        baseA.subtitle = [NSString stringWithFormat:@"base_%d.png",playerOrder];
                        mapAnnotations *baseB = [[mapAnnotations alloc] init];
                        baseB.coordinate = baseBLocation;
                        baseB.subtitle = [NSString stringWithFormat:@"base_%d.png",playerOrder];
                        [mapView addAnnotation:baseB];
                        [mapView addAnnotation:baseA];
                        CLLocation *currentALocation = [[CLLocation alloc]initWithLatitude:baseALocation.latitude longitude:baseALocation.longitude];
                        CLLocation *currentBLocation = [[CLLocation alloc]initWithLatitude:baseBLocation.latitude longitude:baseBLocation.longitude];
                        [basesArray addObject: currentALocation];
                        [basesArray addObject: currentBLocation];
                    }
                    
                    
                    
                }
                
                if ([[player objectForKey:@"won"] intValue] == 1){
                    [gameWinners addObject:[player objectForKey:@"username"]];
                }
                
                

            } // END OF FOR LOOP
            
            
            //[self loadPlayerTab];
            
            
            if ([callback intValue] == 1){
                
                playersInfoView.playersArray = playerArray;
                [playersInfoView.playersTableView reloadData];
                NSLog(@"players array: %@", playerArray);
                
                [self replaceTopConstraintOnView:playerInfoContainer withConstant:60];
                [self animateConstraints];
                
                
            }else{
                if(basesSet){
                    if([currentGame.initiated intValue]>0){
                    [self loadBombs];
                    }else{
                        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Phone Tag"
                                                                          message:@"Not everyone has setup their game yet. Tell your friends to get their shit together. We will let you know when they do. (in the game, not the real life. Your friends are losers, that will never happen.)"
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                        [message show];
                    }
                    
                }else{
                    int p = playerOrder-1;
                    [self loadBases: numberOfBases player: p];
                    
                }
            }
            
            if (gameWinners.count > 0){ // THERE'S A WINNER
                NSLog(@"there's a winner");
                UIView *winnerCover = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
                UIView *winnerCoverBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
                UIView *winnerBox = [[UIView alloc]initWithFrame:CGRectMake(20, screenHeight/4, screenWidth - 40, screenHeight/2)];
                UIButton *winnerButton = [[UIButton alloc]initWithFrame:CGRectMake(winnerBox.frame.size.width -50, 20, 30, 30)];
                [winnerButton addTarget:self action:@selector(closeWinnerBox:) forControlEvents:UIControlEventTouchUpInside];
                UILabel *winnerTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, winnerBox.frame.size.width - 40, 40)];
                winnerTitle.textAlignment = NSTextAlignmentCenter;
                winnerTitle.textColor = [UIColor blackColor];

                UILabel *winnerSubtitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, winnerBox.frame.size.width -40, 80)];
                winnerSubtitle.textAlignment = NSTextAlignmentCenter;
                winnerSubtitle.textColor = [UIColor blackColor];
                
                if (gameWinners.count == 1){
                    
                    if([[gameWinners objectAtIndex:0] isEqualToString:myInfo.ptUsername]){
                        NSLog(@"one winner");
                        winnerTitle.text = @"YOU WON!";
                    }else{
                        winnerTitle.text = [NSString stringWithFormat:@"%@ Won!", [gameWinners objectAtIndex:0]];
                        winnerSubtitle.text = @"Better luck next time!";
                    }
                }else{
                    winnerTitle.text = @"There was a tie!";
                    winnerSubtitle.text = [gameWinners componentsJoinedByString:@","];
                }
                
                winnerButton.backgroundColor = [UIColor blackColor];
                winnerBox.backgroundColor = [UIColor whiteColor];
                winnerCoverBackground.backgroundColor = [UIColor blackColor];
                winnerCoverBackground.alpha = 0.8;
                
                [winnerCover addSubview:winnerCoverBackground];
                [winnerCover addSubview:winnerBox];
                [winnerBox addSubview:winnerButton];
                [winnerBox addSubview:winnerTitle];
                if (winnerSubtitle.text.length > 0){
                    [winnerBox addSubview:winnerSubtitle];
                }
                
                [self.view insertSubview:winnerCover atIndex:999];
            }else{
                [self refreshAnnotationViews];
            }

        }); // END OF DISPATCH

    }];
    
    [checkUsernameTask resume];

}

- (IBAction)closeWinnerBox:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closePlayerInfo:(id)sender{
    if (playerInfoContainer.frame.origin.y > 0){
    [self replaceTopConstraintOnView:playerInfoContainer withConstant:-298];
    [self animateConstraints];
    }
}

- (IBAction)openPlayerInfo:(id)sender{
    if (playerInfoContainer.frame.origin.y < 0){
        [self getGameData:@"1"];
    }
}

- (void)closePlayerInfo{
    
    float movexdistance = screenWidth - (playerInfoContainer.frame.size.width - playerInfoBox.frame.size.width);
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [playerInfoContainer setFrame:CGRectMake(movexdistance, 0, playerInfoContainer.frame.size.width, playerInfoContainer.frame.size.height)];
                         
                     }completion:^(BOOL finished){
                         
                     }];
}

- (void)loadBases:(int)baseCount player:(int)order{
    
    NSString *baseNumber;
    switch (order) {
        case 0:
            baseNumber = @"base_1.png";
            break;
        case 1:
            baseNumber = @"base_2.png";
            break;
        case 2:
            baseNumber = @"base_3.png";
            break;
        case 3:
            baseNumber = @"base_4.png";
            break;
        case 4:
            baseNumber = @"base_5.png";
            break;
        default:
            break;
    }
    
    unPlacedBases = [[NSMutableArray alloc]init];
    int b;
    for (b = 0; b < 2; b++){
        float xpos = 10;
        NSString *baseHolder = @"BASE 1";
        if (b == 1){
            xpos = ((screenWidth /2)-15) + 20;
            baseHolder = @"BASE 2";
        }
        UILabel *baseLabel = [[UILabel alloc]initWithFrame:CGRectMake(xpos, 0, ((screenWidth / 2) - 15), 58)];
        [baseLabel setText:baseHolder];
        baseLabel.textAlignment = NSTextAlignmentCenter;
        baseLabel.backgroundColor = [UIColor lightGrayColor];
        [itemHolder addSubview:baseLabel];
        
    }
    int i;
    for (i = 0; i < baseCount; i++){
        float xpos = 12;
        if (i == 1){
            xpos = ((screenWidth /2)-45) + 52;
        }
        UIImageView *baseObject = [[UIImageView alloc]initWithFrame:CGRectMake(xpos, 2, ((screenWidth / 2) - 19), 54)];
        [baseObject setImage:[UIImage imageNamed:baseNumber]];
        baseObject.backgroundColor = [UIColor redColor];
        
        baseObject.contentMode = UIViewContentModeScaleAspectFit;
        NSLog(@"base position: %f", baseObject.frame.origin.x);
        [itemHolder addSubview:baseObject];
        [unPlacedBases addObject:baseObject];
        
    }
    if (unPlacedBases.count > 0){
        [self openLoaderDoor];
    }
}


-(void)loadBombs{
    unusedBombs = [[NSMutableArray alloc] init];
    
    
    int totalToSubtract = [currentGame.bombsLeft intValue];
    //int totalToSubtract = 100;

    for(int i=0; i<totalToSubtract; i++){
        UIImageView *bomb = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 70,70)];
        [bomb setImage:[UIImage imageNamed:[NSString stringWithFormat:@"missile_%d.png",myPlayerNumber]]];
        [bomb isUserInteractionEnabled];
        [itemHolder addSubview:bomb];
        NSLog(@"adding bomb %d",i);
        [unusedBombs addObject:bomb];
    }
    NSString *totalBombs = [[NSString alloc]initWithFormat:@"%d",(int)unusedBombs.count];
    
    [bombLabel setText:totalBombs];
    [bombLabel setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:28]];
    
    UILabel *bombLabelx = [[UILabel alloc]initWithFrame:CGRectMake(56,85,100,20)];
    [bombLabelx setText:@"x"];
    [bombLabelx setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:14]];
    [self.view insertSubview:bombLabelx atIndex:9];
    NSLog(@"this is the amoung of bombe %d",unusedBombs.count);
    
    
    
    NSString *post = [NSString stringWithFormat: @"gid=%@", gameid];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=getBombsForGame";
    NSMutableURLRequest *loadBombsRequest = [[NSMutableURLRequest alloc] init];
    [loadBombsRequest setURL:[NSURL URLWithString:fullURL]];
    [loadBombsRequest setHTTPMethod:@"POST"];
    [loadBombsRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [loadBombsRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [loadBombsRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *loadBombsSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *loadBombsTask = [loadBombsSession dataTaskWithRequest:loadBombsRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"data string: %@", datastring);
            
            NSError *error = nil;
            //NSLog(@"this is bombs: %@",datastring);

            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            [self drawBombs:jsonArray];
            
        });
    }];
    
    [loadBombsTask resume];
    
}

- (void)drawBombs:(NSArray *)bombArray
{
    aBombArray = [[NSMutableArray alloc]init];
    int totalBombs = bombArray.count;
    //        if(totalBombs>0){
    //            NSLog(@"this has happened");
    //            CCAlertView *alert = [[CCAlertView alloc]
    //                                  initWithTitle:@"Phone Tag"
    //                                  message:@"You've been HIT!"];
    //            [alert addButtonWithTitle:@"Ok" block:NULL];
    //            [alert show];
    //            //[self looseLife];
    //
    //        }
    //NSLog(@"this is the players %@",playerNumbers);
    for (NSDictionary *bomb in bombArray)
    {
        aBomb *bombDr = [[aBomb alloc]init];
        bombDr.lat = [bomb objectForKey:@"lat"];
        bombDr.longi = [bomb objectForKey:@"longi"];
        bombDr.userid = [bomb objectForKey:@"userid"];
        bombDr.radius = [bomb objectForKey:@"radius"];
        bombDr.hits = [bomb objectForKey:@"hits"];
        bombDr.dateBombed = [bomb objectForKey:@"dateBombed"];
        bombDr.type = [bomb objectForKey:@"type"];
        
        
        
        
       // NSLog(@"bomb radius: %@", bombDr.radius);
       // NSLog(@"this is the player Jersery %@",[playerNumbers objectForKey:bombDr.userid]);
        //NSLog(@"bomb doctor %@", bombDr.lat);
        
        CLLocationCoordinate2D annotationlocation;
        double latiDouble = [bombDr.lat doubleValue];
        double longiDouble = [bombDr.longi doubleValue];
        annotationlocation.latitude = latiDouble;
        annotationlocation.longitude = longiDouble;
        mapAnnotations *txts = [[mapAnnotations alloc] init];
        txts.coordinate = annotationlocation;
        if (bombDr.hits.count > 0){
            txts.subtitle = [NSString stringWithFormat:@"hit_%@",bombDr.type];
        }else{
            if([bombDr.type isEqualToString:@"2"] && [bombDr.userid isEqualToString:myInfo.ptId] ){
                txts.subtitle = [NSString stringWithFormat:@"tripWire.png"];

            }else if([bombDr.type isEqualToString:@"1"]){
                txts.subtitle = [NSString stringWithFormat:@"missile_%@.png",[playerNumbers objectForKey:bombDr.userid]];
            }
        }
        
        [mapView addAnnotation:txts];
        [aBombArray addObject:bombDr];
        // add an annotation with coord
    }
    if (topDoorBox.frame.origin.y == 0){
        NSLog(@"updating annotations!");
        annotationsUpdated = TRUE;
        [self openLoaderDoor];
    }
    
}




#pragma mark - general app stuff

- (void)replaceTopConstraintOnView:(UIView *)view withConstant:(float)constant
{
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.firstItem == view) && (constraint.firstAttribute == NSLayoutAttributeTop)) {
            constraint.constant = constant;
        }
    }];
}

- (void)animateConstraints
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                         
                     }completion:^(BOOL finished){
                         
                     }];
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{}];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)openLoaderDoor{
    if ((myLocationUpdated == TRUE && annotationsUpdated == TRUE) || unPlacedBases.count > 0){
    [UIView animateWithDuration:2.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [topDoorBox setFrame:CGRectMake(0, -topDoorBox.frame.size.height, topDoorBox.frame.size.width, topDoorBox.frame.size.height)];
                         
                     }completion:^(BOOL finished){
                         
                     }];
    [UIView animateWithDuration:2.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [bottomDoorBox setFrame:CGRectMake(0, screenHeight, bottomDoorBox.frame.size.width, bottomDoorBox.frame.size.height)];
                         
                     }completion:^(BOOL finished){
                         
                     }];
    }
}

- (void)makeLoaderDoor{
    topDoorBox = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, (screenHeight/2)+45)];
    UIView *topDoorBlock = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight/2)];
    topDoorBlock.backgroundColor = [UIColor blackColor];
    UIImageView *topDoorEdge = [[UIImageView alloc]initWithFrame:CGRectMake(0, screenHeight/2, screenWidth, 45)];
    [topDoorEdge setImage:[UIImage imageNamed:@"topDoor.png"]];
    
    [topDoorBox addSubview:topDoorBlock];
    [topDoorBox addSubview:topDoorEdge];
    
    bottomDoorBox = [[UIView alloc]initWithFrame:CGRectMake(0, (screenHeight/2)-45, screenWidth, (screenHeight/2)+45)];
    UIView *bottomDoorBlock = [[UIView alloc]initWithFrame:CGRectMake(0, 45, screenWidth, screenHeight/2)];
    bottomDoorBlock.backgroundColor = [UIColor blackColor];
    UIImageView *bottomDoorEdge = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 45)];
    [bottomDoorEdge setImage:[UIImage imageNamed:@"bottomDoor.png"]];
    
    [bottomDoorBox addSubview:bottomDoorBlock];
    [bottomDoorBox addSubview:bottomDoorEdge];
    
    [self.view insertSubview:topDoorBox belowSubview:itemHolder];
    [self.view insertSubview:bottomDoorBox belowSubview:itemHolder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    feedTableView = [[FeedTable alloc]initWithNibName:@"FeedTable" bundle:nil];
    [feedBox addSubview:feedTableView.view];
    
    NSLog(@"scroll view: %f", scrollView.frame.size.width);
    NSLog(@"scroll content: %f", scrollContent.frame.size.width);
    
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    [self makeLoaderDoor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"bombdrop" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(youHitSomeone)
                                                 name:@"hitSomeone" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closePlayerInfo)
                                                 name:@"closeplayerbox" object:nil];
    
    playersInfoView = [[PlayersInfo alloc]initWithNibName:@"PlayersInfo" bundle:nil];
    [playerInfoBox addSubview:playersInfoView.view];
    
    myInfo = [PTStaticInfo sharedManager];
    
    indGameSetup.hidden = YES;
    //[self.view insertSubview:indGameSetup atIndex:10];
    homeTouch = false;
    needsBases = true;
    CLLocation *userLoc = mapView.userLocation.location;
    CLLocationCoordinate2D userCoordinate = userLoc.coordinate;
	NSLog(@"user latitude = %f",userCoordinate.latitude);
	NSLog(@"user longitude = %f",userCoordinate.longitude);
    loadingMap = [[UIView alloc]initWithFrame:CGRectMake(50, 200, 200, 300)];
    loadingMap.backgroundColor = [UIColor clearColor];
    UILabel *checkingLoc = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 160, 80)];
    checkingLoc.text = @"Checking your location..";
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.frame = CGRectMake(80, 200, 40, 40);
    [spinner startAnimating];
    [loadingMap addSubview:spinner];
    [loadingMap addSubview:checkingLoc];
    
    
    
    UIImage *crossHairsImage = [UIImage imageNamed:@"crosshairs.png"];
    crossHairs = [[UIImageView alloc] initWithImage:crossHairsImage];
    [self.view addSubview:crossHairs];
    crossHairs.hidden = TRUE;
    
    activeBomb = [[UIImageView alloc]init];
    
    
    player1Color = [UIColor colorWithRed:237.0/255.0 green:28.0/255.0 blue:36.0/255.0 alpha:255.0/255.0];
    player2Color = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:255.0/255.0];
    player3Color = [UIColor colorWithRed:255.0/255.0 green:242.0/255.0 blue:0.0/255.0 alpha:255.0/255.0];
    player4Color = [UIColor colorWithRed:178.0/255.0 green:30.0/255.0 blue:142.0/255.0 alpha:255.0/255.0];
    player5Color = [UIColor colorWithRed:178.0/255.0 green:210.0/255.0 blue:53.0/255.0 alpha:255.0/255.0];
    
    
    activeBases =[[UIImageView alloc]init];
    
    unPlacedBases = [[NSMutableArray alloc]init];
//    [unPlacedBases addObject:Base1];
//    [unPlacedBases addObject:Base2];
    
    bombLabel = [[UILabel alloc]initWithFrame:CGRectMake(64,73,100,30)];
    [self.view insertSubview:bombLabel atIndex:10];

    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    mapView.showsPointsOfInterest = NO;
    [self.view insertSubview:mapView atIndex:0];
    [self.view insertSubview:loadingMap aboveSubview:mapView];
    CLLocationCoordinate2D location;
    location.latitude = 0;
    location.longitude = 0;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.007;
    span.longitudeDelta = 0.007;
    region.center = location;
    region.span = span;
    [self initLocationManager];
    foundPlace = 0;
    
    
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:pinchRecognizer];
    
    
    
    
    [self setNeedsStatusBarAppearanceUpdate];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated{
    gameid = myInfo.activeGameId;
    foundPlace = 0;
    
    [self getGameData: @"2"];
    [self getArsenal];
}

- (void)getArsenal{
    arsenalArray = [[NSArray alloc]initWithArray:myInfo.ptArsenalArray];
    NSLog(@"arsenal array: %@", arsenalArray);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
