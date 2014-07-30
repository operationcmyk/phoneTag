//
//  Registration.h
//  phonetag
//
//  Created by Brandon Phillips on 5/29/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTStaticInfo.h"

@interface Registration : UIViewController<UITextFieldDelegate, NSURLSessionDelegate, UIScrollViewDelegate>{
    
    PTStaticInfo *staticUserInfo;
    float screenWidth;
    float screenHeight;
    
    IBOutlet UITextField *uNameField;
    IBOutlet UILabel *uNameLabel;
    int unameVerify;
    
    IBOutlet UITextField *fNameField;
    int fnameVerify;
    
    IBOutlet UITextField *lNameField;
    int lnameVerify;
    
    IBOutlet UITextField *emailField;
    IBOutlet UILabel *emailLabel;
    int emailVerify;
    
    IBOutlet UITextField *passwordField;
    IBOutlet UILabel *passwordLabel;
    int passwordVerify;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIImageView *boxONE;
    
}


@end
