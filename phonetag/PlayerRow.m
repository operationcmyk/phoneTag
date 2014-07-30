//
//  PlayerRow.m
//  phonetag
//
//  Created by Brandon Phillips on 6/3/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "PlayerRow.h"

@implementation PlayerRow

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.uName.font = [UIFont fontWithName:@"SFArchRival-Italic" size:24];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
