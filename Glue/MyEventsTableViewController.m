//
//  MyEventsTableViewController.m
//  Glue
//
//  Created by Pietro Rea on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyEventsTableViewController.h"
#import "EventDetailViewController.h"
#import "SingletonUser.h"
#import "StreamCell.h"
#import "Event.h"

SingletonUser *currentUser;
NSMutableArray *eventsMutableArray;

@interface MyEventsTableViewController ()

@end

@implementation MyEventsTableViewController

//createNewEventButton is called when the "+" button is pressed.
-(IBAction)createNewEventButton:(id)sender {
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    EventDetailViewController *vc = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Event *selectedEvent = [eventsMutableArray objectAtIndex:path.row];
    
    vc.eventID = selectedEvent.eventID;
    vc.eventName = selectedEvent.eventName;
    vc.eventCategory = selectedEvent.eventCategory;
    vc.eventLocation = selectedEvent.eventLocation;
    vc.eventHost = currentUser.fullName;
    vc.eventStartTime = selectedEvent.eventStartTime;
    vc.eventEndTime = selectedEvent.eventEndTime;
    vc.eventDescription = selectedEvent.eventDescription;
    vc.eventGuestList = selectedEvent.eventGuests;
    vc.eventGuestListKeys = [selectedEvent.eventGuests allKeys];
    vc.previousUIView = @"MyEventsTableViewController";
    
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
    currentUser = [SingletonUser sharedInstance];
    
    if (currentUser.shouldUpdateMyEvents == YES){
        eventsMutableArray = [currentUser getMyEvents];
        [self.tableView reloadData];
        currentUser.shouldUpdateMyEvents = NO;
    }
}    

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 65;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventsMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StreamCell *cell;    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[StreamCell alloc] init];
    }
    
    Event *myEvent = [eventsMutableArray objectAtIndex:indexPath.row];
    cell.eventName.text = myEvent.eventName;
    cell.eventHost.text = currentUser.fullName;
    cell.eventTime.text = myEvent.eventStartTime;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
