//
//  PlayerArsenalCell.h
//  phonetag
//
//  Created by Brandon Phillips on 7/21/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerArsenalCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *itemImage;
@property (nonatomic, strong) IBOutlet UILabel *itemName;
@property (nonatomic, strong) IBOutlet UILabel *itemCount;
@property (nonatomic, strong) IBOutlet UILabel *itemx;
@property (nonatomic, strong) NSString *itemAppleId;

@end
