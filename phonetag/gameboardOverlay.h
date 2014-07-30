//
//  gameboardOverlay.h
//  phonetag
//
//  Created by Christopher on 7/21/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface gameboardOverlay : NSObject <MKOverlay>{
    
    
    
}

- (MKMapRect)boundingMapRect;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andImage:(NSString*)image with:(CGSize)imageSize as:(NSString *)overlayType withOpacity:(float)op;

@property (nonatomic, readonly) NSString *flagImage;
@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) float opacity;



@end
