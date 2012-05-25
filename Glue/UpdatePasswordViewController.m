//
//  UpdatePasswordViewController.m
//  Glue
//
//  Created by Pietro Rea on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "SingletonUser.h"

SingletonUser *currentUser;


@interface UpdatePasswordViewController ()

@end

@implementation UpdatePasswordViewController

@synthesize updatedPasswordTextField;
@synthesize retypeUpdatedPasswordTextField;

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
}

- (void)viewDidUnload
{
    [self setUpdatedPasswordTextField:nil];
    [self setRetypeUpdatedPasswordTextField:nil];
    [super viewDidUnload];
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
    
    if ([[updatedPasswordTextField text] length] == 0) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                           message:@"What is the new password?"
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    else if ([[retypeUpdatedPasswordTextField text] length] == 0) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                           message:@"Please retype your new password?"
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    else if (![updatedPasswordTextField.text isEqualToString:retypeUpdatedPasswordTextField.text]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Try Again" 
                                           message:@"Your passwords don't match."
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        updatedPasswordTextField.text = nil;
        retypeUpdatedPasswordTextField.text = nil;
        
        return;
    }
    
    int result = [currentUser updatePassword:updatedPasswordTextField.text];
    
    
    /* If successful, hitting "OK" triggers delegate method */
    
    if (result == 1){
        UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Success!" 
                                                               message:@"Your password has been updated." 
                                                              delegate:self 
                                                     cancelButtonTitle:@"OK" 
                                                     otherButtonTitles:nil];
        
        [updatedAlert show];
        
    }
    
    /* If unsuccessful, hitting "OK" triggers nothing */
    
    else {
        UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Try again!" 
                                                               message:@"Your password could not be updated." 
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
