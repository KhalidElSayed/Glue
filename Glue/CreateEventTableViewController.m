//
//  CreateEventTableViewController.m
//  Glue
//
//  Created by Pietro Rea on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateEventTableViewController.h"
#import "AddFriendsViewController.h"
#import "SingletonUser.h"

SingletonUser *currentUser;
NSDate *startTime;
NSDate *endTime;

@interface CreateEventTableViewController ()

@end

@implementation CreateEventTableViewController

@synthesize eventName;
@synthesize eventCategory;
@synthesize eventLocation;
@synthesize eventStartTime;
@synthesize eventEndTime;
@synthesize eventDescription;
@synthesize currentEventGuestList;
@synthesize previousViewController;

@synthesize eventNameTextField;
@synthesize eventCategoryTextField;
@synthesize eventLocationTextField;
@synthesize eventStartTimeTextField;
@synthesize eventEndTimeTextField;
@synthesize eventDescriptionTextField;

@synthesize categoryPicker;
@synthesize startTimeDatePicker;
@synthesize endTimeDatePicker;
@synthesize dateFormatter;


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{       
    AddFriendsViewController * afc = [segue destinationViewController];
    afc.eventName = self.eventNameTextField.text;
    afc.eventCategory = self.eventCategoryTextField.text;
    afc.eventLocation = self.eventLocationTextField.text;
    afc.eventStarTime = self.eventStartTimeTextField.text;
    afc.eventEndTime = self.eventEndTimeTextField.text;
    afc.eventDescription = self.eventDescriptionTextField.text;
    
    self.eventNameTextField.text = nil;
    self.eventCategoryTextField.text = nil;
    self.eventLocationTextField.text = nil;
    self.eventStartTimeTextField.text = nil;
    self.eventEndTimeTextField.text = nil;
    self.eventDescriptionTextField.text = nil;
    
    self.eventNameTextField.placeholder = @"Event Name";
    self.eventCategoryTextField.placeholder = @"Category";
    self.eventLocationTextField.placeholder = @"Location";
    self.eventStartTimeTextField.placeholder = @"Start Time";
    self.eventEndTimeTextField.placeholder = @"End Time";
    self.eventDescriptionTextField.placeholder = @"Description (Optional)";
}

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
    
    /* Populate existing Event Information if updating an Event */
    if (eventName != nil){
        self.eventNameTextField.text = self.eventName;
        [self.eventNameTextField becomeFirstResponder];
    }
    if (eventCategory != nil){
        self.eventCategoryTextField.text = self.eventCategory;
    }
    if (eventLocation != nil){
        self.eventLocationTextField.text = self.eventLocation;
    }
    if (eventStartTime != nil){
        self.eventStartTimeTextField.text = self.eventStartTime;
    }
    if (eventEndTime != nil){
        self.eventEndTimeTextField.text = self.eventEndTime;
    }
    if (eventDescription != nil){
        self.eventDescriptionTextField.text = self.eventDescription;
    }
    
    
    self.eventNameTextField.delegate = self;
    self.eventCategoryTextField.delegate = self;
    self.eventLocationTextField.delegate = self;
    self.eventStartTimeTextField.delegate = self;
    self.eventEndTimeTextField.delegate = self;
    self.eventDescriptionTextField.delegate = self;
    
    self.startTimeDatePicker = [[UIDatePicker alloc] init];
    self.endTimeDatePicker = [[UIDatePicker alloc] init];
    self.eventStartTimeTextField.inputView = startTimeDatePicker;
    self.eventEndTimeTextField.inputView = endTimeDatePicker;
    [self.startTimeDatePicker addTarget:self action:@selector(startTimeDatePickerChanged) forControlEvents:UIControlEventValueChanged];
    [self.endTimeDatePicker addTarget:self action:@selector(endTimeDatePickerChanged) forControlEvents:UIControlEventValueChanged];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.categoryPicker = [[UIPickerView alloc] init];
    self.categoryPicker.showsSelectionIndicator = YES;
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    self.eventCategoryTextField.inputView = categoryPicker;
    
    if ([self.previousViewController isEqualToString:@"EventDetailViewController"]){
        [self createUpdateInvitationsButton];
    }
    else {
        [self createInviteFriendsButton];
    }
    
}   

- (void)viewDidUnload
{
    [self setEventNameTextField:nil];
    [self setEventCategoryTextField:nil];
    [self setEventLocationTextField:nil];
    [self setEventStartTimeTextField:nil];
    [self setEventEndTimeTextField:nil];
    [self setEventDescriptionTextField:nil];
    [self setEventLocationTextField:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return @"Step 1: Event Details";
    }
    else {
        return @"";
    }
}

- (void) startTimeDatePickerChanged
{
    NSLog(@"startTimeDatePickerChanged was called");
    startTime = [startTimeDatePicker date];
    NSString *starttime = [dateFormatter stringFromDate:startTimeDatePicker.date];
    self.eventStartTimeTextField.text = starttime;
}

- (void) endTimeDatePickerChanged
{
    NSLog(@"endTimeDatePickerChanged was called");
    endTime = [endTimeDatePicker date];
    NSString *endtime = [dateFormatter stringFromDate:endTimeDatePicker.date];
    self.eventEndTimeTextField.text = endtime;
}

- (void) createInviteFriendsButton
{
    UIButton * InviteFriendsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIView * buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 50.0)];
    [InviteFriendsButton addTarget:self action:@selector(inviteFriendsToThisEvent) forControlEvents:UIControlEventTouchDown];
    [InviteFriendsButton setTitle:@"Invite Friends" forState:UIControlStateNormal];
    InviteFriendsButton.frame = CGRectMake(10.0, 0.0, self.tableView.frame.size.width - 20, 40.0);
    [buttonView addSubview:InviteFriendsButton];
    self.tableView.tableFooterView = buttonView;
    
