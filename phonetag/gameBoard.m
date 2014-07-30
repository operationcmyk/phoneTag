//
//  gameBoard.m
//  phonetag
//
//  Created by Christopher on 6/3/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "gameBoard.h"
#import "UIImageView+WebCache.h"


@interface gameBoard ()

@end

@implementation gameBoard

@synthesize mapView;


#pragma mark - locationServices

- (IBAction)reOrient:(id)sender{
    //[self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.007;
    span.longitudeDelta = 0.007;
    region.span = span;
    region.center = self.mapView.userLocation.coordinate;
    [mapView setRegion:region animated:YES];
}

-(void)initLocationManager {
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 100 m
    }
    [locationManager startMonitoringSignificantLocationChanges];

    //[locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.007;
    span.longitudeDelta = 0.007;
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
        loadingMap.hidden = YES;

        

        //[self getAllBombs];
        //[self checkForHit];
        
        
    }
    [self clearUserLocOverlay];
    if (topDoorBox.frame.origin.y == 0){
        myLocationUpdated = TRUE;
    }
    gameboardOverlay *mapOverlay = [[gameboardOverlay alloc]initWithCoordinate:location andImage:[NSString stringWithFormat:@"userLoc_%d.png",myPlayerNumber] with:CGSizeMake(1200, 1200) as:@"userLoc" withOpacity:1];
    

    [mapView addOverlay:mapOverlay];
    
    
}


-(void)mapView:(MKMapView *)pMapView regionDidChangeAnimated:(BOOL)animated{
//    for (id <MKAnnotation>annotation in pMapView.annotations) {
//        // if it's the user location, just return nil.
//        // try to retrieve an existing pin view first
//        MKAnnotationView *pinView = [pMapView viewForAnnotation:annotation];
//        //Format the pin view
//        [self formatAnnotationView:pinView forMapView:pMapView];
//        
//    }
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

//        gameboardOverlay *mapOverlay = [[gameboardOverlay alloc]initWithCoordinate:pinView.annotation.coordinate andImage:txts.subtitle with:CGSizeMake(2000, 2000)];
//        [mapView addOverlay:mapOverlay];

        
        
        //pinView.pinColor = MKPinAnnotationColorPurple;
        //        pinView.canShowCallout = YES;
        //        CGRect resizeRect;
        //        UIImage *uiimage = [UIImage imageNamed:txts.subtitle];
//        CGSize size = uiimage.size;
//        UIGraphicsBeginImageContext(size);
//        //CGContextRef context = UIGraphicsGetCurrentContext();
//        //[uiimage drawAtPoint:CGPointZero blendMode:kCGBlendModeColorBurn alpha:0.5];
//        //CGRect rect = CGRectMake(0, 0, uiimage.size.width, uiimage.size.height);
//        //CGContextDrawImage(context, rect, uiimage.CGImage);
//
//        [uiimage drawAtPoint:CGPointZero blendMode:kCGBlendModeColorBurn alpha:1.0];
//        
//        UIImage* flagImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        resizeRect.size = flagImage.size;
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
//       	UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
//        myLabel.text = @"cites";
//        
//        pinView.image = flagImage;
//        pinView.opaque = YES;
        

        
        
        //UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //  double footnoteDistance = [txts.noteDistance doubleValue];
        //CLLocationCoordinate2D cooords = currentLocation;
        
    }
    else {
        //[mapView.userLocation setTitle:@"hello"];

        
        
        static NSString *defaultPinID = @"userIcon";
        if ( pinView == nil ) pinView = [[MKAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:defaultPinID];

        
           // gameboardOverlay *mapOverlay = [[gameboardOverlay alloc]initWithCoordinate:pinView.annotation.coordinate andImage:[NSString stringWithFormat:@"userLoc_%d.png",myPlayerNumber] with:CGSizeMake(1200, 1200)];
           // [mapView addOverlay:mapOverlay];
        
        // pinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"flag_1.png"]];
        //UIImage *storyIconImage = [UIImage imageNamed:[NSString stringWithFormat:@"flag_1.png"]];
//         CGRect storyIconBox = CGRectMake(0, 0, 170, 170);
//        UIGraphicsBeginImageContext(storyIconBox.size);
//        [storyIconImage drawInRect:storyIconBox];
//        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        pinView.canShowCallout = NO;
//        pinView.image = resizedImage;


        
        
        
        
    }

    
    
    return pinView;
    
}


//- (void)formatAnnotationView:(MKAnnotationView *)pinView forMapView:(MKMapView *)aMapView {
//    
//    if (pinView && ![pinView.reuseIdentifier isEqualToString:@"userIcon"])
//    {
//               // double zoomLevel = [aMapView getZoomLevel];
//        double zoomLevel = (21 - round(log2(mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapView.bounds.size.width))));
//        //        double scale = -1 * sqrt((double)(1 - pow((zoomLevel/20.0), 2.0))) + 1.1; // This is a circular scale function where at zoom level 0 scale is 0.1 and at zoom level 20 scale is 1.1
//        double scale = pow(((zoomLevel-7)/10),5); // This is a circular scale function where at zoom level 0 scale is 0.1 and at zoom level 20 scale is 1.1
//        // Option #1
//        MKZoomScale currentZoomScale = mapView.bounds.size.width / mapView.visibleMapRect.size.width;
//        
//        UIImage *orangeImage = [UIImage imageNamed:[pinView.annotation subtitle]];
//        CGRect resizeRect;
//        //rescale image based on zoom level
//        resizeRect.size.height = 2400 * currentZoomScale;
//        resizeRect.size.width = 2400  * currentZoomScale;
//        resizeRect.origin = (CGPoint){0,0};
//         float alphaNumber = 0.5;
//        UIGraphicsBeginImageContext(resizeRect.size);
//        [orangeImage drawInRect:resizeRect];
//        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
//
//        UIGraphicsEndImageContext();
//        //[resizedImage drawInRect:resizeRect blendMode:kCGBlendModeColorBurn alpha:alphaNumber];
//
//        pinView.image = resizedImage;
//        
//        
//        //[UIView beginAnimations:@"UIBase Hide" context:nil];
//        //[UIView setAnimationDuration:.01];
//        
//        //[UIView commitAnimations];
//        //CGAffineTransform moveit = CGAffineTransformMakeScale(scale, scale);
//        //pinView.transform = moveit;
//        //[pinView setNeedsDisplay];
//        //NSLog(@"zoomlevel: %f   Scale: %f",zoomLevel,scale);
//        // Option #2
//        
//    }
//}
//
//-(void)refreshAnnotationViews{
//    
//    
//    for (id <MKAnnotation>annotation in mapView.annotations) {
//        // if it's the user location, just return nil.
//        if ([annotation isKindOfClass:[MKUserLocation class]])
//            return;
//        
//        // handle our custom annotations
//        //
//        if ([annotation isKindOfClass:[MKPointAnnotation class]])
//        {
//            // try to retrieve an existing pin view first
//            MKAnnotationView *pinView = [mapView viewForAnnotation:annotation];
//            //Format the pin view
//            [self formatAnnotationView:pinView forMapView:mapView];
//        }
//    }
//    
//}



- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    Class theClass = NSClassFromString(@"MKCircle");
    if([overlay isKindOfClass:theClass]){
       // NSLog(@"this is the class of the mapview %@",overlay.class);

        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleView.fillColor = [[UIColor colorWithRed:36.0/255.0 green:255.0/255.0 blue:0 alpha:1] colorWithAlphaComponent:0.4];
        circleView.strokeColor = [[UIColor colorWithRed:255.0/255.0 green:213.0/255.0 blue:0 alpha:1] colorWithAlphaComponent:1];
        circleView.lineWidth = 1;
        return circleView;

    }else if ([overlay isKindOfClass:gameboardOverlay.class]) {

        gameboardOverlay *mapOverlay = overlay;
        //NSLog(@"this is the lat of the overlay %f",mapOverlay.coordinate.longitude);

        gameBoardOverlayView *mapOverlayView = [[gameBoardOverlayView alloc] initWithOverlay:mapOverlay];
        
        return mapOverlayView;
        
    }
    
    
    
    return nil;
}

- (IBAction)openSearchBar:(id)sender {
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [searchMap setAlpha:1.0f];
                         
                     }
     ];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        region.center.latitude = placemark.location.coordinate.latitude;
        region.center.longitude = placemark.location.coordinate.longitude;
        MKCoordinateSpan span;
        double radius = placemark.region.radius / 1000; // convert to km
        
        NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
        span.latitudeDelta = radius / 112.0;
        
        region.span = span;
        
        [mapView setRegion:region animated:YES];
        [UIView animateWithDuration:0.5f
                         animations:^{
                             [searchMap setAlpha:0.0f];
                             
                         }
         ];
    }];
}



-(void)clearOverlays{
    for(id<MKOverlay> over in mapView.overlays){
        if ([over isKindOfClass:gameboardOverlay.class]){
            [mapView removeOverlay:over];
        }
    }
}


-(void)clearUserLocOverlay{
    for(id<MKOverlay> over in mapView.overlays){
        if ([over isKindOfClass:gameboardOverlay.class]){
            gameboardOverlay *o = over;
            if([o.type isEqualToString:@"userLoc"]){
            [mapView removeOverlay:over];
            }
        }
    }
    
}

#pragma mark - touch methods

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchRecognizer {
   // NSLog(@" this is the lat span %f",mapView.region.span.latitudeDelta);
    
    
    
    
    
//    MKZoomScale currentZoomScale = mapView.bounds.size.width / mapView.visibleMapRect.size.width;
//    
//    
//
//    if (pinchRecognizer.state != UIGestureRecognizerStateChanged) {
//    }
//    
//    MKMapView *aMapView = (MKMapView *)pinchRecognizer.view;
//    
//    for (id <MKAnnotation>annotation in aMapView.annotations) {
//        // if it's the user location, just return nil.
//        if ([annotation isKindOfClass:[MKUserLocation class]])
//            return;
//        
//        // handle our custom annotations
//        //
//        if ([annotation isKindOfClass:[MKPointAnnotation class]])
//        {
//            // try to retrieve an existing pin view first
//            MKAnnotationView *pinView = [aMapView viewForAnnotation:annotation];
//            //Format the pin view
//            [self formatAnnotationView:pinView forMapView:aMapView];
//        }
//    }
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
//    CGPoint pt = [[touches anyObject] locationInView:self.view];
//    startLocation = pt;
    
}


- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
//    CGPoint pt = [[touches anyObject] locationInView:self.view];
//    for (UIImageView *bomber in unusedBombs){
//        CGRect frame = [bomber frame];
//        if(pt.x>frame.origin.x && pt.x<(frame.origin.x+frame.size.width) && pt.y>frame.origin.y && pt.y<frame.origin.y+frame.size.height && !bombTouch){
//            bombTouch = TRUE;
//            activeBomb = bomber;
//            crossHairs.hidden = FALSE;
//        }
//        if(bombTouch)
//        {
//            CGRect frame = [bomber frame];
//
//            frame = CGRectMake(pt.x-75, pt.y-108, 150, 150);
//            [activeBomb setFrame: frame];
//            [crossHairs setFrame:CGRectMake(pt.x-100, pt.y-100, 200, 200)];
//        }
//    }
//    for (UIImageView *bases in unPlacedBases){
//        CGRect frame = [bases frame];
//    
//        CGPoint basePoint = CGPointMake(frame.origin.x, frame.origin.y);
//        basePoint = [indGameSetup convertPoint:basePoint toView:nil];
//        if(pt.x>frame.origin.x && pt.x<(frame.origin.x+frame.size.width) && pt.y>frame.origin.y && pt.y<frame.origin.y+frame.size.height && !homeTouch){
//            homeTouch = TRUE;
//            activeBases = bases;
//            crossHairs.hidden = FALSE;
//        }
//        if(homeTouch)
//        {
//            frame = CGRectMake(pt.x-(frame.size.width/2), pt.y-(frame.size.height/2), 150, 150);
//            [activeBases setFrame: frame];
//            [crossHairs setFrame:CGRectMake(frame.origin.x-25, frame.origin.y-25, 200, 200)];
//        }
//    }
    
    
    
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
//    CGPoint pt = [[touches anyObject] locationInView:self.view];
//    startLocation = pt;
//    pt.x = pt.x - 0;
//    pt.y = pt.y - 109;
//    
//    if(bombTouch){
//        activeBomb.hidden = TRUE;
//        [unusedBombs removeObject:activeBomb];
//        crossHairs.hidden = TRUE;
//        [self addPin:&pt];
//        
//        bombTouch = FALSE;
//    }
//    if(homeTouch){
//        activeBases.hidden = TRUE;
//        [unPlacedBases removeObject:activeBases];
//        
//        crossHairs.hidden = TRUE;
//        
//        [self addBase:&pt];
//        
//        homeTouch = FALSE;
//    }
    
    
}








