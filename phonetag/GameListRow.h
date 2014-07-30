//
//  GameListRow.h
//  phonetag
//
//  Created by Brandon Phillips on 5/28/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameListRow : UITableViewCell{
    
    
}

@property (nonatomic, weak) IBOutlet UILabel *startTimer;
@property (nonatomic, weak) IBOutlet UIButton *gameCode;
@property (nonatomic, weak) IBOutlet UIView *startInfo;
@property (nonatomic, weak) IBOutlet UIView *gameHolder;
@property (nonatomic, weak) IBOutlet UIView *changesView;
@property (nonatomic, weak) IBOutlet UILabel *gameTitle;

- (IBAction)textCode:(id)sender;


@end
