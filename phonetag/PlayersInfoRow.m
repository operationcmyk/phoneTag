//
//  PlayersInfoRow.m
//  phonetag
//
//  Created by Brandon Phillips on 6/6/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "PlayersInfoRow.h"

@implementation PlayersInfoRow

- (void)awakeFromNib
{
    // Initialization code
    self.userName.font = [UIFont fontWithName:@"BadaBoom BB" size:24];
    self.userNameBg.font = [UIFont fontWithName:@"BadaBoom BB" size:24];
    self.playerName.font = [UIFont fontWithName:@"SFArchRival-Italic" size:11];
    self.playerLives.font = [UIFont fontWithName:@"SFArchRival-Italic" size:24];
    self.playerBombs.font = [UIFont fontWithName:@"SFArchRival-Italic" size:24];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
