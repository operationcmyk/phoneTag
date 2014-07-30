//
//  purchaseItem.h
//  phonetag
//
//  Created by Brandon Phillips on 7/25/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "AppDelegate.h"

@interface purchaseItem : NSObject<SKPaymentTransactionObserver, SKProductsRequestDelegate, NSURLSessionDelegate>{
    AppDelegate *appDel;
    PTStaticInfo *staticUserInfo;
    NSMutableArray *transactionArray;
}

@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) NSString *databaseId;
@property (strong, nonatomic) NSString *itemQuantity;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UITextView *productDescription;

- (void)buyItem: (NSString *)itemId dbId: (NSString *)dbId itemQ: (NSString *)quantity user: (NSString *)uid;

@end
