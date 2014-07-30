//
//  StartGame.m
//  phonetag
//
//  Created by Brandon Phillips on 6/2/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "StartGame.h"
#import "UIImageView+WebCache.h"
#import "CCAlertView.h"


@interface StartGame ()

@end

@implementation StartGame

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)getFriendsList:(id)sender{
    [self listSwitch:1];
}

- (IBAction)facebookFriends:(id)sender
{
    [self listSwitch:2];
    /*
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }*/
}

- (IBAction)getRecentList:(id)sender{
    [self listSwitch:3];
}

- (void)cancelNewGame:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(34) % [letters length]]];
    }
    
    return randomString;
}

- (void)viewDidAppear:(BOOL)animated{
    addedUsers = [[NSMutableArray alloc]init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    gameNameField.font = [UIFont fontWithName:@"SFArchRival-Italic" size:30];
    gameNameField.tintColor = [UIColor blackColor];
    
    UIImageView *pOne = [[UIImageView alloc]initWithFrame:CGRectMake(32, 26, 32, 45)];
        [pOne setImage:[UIImage imageNamed:@"player_1.png"]];
    UIImageView *pTwo = [[UIImageView alloc]initWithFrame:CGRectMake(180, 17, 32, 45)];
        [pTwo setImage:[UIImage imageNamed:@"player_2.png"]];
    UIImageView *pThree = [[UIImageView alloc]initWithFrame:CGRectMake(64, 90, 32, 45)];
        [pThree setImage:[UIImage imageNamed:@"player_3.png"]];
    UIImageView *pFour = [[UIImageView alloc]initWithFrame:CGRectMake(210, 92, 32, 45)];
        [pFour setImage:[UIImage imageNamed:@"player_4.png"]];
    
    arrayOfNumbers = [[NSArray alloc]initWithObjects:pFour, pThree, pTwo, pOne, nil];
    
    for (UIImageView *numberImage in arrayOfNumbers){
        [numberHolder addSubview:numberImage];
    }

    
    UIImageView *tablebg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBackgroundSolid.png"]];
    [tablebg setFrame:self.playersTableView.frame];
    self.playersTableView.backgroundView = tablebg;
    self.playersTableView.backgroundColor = [UIColor clearColor];

    self.playersCollectionView.backgroundColor = [UIColor clearColor];
    self.playersArray = [[NSMutableArray alloc]init];

    staticUserInfo = [PTStaticInfo sharedManager];

    [self setupPlayersCollectionView];
    [self listSwitch:1];
    
    self.playersCollectionView.backgroundColor = [UIColor clearColor];
    
    gameUserPhoneNumbers = [[NSMutableArray alloc]init];
    gameUserIds = [[NSMutableArray alloc]init];

    gameRegistrationNumber = [self randomStringWithLength:6];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)listSwitch: (int)listType{
    
    [friendsButton setImage:[UIImage imageNamed:@"friendsOff.png"] forState:UIControlStateNormal];
    [facebookButton setImage:[UIImage imageNamed:@"fbOff.png"] forState:UIControlStateNormal];
    [recentButton setImage:[UIImage imageNamed:@"recentOff.png"] forState:UIControlStateNormal];
    tableLoader.hidden = FALSE;
    self.currentList = [[NSMutableArray alloc]init];
    switch (listType) {
        case 1:
            NSLog(@"friends!");
            [friendsButton setImage:[UIImage imageNamed:@"friendsOn.png"] forState:UIControlStateNormal];
            [self loadAddressBook];
            break;
        case 2:
            NSLog(@"facebook!");
            [facebookButton setImage:[UIImage imageNamed:@"fbOn.png"] forState:UIControlStateNormal];
            break;
        case 3:
            NSLog(@"recent!");
            [recentButton setImage:[UIImage imageNamed:@"recentOn.png"] forState:UIControlStateNormal];
            [self getRecentPlayers];
            break;
            
        default:
            break;
    }
}

- (void)getRecentPlayers{
    NSString *post = [NSString stringWithFormat: @"uid=%@", staticUserInfo.ptId];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=getRecentFriends"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *getRecentsSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *getRecentsTask = [getRecentsSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSArray *recentsArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            for (NSDictionary *recentItem in recentsArray){
                NSArray *allEmails = [NSArray arrayWithObjects:[recentItem objectForKey:@"email"], nil];
                NSDictionary *userDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                       //contactImageData, @"imageData",
                            @"", @"initials",
                            [recentItem objectForKey:@"name"], @"nameString",
                            @"", @"phoneNumber",
                            @"no", @"mobileCheck",
                            allEmails, @"emailArray",
                            @"1", @"checked",
                            [recentItem objectForKey:@"username"], @"username",
                            [recentItem objectForKey:@"id"], @"id",
                            nil];
                if (self.playersArray.count > 0){
                    if ([self.playersArray containsObject:userDictionary]){
                        
                    }else{
                        [self.currentList addObject:userDictionary];
                    }
                }else{
                    [self.currentList addObject:userDictionary];
                }
            }
            [self.playersTableView reloadData];
            tableLoader.hidden = TRUE;
            
            NSLog(@"string: %@, array: %@", dataString, self.currentList);
        });
    }];
    
    [getRecentsTask resume];
}

