//
//  FeedRow.m
//  phonetag
//
//  Created by Brandon Phillips on 7/16/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "FeedRow.h"

@implementation FeedRow

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.feedMessage.font = [UIFont fontWithName:@"SFArchRival-Italic" size:13];
    self.feedWebView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews
{
    [super layoutSubviews];

        //float rowYposition = self.frame.origin.y;
        //NSLog(@"index path: %d and position: %f", (int)index, self.frame.origin.y);
        //[self.feedWebView setFrame:CGRectMake(rowYposition *.4 , self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    
}

@end