//    [InviteFriendsButton setBackgroundImage:[[UIImage imageNamed:@"redbuttonnew.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//    
//    [deleteEventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void) createUpdateInvitationsButton
{
    UIButton * updateInvitationsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIView * buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 50.0)];
    [updateInvitationsButton addTarget:self action:@selector(updateInvitationsOfThisEvent) forControlEvents:UIControlEventTouchDown];
    [updateInvitationsButton setTitle:@"Update Invitations" forState:UIControlStateNormal];
    updateInvitationsButton.frame = CGRectMake(10.0, 0.0, self.tableView.frame.size.width - 20, 40.0);
    [buttonView addSubview:updateInvitationsButton];
    self.tableView.tableFooterView = buttonView;
    
}

- (void) inviteFriendsToThisEvent
{

    [self.eventNameTextField resignFirstResponder];
    [self.eventCategoryTextField resignFirstResponder];
    [self.eventLocationTextField resignFirstResponder];
    [self.eventStartTimeTextField resignFirstResponder];
    [self.eventEndTimeTextField resignFirstResponder];
    [self.eventDescriptionTextField resignFirstResponder];
    
    UIAlertView *alert;
     
     if ([[eventNameTextField text] length] == 0) {
         
         alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                            message:@"What is the name of the event?"
                                           delegate:nil 
                                  cancelButtonTitle:@"Okay" 
                                  otherButtonTitles:nil];
         [alert show];
         return;
     }
     
     else if ([[eventCategoryTextField text] length] == 0) {
         alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                            message:@"What is the event category?"
                                           delegate:nil 
                                  cancelButtonTitle:@"Okay" 
                                  otherButtonTitles:nil];
         [alert show];
         return;
     }
    
     else if ([[eventLocationTextField text] length] == 0) {
         alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                            message:@"Where is the event going to be?"
                                           delegate:nil 
                                  cancelButtonTitle:@"Okay" 
                                  otherButtonTitles:nil];
         [alert show];
         return;
     }
     
     else if ([[eventStartTimeTextField text] length] == 0) {
     alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                        message:@"When does the event start?"
                                       delegate:nil 
                              cancelButtonTitle:@"Okay" 
                              otherButtonTitles:nil];
         [alert show];
         return;
     }
     
     else if ([[eventEndTimeTextField text] length] == 0) {
         alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                            message:@"When does the event end?"
                                           delegate:nil 
                                  cancelButtonTitle:@"Okay" 
                                  otherButtonTitles:nil];
         [alert show];
         return;
     }
    
     else if ([startTime compare:endTime] != NSOrderedAscending){
         
         /* startTime and endTime are nil when they haven't been set by a datePicker*/
         /* This includes the case of editing an existing event*/
         
         if (startTime == nil || endTime == nil){
             return;
         }
         
         alert = [[UIAlertView alloc] initWithTitle:@"Try again" 
                                            message:@"The event cannot end before it starts."
                                           delegate:nil 
                                  cancelButtonTitle:@"Okay" 
                                  otherButtonTitles:nil];
         [alert show];
         return;
     }

    [self performSegueWithIdentifier:@"createEventToInviteFriends" sender:self];
    
}

- (void) updateInvitationsOfThisEvent
{
    [self.eventNameTextField resignFirstResponder];
    [self.eventCategoryTextField resignFirstResponder];
    [self.eventLocationTextField resignFirstResponder];
    [self.eventStartTimeTextField resignFirstResponder];
    [self.eventEndTimeTextField resignFirstResponder];
    [self.eventDescriptionTextField resignFirstResponder];
    
    UIAlertView *alert;
    
    if ([[eventNameTextField text] length] == 0) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                           message:@"What is the name of the event?"
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    else if ([[eventCategoryTextField text] length] == 0) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                           message:@"What is the event category?"
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    else if ([[eventLocationTextField text] length] == 0) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                           message:@"Where is the event going to be?"
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    else if ([[eventStartTimeTextField text] length] == 0) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                           message:@"When does the event start?"
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    else if ([[eventEndTimeTextField text] length] == 0) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec..." 
                                           message:@"When does the event end?"
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    else if ([startTime compare:endTime] != NSOrderedAscending){
        
        /* startTime and endTime are nil when they haven't been set by a datePicker*/
        /* This includes the case of editing an existing event*/
        
        if (startTime == nil || endTime == nil){
            [self performSegueWithIdentifier:@"updateEventDetailsToUpdateGuestList" sender:self];
            return;
        }
        
        alert = [[UIAlertView alloc] initWithTitle:@"Try again" 
                                           message:@"The event cannot end before it starts."
                                          delegate:nil 
                                 cancelButtonTitle:@"Okay" 
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self performSegueWithIdentifier:@"updateEventDetailsToUpdateGuestList" sender:self];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/* DATA PICKER DELEGATE & DATA SOURCE METHODS */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"Food";
    }
    
    else if (row == 1){
        return @"Get Together";
    }
    
    else if (row == 2){
        return @"Working Out";
    }
    else if (row == 3) {
        return @"Academics";
    }
    else {
        return @"Just Because";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *selectedCategory = [self pickerView:pickerView titleForRow:row forComponent:component];
    self.eventCategoryTextField.text = selectedCategory;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)cancelCreateEventButtonPressed:(id)sender 
{
    [self.eventNameTextField resignFirstResponder];
    [self.eventCategoryTextField resignFirstResponder];
    [self.eventLocationTextField resignFirstResponder];
    [self.eventStartTimeTextField resignFirstResponder];
    [self.eventEndTimeTextField resignFirstResponder];
    [self.eventDescriptionTextField resignFirstResponder];
}
@end