- (void)setupPlayersCollectionView{
    
}

-(void)loadAddressBook{
    
    //allPhoneNumbersString = [[NSString alloc]init];
    NSMutableSet *unifiedRecordsSet = [NSMutableSet set];
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef records = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    for (CFIndex i = 0; i < CFArrayGetCount(records); i++)
    {
        NSMutableSet *contactSet = [NSMutableSet set];
        
        ABRecordRef record = CFArrayGetValueAtIndex(records, i);
        [contactSet addObject:(__bridge id)record];
        
        NSArray *linkedRecordsArray = (__bridge NSArray *)ABPersonCopyArrayOfAllLinkedPeople(record);
        [contactSet addObjectsFromArray:linkedRecordsArray];
        
        // Your own custom "unified record" class (or just an NSSet!)
        NSSet *unifiedRecord = [[NSSet alloc] initWithSet:contactSet];
        
        [unifiedRecordsSet addObject:unifiedRecord];
        CFRelease(record);
    }
    
    //CFRelease(records);
    //CFRelease(addressBookRef);
    
    //userArray = [[NSMutableArray alloc]initWithArray:[unifiedRecordsSet allObjects]];
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            //  CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBookRef );
            CFIndex nPeople = ABAddressBookGetPersonCount( addressBookRef );
            
            for ( int i = 0; i < nPeople; i++ )
            {
                // ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
                
                
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        
        for (NSSet* contact in unifiedRecordsSet){
            int checked= 0;
            [contact enumerateObjectsUsingBlock:^(id addy, BOOL *stop) {
                ABRecordRef record = (__bridge ABRecordRef)(addy);
                ABMultiValueRef phoneNumberMultiValue = ABRecordCopyValue(record, kABPersonPhoneProperty);
                int count = (int)ABMultiValueGetCount(phoneNumberMultiValue);
                if(count>0){
                    [self getAddressBookRecord:record];
                    CFRelease(record);
                    *stop = YES;
                }
            }];
            
        }
        if (self.playersArray.count > 0){
            for (NSDictionary *user in self.playersArray){
                if ([self.currentList containsObject:user]){
                    [self.currentList removeObjectIdenticalTo:user];
                }
            }
        }
        [self.playersTableView reloadData];
        tableLoader.hidden = TRUE;
        //[[NSUserDefaults standardUserDefaults] setObject:allPhoneNumbersString forKey:@"allNumbersString"];
        
    }else{
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:Nil
                                                          message:@"We need access to your address book to move foward. Please allow access in your privacy settings and come back!"
                                                         delegate:self
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles: nil];
        [message show];
    }
    
}

