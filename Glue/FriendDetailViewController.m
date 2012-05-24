//
//  FriendDetailViewController.m
//  Glue
//
//  Created by Pietro Rea on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "StreamCell.h"
#import "SingletonUser.h"
#import "Event.h"
#import "User.h"

SingletonUser *currentUser;
NSMutableArray *myEventsWithFriend;


@interface FriendDetailViewController ()

@end

@implementation FriendDetailViewController

@synthesize currentFriend;

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
    myEventsWithFriend = [currentUser getAllEventsWithFriend:currentFriend.userid];
    
    [self addDeleteFriendButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) addDeleteFriendButton
{
    UIButton * deleteFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIView * buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 50.0)];
    [deleteFriendButton addTarget:self action:@selector(deleteThisFriend) forControlEvents:UIControlEventTouchDown];
    [deleteFriendButton setTitle:@"Delete Friend" forState:UIControlStateNormal];
    deleteFriendButton.frame = CGRectMake(10.0, 0.0, self.tableView.frame.size.width - 20, 40.0);
    [deleteFriendButton setBackgroundImage:[[UIImage imageNamed:@"redbuttonnew.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [deleteFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [buttonView addSubview:deleteFriendButton];
    self.tableView.tableFooterView = buttonView;
}

- (void) deleteThisFriend
{
    
    UIAlertView *confirmAlert = [[UIAlertView alloc] 
                                 initWithTitle:@"Confirmation" 
                                 message:@"Are you sure you want to delete this friend?" 
                                 delegate:self 
                                 cancelButtonTitle:@"Yes" 
                                 otherButtonTitles:@"No", nil];
    
    [confirmAlert show];
}

// UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == 0){
        [currentUser deleteFriend:currentFriend.userid];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (myEventsWithFriend.count == 0)
        return 1;
    else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 3;
    }
    else {
        NSLog(@"Number of events with this friend: %i", myEventsWithFriend.count);
        return myEventsWithFriend.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Section 1 contains Friends Details
    if (indexPath.section == 0 ) {
        
        static NSString *CellIdentifier = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue2
                    reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = currentFriend.fullName;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"E-mail";
            cell.detailTextLabel.text = currentFriend.email;
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"Phone";
            cell.detailTextLabel.text = currentFriend.phone;
    }
        
        return cell;
}
        
    
    //Section 2 contains events that this friend has invited me to
    else {
        
        static NSString *CellIdentifier = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:CellIdentifier];
        }
        
        Event *myEvent = [myEventsWithFriend objectAtIndex:indexPath.row];
        cell.textLabel.text = myEvent.eventName;
        cell.detailTextLabel.text = myEvent.eventStartTime;
     
        return cell;
        }
        
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Friend Details";
    }
    else {
        return @"Events with this friend";
    }
    
    return nil;
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

@end
