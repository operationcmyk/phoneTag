//
//  ViewController.h
//  phonetag
//
//  Created by Brandon Phillips on 5/28/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GameListRow.h"
#import "PTStaticInfo.h"
#import "gameBoard.h"
#import <MessageUI/MessageUI.h>


@interface ViewController : UIViewController<NSURLSessionDelegate, NSURLSessionTaskDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>{
    
    float screenWidth;
    float screenHeight;
    IBOutlet UIView *coverall;
#pragma mark - LOGIN
    
    
#pragma mark - TOP BUTTONS
    
    IBOutlet UIImageView *startGameBox;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *joinButton;
    IBOutlet UIButton *checkRegistrationButton;
    
    IBOutlet UIView *codeInputBox;
    BOOL codeInputBoxOpen;
    
    IBOutlet UITextField *code1;
    IBOutlet UITextField *code2;
    IBOutlet UITextField *code3;
    IBOutlet UITextField *code4;
    IBOutlet UITextField *code5;
    IBOutlet UITextField *code6;
    IBOutlet UILabel *codeLabel;

    
#pragma mark - GAMES LIST
    
    IBOutlet UIImageView *backgroundLogo;
    gameBoard *gameBoardView;
    PTStaticInfo *staticUserInfo;
    GameListRow *gameRow;
    
    UIRefreshControl *refreshControl;

    NSArray *userArray;
    NSMutableArray *gamesArray;
    NSMutableArray *completedGamesArray;
    NSArray *allGames;
    NSMutableArray *historyChanges;
    NSMutableArray *mismatchedUserIds;
    
    CLLocationManager *cLocationManager;

    
#pragma mark - FACEBOOK FRIENDS
    
    NSString *accessToken;
}

@property (nonatomic, weak) IBOutlet UITableView *listOfGames;
@property (nonatomic, weak) IBOutlet UITableViewCell *gameRow;


@end
