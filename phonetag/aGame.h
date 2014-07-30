//
//  aGame.h
//  phonetag
//
//  Created by chris langer on 7/19/12.
//
//

#import <Foundation/Foundation.h>

@interface aGame : NSObject{
    NSString *lives;
    NSString *bombsLeft;
    NSString *lastLocLat;
    NSString *lastLocLongi;
    NSString *lastLogin;
    NSString *alive;
    NSString *totalPlayers;
    NSArray *Players;
    NSString *player5Bases;
    NSString *winner;
    NSString *gametype;
    NSString *regCode;
    NSString *initiated;
    
}
@property (nonatomic, retain) NSString *lives;
@property (nonatomic, retain) NSString *bombsLeft;
@property (nonatomic, retain) NSString *lastLocLat;
@property (nonatomic, retain) NSString *lastLocLongi;
@property (nonatomic, retain) NSString *lastLogin;
@property (nonatomic, retain) NSString *alive;
@property (nonatomic, retain) NSString *totalPlayers;
@property (nonatomic, retain) NSString *winner;
@property (nonatomic, retain) NSString *gametype;
@property (nonatomic, retain) NSString *regCode;
@property (nonatomic, retain) NSString *initiated;
@property (nonatomic, retain) NSArray *players;



@end
