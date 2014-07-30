//
//  Login.m
//  phonetag
//
//  Created by Brandon Phillips on 6/4/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "Login.h"

@interface Login ()

@end

@implementation Login

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitLogin:(id)sender{
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];

    passwordLabel.hidden = TRUE;
    loginLabel.hidden = TRUE;
    
    if (usernameField.text.length == 0){
        passwordLabel.hidden = FALSE;
        usernameVerify = 0;
    }else{
        passwordLabel.hidden = TRUE;
        usernameVerify = 1;
    }
    
    if (passwordField.text.length == 0){
        passwordLabel.hidden = FALSE;
        passwordVerify = 0;
    }else{
        passwordLabel.hidden = TRUE;
        passwordVerify = 1;
    }
    
    if (passwordVerify == 1 && usernameVerify == 1){
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        NSString *post = [NSString stringWithFormat: @"user=%@&pw=%@&token=%@", usernameField.text, passwordField.text, token];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=loginUser";
        
        NSMutableURLRequest *loginRequest = [[NSMutableURLRequest alloc] init];
        [loginRequest setURL:[NSURL URLWithString:fullURL]];
        [loginRequest setHTTPMethod:@"POST"];
        [loginRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [loginRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [loginRequest setHTTPBody:postData];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *loginSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        NSURLSessionDataTask *loginTask = [loginSession dataTaskWithRequest:loginRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"datastring %@", datastring);
                
                switch ([datastring intValue]) {
                    case 0:
                        //NO USER FOUND
                        NSLog(@"no user");
                        break;
                    case 1:
                        //INCORRECT PASSWORD
                        NSLog(@"incorrect password");
                        [self shakeIt];
                        break;
                    default:
                        
                        break;
                }
                
                NSError *error = nil;
                NSArray *userArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
                NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                NSLog(@"user array: %@", userArray);
                if (userArray.count > 0){
                    NSDictionary *item = [userArray objectAtIndex:0];
                    [staticUserInfo username:[item objectForKey:@"username"] fullname:[item objectForKey:@"name"] email:[item objectForKey:@"email"] PTId:[item objectForKey:@"userId"] PTv:versionNumber];
                    NSLog(@"static id: %@", staticUserInfo.ptId);
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
            });
        }];
        
        [loginTask resume];
    }
}

- (void)shakeIt{
    loginLogo.duration = 0.5;
    loginLogo.delay = 0.0;
    loginLogo.type = CSAnimationTypeShake;
    
    [loginLogo startCanvasAnimation];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y + 50) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)viewDidAppear:(BOOL)animated{
    if (staticUserInfo.ptId){
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)viewDidLoad
{
    usernameField.font = [UIFont fontWithName:@"SFArchRival-Italic" size:24];
    passwordField.font = [UIFont fontWithName:@"SFArchRival-Italic" size:24];
    passwordLabel.font = [UIFont fontWithName:@"SFArchRival-Italic" size:14];

    [forgotInfo.titleLabel setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:12]];
    [registerButton.titleLabel setFont:[UIFont fontWithName:@"SFArchRival-Italic" size:12]];
    
    [usernameField setValue:[UIColor blackColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    [passwordField setValue:[UIColor blackColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    [super viewDidLoad];
    staticUserInfo = [PTStaticInfo sharedManager];
    [self setNeedsStatusBarAppearanceUpdate];
    
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
