//
//  ViewController.m
//  phonetag
//
//  Created by Brandon Phillips on 5/28/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "ViewController.h"
#import "Registration.h"
#import "CCAlertView.h"
#import "outlinedLabel.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize gameRow = _gameRow;

- (void)getGames{
    gamesArray = [[NSMutableArray alloc]init];
    completedGamesArray = [[NSMutableArray alloc]init];
    historyChanges = [[NSMutableArray alloc]init];
    NSURL *fullURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.operationcmyk.com/phonetag/phoneTag.php?uid=%@&fn=gameList", staticUserInfo.ptId]];
    NSURLSession *allGamesSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *allGamesTask = [allGamesSession dataTaskWithURL: fullURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *chapterText = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *error = nil;
            
            NSArray *allGamesArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            
            NSArray *historyArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"gamesHistory"];
            
            for (NSDictionary *game in allGamesArray){
                
                // ADD TO ARRAY OF HISTORY CHANGES
                if (historyArray){
                    
                 
                NSArray *gameHistory = [historyArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(id == %@)", [game objectForKey:@"id"]]];
                   if(gameHistory.count != 0){
                    
                NSDictionary *historyDictionary = [gameHistory objectAtIndex:0];
                
                NSString *hString =[historyDictionary objectForKey:@"players"];
                NSData *hData = [hString dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *hArray = [NSJSONSerialization JSONObjectWithData: hData options: NSJSONReadingMutableContainers error: &error];
                NSMutableArray *hChanges = [[NSMutableArray alloc]init];
                for (NSDictionary *h in hArray){
                    [hChanges addObject:[h objectForKey:@"lives"]];
                }
                
                NSString *gString =[game objectForKey:@"players"];
                NSData *gData = [gString dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *gArray = [NSJSONSerialization JSONObjectWithData: gData options: NSJSONReadingMutableContainers error: &error];
                NSMutableArray *gChanges = [[NSMutableArray alloc]init];
                for (NSDictionary *g in gArray){
                    [gChanges addObject:[g objectForKey:@"lives"]];
                }
                
                if (![gChanges isEqualToArray:hChanges]){
                    [historyChanges addObject:[game objectForKey:@"id"]];
                }
                    
                }
                
                // COMPLETED VS. IN PROGRESSS
                if ([[game objectForKey:@"winner"] intValue] == 0){
                    [gamesArray addObject:game];
                }else{
                    [completedGamesArray addObject:game];
                }
                }
            }
        
            [[NSUserDefaults standardUserDefaults]setObject:allGamesArray forKey:@"gamesHistory"];
            
            allGames = [NSArray arrayWithObjects:gamesArray, completedGamesArray, nil];
            
            //NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"started" ascending:NO];
            //gamesArray = [gamesArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort,nil]];
            
            self.listOfGames.delegate = self;
            self.listOfGames.dataSource = self;
            
            [self.listOfGames.tableHeaderView setFrame:CGRectMake(0, 0, 300, 80)];
            
            if (gamesArray.count == 0 && completedGamesArray.count == 0){
                backgroundLogo.hidden = FALSE;
            }else{
                backgroundLogo.hidden = TRUE;
            }
            
            
            [self.listOfGames reloadData];
            [refreshControl endRefreshing];
            
        });
    }];
    
    [allGamesTask resume];
}

- (void)viewDidAppear:(BOOL)animated{
    if (staticUserInfo.ptId){
        [self getGames];
    }else{
        [self performSegueWithIdentifier:@"loginsegue" sender:self];
    }
}

- (IBAction)settings:(id)sender{
    [staticUserInfo logout];
}

