//
//  Arsenal.m
//  phonetag
//
//  Created by Christopher on 5/28/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "Arsenal.h"
#import "UIImageView+WebCache.h"
#import "outlinedLabel.h"

@interface Arsenal ()

@end

@implementation Arsenal

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)closeOut:(id)sender {
    
    if (itemBoxIsOpen == TRUE){
        arsenalInfoBox.hidden = TRUE;
        itemBoxIsOpen = FALSE;
    }else{
        [self dismissViewControllerAnimated:YES completion:^(){}];
    }
}

- (void)reloadCollectionView{
    [self.arsenalCollectionView reloadData];
    [self.arsenalTableView reloadData];
}
    
- (void)viewDidLoad
{
    [super viewDidLoad];

    itemBoxIsOpen = false;
    
    self.arsenalTableView.backgroundColor = [UIColor clearColor];
    self.arsenalCollectionView.backgroundColor = [UIColor clearColor];
    self.arsenalCollectionView.transform = CGAffineTransformMakeRotation(M_PI*.01);
    
    aDetails = [[ArsenalDetails alloc]initWithNibName:@"ArsenalDetails" bundle:nil];
    appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadCollectionView)
                                                 name:@"arsenalRefresh" object:nil];
    
    staticUserInfo = [PTStaticInfo sharedManager];
    
    [self getUserArsenal];
    [self setNeedsStatusBarAppearanceUpdate];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (IBAction)restoreAllPurchases:(id)sender{
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
}

- (void)getUserArsenal{
    [appDel refreshArsenal];
}

#pragma mark - COLLECTION VIEW


- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [arsenalArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSArray *buildArray;
    NSLog(@"here");
    static NSString *identifier = @"acell";
    aCell = (PlayerArsenalCell *)[self.arsenalCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSMutableDictionary *item = [arsenalArray objectAtIndex:indexPath.row];

        //aCell.itemName.text = [item objectForKey:@"name"];
    
    for(NSDictionary *bomb in [item objectForKey:@"bomb"]){
        NSLog(@"bomb: %@", bomb);
    }
    NSDictionary *bomb = [[item objectForKey:@"bomb"] objectAtIndex:0];
        aCell.itemName.text = [bomb objectForKey:@"name"];
        aCell.itemCount.text = [item objectForKey:@"count"];
    [aCell.itemCount setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:16]];
    [aCell.itemx setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:11]];
        [aCell.itemImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.operationcmyk.com/phonetag/arsenalImages/%@_arsenal.png", [item objectForKey:@"id"]]]placeholderImage:nil
     options:0
     progress:nil
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
     
     }];
    
    return aCell;
}

-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = [arsenalArray objectAtIndex:indexPath.row];
    int aId = [[item objectForKey:@"id"] intValue];
    [self showArsenalDetails: aId];
}

#pragma mark - TABLE VIEW

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 175;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 175)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(23, 40, 275, 105)];
    [headerView addSubview:headerImage];
    [headerImage setImage:[UIImage imageNamed:@"addtoarsenal"]];
    
    return headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainArsenalArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    aRow = [self.arsenalTableView dequeueReusableCellWithIdentifier:@"arow" forIndexPath:indexPath];
    
    NSDictionary *item = [mainArsenalArray objectAtIndex:indexPath.row];
    
    aRow.itemName.text = [item objectForKey:@"name"];
    aRow.itemCount.text = [item objectForKey:@"quantity"];
    aRow.itemQuantity = [item objectForKey:@"quantity"];
    aRow.itemId = [item objectForKey:@"id"];
    aRow.userid = staticUserInfo.ptId;
    [aRow.itemImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.operationcmyk.com/phonetag/arsenalImages/%@_arsenal.png", [item objectForKey:@"id"]]]placeholderImage:nil
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                        }];
    [aRow setBuyButton:[item objectForKey:@"appleId"]];
    //NSLog(@"item: %@", item);
    return aRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [mainArsenalArray objectAtIndex:indexPath.row];
    int aId = [[item objectForKey:@"id"] intValue];
    [self showArsenalDetails:aId];
}

- (void)showArsenalDetails:(int)aId{

    [aDetails.view removeFromSuperview];
    [arsenalInfoBox addSubview:aDetails.view];
    [aDetails buildArsenalInfo:(int)aId];
    itemBoxIsOpen = true;
    arsenalInfoBox.hidden = FALSE;
}

- (IBAction)closeUserArsenalInfoBox:(id)sender{
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
