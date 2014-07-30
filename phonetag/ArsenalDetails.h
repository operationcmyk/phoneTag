//
//  ArsenalDetails.h
//  phonetag
//
//  Created by Brandon Phillips on 7/22/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseItem.h"
#import "PTStaticInfo.h"

@interface ArsenalDetails : UIViewController{
    
    purchaseItem *purchase;
    PTStaticInfo *staticUserInfo;
    
    IBOutlet UIView *detailsBox;
    NSString *currentItemDBId;
    NSString *currentItemAppId;
    NSString *currentQuantity;
}

@property (nonatomic, strong) IBOutlet UIImageView *arsenalImage;
@property (nonatomic, strong) IBOutlet UITextView *arsenalText;
@property (nonatomic, strong) IBOutlet UILabel *arsenalName;
@property (nonatomic, strong) IBOutlet UILabel *arsenalNameBg;
@property (nonatomic, strong) IBOutlet UILabel *arsenalBuyMessage;
@property (nonatomic, strong) IBOutlet UILabel *arsenalBuyMessageBg;
@property (nonatomic, strong) IBOutlet UIButton *arsenalBuyButton;

- (void)buildArsenalInfo: (int)aId;

@end
