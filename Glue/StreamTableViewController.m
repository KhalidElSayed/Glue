//
//  StreamTableViewController.m
//  Glue
//
//  Created by Pietro Rea on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StreamTableViewController.h"
#import "EventDetailViewController.h"
#import "SingletonUser.h"
#import "StreamCell.h"
#import "Event.h"

SingletonUser *currentUser;
NSMutableArray *mutableArrayOfInvitations;

@interface StreamTableViewController ()

@end

@implementation StreamTableViewController

- (IBAction)refreshStreamButtonPressed:(id)sender {
    mutableArrayOfInvitations = [currentUser getInvitations];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    EventDetailViewController *vc = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    StreamCell *selectedCell = (StreamCell *) [self.tableView cellForRowAtIndexPath:path];
    Event *selectedEvent = [mutableArrayOfInvitations objectAtIndex:path.row];
    
    vc.eventID  = selectedEvent.eventID;
    vc.eventName = selectedEvent.eventName;
    vc.eventCategory = selectedEvent.eventCategory;
    vc.eventLocation = selectedEvent.eventLocation;
    vc.eventHost = selectedCell.eventHost.text;
    vc.eventStartTime = selectedEvent.eventStartTime;
    vc.eventEndTime = selectedEvent.eventEndTime;
    vc.eventDescription = selectedEvent.eventDescription;
    vc.eventGuestList = selectedEvent.eventGuests;
    vc.eventGuestListKeys = [selectedEvent.eventGuests allKeys];
    vc.previousUIView = @"StreamTableViewController";
    
    [self.tableView deselectRowAtIndexPath:path animated:NO];
} 

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    mutableArrayOfInvitations = [currentUser getInvitations];
    [self.tableView reloadData];
}   

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 65;
    currentUser = [SingletonUser sharedInstance];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mutableArrayOfInvitations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StreamCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[StreamCell alloc] init];                
    }
    
    Event *myEvent = [mutableArrayOfInvitations objectAtIndex:indexPath.row];
    cell.eventName.text = myEvent.eventName;
    cell.eventHost.text = myEvent.eventHostFullName;
    //cell.eventHost.text = [currentUser getUserFullName:myEvent.eventHostID];
    cell.eventTime.text = myEvent.eventStartTime;
    
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

@end
