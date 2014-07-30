//
//  PlayersInfo.h
//  phonetag
//
//  Created by Brandon Phillips on 7/17/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayersInfoRow.h"

@interface PlayersInfo : UITableViewController<NSURLSessionDelegate>{
    PlayersInfoRow *pRow;
}

@property (nonatomic, strong) NSArray *playersArray;

@end
