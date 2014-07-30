//
//  ArsenalRow.h
//  phonetag
//
//  Created by Brandon Phillips on 6/5/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "PurchaseItems.h"

@interface ArsenalRow : UITableViewCell{
    PurchaseItems *purchaseItem;
}

- (void)setBuyButton: (NSString *)itemId;

@property (nonatomic, strong) IBOutlet UIImageView *itemImage;
@property (nonatomic, strong) IBOutlet UILabel *itemName;
@property (nonatomic, strong) IBOutlet UILabel *itemCount;
@property (nonatomic, strong) NSString *itemAppleId;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *itemQuantity;
@property (nonatomic, strong) NSString *userid;


- (IBAction)buyItem:(id)sender;

@end
