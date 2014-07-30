//
//  FeedTable.h
//  phonetag
//
//  Created by Brandon Phillips on 7/16/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedRow.h"

@interface FeedTable : UITableViewController<NSURLSessionDelegate>{
    NSArray *feedArray;
    FeedRow *fRow;
}

- (void)loadFeedForGame: (NSString *)gid andUser: (NSString *)uid;

@end
