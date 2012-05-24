//
//  SignUpViewController.h
//  Glue
//
//  Created by Pietro Rea on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputUserFirstName;
@property (weak, nonatomic) IBOutlet UITextField *inputUserLastName;
@property (weak, nonatomic) IBOutlet UITextField *inputUserEmail;
@property (weak, nonatomic) IBOutlet UITextField *inputUserPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *inputUserPassword;
@property (weak, nonatomic) IBOutlet UITextField *inputUserRetypePassword;

// createUser is called when the "Done" button is pressed.
- (IBAction)createUser:(id)sender;

@end
