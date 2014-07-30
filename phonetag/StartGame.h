//
//  StartGame.h
//  phonetag
//
//  Created by Brandon Phillips on 6/2/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "PlayerCell.h"
#import "PlayerRow.h"
#import "PTStaticInfo.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@interface StartGame : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NSURLSessionDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate>{
    
    IBOutlet UIScrollView *recentPlayersScroller;
    
    PlayerRow *pRow;
    PTStaticInfo *staticUserInfo;
    NSMutableArray *gameUserIds;
    NSString *gameRegistrationNumber;
    NSMutableArray *gameUserPhoneNumbers;
    NSMutableArray *addedUsers;
    
    IBOutlet UIButton *friendsButton;
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *recentButton;
    IBOutlet UIView *tableLoader;
    
    
#pragma mark - COLLECTION VIEW
    
    PlayerCell *pCell;
    IBOutlet UIView *numberHolder;
    NSArray *arrayOfNumbers;
    
#pragma mark - ADD TITLE
    
    IBOutlet UIView *titleBox;
    IBOutlet UITextField *gameNameField;
    IBOutlet UIButton *titleSubmitCancel;
    IBOutlet UIButton *titleSubmitButton;
}

@property (nonatomic, strong) IBOutlet UICollectionView *playersCollectionView;
@property (nonatomic, strong) IBOutlet UITableView *playersTableView;
@property (nonatomic, strong) NSMutableArray *playersArray;
@property (nonatomic, strong) NSMutableArray *currentList;


- (IBAction)cancelNewGame:(id)sender;
- (IBAction)submitGame:(id)sender;


@end
