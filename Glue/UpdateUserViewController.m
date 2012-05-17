//
//  UpdateUserViewController.m
//  Glue
//
//  Created by Pietro Rea on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpdateUserViewController.h"
#import "SingletonUser.h"

SingletonUser *currentUser;

@interface UpdateUserViewController ()

@end

@implementation UpdateUserViewController
@synthesize firstNameTextLabel;
@synthesize lastNameTextLabel;
@synthesize emailTextLabel;
@synthesize phoneTextLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentUser = [SingletonUser sharedInstance];
    self.firstNameTextLabel.text = currentUser.name;
    self.lastNameTextLabel.text = currentUser.lastname;
    self.emailTextLabel.text = currentUser.email;
    self.phoneTextLabel.text = currentUser.phone;
    
    [self.firstNameTextLabel becomeFirstResponder];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setFirstNameTextLabel:nil];
    [self setLastNameTextLabel:nil];
    [self setEmailTextLabel:nil];
    [self setPhoneTextLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)doneButtonPressed:(id)sender {
    
    UIAlertView *alert;
    if ([[self.firstNameTextLabel text] length] == 0) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                           message:@"What is the new name?"
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    else if ([[self.lastNameTextLabel text] length] == 0) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                           message:@"What is your new last name?"
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /* Check if e-mail address doesn't already exist in the system */
    else if ([[self.emailTextLabel text] length] == 0) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                           message:@"What is your new e-mail address?"
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    int result = [currentUser updateUserDetailsWithFirstName:firstNameTextLabel.text 
                                             andUserLastName:lastNameTextLabel.text 
                                                andUserEmail:emailTextLabel.text 
                                                andUserPhone:phoneTextLabel.text];
    
    
    /* If successful, hitting "OK" triggers delegate method. */
    if (result == 1){
        UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Success!" 
                                                               message:@"Your information has been updated." 
                                                              delegate:self 
                                                     cancelButtonTitle:@"OK" 
                                                     otherButtonTitles:nil];
        
        currentUser.name = firstNameTextLabel.text;
        currentUser.lastname = lastNameTextLabel.text;
        currentUser.fullName = [NSString stringWithFormat:@"%@ %@", currentUser.name, currentUser.lastname];
        currentUser.email = emailTextLabel.text;
        currentUser.phone = phoneTextLabel.text;
        [updatedAlert show];
    }
    
    /* If user already exists, hitting "OK" triggers nothing. */
    else if (result == 2){
        UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                               message:@"A user with that e-mail already exists." 
                                                              delegate:nil 
                                                     cancelButtonTitle:@"OK" 
                                                     otherButtonTitles:nil];
        [updatedAlert show];
    }
    
    /* If unsuccessful, hitting "OK" triggers nothing */
    
    else {
        UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Try again" 
                                                               message:@"Your information could not be updated." 
                                                              delegate:nil 
                                                     cancelButtonTitle:@"OK" 
                                                     otherButtonTitles:nil];
        [updatedAlert show];
    }
    
}

/* UIAlertView delegate method */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
