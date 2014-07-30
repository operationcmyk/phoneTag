//
//  Login.h
//  phonetag
//
//  Created by Brandon Phillips on 6/4/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTStaticInfo.h"
#import "Canvas.h"

@interface Login : UIViewController<NSURLSessionDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate>{
    
    PTStaticInfo *staticUserInfo;
    
    IBOutlet UITextField *usernameField;
    IBOutlet CSAnimationView *loginLogo;

    int usernameVerify;
    
    IBOutlet UITextField *passwordField;
    IBOutlet UILabel *passwordLabel;
    
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *forgotInfo;
    int passwordVerify;
    
    IBOutlet UILabel *loginLabel;
    
    IBOutlet UIScrollView *scrollView;
}

@end