-(void)getAddressBookRecord:(ABRecordRef)ref{
    
    if(ABRecordGetRecordType(ref) ==  kABPersonType) // this check execute if it is person group
    {
        //NSString *number = [NSString stringWithFormat:@"%@",registerNumber.text];
        NSString *resultString = [[NSString alloc]init];
        NSString *firstThreeNumbers = [[NSString alloc]init];
        NSMutableArray *phoneNumberArray = [[NSMutableArray alloc]init];
        NSString *initials = [[NSString alloc]init];
        NSString *phoneNumber = [[NSString alloc]init];
        // ABRecordID recordId = ABRecordGetRecordID(ref); // get record id from address book record
        // NSString *recordIdString = [NSString stringWithFormat:@"%d",recordId]; // get record id string from record id
        NSMutableArray *allEmails = [[NSMutableArray alloc]init];
        ABMultiValueRef emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
            NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
            [allEmails addObject:email];
            //[email release];
        }
        CFRelease(emails);
        
    
        NSString *firstNameString = (__bridge NSString*)ABRecordCopyValue(ref,kABPersonFirstNameProperty); // fetch contact first name from address book
        NSString *lastNameString = [[NSString alloc]init];
        lastNameString = (__bridge NSString*)ABRecordCopyValue(ref,kABPersonLastNameProperty); // fetch contact last name from address book
        //NSString *contactEmail = (__bridge NSString*)ABRecordCopyValue(record,kABPersonEmailProperty); // fetch contact last name from address book
        if (lastNameString.length > 0){
            
        }else{
            lastNameString = @"";
        }
        
        
        // NSString * fullName = [NSString stringWithFormat:@"%@ %@", firstNameString, lastNameString];
        
        
        
        //Get Persons Image
        //NSData *contactImageData = [[NSData alloc]init];
        //if(ABPersonHasImageData(ref)) {
        //    contactImageData = (__bridge NSData*) ABPersonCopyImageDataWithFormat(ref,kABPersonImageFormatThumbnail);
        //}else{
            NSString * lastLetter = [[NSString alloc]init];
            NSString * firstLetter = [firstNameString substringToIndex:1];
            if(lastNameString.length > 0){
                lastLetter = [lastNameString substringToIndex:1];
            }else{
                lastLetter = @"";
            }
            
            if (firstLetter != nil && lastLetter != nil){
                initials = [[NSString alloc]initWithFormat:@"%@%@",firstLetter,lastLetter];
            }else if(firstLetter != nil && lastLetter == nil){
                initials = [[NSString alloc]initWithString:firstLetter];
            }else if(lastLetter != nil && firstLetter == nil){
                firstNameString = @"";
                initials = [[NSString alloc]initWithString:lastLetter];
            }else{
                initials = @"";
            }
            
        //}
        UIImageView *cover = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [cover setImage:[UIImage imageNamed:@"User_Free.png"]];
        NSString *mobileCheck = [[NSString alloc]init];
        NSString *mobileLabel = [[NSString alloc]init];
        ABMultiValueRef phoneNumberMultiValue = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        NSUInteger phoneNumberIndex;
        for (phoneNumberIndex = 0; phoneNumberIndex < ABMultiValueGetCount(phoneNumberMultiValue); phoneNumberIndex++) {
            //CFStringRef labelStingRef = ABMultiValueCopyLabelAtIndex (phoneNumberMultiValue, phoneNumberIndex);
            phoneNumber  = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumberMultiValue, phoneNumberIndex);
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneNumberMultiValue, phoneNumberIndex);
            if (ABMultiValueGetCount(phoneNumberMultiValue) > 1){
                if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel]){
                    mobileCheck = @"mobile";
                }else if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel]){
                    mobileCheck = @"iphone";
                }else{
                    mobileCheck = @"no";
                }
            }else{
                mobileCheck = @"no";
            }
            NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
            resultString = [[phoneNumber componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
            
            if(resultString.length >= 10){
                resultString = [resultString substringFromIndex:resultString.length -10];
                firstThreeNumbers = [resultString substringToIndex:3];
                
                
            }else if (resultString.length == 0){
                resultString = 0;
            }else if (resultString.length >= 3){
                
            }else{
                
            }
            
            if ([firstThreeNumbers isEqualToString:@"800"] ||
                [firstThreeNumbers isEqualToString:@"900"] ||
                resultString.length < 10 ){
                
            }else{
                [phoneNumberArray addObject: resultString];
            }
            
            
            // CFRelease(labelStingRef);
            
        }
        NSString *namestring = [NSString stringWithFormat:@"%@ %@", firstNameString, lastNameString];
        NSMutableDictionary *userDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        //contactImageData, @"imageData",
                                        initials, @"initials",
                                        namestring, @"nameString",
                                        phoneNumberArray, @"phoneNumber",
                                        mobileCheck, @"mobileCheck",
                                        allEmails, @"emailArray",
                                        @"0", @"checked",
                                        @"", @"username",
                                        @"", @"id",
                                        //emailString, @"email",
                                        nil];
        if (([firstNameString isEqualToString:@""] && [lastNameString isEqualToString:@""])||
            [resultString isEqualToString:@""] ){
        }else{
            if (self.playersArray.count > 0){
                BOOL nameExists = FALSE;
                for(NSDictionary *user in self.playersArray){
                    if ([[user objectForKey:@"nameString"] isEqualToString:namestring]){
                        nameExists = TRUE;
                    }
                }
                if(nameExists == TRUE){
                    
                }else{
                    [self.currentList addObject:userDictionary];
                }
            }else{
                [self.currentList addObject:userDictionary];
            }
        }
    }
}


