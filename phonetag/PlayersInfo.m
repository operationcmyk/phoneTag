//
//  PlayersInfo.m
//  phonetag
//
//  Created by Brandon Phillips on 7/17/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "PlayersInfo.h"
#import "outlinedLabel.h"

@interface PlayersInfo ()

@end

@implementation PlayersInfo

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.playersArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"PlayersInfoRow" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"pirow"];
    pRow = [self.tableView dequeueReusableCellWithIdentifier:@"pirow" forIndexPath:indexPath];
    NSDictionary *item = [self.playersArray objectAtIndex:indexPath.row];
    NSLog(@"players array: %@", self.playersArray);
    
    if ([[item objectForKey:@"alive"] intValue] == 1){
    }else{
    }
    switch (indexPath.row) {
        case 0:
            pRow.userName.textColor = [UIColor colorWithRed:237.0/255.0 green:25.0/255.0 blue:105.0/255.0 alpha:1.0];
            break;
        case 1:
            pRow.userName.textColor = [UIColor colorWithRed:159.0/255.0 green:204.0/255.0 blue:58.0/255.0 alpha:1.0];
            break;
        case 2:
            pRow.userName.textColor = [UIColor colorWithRed:255.0/255.0 green:198.0/255.0 blue:19.0/255.0 alpha:1.0];
            break;
        case 3:
            pRow.userName.textColor = [UIColor colorWithRed:111.0/255.0 green:84.0/255.0 blue:164.0/255.0 alpha:1.0];
            break;
        case 4:
            pRow.userName.textColor = [UIColor colorWithRed:52.0/255.0 green:103.0/255.0 blue:177.0/255.0 alpha:1.0];
            break;
        default:
            break;
    }
    pRow.bombView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bombsX_%d", (int)indexPath.row +1]];
    pRow.livesView.image = [UIImage imageNamed:[NSString stringWithFormat:@"livesX_%d", (int)indexPath.row +1]];
    pRow.userName.text = [item objectForKey:@"username"];
    pRow.userNameBg.text = [item objectForKey:@"username"];
    pRow.playerName.text = [item objectForKey:@"fullname"];
    pRow.playerLives.text = [item objectForKey:@"lives"];
    pRow.playerBombs.text = [item objectForKey:@"bombs"];
    //pRow.userName.text = [item objectForKey:@"nameString"];
    
    //NSLog(@"item: %@", item);
    return pRow;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *player = [self.playersArray objectAtIndex:indexPath.row];
}


@end
