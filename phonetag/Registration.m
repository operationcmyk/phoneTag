//
//  Registration.m
//  phonetag
//
//  Created by Brandon Phillips on 5/29/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "Registration.h"
#import "PTStaticInfo.h"

@interface Registration ()

@end

@implementation Registration

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    uNameField.font = [UIFont fontWithName:@"SFArchRival-Italic" size:24];
    fNameField.font = [UIFont fontWithName:@"SFArchRival-Italic" size:24];
    lNameField.font = [UIFont fontWithName:@"SFArchRival-Italic" size:24];
    emailField.font = [UIFont fontWithName:@"SFArchRival-Italic" size:24];
    passwordField.font = [UIFont fontWithName:@"SFArchRival-Italic" size:24];
    
    passwordLabel.font = [UIFont fontWithName:@"SFArchRival-Italic" size:14];
    uNameLabel.font = [UIFont fontWithName:@"SFArchRival-Italic" size:14];
    emailLabel.font = [UIFont fontWithName:@"SFArchRival-Italic" size:14];
    
    [uNameField setValue:[UIColor blackColor]
                 forKeyPath:@"_placeholderLabel.textColor"];
    [fNameField setValue:[UIColor blackColor]
              forKeyPath:@"_placeholderLabel.textColor"];
    [lNameField setValue:[UIColor blackColor]
                 forKeyPath:@"_placeholderLabel.textColor"];
    [emailField setValue:[UIColor blackColor]
              forKeyPath:@"_placeholderLabel.textColor"];
    [passwordField setValue:[UIColor blackColor]
                 forKeyPath:@"_placeholderLabel.textColor"];
    
    staticUserInfo = [PTStaticInfo sharedManager];
    
    uNameField.tag = 1;
    fNameField.tag = 2;
    lNameField.tag = 3;
    emailField.tag = 4;
    passwordField.tag = 5;
    [self setNeedsStatusBarAppearanceUpdate];

    [self.view layoutSubviews];
    
    NSLog(@"scroll view: %@", boxONE.constraints);
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    switch (textField.tag) {
        case 1:
            
            break;
        case 2:

            break;
        case 3:
            [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y -40) animated:YES];
            break;
        case 4:
            [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y + -60) animated:YES];
            break;
        case 5:
            [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-80) animated:YES];
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
     [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    switch (textField.tag) {
        case 1:
            if (uNameField.text.length > 0){
               [self checkDatabaseForUsername];
            }else{
                unameVerify = 0;
            }
            
            break;
        case 2:
            if (fNameField.text.length > 0){
                fnameVerify = 1;
            }else{
                fnameVerify = 0;
            }
            break;
        case 3:
            if (lNameField.text.length > 0){
                lnameVerify = 1;
            }else{
                lnameVerify = 0;
            }
            break;
        case 4:
            [self checkDatabaseForEmail];
            break;
        case 5:
            if (passwordField.text.length > 4){
                passwordVerify = 1;
            }else{
                passwordVerify = 0;
            }
            break;
            
        default:
            break;
    }
    
    if (textField.tag == 1){
        
    }
}

- (void)checkDatabaseForUsername{
    NSString *post = [NSString stringWithFormat: @"username=%@", uNameField.text];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=checkUsername";
    
    NSMutableURLRequest *checkUsernameRequest = [[NSMutableURLRequest alloc] init];
    [checkUsernameRequest setURL:[NSURL URLWithString:fullURL]];
    [checkUsernameRequest setHTTPMethod:@"POST"];
    [checkUsernameRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [checkUsernameRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [checkUsernameRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *checkUsernameSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *checkUsernameTask = [checkUsernameSession dataTaskWithRequest:checkUsernameRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"datastring %@", datastring);
            if ([datastring intValue] == 1){
                //USERNAME TAKEN
                uNameLabel.hidden = FALSE;
                unameVerify = 0;
                uNameLabel.text = @"Username is already taken";
            }else{
                uNameLabel.hidden = FALSE;
                uNameLabel.text = @"Great choice!";
                unameVerify = 1;
                //USERNAME IS OK
            }
            
        });
    }];
    
    [checkUsernameTask resume];
}

- (void)checkDatabaseForEmail{
    NSString *post = [NSString stringWithFormat: @"email=%@", emailField.text];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=checkEmail";
    
    NSMutableURLRequest *checkEmailRequest = [[NSMutableURLRequest alloc] init];
    [checkEmailRequest setURL:[NSURL URLWithString:fullURL]];
    [checkEmailRequest setHTTPMethod:@"POST"];
    [checkEmailRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [checkEmailRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [checkEmailRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *checkEmailSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *checkEmailTask = [checkEmailSession dataTaskWithRequest:checkEmailRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"datastring %@", datastring);
            
            switch ([datastring intValue]) {
                case 0:
                    //EMAIL IS GOOD
                    emailVerify = 1;
                    break;
                case 1:
                    //EMAIL IS REGISTERED
                    if (emailField.text.length > 5){
                        emailLabel.hidden = FALSE;
                        emailLabel.text = @"This email address is already registered";
                    }
                    break;
                case 2:
                    //EMAIL IS NOT IN EMAIL FORMAT
                    if (emailField.text.length > 5){
                        emailLabel.hidden = FALSE;
                        emailLabel.text = @"This is not in email format";
                    }
                    break;
                default:
                    break;
            }
            
        });
    }];
    
    [checkEmailTask resume];
}

- (IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitRegistration:(id)sender{
    [uNameField resignFirstResponder];
    [fNameField resignFirstResponder];
    [lNameField resignFirstResponder];
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
    if (emailVerify == 1 && fnameVerify == 1 && lnameVerify == 1 && passwordVerify == 1 & unameVerify == 1){
    
    NSString *username = [uNameField.text
                          stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *firstname = fNameField.text;
    NSString *lastname = lNameField.text;
    
    NSString *fullname = [[NSString stringWithFormat:@"%@ %@", firstname, lastname] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *email = [emailField.text
                       stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *password = [passwordField.text
                          stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        NSString *post = [NSString stringWithFormat: @"un=%@&fname=%@&em=%@&pw=%@&token=%@", username, fullname, email, password, token];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=registerUser";
        
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
                
                NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"data string: %@", datastring);
                if (![datastring intValue] == 0) {
                    // PUSH ALL VALUES TO PT STATIC INFO
                    
                    NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                    [staticUserInfo username:username fullname:fullname email:email PTId:datastring PTv:versionNumber];
                    [self performSegueWithIdentifier:@"registered" sender:self];
                }
                        
            });
        }];
        
        [registerTask resume];
        
        
    }else{
        UIAlertView *fixErrors = [[UIAlertView alloc] initWithTitle:Nil
                                                          message:@"Fix the registration errors and try again"
                                                         delegate:self
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles: nil];
        [fixErrors show];
    }
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
