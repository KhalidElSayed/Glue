//
//  FriendsTableViewController.m
//  Glue
//
//  Created by Pietro Rea on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "FriendDetailViewController.h"
#import "SingletonUser.h"
#import "User.h"

SingletonUser *currentUser;
User *currentFriend;
NSMutableArray *friendsMutableArray;

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"friendTableToFriendDetail"]){
        FriendDetailViewController *detailedView = [segue destinationViewController];
        NSIndexPath *path  = [self.tableView indexPathForSelectedRow];
        User *f = [friendsMutableArray objectAtIndex:path.row];
        detailedView.currentFriend = f;
        
        [self.tableView deselectRowAtIndexPath:path animated:NO];
    }
    
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
    friendsMutableArray = [currentUser getFriends];
}

- (void)viewWillAppear:(BOOL)animated{
    currentUser = [SingletonUser sharedInstance];
    
    if (currentUser.shouldUpdateMyFriends == YES){
        friendsMutableArray = [currentUser getFriends];
        [self.tableView reloadData];
        currentUser.shouldUpdateMyFriends = NO;
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friendsMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    currentFriend = [friendsMutableArray objectAtIndex:indexPath.row];    
    cell.textLabel.text = currentFriend.fullName;
    return cell;
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