- (void)logout{
    [self performSegueWithIdentifier:@"loginsegue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    int footerHeight;
    switch (section) {
        case 0:
            footerHeight = 55;
            break;
        case 1:
            if (completedGamesArray.count > 0){
            footerHeight = 20;
            }else{
                footerHeight = 0;
            }
            break;
            
        default:
            break;
    }
    return footerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 88;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 143)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 280, 88)];
    switch (section) {
        case 0:
            if (gamesArray.count >0){
            [headerImage setImage:[UIImage imageNamed:@"currentGames"]];
            }
            break;
        case 1:
            if (completedGamesArray.count > 0){
            [headerImage setImage:[UIImage imageNamed:@"oldGames"]];
            }
            break;
        default:
            break;
    }
    [headerView addSubview:headerImage];
    
    return headerView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *deletionary = [gamesArray objectAtIndex:indexPath.row];
        NSString *newArray =[deletionary objectForKey:@"players"];
        NSData *data = [newArray dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSArray *gameplayersArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
        NSMutableArray *confirmedPlayers = [[NSMutableArray alloc]init];
        for(NSDictionary *player in gameplayersArray){
            if ([[player objectForKey:@"confirmed"] isEqualToString:@"1"]){
                [confirmedPlayers addObject:player];
            }
        }
        NSString *deleteMessage = @"Do you really want to delete this game?";
        if (confirmedPlayers.count > 1){
            deleteMessage = @"Do you really want to resign from this game?";
        }

        CCAlertView *alert = [[CCAlertView alloc]
                              initWithTitle:@"Submit Game"
                              message:deleteMessage];
        [alert addButtonWithTitle:@"Yes, I'm a quitter" block:^{
            NSString *gameId = [deletionary objectForKey:@"id"];
            [self deleteGame:gameId];
        }];
        [alert addButtonWithTitle:@"Psh, I'm no quitter!" block:NULL];
        [alert show];
        
    }
}

