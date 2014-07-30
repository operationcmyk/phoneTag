//
//  PlayersInfoRow.h
//  phonetag
//
//  Created by Brandon Phillips on 6/6/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayersInfoRow : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *playerImage;
@property (nonatomic, strong) IBOutlet UILabel *playerName;
@property (nonatomic, strong) IBOutlet UILabel *userNameBg;
@property (nonatomic, strong) IBOutlet UILabel *userName;
@property (nonatomic, strong) IBOutlet UILabel *playerLives;
@property (nonatomic, strong) IBOutlet UILabel *playerBombs;
@property (nonatomic, strong) IBOutlet UIImageView *bombView;
@property (nonatomic, strong) IBOutlet UIImageView *livesView;


@end
