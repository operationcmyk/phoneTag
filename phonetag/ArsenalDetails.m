//
//  ArsenalDetails.m
//  phonetag
//
//  Created by Brandon Phillips on 7/22/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "ArsenalDetails.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface ArsenalDetails ()

@end

@implementation ArsenalDetails

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    staticUserInfo = [PTStaticInfo sharedManager];
    
    [self.arsenalBuyMessage setFont: [UIFont fontWithName:@"SFArchRival-Italic" size:20]];
    [self.arsenalBuyMessageBg setFont: [UIFont fontWithName:@"SFArchRival-Italic" size:20]];
    [self.arsenalName setFont: [UIFont fontWithName:@"BadaBoom BB" size:24]];
    [self.arsenalNameBg setFont: [UIFont fontWithName:@"BadaBoom BB" size:24]];
    
    detailsBox.transform = CGAffineTransformMakeRotation(M_PI*.07);
    // Do any additional setup after loading the view from its nib.
}

- (void)buildArsenalInfo: (int)aId{
    NSDictionary *item = [[NSDictionary alloc]init];
    for (NSDictionary *aItem in mainArsenalArray){
        if ([[aItem objectForKey:@"id"] intValue] == aId){
            item = aItem;
        }
    }
    NSLog(@"item: %@", item);
    currentItemAppId = [item objectForKey:@"appleId"]; // APPLE ID
    currentItemDBId = [item objectForKey:@"id"]; //CURRENT DB ID
    currentQuantity = [item objectForKey:@"quantity"];
    
    
    [self.arsenalImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.operationcmyk.com/phonetag/arsenalImages/%@_arsenal.png", [item objectForKey:@"id"]]]placeholderImage:nil
                                   options:0
                                  progress:nil
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                 }];
    [self.arsenalText setText:[item objectForKey:@"info"]];
    [self.arsenalName setText:[item objectForKey:@"name"]];
    [self.arsenalNameBg setText:[item objectForKey:@"name"]];
    self.arsenalText.font = [UIFont fontWithName:@"SFArchRival-Italic" size:11];
    self.arsenalText.textAlignment = NSTextAlignmentCenter;
    
    NSString *buyMessage = [NSString stringWithFormat:@"Buy %@ for $%@", [item objectForKey:@"quantity"], [item objectForKey:@"price"]];
    [self.arsenalBuyMessage setText:buyMessage];
    [self.arsenalBuyMessageBg setText:buyMessage];
    [self.arsenalBuyButton addTarget:self
                                  action:@selector(buyItem:)
                        forControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)buyItem:(id)sender{
    
    [self makePurchase];
}

- (void)makePurchase{
    purchase = [[purchaseItem alloc]init];
    [purchase buyItem:currentItemAppId dbId:currentItemDBId itemQ:currentQuantity user:staticUserInfo.ptId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
