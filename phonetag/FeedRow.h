//
//  FeedRow.h
//  phonetag
//
//  Created by Brandon Phillips on 7/16/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedRow : UITableViewCell<UIWebViewDelegate>{
}

@property (nonatomic, strong) IBOutlet UILabel *feedMessage;
@property (nonatomic, strong) IBOutlet UIWebView *feedWebView;

@end