- (void)checkUser:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *userinfo = [self.playersArray objectAtIndex:indexPath.row];
    NSArray *useremails = [userinfo objectForKey:@"emailArray"];
    NSLog(@"useremails %@", useremails);
    NSString *emailString = [useremails componentsJoinedByString:@","];
    NSString *post = [NSString stringWithFormat: @"emails=%@", emailString];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.operationcmyk.com/phonetag/checkEmail.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *createFootnoteSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *createFootnoteTask = [createFootnoteSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSMutableDictionary *item = [self.playersArray objectAtIndex:indexPath.row];
            NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"toggling %@", dataString);
            NSError *error = nil;
            NSArray *newUserInfoArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            NSDictionary *uInfo = [newUserInfoArray objectAtIndex:0];
            
            if(![dataString isEqualToString:@""]){
                [item setValue:[uInfo objectForKey:@"username"] forKey:@"username"];
                [item setValue:[[uInfo objectForKey:@"name"] capitalizedString] forKey:@"nameString"];
                [item setValue:[uInfo objectForKey:@"id"] forKey:@"id"];
                [item setValue:@"1" forKey:@"checked"];
                [self.playersCollectionView reloadData];
            }else{
                NSArray *usersPhoneNumbers = [item objectForKey:@"phoneNumber"];
                if (usersPhoneNumbers.count > 1){
                    [self chooseNumber:usersPhoneNumbers forUser:[item objectForKey:@"nameString"] atIndex:indexPath];
                }else{
                    [item setValue:usersPhoneNumbers[0] forKey:@"phoneNumber"];
                }
                [item setValue:@"1" forKey:@"checked"];
                
            }
            
        });
        
    }];
    
    [createFootnoteTask resume];
}

- (void)chooseNumber:(NSArray *)numberArray forUser:(NSString *)user atIndex:(NSIndexPath *)indexPath{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"We'll need you to text %@ because we can't find them in our database. Choose one:", user] delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    for(NSString *number in numberArray){
        NSString *tenDigitNumber = number;
        tenDigitNumber = [tenDigitNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d{4})"
                                                                   withString:@"($1) $2-$3"
                                                                      options:NSRegularExpressionSearch
                                                                        range:NSMakeRange(0, [tenDigitNumber length])];
        [popup addButtonWithTitle:tenDigitNumber];
    }
    popup.tag = indexPath.row;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"array: %@", phonearray[buttonIndex]);
    //[gameUserPhoneNumbers addObject:phonearray];
    NSDictionary *item = [self.playersArray objectAtIndex:popup.tag];
    NSString *selectedNumber = [item objectForKey:@"phoneNumber"][buttonIndex];
    [item setValue:selectedNumber forKey:@"phoneNumber"];
    
    NSLog(@"button index: %ld", (long)buttonIndex);
    [self.playersCollectionView reloadData];
}


#pragma mark - COLLECTION VIEW


- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.playersArray count];
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeZero;
    switch (indexPath.row) {
        case 0:
            cellSize = CGSizeMake(100, 80);
            break;
        case 1:
            cellSize = CGSizeMake(200, 80);
            break;
        case 2:
            cellSize = CGSizeMake(160, 80);
            break;
        case 3:
            cellSize = CGSizeMake(140, 80);
            break;
        default:
            break;
    }
    return cellSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int numberCount = 4 - ((int)[self.playersArray count]);
    
    
    for (int i = 0; i < 4; i++){
        NSLog(@"i: %d number count: %d", i,  (int)[self.playersArray count]);
        UIImageView *numberImage = [arrayOfNumbers objectAtIndex:i];
        if (i < numberCount){
            numberImage.hidden = FALSE;
        }else{
            numberImage.hidden = TRUE;
        }
    }
    //NSArray *buildArray;
    NSLog(@"here");
    NSString *identifier = [NSString stringWithFormat:@"pcell_%d", (int)indexPath.row];
    
    pCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSMutableDictionary *item = [self.playersArray objectAtIndex:indexPath.row];
    
    int usernameFontSize = 18;
    
    switch (indexPath.row) {
        case 0:
            usernameFontSize = 18;
            break;
        case 1:
            usernameFontSize = 28;
            break;
        case 2:
            usernameFontSize = 23;
            break;
        case 3:
            usernameFontSize = 26;
            break;
            
        default:
            break;
    }
    pCell.username.font = [UIFont fontWithName:@"BadaBoom BB" size:usernameFontSize];
    pCell.usernamebg.font = [UIFont fontWithName:@"BadaBoom BB" size:usernameFontSize];
    pCell.fullname.font = [UIFont fontWithName:@"SFArchRival-Italic" size:11];
    
    for (UIView *subview in [pCell subviews]) {
        [[subview viewWithTag:100] removeFromSuperview];
    }
    
    if(![[item objectForKey:@"username"] isEqualToString:@""]){
        
        pCell.fullname.hidden = FALSE;
        pCell.username.text = [item objectForKey:@"username"];
        pCell.usernamebg.text = [item objectForKey:@"username"];
        pCell.fullname.text = [item objectForKey:@"nameString"];
        CGSize textSize = [[pCell.username text] sizeWithAttributes:@{NSFontAttributeName:[pCell.username font]}];
        float flagY = pCell.username.frame.origin.y + ((pCell.username.frame.size.height/2) - (textSize.height /2)) - 20 + 10;
        float flagX = (pCell.frame.size.width/2) + ((textSize.width/2) - 10);
        
        UIImageView *flagView = [[UIImageView alloc]initWithFrame:CGRectMake(flagX, flagY, 20, 21)];
        [flagView setImage:[UIImage imageNamed:@"flag.png"]];
        [flagView setTag:100];
        [pCell insertSubview:flagView atIndex:0];
        NSLog(@"text size: %f", textSize.width);
    }else{
        pCell.fullname.hidden = TRUE;
        pCell.username.text = [item objectForKey:@"nameString"];
        pCell.usernamebg.text = [item objectForKey:@"nameString"];
    }
    
    /*[pCell.uImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.operationcmyk.com/footnotes/userimages/%@_userimage.jpg", [item objectForKey:@"uid"]]]placeholderImage:nil
                          options:nil
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                            
                        }];*/
    if ([[item objectForKey:@"checked"] isEqualToString:@"0"]){
        //[item setValue:@"1" forKey:@"checked"];
        NSLog(@"checked: %@", item);
        NSArray *emails = [item objectForKey:@"emailArray"];
        if (emails.count > 0){
        [self checkUser:indexPath];
        }else{
            NSArray *usersPhoneNumbers = [item objectForKey:@"phoneNumber"];
            if (usersPhoneNumbers.count > 1){
                [self chooseNumber:usersPhoneNumbers forUser:[item objectForKey:@"nameString"] atIndex:indexPath];
            }else{
                [item setValue:usersPhoneNumbers[0] forKey:@"phoneNumber"];
            }
            [item setValue:@"1" forKey:@"checked"];
        }
    }
    
    return pCell;
}

-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = [self.playersArray objectAtIndex:indexPath.row];
    [self.currentList addObject:item];
    NSLog(@"entry: %@", [item objectForKey:@"nameString"]);
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"nameString" ascending:YES];
    [self.currentList sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [self.playersArray removeObjectAtIndex:indexPath.row];
    [self.playersCollectionView reloadData];
    [self.playersTableView reloadData];
    
    if (self.playersArray.count == 0){
        UIImageView *numberImage = [arrayOfNumbers objectAtIndex:3];
        numberImage.hidden = FALSE;
    }
}

#pragma mark - TABLE VIEW

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"PlayerRow" bundle:nil];
    [self.playersTableView registerNib:nib forCellReuseIdentifier:@"prow"];
    pRow = [self.playersTableView dequeueReusableCellWithIdentifier:@"prow" forIndexPath:indexPath];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"nameString"  ascending:YES];
    NSArray *tableArray = [self.currentList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    NSDictionary *item = [tableArray objectAtIndex:indexPath.row];
    pRow.uName.text = [item objectForKey:@"nameString"];
    
    //NSLog(@"item: %@", item);
    return pRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.playersArray.count < 4){
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"nameString"  ascending:YES];
    NSArray *tableArray = [self.currentList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    NSDictionary *player = [tableArray objectAtIndex:indexPath.row];
    [self.playersArray addObject:player];
        [self.currentList removeObjectIdenticalTo:player];
    [self.playersTableView reloadData];
    [self.playersCollectionView reloadData];
    }else{
        UIAlertView *onlyfour = [[UIAlertView alloc] initWithTitle:Nil
                                                          message:@"You can only add up to 4 players per game."
                                                         delegate:self
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles: nil];
        [onlyfour show];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 55)];
    headerView.backgroundColor = [UIColor clearColor];
    
    return headerView;
}

#pragma mark - SUBMIT GAME INFO