#pragma mark - Gameplay - bombing and map placement






- (void)addPin:(CGPoint*)pt
{
    CGPoint tappedPoint = *pt;
    CLLocationCoordinate2D coord= [mapView convertPoint:tappedPoint toCoordinateFromView:mapView];
    longi = [[NSString alloc]initWithFormat:@"%f",coord.longitude];
    lati = [[NSString alloc]initWithFormat:@"%f",coord.latitude];
    

    [self postDropBomb:1 dLat:[lati floatValue] dLong:[longi floatValue]];
    // add an annotation with coord
}


-(void)openBombDropper{
    int totalBombs = (int)bombLabel.text;
    if(totalAmountOfBombs>0){
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [bombDropSightOverlay setAlpha:1.0f];

                     }completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                             [bombDropSightOverlay setFrame:CGRectMake(-20, 0, screenWidth, bombDropSightOverlay.frame.size.height)];
                         }completion:^(BOOL done){
                         }];
                         
        }];
    }
}


-(void)closeBombDropper{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [bombDropSightOverlay setAlpha:0.0f];
                         
                     }
     ];
}

- (IBAction)cancelBombDrop:(id)sender {
    [self closeBombDropper];
}


- (IBAction)dropABomb:(id)sender {
    
    CGPoint centerOfMap = CGPointMake(160, 210);
    
    CLLocationCoordinate2D centerOfMapCoord = [mapView convertPoint:centerOfMap toCoordinateFromView:mapView];   //Step 2
    [self postDropBomb:1 dLat:centerOfMapCoord.latitude dLong:centerOfMapCoord.longitude];

    
}





- (void)dropMine{
    CCAlertView *alert = [[CCAlertView alloc]
                                                       initWithTitle:@"Phone Tag"
                                                        message:@"Do you want to drop a trip line where you are standing?"];
    [alert addButtonWithTitle:@"Ok" block:^{[self dropTheMineWhereTheyAreStanding];}];
    [alert addButtonWithTitle:@"Nope." block:NULL];
                                  [alert show];

}

- (void)useRecon{
    CCAlertView *alert = [[CCAlertView alloc]
                          initWithTitle:@"Phone Tag"
                          message:@"Do you want to use a recon?"];
    [alert addButtonWithTitle:@"Ok" block:^{[self launchRecon];}];
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

- (void)launchRecon{
    NSString *post = [NSString stringWithFormat: @"gid=%@&uid=%@", gameid, myInfo.ptId];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=recon";
    
    NSMutableURLRequest *reconRequest = [[NSMutableURLRequest alloc] init];
    [reconRequest setURL:[NSURL URLWithString:fullURL]];
    [reconRequest setHTTPMethod:@"POST"];
    [reconRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [reconRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [reconRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *reconSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *reconTask = [reconSession dataTaskWithRequest:reconRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"data string: %@", datastring);
            NSError *error = nil;
            NSArray *reconResults = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            NSDictionary *reconDict = [reconResults objectAtIndex:0];
            CGPoint resultPoint = CGPointMake([[reconDict objectForKey:@"currentLat"] floatValue], [[reconDict objectForKey:@"currentLong"] floatValue]);
            [self plotReconPoints:resultPoint];
            [appDel refreshArsenal];
            
        });
    }];
    [reconTask resume];
}

- (void)plotReconPoints: (CGPoint)reconTarget{
    
    for(id<MKOverlay> over in mapView.overlays){
        Class theClass = NSClassFromString(@"MKCircle");

        if([over isKindOfClass:theClass]){
        [mapView removeOverlay:over];
        }
    }
    CLLocationCoordinate2D coord= CLLocationCoordinate2DMake(reconTarget.x, reconTarget.y);

	mapAnnotations* original=[[mapAnnotations alloc] init];
    mapAnnotations* new=[[mapAnnotations alloc] init];
	
	original.coordinate=coord;
	original.title=@"recon one";
    original.subtitle=@"base_1.png";
    original.pinImage=@"base_1.png";
    
    float newX = [self randomFloatBetween:(reconTarget.x - (reconTarget.x*0.000065)) and:(reconTarget.x + (reconTarget.x*0.000065))];
    float newY = [self randomFloatBetween:(reconTarget.y - (reconTarget.y*0.000065)) and:(reconTarget.y + (reconTarget.y*0.000065))];
    
    CGPoint newPoint = CGPointMake(newX, newY);
    CLLocationCoordinate2D newCoord= CLLocationCoordinate2DMake(newPoint.x, newPoint.y);
    new.coordinate=newCoord;
	new.title=@"recon two";
    new.subtitle=@"base_2.png";
    new.pinImage=@"base_2.png";
    
    float angleTwo = arc4random()*(M_PI*2);
    float circleTwoX = cos(angleTwo)*.01;
    float circleTwoY = sin(angleTwo)*.01;
    
    CLLocationCoordinate2D coordTwo = CLLocationCoordinate2DMake(reconTarget.x + circleTwoX, reconTarget.y + circleTwoY);
    
    float angleThree = arc4random()*(M_PI*2);
    float circleThreeX = (cos(angleThree)*.016);
    float circleThreeY = (sin(angleThree)*.016);
    
    CLLocationCoordinate2D coordThree = CLLocationCoordinate2DMake(reconTarget.x + circleThreeX, reconTarget.y + circleThreeY);
    
    mapView.centerCoordinate = newCoord;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;


        region.span = span;
        region.center = newCoord;
        [mapView setRegion:region animated:YES];
        
        
    MKCircle *circleOne = [MKCircle circleWithCenterCoordinate:newCoord radius:320];
    MKCircle *circleTwo = [MKCircle circleWithCenterCoordinate:coordTwo radius:320];
    MKCircle *circleThree = [MKCircle circleWithCenterCoordinate:coordThree radius:320];
    
    NSArray *arrayOfCircles = [[NSArray alloc]initWithObjects:circleOne, circleTwo, circleThree, nil];

    [mapView addOverlay:circleOne];
    [mapView addOverlay:circleTwo];
    [mapView addOverlay:circleThree];
    
	//[mapView addAnnotation:original];
    //[mapView addAnnotation:new];
    
}



- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}
- (IBAction)dropABase:(id)sender {
    NSLog(@"dropping a base");
    CGPoint centerOfMap = CGPointMake(160, 210);
    [self addBase:&centerOfMap];
    
    
}

- (void)addBase:(CGPoint*)pt
{
    totalBasesDropped++;
    CGPoint tappedPoint = *pt;
    CLLocationCoordinate2D coord= [mapView convertPoint:tappedPoint toCoordinateFromView:mapView];
    longi = [[NSString alloc]initWithFormat:@"%f",coord.longitude];
    lati = [[NSString alloc]initWithFormat:@"%f",coord.latitude];
    
//	mapAnnotations* myAnnotation1=[[mapAnnotations alloc] init];
//	
//	myAnnotation1.coordinate=coord;
//	myAnnotation1.title=@"homeBase";
//	myAnnotation1.subtitle=[NSString stringWithFormat:@"base_%d.png",myPlayerNumber];
//    myAnnotation1.pinImage=[NSString stringWithFormat:@"base_%d.png",myPlayerNumber];
//    
//	[mapView addAnnotation:myAnnotation1];
    
    gameboardOverlay *mapOverlay = [[gameboardOverlay alloc]initWithCoordinate:coord andImage:[NSString stringWithFormat:@"base_%d.png",myPlayerNumber] with:CGSizeMake(2000, 2000) as:@"base" withOpacity:1];
    [mapView addOverlay:mapOverlay];
    
    
    if(totalBasesDropped == 1){
        basesLocationString = [[NSString alloc]initWithFormat:@"%@,%@",lati,longi];
    }else if(totalBasesDropped == 2){
        basesLocationString = [[NSString alloc]initWithFormat:@"%@,%@,%@",basesLocationString,lati,longi];
        [self buildBase:basesLocationString];
        
    }
    // add an annotation with coord
}




#pragma mark - gameplay updating


- (void)postDropBomb:(int)type dLat:(float)dropLat dLong:(float)dropLong{
    BOOL illegalHit = FALSE;
    double radiusOfItem = 0.2;
    for(NSDictionary *item in mainArsenalArray){
        NSLog(@"this is the itemId %d",[[item objectForKey:@"id"]intValue]);
        
        if(type == [[item objectForKey:@"id"]intValue]){
            NSLog(@"this is a main aresenal array item %@",item);
            radiusOfItem = [[item objectForKey:@"radius"]floatValue];

        }
    }
    CLLocation *currentBomb = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(dropLat, dropLong) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]];
    double radi = (radiusOfItem*0.621371192)*1000; // GET THE RADIUS OF THE BOMB LATER
    double baseRadius = (0.1*0.621371192)*1000;
    for (aBomb *aBombObject in aBombArray){
        
        CLLocation *bombLocation = [[CLLocation alloc] initWithLatitude:[aBombObject.lat floatValue] longitude:[aBombObject.longi floatValue]];
        double distance = [bombLocation distanceFromLocation:currentBomb];
        double combinedRadii = (radi) + (([aBombObject.radius floatValue]/2));
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-LL-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:aBombObject.dateBombed];
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:date
                                                              toDate:[NSDate date]
                                                             options:0];
        
        if ( distance < combinedRadii && [components day] < 1){

            illegalHit = TRUE;
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Phone Tag"
                                                              message:@"You can't drop a bomb on a place that has already been bombed today!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
    for (CLLocation *baseLocation in basesArray){

        double distance = [baseLocation distanceFromLocation:currentBomb];
        double combinedRadii = (radi) + (baseRadius);

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
        
    }else{
        mapAnnotations* myAnnotation1=[[mapAnnotations alloc] init];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(dropLat, dropLong);
        
//        myAnnotation1.coordinate=coord;
//        myAnnotation1.title=@"bomb";
//        myAnnotation1.subtitle=[NSString stringWithFormat:@"bomb_%d.png",myPlayerNumber];
//        myAnnotation1.pinImage=[NSString stringWithFormat:@"bomb_%d.png",myPlayerNumber];
//        //[self refreshAnnotationViews];
//        
//        [mapView addAnnotation:myAnnotation1];
        
        
        gameboardOverlay *mapOverlay = [[gameboardOverlay alloc]initWithCoordinate:coord andImage:[NSString stringWithFormat:@"bomb_%d.png",myPlayerNumber] with:CGSizeMake(2000, 2000) as:@"bomb" withOpacity:1];
        [mapView addOverlay:mapOverlay];
        bombAnimation.hidden= NO;

        [bombAnimation startAnimating];
    
        
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
            NSError *error = nil;
            NSArray *hitResults = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            NSLog(@"hit results: %@", datastring);
            hitResultArray = [[NSMutableArray alloc]init];
            if (hitResults.count > 0){
                NSLog(@"adding box");
                hitsContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
                hitsContainer.backgroundColor = [UIColor blackColor];
                hitsContainer.alpha = 0.8;
                
                UIImageView *hitContainerBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
                [hitContainerBg setImage:[UIImage imageNamed:@"hitResultBlast"]];
                
                UIView *hitResultsBox = [[UIView alloc]initWithFrame:CGRectMake(0, (screenHeight/2)-((34*hitResults.count)/2), screenWidth, 34*hitResults.count)];
                for (NSDictionary *hitUser in hitResults){
                    NSString *hitMessage = [[NSString alloc]init];
                    if ([[hitUser objectForKey:@"uid"] isEqualToString:myInfo.ptId]){ // YOURSELF
                        if ([[hitUser objectForKey:@"kill"] integerValue] == 1){ // KILLED YOURSELF
                            hitMessage = @"You hit and killed yourself!";
                        }else{ // HIT YOURSELF
                            hitMessage = @"You hit yourself!";
                        }
                    }else{ // SOMEONE ELSE
                        if ([[hitUser objectForKey:@"kill"] integerValue] == 1){ // KILLED PLAYER
                            hitMessage = [NSString stringWithFormat:@"You hit and killed %@!", [hitUser objectForKey:@"uname"]];
                        }else{ // HIT PLAYER
                            hitMessage = [NSString stringWithFormat:@"You hit %@!", [hitUser objectForKey:@"uname"]];
                        }
                    }
                    
                    NSLog(@"hit message: %@", hitMessage);
                    
                    int hitOrder = (int)[hitResults indexOfObject:hitUser];
                    UIView *hitResultView = [[UIView alloc]initWithFrame:CGRectMake(0, (34 *hitOrder),screenWidth , 28)];
                    hitResultView.backgroundColor = [UIColor blackColor];
                    hitResultView.alpha = 0.9;
                    
                    UILabel *hitResultLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, screenWidth - 40, 28)];
                    [hitResultLabel setTextAlignment:NSTextAlignmentCenter];
                    [hitResultLabel setText:hitMessage];
                    hitResultLabel.minimumScaleFactor = 0.5;
                    hitResultLabel.font = [UIFont fontWithName:@"SFArchRival-Italic" size:17];
                    hitResultLabel.textColor = [UIColor whiteColor];
                    hitResultLabel.minimumScaleFactor = 0.5;
                    [hitResultView addSubview:hitResultLabel];
                    
                    [hitResultsBox addSubview:hitResultView];
                    [hitResultArray addObject:hitResultView];
                }
                [hitsContainer addSubview:hitContainerBg];
                [hitsContainer addSubview:hitResultsBox];
                [self.view insertSubview:hitsContainer belowSubview:playerInfoContainer];
                hitsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeHitResults:)];
                int totalBombs = (int)bombLabel.text;
                totalAmountOfBombs = totalBombs;
                totalBombs--;
                [bombLabel setText:[NSString stringWithFormat:@"%d",totalBombs]];
                
                [self.view addGestureRecognizer:hitsTap];
            }
            [appDel refreshArsenal];
            [self getGameData:0];
            [self closeBombDropper];
            
            
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

