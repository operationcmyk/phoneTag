//
//  gameboardOverlay.m
//  phonetag
//
//  Created by Christopher on 7/21/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "gameboardOverlay.h"

@implementation gameboardOverlay
@synthesize coordinate, flagImage, size,type,opacity;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andImage:(NSString*)image with:(CGSize)imageSize as:(NSString *)overlayType withOpacity:(float)op {
    self = [super init];
    if (self != nil) {
        coordinate = aCoordinate;
        flagImage = image;
        size = imageSize;
        type = overlayType;
        opacity = op;
    }
    return self;
}




- (MKMapRect)boundingMapRect
{
    
    MKMapPoint upperLeft = MKMapPointForCoordinate(self.coordinate);
    
    MKMapRect bounds = MKMapRectMake(upperLeft.x-size.width/2, upperLeft.y-size.height/2, size.width, size.height);
    return bounds;
}


@end
