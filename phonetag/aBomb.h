//
//  aBomb.h
//  phonetag
//
//  Created by chris langer on 7/19/12.
//
//

#import <Foundation/Foundation.h>

@interface aBomb : NSObject{
    NSString *bombId;
    NSString *gameid;
    NSString *lat;
    NSString *longi;
    NSString *userid;
    NSString *type;
    NSString *radius;
    NSArray *hits;
    NSString *dateBombed;
}

@property (nonatomic, retain) NSString *bombId;
@property (nonatomic, retain) NSString *gameid;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *longi;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *radius;
@property (nonatomic, retain) NSString *dateBombed;
@property (nonatomic, retain) NSArray *hits;


@end
