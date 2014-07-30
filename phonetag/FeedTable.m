//
//  FeedTable.m
//  phonetag
//
//  Created by Brandon Phillips on 7/16/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "FeedTable.h"

@interface FeedTable ()

@end

@implementation FeedTable

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadFeedForGame: (NSString *)gid andUser: (NSString *)uid{
    NSString *post = [NSString stringWithFormat: @"gid=%@&uid=%@", gid, uid];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=getFeed";
    
    NSMutableURLRequest *dropBombRequest = [[NSMutableURLRequest alloc] init];
    [dropBombRequest setURL:[NSURL URLWithString:fullURL]];
    [dropBombRequest setHTTPMethod:@"POST"];
    [dropBombRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [dropBombRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [dropBombRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *dropBombSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dropBombTask = [dropBombSession dataTaskWithRequest:dropBombRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            feedArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            if (feedArray.count > 0){
                NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
                feedArray = [feedArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort,nil]];
                [self.tableView reloadData];
            }
        });
    }];
    
    [dropBombTask resume];
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
    return feedArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UINib *nib = [UINib nibWithNibName:@"FeedRow" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"feed"];
    fRow = [tableView dequeueReusableCellWithIdentifier:@"feed" forIndexPath:indexPath];
    NSDictionary *feedItem = [feedArray objectAtIndex:indexPath.row];
    //fRow.feedMessage.text = [feedItem objectForKey:@"message"];
    if (indexPath.row == 0){
        NSLog(@"frow y: %f", fRow.feedWebView.frame.origin.y);
    }
    [fRow.feedWebView loadHTMLString:[feedItem objectForKey:@"html"] baseURL:nil];
    fRow.feedWebView.userInteractionEnabled = false;
    
    return fRow;
}

/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSArray *indexpaths = [self.tableView indexPathsForVisibleRows];
    for( NSUInteger index =0; index < indexpaths.count; index++ )
    {
        
        FeedRow *cell = (FeedRow*)[self.tableView cellForRowAtIndexPath:[ indexpaths objectAtIndex:index]];
        float rowYposition = self.tableView.frame.size.height - cell.frame.origin.y;
        NSLog(@"index path: %d and position: %f", (int)index, cell.frame.origin.y);
        [cell.feedMessage setFrame:CGRectMake(rowYposition *.4 , cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    }
}*/



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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
