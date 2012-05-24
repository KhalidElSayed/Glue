//
//  LoginViewController.m
//  Glue
//
//  Created by Pietro Rea on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

#import "MyEventsTableViewController.h"
#import "LoginViewController.h"
#import "SingletonUser.h"

SingletonUser *currentUser;

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize emailLoginTextField;
@synthesize passwordLoginTextField;

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
    
    self.emailLoginTextField.delegate = self;
    self.passwordLoginTextField.delegate = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbackground.png"]];
}

- (void)viewDidUnload
{
    [self setEmailLoginTextField:nil];
    [self setPasswordLoginTextField:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loginButtonPressed:(id)sender 
{
    NSString *inputEmail = self.emailLoginTextField.text;
    NSString *inputPassword = self.passwordLoginTextField.text;
    
    // Alert user if no e-mail has been given
    if (inputEmail.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter e-mail" 
                                                        message:@"Please enter your e-mail address" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    // Alert user if no password has been given
    else if (inputPassword.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Passwprd" 
                                                        message:@"Please enter your password" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    
    currentUser = [SingletonUser initSharedInstanceWithEmail:inputEmail 
                                                 andPassword:inputPassword];
    
    // Alert user user if login was unsuccessful.
    // This could be triggered by an incorrect e-mail/password of if server cannot be reached
    if (currentUser == nil){
        UIAlertView *userNotFoundAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" 
                                                       message:@"E-mail or password are incorrect. Please try again." 
                                                      delegate:nil 
                                             cancelButtonTitle:@"OK" 
                                             otherButtonTitles:nil];
        [userNotFoundAlert show];
    }
    
    else {
        [self performSegueWithIdentifier:@"loginSuccessful" sender:self];
    }
    
}

- (IBAction)signupButtonPresesd:(id)sender {
    // The segue is fired from MainStoryboard.storyboard
}


//UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
