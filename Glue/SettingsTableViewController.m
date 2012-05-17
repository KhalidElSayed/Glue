//
//  SettingsTableViewController.m
//  Glue
//
//  Created by Pietro Rea on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "UpdateUserViewController.h"
#import "SingletonUser.h"

SingletonUser *currentUser;

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

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
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentUser = [SingletonUser sharedInstance];
    [self addUpdatePassworddButton];

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Account Details";
    else {
        return @"Reset Password";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString * CellIdentifier = @"Cell";
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
                                      reuseIdentifier:CellIdentifier];
        
    }
    
    if (indexPath.section == 0){
        
        if (indexPath.row == 0){
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = currentUser.fullName;
        }
        
        if (indexPath.row == 1){
            cell.textLabel.text = @"E-mail";
            cell.detailTextLabel.text = currentUser.email;
        }
        
        if (indexPath.row == 2){
            cell.textLabel.text = @"Phone";
            cell.detailTextLabel.text = currentUser.phone;
        }
        
    }
    
    return cell;
}


- (void) addUpdatePassworddButton
{
    UIButton * updatePasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIView * buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 50.0)];
    
    [updatePasswordButton addTarget:self action:@selector(updatePasswordButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    [updatePasswordButton setTitle:@"Update Password" forState:UIControlStateNormal];
    updatePasswordButton.frame = CGRectMake(10.0, 0.0, self.tableView.frame.size.width - 20, 40.0);
//    [updatePasswordButton setBackgroundImage:[[UIImage imageNamed:@"redbuttonnew.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//    
//    [updatePasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [buttonView addSubview:updatePasswordButton];
    self.tableView.tableFooterView = buttonView;
}

- (void) updatePasswordButtonPressed
{
    [self performSegueWithIdentifier:@"settingsToUpdatePassword" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

- (IBAction)logOutButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"logOutToLogIn" 
                              sender:self];
}
@end
