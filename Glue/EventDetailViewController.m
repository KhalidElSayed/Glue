//
//  EventDetailViewController.m
//  Glue
//
//  Created by Pietro Rea on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventDetailViewController.h"
#import "CreateEventTableViewController.h"
#import "SingletonUser.h"

SingletonUser *currentUser;
NSMutableDictionary *guestListDictionary;
NSArray *guestListDictionaryKeys;

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

@synthesize previousUIView;

@synthesize eventID, eventName, eventCategory, eventLocation, eventEndTime, 
eventStartTime, eventDescription, eventGuestList, eventGuestListKeys;

@synthesize eventHost;

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
    guestListDictionary = [currentUser getGuests:self.eventID];
    guestListDictionaryKeys = [guestListDictionary allKeys];
    
    if ([self.previousUIView isEqualToString:@"MyEventsTableViewController"])
        [self addDeleteEventButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"eventDetailsToUpdateEvent"]) {
        NSLog(@"Going to Update Event");
        
        CreateEventTableViewController *vc = [segue destinationViewController];
        vc.eventName = self.eventName;
        vc.eventCategory = self.eventCategory;
        vc.eventLocation = self.eventLocation;
        vc.eventStartTime = self.eventStartTime;
        vc.eventEndTime = self.eventEndTime;
        vc.eventDescription = self.eventDescription;
        vc.currentEventGuestList = self.eventGuestList;
        
        vc.previousViewController = @"EventDetailViewController";
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) addDeleteEventButton
{
    UIButton * deleteEventButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIView * buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 50.0)];
    [deleteEventButton addTarget:self action:@selector(deleteThisEvent) forControlEvents:UIControlEventTouchDown];
    [deleteEventButton setTitle:@"Delete Event" forState:UIControlStateNormal];
    deleteEventButton.frame = CGRectMake(10.0, 0.0, self.tableView.frame.size.width - 20, 40.0);
    [buttonView addSubview:deleteEventButton];
    self.tableView.tableFooterView = buttonView;
    
    [deleteEventButton setBackgroundImage:[[UIImage imageNamed:@"redbuttonnew.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [deleteEventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void) deleteThisEvent
{
    UIAlertView *confirmAlert = [[UIAlertView alloc] 
                                 initWithTitle:@"Confirmation" 
                                 message:@"Are you sure you want to cancel this event?" 
                                 delegate:nil 
                                 cancelButtonTitle:@"Yes" 
                                 otherButtonTitles:@"No", nil];
    
    confirmAlert.delegate = self;
    [confirmAlert show];
    currentUser.shouldUpdateMyEvents = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == 0){
        [currentUser deleteEvent:self.eventID];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
        
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 
    if (section == 0 || section == 1)
        return @"Event Details";
    else 
        return @"Guest List";
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Section 1: Event Details
    //Section 2: Host + Response
    //Section 3: Guest List
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0){
        return 6;        
    }
    
    else if (section == 1){
        return 2;
    }
    else {
        return guestListDictionary.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1 
                reuseIdentifier: CellIdentifier];
    }

    
    if (indexPath.section == 0){
        
        if (indexPath.row == 0){
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.eventName;
        }
        
        if (indexPath.row == 1){
            cell.textLabel.text = @"Category";
            cell.detailTextLabel.text = self.eventCategory;
        }
        if (indexPath.row == 2){
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = self.eventLocation;
        }
        
        if (indexPath.row == 3){
            cell.textLabel.text = @"Start Time";
            cell.detailTextLabel.text = self.eventStartTime;
        }
        
        if (indexPath.row == 4){
            cell.textLabel.text = @"End Time";
            cell.detailTextLabel.text = self.eventEndTime;
        }
        
        if (indexPath.row == 5){
            cell.textLabel.text = @"Description";
            cell.detailTextLabel.text = self.eventDescription;
        }
                
    }
    
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0){
            cell.textLabel.text = @"Host";
            cell.detailTextLabel.text = self.eventHost;
        }
        
        if (indexPath.row == 1){
            cell.textLabel.text = @"Going?";
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            
            if ([self.previousUIView isEqualToString:@"MyEventsTableViewController"]){
                [switchView setOn:YES animated:NO];
                switchView.enabled = NO;
            }
            
            else {
                
                if ([currentUser amIGoingToEvent:self.eventID]){
                    NSLog(@"UISwitch is being turned on");
                    [switchView setOn:YES animated:NO];
                }
                else {
                    NSLog(@"UISwitch is being turned off");
                    [switchView setOn:NO animated:NO];
                }
            }
            
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        
    }
    
    else {
        
        cell.textLabel.text = [guestListDictionaryKeys objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [guestListDictionary objectForKey:[guestListDictionaryKeys objectAtIndex:indexPath.row]];
    }
    
    
    return cell;
}


- (void) switchChanged: (id)sender
{
    
    UISwitch* theSwitch = (UISwitch*) sender;
    
    BOOL theSwitchIsOn = theSwitch.on; //Represents the new state
    
    int result;
    if (theSwitchIsOn == YES){
        result = [currentUser updateResponse:YES forEvent:self.eventID];
    }
    else {
        result = [currentUser updateResponse:NO forEvent:self.eventID];
    }
    
}

#pragma mark - Table view delegate

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

- (IBAction)refreshEventDetailsButtonPressed:(id)sender {
    NSLog(@"refreshEventDetailsButton has been pressed");
    guestListDictionary = [currentUser getGuests:self.eventID];
    guestListDictionaryKeys = [guestListDictionary allKeys];
    [self.tableView reloadData];
}
@end
