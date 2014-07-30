//
//  ArsenalRow.m
//  phonetag
//
//  Created by Brandon Phillips on 6/5/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "ArsenalRow.h"


@implementation ArsenalRow

- (void)awakeFromNib
{
    // Initialization code
    self.itemName.font = [UIFont fontWithName:@"BadaBoom BB" size:27];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setBuyButton:(NSString *)itemId{
    self.itemAppleId = itemId;
    
}

- (IBAction)buyItem:(id)sender{
    purchaseItem = [[PurchaseItems alloc]init];
    [[SKPaymentQueue defaultQueue]
     addTransactionObserver:purchaseItem];
    [purchaseItem buyItem:self.itemAppleId dbId: self.itemId itemQ:self.itemQuantity user:self.userid];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
