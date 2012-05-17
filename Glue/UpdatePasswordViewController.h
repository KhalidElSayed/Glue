//
//  UpdatePasswordViewController.h
//  Glue
//
//  Created by Pietro Rea on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePasswordViewController : UITableViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *updatedPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *retypeUpdatedPasswordTextField;

- (IBAction)doneButtonPressed:(id)sender;

@end
