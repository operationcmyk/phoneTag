//
//  PTStaticInfo.h
//  phonetag
//
//  Created by Brandon Phillips on 5/28/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTStaticInfo : NSObject{
    NSString *ptFullname;
    NSString *ptId;
    NSString *ptUsername;
    NSString *ptEmail;
    NSString *activeGameId;
    NSString *ptVersion;
    NSArray *ptArsenalArray;

}

- (void)logout;

- (void)username: (NSString *)uName fullname: (NSString *)fName email:(NSString *)em PTId:(NSString *)PTId PTv:(NSString *)PTv;

- (void)arsenal:(NSArray *)arsenalArray;

- (void)addVersion: (NSString *)PTv;

@property (nonatomic, strong) NSString *ptFullname;
@property (nonatomic, strong) NSString *ptId;
@property (nonatomic, strong) NSString *ptUsername;
@property (nonatomic, strong) NSString *ptEmail;
@property (nonatomic, strong) NSString *activeGameId;
@property (nonatomic, strong) NSString *ptVersion;
@property (nonatomic, strong) NSArray *ptArsenalArray;

+ (id)sharedManager;

@end
