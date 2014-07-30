//
//  gameBoard.h
//  phonetag
//
//  Created by Christopher on 6/3/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKAnnotation.h>
#import "CCAlertView.h"
#import "MKMapView+ZoomLevel.h"
#import "aBomb.h"
#import "aGame.h"
#import "PTStaticInfo.h"
#import "mapAnnotations.h"
#import "PlayersInfo.h"
#import "FeedTable.h"
#import "PlayerArsenalCell.h"
#import "AppDelegate.h"
#import "gameboardOverlay.h"
#import "gameBoardOverlayView.h"
#import "ArsenalDetails.h"

@interface gameBoard : UIViewController<MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate,NSURLSessionDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>{

    ArsenalDetails *arsenalInfo;
    AppDelegate *appDel;
    FeedTable *feedTableView;
    PlayerArsenalCell *aCell;
    
    float screenWidth;
    float screenHeight;
    
    BOOL myLocationUpdated;
    BOOL annotationsUpdated;
    
    NSTimer *loadTimer;
    int timerCount;
    IBOutlet UIImageView *timeBackground;
    UIView *hitsContainer;
    UITapGestureRecognizer *hitsTap;
    
#pragma mark - LOADER
    
    UIView *topDoorBox;
    UIView *bottomDoorBox;
    
    PTStaticInfo *myInfo;
    NSString *myDeviceToken;
    
#pragma mark - GAME INFO
    aGame *currentGame;
    NSString *gameid;
    IBOutlet UIView *indGameSetup;
    
#pragma mark - LOCATION STUFF
    
    IBOutlet MKMapView *mapView;
    int foundPlace;
    CLLocationCoordinate2D currentLocation;
    CGPoint startLocation;
    CLLocationManager *locationManager;
    NSString *submitURL;
    NSString *getUrl;
    NSString *lati;
    NSString *longi;
    NSString *rad;
    NSString *userLat;
    NSString *userLongi;
    NSMutableArray* annotations;
    UIView *loadingMap;
    UIActivityIndicatorView *spinner;
    
#pragma mark - BOMB STUFF
    
    BOOL homeTouch;
    IBOutlet UIView *itemHolder;
    BOOL bombTouch;
    NSMutableArray *aBombArray;
    UIImageView *activeBomb;
    UIImageView *crossHairs;
    NSData *hitData;
    NSData *allBombsData;
    NSMutableArray* unusedBombs;
    int totalAmountOfBombs;
    UILabel *bombLabel;
    
    __weak IBOutlet UIView *youreDead;
    IBOutlet UILabel *directions;
    NSMutableArray *hitResultArray;
    
    IBOutlet UIView *bombDropSightOverlay;
    IBOutlet UIView *bombButtonDropView;
    IBOutlet UIImageView *dropBombButton;
    IBOutlet UIButton *dropBomb;
    
    UIImageView *bombAnimation;
    
    
    
    
    
#pragma mark - MAPS

    IBOutlet UISearchBar *searchMap;
    
    IBOutlet UIButton *openSearch;
    
#pragma mark - ARSENAL
    UIView *arseInfo;
    NSString *currentItemDBId;
    NSString *currentItemAppId;
    NSString *currentQuantity;
    BOOL infoBoxIsOpen;
    
#pragma mark - BASES
    
    IBOutlet UIImageView *baseDropSightOverlay;
    IBOutlet UIButton *dropBaseButton;
    IBOutlet UIView *baseDropperHolder;
    int totalBasesDropped;
    
    IBOutlet UITextView *dropBaseInstructions;
    BOOL needsBases;
    NSMutableArray *basesArray;
    IBOutlet UIImageView *Base1;
    IBOutlet UIImageView *Base2;
    NSMutableArray *allRawBases;
    NSMutableArray *allBases;
    UIImageView *activeBases;
    NSMutableArray *unPlacedBases;
    NSString *basesLocationString;
    
#pragma mark - PLAYERS INFO
    
    NSMutableArray *PlayersInGame;
    int myPlayerNumber;
    NSMutableDictionary *playerNumbers;
    BOOL basesSet;
    PlayersInfo *playersInfoView;
    IBOutlet UIView *playerInfoContainer;
    IBOutlet UIView *playerInfoBox;
    IBOutlet UIView *feedBox;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *scrollContent;
    UIColor *player1Color;
    UIColor *player2Color;
    UIColor *player3Color;
    UIColor *player4Color;
    UIColor *player5Color;
    
    
#pragma mark - PLAYER STATS
    
    
}

@property(nonatomic,retain) IBOutlet MKMapView *mapView;
@property(nonatomic,strong) IBOutlet UICollectionView *arsenalCollection;

@end