- (IBAction)closeHitResults:(UITapGestureRecognizer *)gesture{
    [hitsContainer removeFromSuperview];
    [self.view removeGestureRecognizer:hitsTap];
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
            
            [self closeBases];
            [self getGameData:@"2"];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Phone Tag"
                                                              message:@"You've placed your bases... When everyone else has set up their bases, the game can begin!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            

        });
    }];
    
    [registerTask resume];
    
}


#pragma mark - Game Setup


-(void)getGameData: (NSString *)callback{

    [self clearOverlays];
    [self openLoaderDoor];

    NSMutableArray *gameWinners = [[NSMutableArray alloc]init];
    NSString *post = [NSString stringWithFormat: @"gid=%@&uid=%@", gameid, myInfo.ptId];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    basesArray = [[NSMutableArray alloc]init];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=gameDetail";
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
            [self clearOverlays];
            bombAnimation.hidden= YES;



            //NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
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
                int pn =(int)[playerArray indexOfObject:player];
                pn++;
                [playerNumbers setObject:[NSNumber numberWithInt:pn] forKey:[player objectForKey:@"playerId"]];
                
                if([[player objectForKey:@"playerId"]isEqualToString:myInfo.ptId]){
                    currentGame.bombsLeft = [player objectForKey:@"bombs"];
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
                    gameboardOverlay *baseAOverlay = [[gameboardOverlay alloc]initWithCoordinate:baseALocation andImage:[NSString stringWithFormat:@"base_%d.png",playerOrder] with:CGSizeMake(2000, 2000) as:@"base" withOpacity:1];
                    [mapView addOverlay:baseAOverlay];
                    gameboardOverlay *baseBOverlay = [[gameboardOverlay alloc]initWithCoordinate:baseBLocation andImage:[NSString stringWithFormat:@"base_%d.png",playerOrder] with:CGSizeMake(2000, 2000) as:@"base" withOpacity:1];
                    [mapView addOverlay:baseBOverlay];
                    CLLocation *currentALocation = [[CLLocation alloc]initWithLatitude:baseALocation.latitude longitude:baseALocation.longitude];
                    CLLocation *currentBLocation = [[CLLocation alloc]initWithLatitude:baseBLocation.latitude longitude:baseBLocation.longitude];
                    [basesArray addObject: currentALocation];
                    [basesArray addObject: currentBLocation];

                }else{
                    playerOrder = (int)[playerArray indexOfObject:player];
                    playerOrder++;
                    if(playerOrder == myPlayerNumber && basesSet){
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
                        gameboardOverlay *baseAOverlay = [[gameboardOverlay alloc]initWithCoordinate:baseALocation andImage:[NSString stringWithFormat:@"base_%d.png",playerOrder] with:CGSizeMake(2000, 2000) as:@"base" withOpacity:1];
                        [mapView addOverlay:baseAOverlay];
                        gameboardOverlay *baseBOverlay = [[gameboardOverlay alloc]initWithCoordinate:baseBLocation andImage:[NSString stringWithFormat:@"base_%d.png",playerOrder] with:CGSizeMake(2000, 2000) as:@"base" withOpacity:1];
                        [mapView addOverlay:baseBOverlay];
                        
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
                [playersInfoView.tableView reloadData];
                
                [self replaceTopConstraintOnView:playerInfoContainer withConstant:20];
                [self animateDuration:0.2 delay:0.0];

                
                
            }
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
            
            
            if (gameWinners.count > 0){ // THERE'S A WINNER
                
                float winBoxWidth = screenHeight + (screenHeight *.5);
                float winBoxX = -((winBoxWidth - screenWidth)/2);
                UIView *winnerCover = [[UIView alloc]initWithFrame:CGRectMake(winBoxX, -(screenHeight*.25), winBoxWidth, winBoxWidth)];
                winnerCover.clipsToBounds = NO;
                UIView *winnerCoverBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, winnerCover.frame.size.width, winnerCover.frame.size.width)];
                UIImageView *winnerCoverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, winnerCover.frame.size.width, winnerCover.frame.size.height)];
                [winnerCoverImage setImage:[UIImage imageNamed:@"winbg_2"]];
                [winnerCoverBackground addSubview:winnerCoverImage];
                [self runSpinAnimationOnView:winnerCoverBackground duration:2 rotations:.1 repeat:2];
                
                UIView *winnerBox = [[UIView alloc]initWithFrame:CGRectMake(((winnerCover.frame.size.width/2) - 153), (winnerCover.frame.size.height/2) - 129, 305, 259)];
                UIImageView *winnerBoxImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, winnerBox.frame.size.width, winnerBox.frame.size.height)];
                [winnerBoxImage setImage:[UIImage imageNamed:@"winnerCloud"]];
                
                //UIButton *winnerButton = [[UIButton alloc]initWithFrame:CGRectMake(winnerBox.frame.size.width -50, 20, 30, 30)];
                //[winnerButton addTarget:self action:@selector(closeWinnerBox:) forControlEvents:UIControlEventTouchUpInside];
                UILabel *winnerTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, winnerBox.frame.size.width - 40, 80)];
                winnerTitle.textAlignment = NSTextAlignmentCenter;
                winnerTitle.textColor = [UIColor blackColor];
                winnerTitle.font = [UIFont fontWithName:@"BadaBoom BB" size:60];
                winnerTitle.minimumScaleFactor = 0.5;

                UILabel *winnerSubtitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, winnerBox.frame.size.width -40, 80)];
                winnerSubtitle.textAlignment = NSTextAlignmentCenter;
                winnerSubtitle.textColor = [UIColor blackColor];
                winnerSubtitle.font = [UIFont fontWithName:@"BadaBoom BB" size:60];
                winnerSubtitle.minimumScaleFactor = 0.3;
                
                if (gameWinners.count == 1){
                    
                    if([[gameWinners objectAtIndex:0] isEqualToString:myInfo.ptUsername]){
                        winnerTitle.text = @"YOU WON!";
                        [winnerTitle setFrame:CGRectMake(20, 75, winnerBox.frame.size.width - 40, 80)];
                        winnerTitle.font = [UIFont fontWithName:@"BadaBoom BB" size:70];
                    }else{
                        winnerTitle.text = [NSString stringWithFormat:@"%@", [gameWinners objectAtIndex:0]];
                        winnerSubtitle.text = @"Wins!";
                    }
                }else{
                    winnerTitle.text = @"DRAW!";
                }
            
                winnerCoverBackground.backgroundColor = [UIColor blackColor];
                winnerCoverBackground.alpha = 0.8;
                
                [winnerCover addSubview:winnerCoverBackground];
                [winnerCover addSubview:winnerBox];
                [winnerBox addSubview:winnerBoxImage];
                [winnerBox addSubview:winnerTitle];
                if (winnerSubtitle.text.length > 0){
                    [winnerBox addSubview:winnerSubtitle];
                }
                
                [self.view insertSubview:winnerCover belowSubview:timeBackground];
            }else{
                //[self refreshAnnotationViews];
            }

        }); // END OF DISPATCH

    }];
    
    [checkUsernameTask resume];


}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    animation2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)];
    animation2.repeatCount = HUGE_VALF;
    animation2.duration = 0.8;
    animation2.autoreverses = YES;
    
    [view.layer addAnimation:animation2 forKey:@"animateMask2"];
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (IBAction)closeWinnerBox:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closePlayerInfo:(id)sender{
    if (playerInfoContainer.frame.origin.y > 0){
   [self replaceTopConstraintOnView:playerInfoContainer withConstant:-298];
    [self animateDuration:0.2 delay:0.0];
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
    itemHolder.hidden = YES;
    playerInfoContainer.hidden = YES;
    baseDropperHolder.hidden = NO;
    baseDropSightOverlay.hidden = NO;
    dropBaseButton.hidden = NO;
    totalBasesDropped = 0;
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

    int i;
    for (i = 0; i < baseCount; i++){
        float xpos = 5;
        if (i == 1){
            xpos = 72;
        }
        UIImageView *baseObject = [[UIImageView alloc]initWithFrame:CGRectMake(xpos, 15, 60, 60)];
        [baseObject setImage:[UIImage imageNamed:[NSString stringWithFormat:@"base_%d.png",myPlayerNumber]]];
        baseObject.contentMode = UIViewContentModeScaleAspectFit;
        [baseDropperHolder addSubview:baseObject];
        [unPlacedBases addObject:baseObject];
        
    }
    if (unPlacedBases.count > 0){
        [self openLoaderDoor];
    }
}


-(void)closeBases{
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [baseDropperHolder setAlpha:0.0f];
                         [baseDropSightOverlay setAlpha:0.0f];
                         [dropBaseButton setAlpha:0.0f];

                         
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             itemHolder.hidden = NO;
                             playerInfoContainer.hidden = NO;
                             baseDropperHolder.hidden = YES;
                             baseDropSightOverlay.hidden = YES;
                             dropBaseButton.hidden = YES;
                         }
                     }
     ];
    
    
    
}





