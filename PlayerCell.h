//
//  PlayerCell.h
//  phonetag
//
//  Created by Brandon Phillips on 7/8/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *username;
@property (nonatomic, strong) IBOutlet UILabel *usernamebg;
@property (nonatomic, strong) IBOutlet UILabel *fullname;
@property (nonatomic, strong) IBOutlet UILabel *status;
@property (nonatomic, strong) IBOutlet UIImageView *uImage;

@end
