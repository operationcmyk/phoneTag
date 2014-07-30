//
//  gameBoardOverlayView.m
//  phonetag
//
//  Created by Christopher on 7/21/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "gameBoardOverlayView.h"

@implementation gameBoardOverlayView

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)ctx
{
    gameboardOverlay *ove = self.overlay;
    
    UIImage *image  = [UIImage imageNamed:ove.flagImage];
    
    CGImageRef imageReference = image.CGImage;
    
    MKMapRect theMapRect    = [self.overlay boundingMapRect];
    CGRect theRect           = [self rectForMapRect:theMapRect];
    CGRect clipRect     = [self rectForMapRect:mapRect];

//    CGContextAddRect(ctx, clipRect);
//    CGContextClip(ctx);
//    
//    CGContextDrawImage(ctx, theRect, imageReference);
    UIGraphicsPushContext(ctx);
    [image drawInRect:theRect blendMode:kCGBlendModeHardLight alpha:ove.opacity];
    UIGraphicsPopContext();
    
}


@end