-(void)loadBombs{
    unusedBombs = [[NSMutableArray alloc] init];
    
    
    int totalToSubtract = [currentGame.bombsLeft intValue];
    //int totalToSubtract = 100;

    for(int i=0; i<totalToSubtract; i++){
        UIImageView *bomb = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 70,70)];
        //[bomb setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bomb_%d.png",myPlayerNumber]]];
        //[bomb isUserInteractionEnabled];
        //[itemHolder addSubview:bomb];
        [unusedBombs addObject:bomb];
    }
    UIButton *bombButton = [[UIButton alloc]initWithFrame:CGRectMake(2, -5, 87, 87)];
    [bombButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bomb_btn_%d.png",myPlayerNumber]] forState:UIControlStateNormal];
    [bombButton addTarget:self
               action:@selector(openBombDropper)
     forControlEvents:UIControlEventTouchUpInside];
    [itemHolder addSubview:bombButton];

    
    
    NSString *totalBombs = [[NSString alloc]initWithFormat:@"%d",totalToSubtract];
    totalAmountOfBombs = [totalBombs intValue];
    [bombLabel setText:totalBombs];
    [bombLabel setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:28]];
    
    UILabel *bombLabelx = [[UILabel alloc]initWithFrame:CGRectMake(56,85,100,20)];
    [bombLabelx setText:@"x"];
    [bombLabelx setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:14]];
    [self.view insertSubview:bombLabelx atIndex:9];
    
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
            
            NSError *error = nil;
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
    //            CCAlertView *alert = [[CCAlertView alloc]
    //                                  initWithTitle:@"Phone Tag"
    //                                  message:@"You've been HIT!"];
    //            [alert addButtonWithTitle:@"Ok" block:NULL];
    //            [alert show];
    //            //[self looseLife];
    //
    //        }
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
        
        CLLocationCoordinate2D annotationlocation;
        double latiDouble = [bombDr.lat doubleValue];
        double longiDouble = [bombDr.longi doubleValue];
        annotationlocation.latitude = latiDouble;
        annotationlocation.longitude = longiDouble;
        mapAnnotations *txts = [[mapAnnotations alloc] init];
        txts.coordinate = annotationlocation;
        NSLog(@"this is date bombed %@",bombDr.dateBombed);
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-LL-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:bombDr.dateBombed];
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:date
                                                              toDate:[NSDate date]
                                                             options:0];
        float bombOp;
        switch ([components day])
        
        {
            case 0:
                 bombOp = 1.0;
                break;
                
            case 1:
                
                 bombOp = 0.7;
                
                break;
            case 2:
                
                 bombOp = 0.4;
                
                break;
            case 3:
                
                 bombOp = 0.2;
                
                break;
                
            default:
                
                 bombOp = 0.1;
                
                break;
                
        }
        
        
        if (bombDr.hits.count > 0){
            NSLog(@"this is a hit %@",bombDr.hits);
            NSLog(@"this is a player  List %@",playerNumbers);
            for(NSString *hitPerson in bombDr.hits){
                NSLog(@"this is a hit %@",hitPerson);

                gameboardOverlay *bombHit = [[gameboardOverlay alloc]initWithCoordinate:txts.coordinate  andImage:[NSString stringWithFormat:@"hit_%@",[playerNumbers objectForKey:hitPerson]] with:CGSizeMake(2000, 2000) as:@"hit" withOpacity:1];
                [mapView addOverlay:bombHit];
                bombOp = 1.0;
                
            }

            txts.subtitle = [NSString stringWithFormat:@"flag_%@",[playerNumbers objectForKey:bombDr.userid]];
            
        }else{
            if([bombDr.type isEqualToString:@"2"] && [bombDr.userid isEqualToString:myInfo.ptId] ){
                txts.subtitle = [NSString stringWithFormat:@"tripLine_%d.png",myPlayerNumber];
                bombOp = 1.0;

            }else if([bombDr.type isEqualToString:@"1"]){
                txts.subtitle = [NSString stringWithFormat:@"bomb_%@.png",[playerNumbers objectForKey:bombDr.userid]];
            }
        }
        
        //[mapView addAnnotation:txts];
        gameboardOverlay *bomb = [[gameboardOverlay alloc]initWithCoordinate:txts.coordinate  andImage:txts.subtitle with:CGSizeMake(2000, 2000) as:@"bomb" withOpacity:bombOp];
        [mapView addOverlay:bomb];
        
        [aBombArray addObject:bombDr];
        // add an annotation with coord
    }
    if (topDoorBox.frame.origin.y == 0){
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

- (void)replaceBottomConstraintOnView:(UIView *)view withConstant:(float)constant
{
    NSLog(@"%f",constant);
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.firstItem == view) && (constraint.firstAttribute == NSLayoutAttributeBottom)) {
            constraint.constant = constant;
        }
    }];
}

