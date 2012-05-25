//
//  SearchViewController.m
//  Glue
//
//  Created by Pietro Rea on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "SingletonUser.h"

SingletonUser *currentUser;
NSMutableArray *mutableArrayOfResults;

@interface SearchViewController ()

@end

@implementation SearchViewController

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
    currentUser = [SingletonUser sharedInstance];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [mutableArrayOfResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    User *potentialFriend = [mutableArrayOfResults objectAtIndex:indexPath.row];
    cell.textLabel.text = potentialFriend.fullName;
    cell.detailTextLabel.text = potentialFriend.email;
    
    // To implement: if a search result is already your friend, set the checkmark here.
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    User *newFriend = [mutableArrayOfResults objectAtIndex:indexPath.row];
    int newFriendID = newFriend.userid;
    
    int result = [currentUser addFriend:newFriendID];
    
    if (result == 1) {
        UITableViewCell *cell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Could not add friend, try again." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}

/* UISearchDisplayDelegate methods */
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{    
    [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:NO];
    UIButton *cancelButton;
    
    // Change the button's default "Cancel" text to "Done"
    for (UIView *subView in self.searchDisplayController.searchBar.subviews){
        if ([subView isKindOfClass:[UIButton class]]){
            cancelButton = (UIButton *) subView;
            [cancelButton setTitle:@"Done" forState:UIControlStateNormal];
        }
    }

}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return NO;
}

/* UISearchBar Delegate methods */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchQuery = self.searchDisplayController.searchBar.text;
    mutableArrayOfResults = [currentUser searchFriendsWithQuery:searchQuery];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchDisplayController setActive:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    mutableArrayOfResults = nil;
    [self.searchDisplayController.searchResultsTableView reloadData];
}

@end