- (void)deleteGame:(NSString *)gid{
    NSString *post = [NSString stringWithFormat: @"gid=%@&uid=%@", gid ,staticUserInfo.ptId];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=deleteGame";
    
    NSMutableURLRequest *deleteGameRequest = [[NSMutableURLRequest alloc] init];
    [deleteGameRequest setURL:[NSURL URLWithString:fullURL]];
    [deleteGameRequest setHTTPMethod:@"POST"];
    [deleteGameRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [deleteGameRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [deleteGameRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *deleteGameSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *deleteGameTask = [deleteGameSession dataTaskWithRequest:deleteGameRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self getGames];
        });
    }];
    
    [deleteGameTask resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[allGames objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return allGames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    gameRow = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (gameRow == nil) {
        gameRow = [[GameListRow alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier ];
    }
    
    for (UIView *subview in gameRow.gameHolder.subviews){
        [subview removeFromSuperview];
    }
    
    gameRow.backgroundColor = [UIColor clearColor];
    
    NSDictionary *item = [[allGames objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([historyChanges containsObject:[item objectForKey:@"id"]]){
        gameRow.changesView.hidden = FALSE;
    }else{
        gameRow.changesView.hidden = TRUE;
    }
    /*UINib *nib = [UINib nibWithNibName:@"GameListRow" bundle:nil];
    [self.listOfGames registerNib:nib forCellReuseIdentifier:@"gamerow"];
    gameRow = [self.listOfGames dequeueReusableCellWithIdentifier:@"gamerow" forIndexPath:indexPath];
    
    //BOOL started = TRUE;
    //gameRow.startInfo.hidden = TRUE;
    
    //float days = 20.0;
    //int daysInSeconds = days * 24 * 60 * 60;
    */
    NSError *error = nil;
    NSString *newArray =[item objectForKey:@"players"];
    NSData *data = [newArray dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *gameplayersArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    
    for (NSDictionary *pInfo in gameplayersArray){
        int pIndex = (int)[gameplayersArray indexOfObject:pInfo];
        
        UIView *PlayerView = [[UIView alloc]initWithFrame:CGRectMake(62*pIndex, 3 + (5*pIndex), 60, 134)];
        if ([[pInfo objectForKey:@"lives"] intValue] == 0){
            PlayerView.alpha = 0.3;
        }else{
            PlayerView.alpha = 1.0;
        }
        outlinedLabel *playerName = [[outlinedLabel alloc]initWithFrame:CGRectMake(-45, 60, 117, 20)];
        UILabel *playerNameBackground = [[UILabel alloc]initWithFrame:CGRectMake(-44, 61, 117, 20)];
        playerName.textAlignment = NSTextAlignmentRight;
        playerNameBackground.textAlignment = NSTextAlignmentRight;
        playerName.text = [pInfo objectForKey:@"username"];
        playerNameBackground.text = [pInfo objectForKey:@"username"];
        playerName.font = [UIFont fontWithName:@"SFArchRival-Italic" size:18];
        playerNameBackground.font = [UIFont fontWithName:@"SFArchRival-Italic" size:18];
        switch (pIndex) {
            case 0:
                playerName.textColor = [UIColor colorWithRed:237.0/255.0 green:25.0/255.0 blue:105.0/255.0 alpha:1.0];
                break;
            case 1:
                playerName.textColor = [UIColor colorWithRed:159.0/255.0 green:204.0/255.0 blue:58.0/255.0 alpha:1.0];
                break;
            case 2:
                playerName.textColor = [UIColor colorWithRed:255.0/255.0 green:198.0/255.0 blue:19.0/255.0 alpha:1.0];
                break;
            case 3:
                playerName.textColor = [UIColor colorWithRed:111.0/255.0 green:84.0/255.0 blue:164.0/255.0 alpha:1.0];
                break;
            case 4:
                playerName.textColor = [UIColor colorWithRed:52.0/255.0 green:103.0/255.0 blue:177.0/255.0 alpha:1.0];
                break;
            default:
                break;
        }
        playerName.transform = CGAffineTransformMakeRotation(M_PI /-2);
        playerNameBackground.transform = CGAffineTransformMakeRotation(M_PI /-2);
        playerNameBackground.textColor = [UIColor blackColor];
        [PlayerView addSubview:playerNameBackground];
        [PlayerView addSubview:playerName];
        int i;
        for (i=0; i<5; i++){
            int liveslost = 5 - [[pInfo objectForKey:@"lives"] intValue];
            if (i < liveslost){
            UIImageView *lifeExplosion = [[UIImageView alloc]initWithFrame:CGRectMake(30, 7+(i*25), 22, 20)];
            [lifeExplosion setImage:[UIImage imageNamed:@"lifelost.png"]];
            [PlayerView addSubview:lifeExplosion];
            }else{
                UIImageView *lifeHeart = [[UIImageView alloc]initWithFrame:CGRectMake(30, 7+(i*25), 22, 20)];
                [lifeHeart setImage:[UIImage imageNamed:[NSString stringWithFormat:@"heart_%d.png", pIndex+1]]];
                [PlayerView addSubview:lifeHeart];
            }
        }
        
        
        
        [gameRow.gameHolder addSubview:PlayerView];

    }
    
    [gameRow.gameCode setTag:indexPath.row];
    gameRow.gameCode.titleLabel.font = [UIFont fontWithName:@"SFArchRival-Italic" size:15];
    [gameRow.gameCode setTitle:[item objectForKey:@"code"] forState:UIControlStateNormal];
    gameRow.gameTitle.font = [UIFont fontWithName:@"SFArchRival-Italic" size:12];
    [gameRow.gameTitle setText:[item objectForKey:@"gamename"]];

    
    return gameRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *game = [[allGames objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *gameId = [game objectForKey:@"id"];
    staticUserInfo.activeGameId = gameId;
    BOOL versionMatch = FALSE;
    NSString *myUpdateStatus = [[NSString alloc]init];
    mismatchedUserIds = [[NSMutableArray alloc]init];
    NSError *error = nil;
    NSMutableArray *mismatchedUserNames = [[NSMutableArray alloc]init];
    NSString *playerArrayString =[game objectForKey:@"players"];
    NSData *data = [playerArrayString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *pArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    for(NSDictionary *player in pArray){
        if ([[player objectForKey:@"version"] floatValue] != [staticUserInfo.ptVersion floatValue]){
            versionMatch = TRUE;
        }
    }
    
    if (versionMatch == FALSE){
    //[[NSUserDefaults standardUserDefaults]setObject:gameId forKey:@"activeGameId"];
    gameBoardView = [[gameBoard alloc]init];
    
    [self performSegueWithIdentifier:@"gameboard" sender:self];
    }else{
        // VERSION MISMATCH
        for (NSDictionary *playerVersion in pArray){
            
            if ([[playerVersion objectForKey:@"version"] floatValue] < [[[NSUserDefaults standardUserDefaults]objectForKey:@"currentVersion"] floatValue] ){
                if([[playerVersion objectForKey:@"playerId"] isEqualToString:staticUserInfo.ptId]){
                    myUpdateStatus = @"You need to update also!";
                }else{
                    [mismatchedUserIds addObject:[playerVersion objectForKey:@"playerId"]];
                    [mismatchedUserNames addObject:[playerVersion objectForKey:@"username"]];
                }
            }
        }
        
        
        
        NSString *usernames = [mismatchedUserNames componentsJoinedByString:@", "];
        NSString *alertMessage = [[NSString alloc]init];
        
        if(mismatchedUserNames.count > 1){
            alertMessage = [NSString stringWithFormat:@"%@ need to update Phone Tag! before you can play %@",usernames, myUpdateStatus ];
        }else{
            alertMessage = [NSString stringWithFormat:@"%@ needs to update Phone Tag! before you can play %@",usernames, myUpdateStatus ];
        }
        UIAlertView *versionAlert = [[UIAlertView alloc] initWithTitle:Nil
                                                            message:alertMessage                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles: @"Tell them to update", nil];
        [versionAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Tell them to update"])
    {
        [self tellUsersToUpgrade];
    }
}

- (void)tellUsersToUpgrade{
    NSString *post = [NSString stringWithFormat: @"name=%@&users=%@", staticUserInfo.ptFullname ,[mismatchedUserIds componentsJoinedByString:@","]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=updatealert";
    
    NSMutableURLRequest *updateUsersRequest = [[NSMutableURLRequest alloc] init];
    [updateUsersRequest setURL:[NSURL URLWithString:fullURL]];
    [updateUsersRequest setHTTPMethod:@"POST"];
    [updateUsersRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [updateUsersRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [updateUsersRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *updateUsersSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *updateUsersTask = [updateUsersSession dataTaskWithRequest:updateUsersRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            //NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
        });
    }];
    
    [updateUsersTask resume];
}

#pragma mark - REGISTRATION CODE

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.tintColor = [UIColor blackColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderWidth = 0.0;
    if (textField.text.length < 1){
        textField.text = @"*";
    }
}

- (IBAction)textFieldDidChange:(id)sender{

    if ([code1 isFirstResponder]){
        if (code1.text.length >= 1){
            [code1 resignFirstResponder];
            [code2 becomeFirstResponder];
        }
    }else if([code2 isFirstResponder]){
        if (code2.text.length >= 1){
            [code2 resignFirstResponder];
            [code3 becomeFirstResponder];
        }
    }else if([code3 isFirstResponder]){
        if (code3.text.length >= 1){
            [code3 resignFirstResponder];
            [code4 becomeFirstResponder];
        }
    }else if([code4 isFirstResponder]){
        if (code4.text.length >= 1){
            [code4 resignFirstResponder];
            [code5 becomeFirstResponder];
        }
    }else if([code5 isFirstResponder]){
        if (code5.text.length >= 1){
            [code5 resignFirstResponder];
            [code6 becomeFirstResponder];
        }
    }else if([code6 isFirstResponder]){
        if (code6.text.length >= 1){
            [code6 resignFirstResponder];
            //[self checkRegistrationCode];
            [code6 resignFirstResponder];
            checkRegistrationButton.hidden = FALSE;
        }
    }else{
        checkRegistrationButton.hidden = TRUE;
    }
}

- (void) resetCode:(NSString *)errorMessage{

    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [self animateLabelShowText:errorMessage characterDelay:0.5];
                   });*/
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:errorMessage forKey:@"string"];
    [dict setObject:@0 forKey:@"currentCount"];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(typingLabel:) userInfo:dict repeats:YES];
    [timer fire];
}

-(void)typingLabel:(NSTimer*)theTimer
{
    NSString *theString = [theTimer.userInfo objectForKey:@"string"];
    int currentCount = [[theTimer.userInfo objectForKey:@"currentCount"] intValue];
    currentCount ++;
    
    [theTimer.userInfo setObject:[NSNumber numberWithInt:currentCount] forKey:@"currentCount"];
    
    if (currentCount > theString.length-1) {
        [theTimer invalidate];
        [code1 setText:@"*"];
        [code2 setText:@"*"];
        [code3 setText:@"*"];
        [code4 setText:@"*"];
        [code5 setText:@"*"];
        [code6 setText:@"*"];
        [code1 becomeFirstResponder];
    }
    
    [codeLabel setText:[theString substringToIndex:currentCount]];
}

- (void)animateLabelShowText:(NSString*)newText characterDelay:(NSTimeInterval)delay
{
    [codeLabel setText:@""];
    
    for (int i=0; i<newText.length; i++)
    {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [codeLabel setText:[NSString stringWithFormat:@"%@%C", codeLabel.text, [newText characterAtIndex:i]]];
                       });
        
        [NSThread sleepForTimeInterval:delay];
    }
}

/*- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}*/

- (void)checkRegistrationCode{
    NSString *completeCode = [NSString stringWithFormat:@"%@%@%@%@%@%@", code1.text, code2.text,code3.text,code4.text,code5.text,code6.text];

    NSString *post = [NSString stringWithFormat: @"id=%@&code=%@", staticUserInfo.ptId ,completeCode];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=addusertogame";
    
    NSMutableURLRequest *addUserRequest = [[NSMutableURLRequest alloc] init];
    [addUserRequest setURL:[NSURL URLWithString:fullURL]];
    [addUserRequest setHTTPMethod:@"POST"];
    [addUserRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [addUserRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [addUserRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *addUserSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *addUserTask = [addUserSession dataTaskWithRequest:addUserRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            switch ([datastring intValue]) {
                case 0: // NO GAME FOUND
                    codeLabel.text = @"We can't locate this game. Try another code?";
                    [self resetCode:@"No Game, Try another?!"];
                    break;
                case 1: // YOU'VE BEEN ADDED
                    [self getGames];
                    break;
                case 2: // THIS GAME IS FULL
                    codeLabel.text = @"Game is full. Try another?!";
                    [self resetCode:@"Game is full. Try another?!"];
                    break;
                case 3: // YOU'RE ALREADY IN THIS GAME
                    codeLabel.text = @"You're already in this game!";
                    [self resetCode:@"You're already in this game!"];
                    break;
                default:
                    break;
            }
            if ([datastring intValue] == 1){
                //USER ADDED

            }else{
 
                //CODE IS INCORRECT
            }
            
        });
    }];
    
    [addUserTask resume];
}

- (IBAction)checkRegistrationCode:(id)sender{
    [self checkRegistrationCode];
}

- (IBAction)joinGame:(id)sender{
        [self openCodeBox];
}

- (IBAction)closeCodeBox:(id)sender{
    [self closeCodeBox];
}

- (void)openCodeBox{
    [code1 becomeFirstResponder];
    coverall.hidden = FALSE;
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [codeInputBox setFrame:CGRectMake(0, 0, codeInputBox.frame.size.width, codeInputBox.frame.size.height)];
                         [startGameBox setFrame:CGRectMake(0, -startGameBox.frame.size.height, startGameBox.frame.size.width, startGameBox.frame.size.height)];
                         [startButton setFrame:CGRectMake(10, -startGameBox.frame.size.height, startGameBox.frame.size.width, startButton.frame.size.height)];
                         [joinButton setFrame:CGRectMake(screenWidth +joinButton.frame.size.width, joinButton.frame.origin.y, joinButton.frame.size.width, joinButton.frame.size.height)];
                         coverall.alpha = 0.8;
                     }completion:^(BOOL finished){
                         codeInputBoxOpen = YES;
                         
                     }];
}

- (void)closeCodeBoxKeyboard{
    [code1 resignFirstResponder];
    [code2 resignFirstResponder];
    [code3 resignFirstResponder];
    [code4 resignFirstResponder];
    [code5 resignFirstResponder];
    [code6 resignFirstResponder];
}

- (void)closeCodeBox{
    [self closeCodeBoxKeyboard];
    checkRegistrationButton.hidden = TRUE;
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [codeInputBox setFrame:CGRectMake(0, -codeInputBox.frame.size.height +165, codeInputBox.frame.size.width, codeInputBox.frame.size.height)];
                         [startGameBox setFrame:CGRectMake(0, 0, startGameBox.frame.size.width, startGameBox.frame.size.height)];
                         [startButton setFrame:CGRectMake(10, 29, startButton.frame.size.width, startButton.frame.size.height)];
                         [joinButton setFrame:CGRectMake(screenWidth - (joinButton.frame.size.width) + 10, codeInputBox.frame.size.height - joinButton.frame.size.height - 63, joinButton.frame.size.width, joinButton.frame.size.height)];
                         coverall.alpha = 0.0;
                     }completion:^(BOOL finished){
                         codeInputBoxOpen = NO;
                         coverall.hidden = TRUE;
                     }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"separatorLogo.png"]];
    [self.listOfGames setSeparatorColor:color];
    self.listOfGames.separatorInset=UIEdgeInsetsMake(0, 0, 30, 0);
    
    // CHECK FOR FONTS:
    
    /*for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }*/

    
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getGames)
             forControlEvents:UIControlEventValueChanged];
    [refreshControl setTintColor:[UIColor whiteColor]];
    [self.listOfGames addSubview:refreshControl];
    
    codeLabel.font = [UIFont fontWithName:@"SFArchRival-Italic" size:24];
    
    code1.tag = 1;
    code2.tag = 2;
    code3.tag = 3;
    code3.tag = 4;
    code4.tag = 5;
    code5.tag = 6;
    
    code1.font = [UIFont fontWithName:@"SFArchRival-Italic" size:46];
    code2.font = [UIFont fontWithName:@"SFArchRival-Italic" size:46];
    code3.font = [UIFont fontWithName:@"SFArchRival-Italic" size:46];
    code4.font = [UIFont fontWithName:@"SFArchRival-Italic" size:46];
    code5.font = [UIFont fontWithName:@"SFArchRival-Italic" size:46];
    code6.font = [UIFont fontWithName:@"SFArchRival-Italic" size:46];
    
    [code1 addTarget:self
           action:@selector(textFieldDidChange:)
           forControlEvents:UIControlEventEditingChanged];
    [code2 addTarget:self
              action:@selector(textFieldDidChange:)
    forControlEvents:UIControlEventEditingChanged];
    [code3 addTarget:self
              action:@selector(textFieldDidChange:)
    forControlEvents:UIControlEventEditingChanged];
    [code4 addTarget:self
              action:@selector(textFieldDidChange:)
    forControlEvents:UIControlEventEditingChanged];
    [code5 addTarget:self
              action:@selector(textFieldDidChange:)
    forControlEvents:UIControlEventEditingChanged];
    [code6 addTarget:self
              action:@selector(textFieldDidChange:)
    forControlEvents:UIControlEventEditingChanged];
    cLocationManager = [[CLLocationManager alloc] init];
    
    cLocationManager.delegate = self;
    
    cLocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    
    cLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
   // NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(bgTimerCalled) userInfo:nil repeats:YES];

    
    //FBLoginView *loginView =
    //[[FBLoginView alloc] initWithReadPermissions:
    // @[@"public_profile", @"email", @"user_friends"]];
    //loginView.frame = CGRectMake(20, 100, 280, 30);
    //[self.view addSubview:loginView];
    
    staticUserInfo = [PTStaticInfo sharedManager];
    self.listOfGames.backgroundColor = [UIColor clearColor];
    if (!staticUserInfo.ptId){
        //PUSH TO REGISTRATION OR LOGIN VIEW
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout)
                                                 name:@"logout" object:nil];

	// Do any additional setup after loading the view, typically from a nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)textCode:(id)sender{
    
    int arrayIndex = (int)[sender tag];
    NSDictionary *item = [gamesArray objectAtIndex: arrayIndex];
    [self sendSMS: [NSString stringWithFormat:@"Join my game of Phone Tag! Enter the game code: %@", [item objectForKey:@"code"]] recipientList:nil];
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    
    if (result == MessageComposeResultCancelled){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (result == MessageComposeResultSent){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager

    didUpdateToLocation:(CLLocation *)newLocation

           fromLocation:(CLLocation *)oldLocation

{
    
    NSString *lati = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.latitude];
    NSString *longi = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.longitude];
    [cLocationManager stopUpdatingLocation];
    
    NSString *post = [NSString stringWithFormat: @"id=%@&lat=%@&longi=%@", staticUserInfo.ptId, lati, longi];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=updateLocation";
    
    NSMutableURLRequest *registerRequest = [[NSMutableURLRequest alloc] init];
    [registerRequest setURL:[NSURL URLWithString:fullURL]];
    [registerRequest setHTTPMethod:@"POST"];
    [registerRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [registerRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [registerRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *registerSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *registerTask = [registerSession dataTaskWithRequest:registerRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            //NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        });
    }];
    
    [registerTask resume];
    
    
}

-(void)bgTimerCalled
{
    [cLocationManager startUpdatingLocation];
}

@end
