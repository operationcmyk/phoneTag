//
//  mapAnnotations.h
//  projectbattleship
//
//  Created by chris langer on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>


@interface mapAnnotations: NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate; 
    NSString *title; 
    NSString *subtitle;
    NSString *pinImage;
    NSString *noteNumber;
    NSString *noteDistance;
    NSString *cites;
    NSString *userID;
    NSString *type;
    
    
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *pinImage;
@property (nonatomic, copy) NSString *noteNumber;
@property (nonatomic, copy) NSString *noteDistance;
@property (nonatomic, copy) NSString *cites;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *type;



@end