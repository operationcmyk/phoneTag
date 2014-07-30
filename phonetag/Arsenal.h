//
//  Arsenal.h
//  phonetag
//
//  Created by Christopher on 5/28/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerArsenalCell.h"
#import "ArsenalRow.h"
#import "PTStaticInfo.h"
#import "AppDelegate.h"
#import "ArsenalDetails.h"

@interface Arsenal : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>{
    
    ArsenalDetails *aDetails;
    AppDelegate *appDel;
    PTStaticInfo *staticUserInfo;
    
#pragma mark - COLLECTION VIEW
    
    PlayerArsenalCell *aCell;
    
#pragma mark - TABLE VIEW
    ArsenalRow *aRow;

#pragma mark - ITEM INFO BOX
    
    BOOL itemBoxIsOpen;
    
    IBOutlet UIView *arsenalInfoBox;
}

@property (nonatomic, strong) IBOutlet UICollectionView *arsenalCollectionView;
@property (nonatomic, strong) IBOutlet UITableView *arsenalTableView;

@end
