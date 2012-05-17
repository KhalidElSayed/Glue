//
//  UpdateUserViewController.h
//  Glue
//
//  Created by Pietro Rea on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateUserViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextLabel;

- (IBAction)doneButtonPressed:(id)sender;

@end