- (IBAction)submitGame:(id)sender{
    
    if (self.playersArray.count > 0){
        // TITLE DROP DOWN
        titleBox.hidden = FALSE;
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [titleBox setFrame:CGRectMake(0, 0, titleBox.frame.size.width, titleBox.frame.size.height)];
                         }completion:^(BOOL finished){
                             [gameNameField becomeFirstResponder];
                         }];
        
    }else{
        CCAlertView *alert = [[CCAlertView alloc]
                              initWithTitle:@"Players"
                              message:@"You haven't added anyone to the game!"];
        [alert addButtonWithTitle:@"Oh, you right. Mah bad." block:NULL];
        [alert show];
    }
    
}

- (IBAction)titleCancel:(id)sender{
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [titleBox setFrame:CGRectMake(0, -titleBox.frame.size.height, titleBox.frame.size.width, titleBox.frame.size.height)];
                     }completion:^(BOOL finished){
                         gameNameField.text = @"";
                         titleBox.hidden = TRUE;
                     }];
    [gameNameField resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 8) ? NO : YES;
}

- (IBAction)titleSubmit:(id)sender{
    if (gameNameField.text.length > 0){
        
        CCAlertView *alert = [[CCAlertView alloc]
                              initWithTitle:@"Submit Game"
                              message:@"Are you ready to submit this game?"];
        [alert addButtonWithTitle:@"Yep" block:^{[self finalSubmit];}];
        [alert addButtonWithTitle:@"Oops, not yet!" block:NULL];
        [alert show];
    }else{
        CCAlertView *alert = [[CCAlertView alloc]
                              initWithTitle:nil
                              message:@"You need to give this game a title"];
        [alert addButtonWithTitle:@"Oops, not yet!" block:NULL];
        [alert show];
    }
}

- (void)finalSubmit{
    for (NSDictionary *item in self.playersArray){
        if ([[item objectForKey:@"id"] isEqualToString:@""]){
            [gameUserPhoneNumbers addObject:[item objectForKey:@"phoneNumber"]];
        }else{
            [gameUserIds addObject:[item objectForKey:@"id"]];
        }
    }
    
    if (gameUserPhoneNumbers.count > 0){
        [self sendSMS:[NSString stringWithFormat:@"Join my game '%@' on phone tag so we can battle each other! Join a game with the registration number: %@",gameNameField.text, gameRegistrationNumber] recipientList:gameUserPhoneNumbers];
    }else{
        if (gameUserIds.count > 0 && gameUserPhoneNumbers.count == 0){
            [self createGame];
        }
    }
}

- (void)createGame{
    int playerCount = (int)self.playersArray.count +1;
    NSString *playerTwo = @"";
    NSString *playerThree = @"";
    NSString *playerFour = @"";
    NSString *playerFive = @"";
    NSString *gameName = gameNameField.text;
    int playerOrder = 2;
    for (NSDictionary *item in self.playersArray){
        if (![[item objectForKey:@"id"] isEqualToString:@""]){
            NSString *currentId = [item objectForKey:@"id"];
            switch (playerOrder) {
                case 2:
                    playerTwo = currentId;
                    break;
                case 3:
                    playerThree = currentId;
                    break;
                case 4:
                    playerFour = currentId;
                    break;
                case 5:
                    playerFive = currentId;
                    break;
                default:
                    break;
            }
        }
        playerOrder++;
    }

    NSString *userId = staticUserInfo.ptId;
    NSLog(@"user id: %@", userId);
    NSString *post = [NSString stringWithFormat: @"p1=%@&p2=%@&p3=%@&p4=%@&p5=%@&type=1&code=%@&count=%d&gamename=%@", userId, playerTwo, playerThree, playerFour, playerFive, gameRegistrationNumber, playerCount, gameName];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=creategame";
    
    NSMutableURLRequest *createGameRequest = [[NSMutableURLRequest alloc] init];
    [createGameRequest setURL:[NSURL URLWithString:fullURL]];
    [createGameRequest setHTTPMethod:@"POST"];
    [createGameRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [createGameRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [createGameRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *createGameSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *createGameTask = [createGameSession dataTaskWithRequest:createGameRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"datastring %@", datastring);
            
            [self performSegueWithIdentifier:@"startgame" sender:self];
            
        });
    }];
    
    [createGameTask resume];
}

#pragma mark - SEND TEXTS

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    NSLog(@"recipients: %@", recipients);
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
        // MESSAGE SENT
        [self dismissViewControllerAnimated:YES completion:^{
            [self createGame];
        }];
        
    }else{
        // MESSAGE FAILED
        NSLog(@"message failed");
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
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
