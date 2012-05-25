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

SingletonUser *currentUser;
NSMutableArray *mutableArrayOfFriends;
NSMutableArray *runningGuestList;
NSMutableArray *UISwitchStates;
User *currentFriend;

@interface AddFriendsViewController ()

@end

@implementation AddFriendsViewController

@synthesize eventName;
@synthesize eventCategory;
@synthesize eventLocation; 
@synthesize eventStarTime; 
@synthesize eventEndTime; 
@synthesize eventDescription;

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
    
    UISwitchStates = [NSMutableArray arrayWithCapacity:mutableArrayOfFriends.count];
    for (int i = 0; i < mutableArrayOfFriends.count; i++){
        NSNumber *noObj = [NSNumber numberWithBool:NO];
        [UISwitchStates insertObject:noObj atIndex:i];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Step 2: Invite Friends to Event";
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
    
    InviteFriendCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"InviteFriendCell"];
        
    if (cell == nil) {
        cell = [[InviteFriendCell alloc] init];
    }
    
    currentFriend = [mutableArrayOfFriends objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.friendUserID = currentFriend.userid;
    cell.friendName.text = currentFriend.fullName;
    cell.tag = indexPath.row;
    
    //Set UISwitch according to global NSMutableArray UISwitchStates
    BOOL state = [[UISwitchStates objectAtIndex:indexPath.row] boolValue];
    [cell.inviteFriendSwitch setOn:state animated:NO];
    
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
    
    UIAlertView * eventCreatedAlert = [[UIAlertView alloc] 
                                       initWithTitle:@"Success!" 
                                       message:@"Your event has been created." 
                                       delegate:self 
                                       cancelButtonTitle:@"OK" 
                                       otherButtonTitles:nil];
    [eventCreatedAlert show];
    currentUser.shouldUpdateMyEvents = YES;
    
}

- (void) addToGuestList: (id) sender 
{
    InviteFriendCell *selectedCell = (InviteFriendCell*) sender;
    NSNumber *guestIDNumber = [NSNumber numberWithInt:selectedCell.friendUserID];
    
    NSNumber *yesObj = [NSNumber numberWithBool:YES];
    [UISwitchStates insertObject:yesObj atIndex:selectedCell.tag];
    [runningGuestList addObject:guestIDNumber];
}

- (void) removeFromGuestList: (id) sender 
{
    InviteFriendCell *selectedCell = (InviteFriendCell*) sender;
    NSNumber *guestIDNumber = [NSNumber numberWithInt:selectedCell.friendUserID];
    
    NSNumber *noObj = [NSNumber numberWithBool:NO];
    [UISwitchStates insertObject:noObj atIndex:selectedCell.tag];
    [runningGuestList removeObject:guestIDNumber];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
}


@end