- (void)animateDuration: (float)duration delay:(float)delay
{
    [UIView animateWithDuration:duration
                          delay:delay
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         NSLog(@"duration: %f, delay: %f", duration, delay);
                         [self.view layoutIfNeeded];
                         
                     }completion:^(BOOL finished){
                         
                     }];
}

- (IBAction)goBack:(id)sender {
    if (infoBoxIsOpen == TRUE){
        [arseInfo removeFromSuperview];
        infoBoxIsOpen = FALSE;
    }else{
        [self dismissViewControllerAnimated:true completion:^{}];
    }
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)startTimer{
    loadTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCalled) userInfo:nil repeats:YES];
    timerCount = 0;
}

-(void)timerCalled{
    if (timerCount < 5){
        timerCount ++;
    }else{
        [loadTimer invalidate];
        CCAlertView *alert = [[CCAlertView alloc]
                              initWithTitle:@"Connection"
                              message:@"Your connection may be weak. Try again when you have a better signal."];
        [alert addButtonWithTitle:@"Ok" block:^{
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];

        [alert show];
    }
    
    // Your Code
}

- (void)openLoaderDoor{
    if ((annotationsUpdated == TRUE) || unPlacedBases.count > 0){
        [loadTimer invalidate];
        
        //myLocationUpdated == TRUE && 
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
    //[self startTimer];
    topDoorBox = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, (screenHeight/2)+79)];
    UIImageView *initMap = [[UIImageView alloc]initWithFrame:CGRectMake(19, 148, 288, 122)];
    [initMap setImage:[UIImage imageNamed:@"initializing"]];
    UIImageView *topDoorBlock = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, topDoorBox.frame.size.height)];
    [topDoorBlock setImage:[UIImage imageNamed:@"topDoor.png"]];
    
    [topDoorBox addSubview:topDoorBlock];
    [topDoorBox addSubview:initMap];
    
    bottomDoorBox = [[UIView alloc]initWithFrame:CGRectMake(0, (screenHeight/2)-25, screenWidth, (screenHeight/2)+25)];
    UIImageView *bottomDoorBlock = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, bottomDoorBox.frame.size.height)];
    [bottomDoorBlock setImage:[UIImage imageNamed:@"bottomDoor.png"]];
    
    [bottomDoorBox addSubview:bottomDoorBlock];
    
    [self.view insertSubview:topDoorBox belowSubview:itemHolder];
    [self.view insertSubview:bottomDoorBox belowSubview:itemHolder];
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [mainArsenalArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    static NSString *identifier = @"acell";
    
    aCell = (PlayerArsenalCell *)[self.arsenalCollection dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [aCell.itemCount setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:16]];
    [aCell.itemx setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:11]];
    NSMutableDictionary *item = [mainArsenalArray objectAtIndex:indexPath.row];
    
    NSDictionary *bomb = [[item objectForKey:@"bomb"] objectAtIndex:0];
    if (arsenalArray.count > 0){
    NSArray *currentBomb = [arsenalArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(id == %@)", [item objectForKey:@"id"]]];
    NSDictionary *arseDict = [[NSDictionary alloc]init];
    if (currentBomb.count > 0){
        arseDict = [currentBomb objectAtIndex:0];
        if ([[arseDict objectForKey:@"count"] isEqualToString:@"0"]){
            aCell.itemCount.text = @"0";
            aCell.self.userInteractionEnabled = NO;
            aCell.self.alpha = 0.4;
        }else{
            aCell.itemCount.text = [arseDict objectForKey:@"count"];
            aCell.userInteractionEnabled = YES;
        }
    }else{
        aCell.itemCount.text = @"0";
        aCell.self.alpha = 0.4;
    }
    }
    
    aCell.itemName.text = [bomb objectForKey:@"name"];
    
    [aCell.itemImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.operationcmyk.com/phonetag/arsenalImages/%@_arsenal.png", [item objectForKey:@"id"]]]placeholderImage:nil
                             options:0
                            progress:nil
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                               
                           }];
    
    return aCell;
}

