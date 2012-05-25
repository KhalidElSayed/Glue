//NOTE: SIGN UP PROCESS STILL DOESN'T WORK

//
//  LoginViewController.h
//  Glue
//
//  Created by Pietro Rea on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailLoginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordLoginTextField;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)signupButtonPresesd:(id)sender;

@end
