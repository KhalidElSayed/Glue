//
//  SignUpViewController.m
//  Glue
//
//  Created by Pietro Rea on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "SingletonUser.h"

SingletonUser *currentUser;
//static NSString * serverIP = @"http://23.23.223.158/";
static NSString * serverIP = @"https://www.ztbinmiyog.us/";
static NSString * sharedKey = @"okXRDgXqnDfyYK11nARRIdUy5xmuGsJi00DQuyzaGYY";

@interface SignUpViewController ()

@end

@implementation SignUpViewController

@synthesize inputUserFirstName;
@synthesize inputUserLastName;
@synthesize inputUserEmail;
@synthesize inputUserPhoneNumber;
@synthesize inputUserPassword;
@synthesize inputUserRetypePassword;


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
    self.inputUserFirstName.delegate = self;
    self.inputUserLastName.delegate = self;
    self.inputUserEmail.delegate = self;
    self.inputUserPhoneNumber.delegate = self;
    self.inputUserPassword.delegate = self;
    self.inputUserRetypePassword.delegate = self;
}

- (void)viewDidUnload
{
    [self setInputUserFirstName:nil];
    [self setInputUserLastName:nil];
    [self setInputUserEmail:nil];
    [self setInputUserPhoneNumber:nil];
    [self setInputUserPassword:nil];
    [self setInputUserRetypePassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (IBAction)createUser:(id)sender {
    
    UIAlertView *alert;
    if (self.inputUserFirstName.text.length == 0){
        alert = [[UIAlertView alloc] initWithTitle:@"Try again" 
                                           message:@"Please enter your first name." 
                                          delegate:nil 
                                 cancelButtonTitle:@"OK" 
                                 otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    else if (self.inputUserLastName.text.length == 0){
        alert = [[UIAlertView alloc] initWithTitle:@"Try again" 
                                           message:@"Please enter your last name." 
                                          delegate:nil 
                                 cancelButtonTitle:@"OK" 
                                 otherButtonTitles:nil];
        
        [alert show];
        return;
    }

    else if (self.inputUserEmail.text.length == 0){
        alert = [[UIAlertView alloc] initWithTitle:@"Try again" 
                                           message:@"Please enter your e-mail address." 
                                          delegate:nil 
                                 cancelButtonTitle:@"OK" 
                                 otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    else if (self.inputUserPassword.text.length == 0){
        alert = [[UIAlertView alloc] initWithTitle:@"Try again" 
                                           message:@"Please choose a password." 
                                          delegate:nil 
                                 cancelButtonTitle:@"OK" 
                                 otherButtonTitles:nil];
        
        [alert show];
        return;
    }

    else if (self.inputUserRetypePassword.text.length == 0){
        alert = [[UIAlertView alloc] initWithTitle:@"Try again" 
                                           message:@"Please retype your password." 
                                          delegate:nil 
                                 cancelButtonTitle:@"OK" 
                                 otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    else if (![self.inputUserPassword.text isEqualToString:self.inputUserRetypePassword.text]){
        alert = [[UIAlertView alloc] initWithTitle:@"Try again" 
                                           message:@"Your password does not match up." 
                                          delegate:nil 
                                 cancelButtonTitle:@"OK" 
                                 otherButtonTitles:nil];
        
        [alert show];
        self.inputUserPassword.text = nil;
        self.inputUserRetypePassword.text = nil;
        return;
    }
    
    int result = [self createUserWithName:inputUserFirstName.text 
                             withLastName:inputUserLastName.text 
                            withUserEmail:inputUserEmail.text 
                            withUserPhone:inputUserPhoneNumber.text 
                         withUserPassword:inputUserPassword.text];
    
    
    if (result == 1){
        
        currentUser = [SingletonUser initSharedInstanceWithEmail:inputUserEmail.text 
                                                     andPassword:inputUserPassword.text];
        
        [self performSegueWithIdentifier:@"signUpToLogin" sender:self];
    }
    
    else if (result == 2) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"User with this e-mail already exists" 
                                                        delegate:nil 
                                                cancelButtonTitle:@"OK" 
                                                otherButtonTitles:nil];
                
        [alert show];
        return;
    }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Please try again" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
}


// Return 1 if successful, 2 if user already exists and 0 if createUser failed
- (int) createUserWithName: (NSString *) userName withLastName: (NSString *) userLastName 
             withUserEmail: (NSString *) userEmail withUserPhone: (NSString *) userPhone 
          withUserPassword: (NSString *) userPassword
{
    NSLog(@"createUserWithName has been called");
    
    NSString * urlString = [serverIP stringByAppendingString:@"create_user?"];
    urlString = [urlString stringByAppendingFormat:@"name=%@&lastname=%@&email=%@&phone=%@&password=%@&key=%@", inputUserFirstName.text, inputUserLastName.text, inputUserEmail.text, inputUserPhoneNumber.text, inputUserPassword.text, sharedKey];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString: %@", urlString);
   
    NSURL * url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString * urlResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    if ([urlResponse isEqualToString:@"yes"]){
        NSLog(@"User has been created successfully");
        return 1;
    }
    
    else if ([urlResponse isEqualToString:@"User already exists"]){
        NSLog(@"Error: User already exists");
        return 2;
    }
    
    else {
        NSLog(@"Error: user could not be created");
        return 0;
    }
    
    
    return 0;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