-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
        NSLog(@"item: %@", mainArsenalArray);
        NSDictionary *item = [mainArsenalArray objectAtIndex:indexPath.row];
        NSArray *currentBomb = [arsenalArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(id == %@)", [item objectForKey:@"id"]]];
    
    if (currentBomb.count > 0){
        int itemId = [[item objectForKey:@"id"] intValue];
        switch (itemId) {
            case 2:
                    [self dropMine];
                break;
            case 3:
                [self useRecon];
                break;
            
            default:
                break;
        }
    }else{
        [arseInfo removeFromSuperview];
        arseInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        [arseInfo addSubview:arsenalInfo.view];
        [arsenalInfo buildArsenalInfo:[[item objectForKey:@"id"] intValue]];
        [self.view insertSubview:arseInfo belowSubview:itemHolder];
        infoBoxIsOpen = TRUE;
        /*[arsenalInfo.arsenalImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.operationcmyk.com/phonetag/arsenalImages/%@_arsenal.png", [item objectForKey:@"id"]]]placeholderImage:nil
                                          options:0
                                         progress:nil
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                            
                                        }];
        currentItemAppId = [item objectForKey:@"appleId"]; // APPLE ID
        currentItemDBId = [item objectForKey:@"id"]; //CURRENT DB ID
        currentQuantity = [item objectForKey:@"quantity"];
        [arsenalInfo.arsenalText setText:[item objectForKey:@"info"]];
        [arsenalInfo.arsenalName setText:[item objectForKey:@"name"]];
        NSString *buyMessage = [NSString stringWithFormat:@"Buy %@ for $%@", [item objectForKey:@"quantity"], [item objectForKey:@"price"]];
        [arsenalInfo.arsenalBuyMessage setText:buyMessage];
        [arsenalInfo.arsenalBuyMessageBg setText:buyMessage];
        [arsenalInfo.arsenalBuyButton addTarget:self
                                      action:@selector(buyItem:)
                            forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"showing view");
        [self.view insertSubview:arseInfo belowSubview:itemHolder];
        infoBoxIsOpen = TRUE;*/
    }
}

- (void)reloadCollection{
    NSLog(@"reload collection");
    [self.arsenalCollection reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchMap.delegate = self;
    [dropBaseInstructions setFont:[UIFont fontWithName:@"BadaBoom BB" size:14]];
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    bombAnimation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 576)];
    NSMutableArray *animationFrames = [[NSMutableArray alloc]init];
    // load all the frames of our animation
    for(int i = 4; i<29;i++){
        NSString *fileName = [[NSString alloc]initWithFormat:@"bomb animation_%d.png",i];
        
        [animationFrames addObject:[UIImage imageNamed:fileName]];
    }
    bombAnimation.animationImages = animationFrames;
    // all frames will execute in 1.75 seconds
    bombAnimation.animationDuration = 1;
    // repeat the annimation forever
    bombAnimation.animationRepeatCount = 1;

    bombAnimation.hidden= YES;
    [self.view insertSubview:bombAnimation atIndex:1000];
    [dropBombButton startAnimating];

    
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadCollection)
                                                 name:@"arsenalRefresh" object:nil];
    
    arsenalInfo = [[ArsenalDetails alloc]initWithNibName:@"ArsenalDetails" bundle:nil];
    myInfo = [PTStaticInfo sharedManager];
    appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    playersInfoView = [[PlayersInfo alloc]initWithNibName:@"PlayersInfo" bundle:nil];
    feedTableView = [[FeedTable alloc]initWithNibName:@"FeedTable" bundle:nil];
    
    [playerInfoBox addSubview:playersInfoView.view];
    [feedTableView loadFeedForGame:myInfo.activeGameId andUser:myInfo.ptId];
    [feedBox addSubview:feedTableView.view];
    
    self.arsenalCollection.backgroundColor = [UIColor clearColor];
    infoBoxIsOpen = FALSE;
    indGameSetup.hidden = YES;
    //[self.view insertSubview:indGameSetup atIndex:10];
    homeTouch = false;
    needsBases = true;
    CLLocation *userLoc = mapView.userLocation.location;
    CLLocationCoordinate2D userCoordinate = userLoc.coordinate;
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
    foundPlace = 0;
    
    
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:pinchRecognizer];
    
    NSMutableArray *aniFrames = [[NSMutableArray alloc]init];
    // load all the frames of our animation
    for(int i = 0; i<23;i++){
        NSString *fileName = [[NSString alloc]initWithFormat:@"boom_btn_%d.png",i];
        
        [aniFrames addObject:[UIImage imageNamed:fileName]];
    }
    dropBombButton.animationImages = aniFrames;
    // all frames will execute in 1.75 seconds
    dropBombButton.animationDuration = 1;
    // repeat the annimation forever
    dropBombButton.animationRepeatCount = 0;
    [dropBombButton startAnimating];

    
    
    [self setNeedsStatusBarAppearanceUpdate];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated{
    gameid = myInfo.activeGameId;
    foundPlace = 0;
    [self initLocationManager];

    [self getGameData: @"2"];
    [appDel refreshArsenal];
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
