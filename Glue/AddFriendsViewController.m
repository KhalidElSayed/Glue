//
//  AddFriendsViewController.m
//  Glue
//
//  Created by Pietro Rea on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "InviteFriendCell.h"
#import "SingletonUser.h"
#import "User.h"

SingletonUser * currentUser;
NSMutableArray * mutableArrayOfFriends;
NSMutableArray * runningGuestList;
User * currentFriend;

@interface AddFriendsViewController ()

@end

@implementation AddFriendsViewController

@synthesize eventName;
@synthesize eventCategory;
@synthesize eventLocation; 
@synthesize eventStarTime; 
@synthesize eventEndTime; 
@synthesize eventDescription;

//For editing existing events
@synthesize currentGuestList;
@synthesize previousViewController;


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
    mutableArrayOfFriends = [currentUser getFriends];
    runningGuestList = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.previousViewController isEqualToString:@"CreateEventTableViewController"]){
        return @"Step 2: Update Guest List";
    }
    else {
        return @"Step 2: Invite Friends to Event";
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mutableArrayOfFriends.count;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    InviteFriendCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"InviteFriendCell"];
        
    if (cell == nil) {
        cell = [[InviteFriendCell alloc] init];
    }
    
    currentFriend = [mutableArrayOfFriends objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.friendUserID = currentFriend.userid;
    
    NSString *name = currentFriend.name;
    name = [name stringByAppendingString:@" "];
    NSString *nameField = [name stringByAppendingString:currentFriend.lastname];
        
    NSLog(@"nameField is %@", nameField);
    cell.friendName.text = nameField;
    return cell;
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

// Creates event in the server
- (IBAction)doneCreatingEvent:(id)sender {
    
    //Create event
    int eventID = [currentUser createEvent:eventName
                                ofCategory:eventCategory 
                                inLocation:eventLocation 
                          withStartingTime:eventStarTime 
                            withEndingTime:eventEndTime 
                           withDescription:eventDescription];
    
    //Add guests
    for (NSNumber * friendID in runningGuestList) {
        [currentUser addGuest:[friendID intValue] inEvent:eventID];
    }
    
    if ([self.previousViewController isEqualToString:@"CreateEventTableViewController"]){
        
        UIAlertView * eventCreatedAlert = [[UIAlertView alloc] 
                                           initWithTitle:@"Success!" 
                                           message:@"Your event has been updated." 
                                           delegate:self 
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil];
        
        [eventCreatedAlert show];
    }
    
    else {
        
        UIAlertView * eventCreatedAlert = [[UIAlertView alloc] 
                                           initWithTitle:@"Success!" 
                                           message:@"Your event has been created." 
                                           delegate:self 
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil];
        [eventCreatedAlert show];
        currentUser.shouldUpdateMyEvents = YES;
    }
    
    
}

- (void) addToGuestList: (int) guestID 
{
    NSLog(@"addToGuestList was called");
    NSNumber * guestIDNumber = [NSNumber numberWithInt:guestID];
    [runningGuestList addObject:guestIDNumber];
}

- (void) removeFromGuestList: (int) guestID 
{
    NSLog(@"removeFromGuestList was called");
    NSNumber * guestIDNumber = [NSNumber numberWithInt:guestID];
    [runningGuestList removeObject:guestIDNumber];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if ([self.previousViewController isEqualToString:@"CreateEventTableViewController"]){
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
}


@end
