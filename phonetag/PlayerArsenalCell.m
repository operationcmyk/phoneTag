//
//  PlayerArsenalCell.m
//  phonetag
//
//  Created by Brandon Phillips on 7/21/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "PlayerArsenalCell.h"

@implementation PlayerArsenalCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self.itemCount setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:16]];
        [self.itemx setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:16]];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
