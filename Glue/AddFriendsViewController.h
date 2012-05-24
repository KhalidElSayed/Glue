//
//  AddFriendsViewController.h
//  Glue
//
//  Created by Pietro Rea on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteFriendCell.h"

@interface AddFriendsViewController : UITableViewController <InviteFriendCellDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *eventCategory;
@property (nonatomic, strong) NSString *eventLocation;
@property (nonatomic, strong) NSString *eventStarTime;
@property (nonatomic, strong) NSString *eventEndTime;
@property (nonatomic, strong) NSString *eventDescription;

- (IBAction)doneCreatingEvent:(id)sender;


@end
