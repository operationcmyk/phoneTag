//
//  PTStaticInfo.m
//  phonetag
//
//  Created by Brandon Phillips on 5/28/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "PTStaticInfo.h"
static PTStaticInfo *sharedMyManager = nil;

@implementation PTStaticInfo
@synthesize ptId,ptEmail,ptFullname,ptUsername,activeGameId,ptArsenalArray,ptVersion;

+ (id)sharedManager {
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}
- (id)init
{
    self = [super init];
    if (self) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary"]){
            NSDictionary *userDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"];
            ptUsername = [userDictionary objectForKey:@"username"];
            ptFullname =[userDictionary objectForKey:@"fullname"];
            ptEmail =[userDictionary objectForKey:@"email"];
            ptId =[userDictionary objectForKey:@"id"];
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"arsenalArray"]){
            ptArsenalArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"arsenalArray"];
        }
        
        activeGameId = NULL;
    }
    return self;
}

- (void)arsenal:(NSArray *)arsenalArray{
    [[NSUserDefaults standardUserDefaults]setObject:arsenalArray forKey:@"arsenalArray"];
    ptArsenalArray = arsenalArray;
}

- (void)addVersion:(NSString *)PTv{
    [[NSUserDefaults standardUserDefaults]setObject:PTv forKey:@"userVersion"];
    ptVersion = PTv;
}

- (void)logout{
    ptFullname = @"";
    ptId = nil;
    ptUsername = @"";
    ptEmail = @"";
    activeGameId = @"";
    ptVersion = @"";
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userDictionary"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:self];
}

- (void)username: (NSString *)uName fullname: (NSString *)fName email:(NSString *)em PTId:(NSString *)PTId PTv:(NSString *)PTv{
    
    NSDictionary *userInfoDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:PTId,@"id",
                                        uName,@"username",
                                        fName,@"fullname",
                                        em,@"email",
                                        PTv,@"version",
                                        nil];
    [[NSUserDefaults standardUserDefaults]setObject:userInfoDictionary forKey:@"userDictionary"];
    
    ptUsername = uName;
    ptFullname = fName;
    ptEmail = em;
    ptId = PTId;
    ptVersion = PTv;
}

@end
