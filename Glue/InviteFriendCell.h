//
//  InviteFriendCell.h
//  Glue
//
//  Created by Pietro Rea on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//InviteFriendCells are used in the second step of creating a new
//event. They allow you to invite a friend using a UISwitch (On/Off)

#import <UIKit/UIKit.h>

@protocol InviteFriendCellDelegate <NSObject>

- (void) addToGuestList: (id) sender;
- (void) removeFromGuestList: (id) sender;

@end

@interface InviteFriendCell : UITableViewCell

@property (nonatomic) int friendUserID;
@property (nonatomic, strong) IBOutlet UILabel *friendName;
@property (nonatomic, strong) IBOutlet UISwitch *inviteFriendSwitch; 
@property (nonatomic, strong) id <InviteFriendCellDelegate> delegate;

@end


