//
//  InviteFriendCell.h
//  Glue
//
//  Created by Pietro Rea on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviteFriendCellDelegate <NSObject>

- (void) addToGuestList: (int) guestID;
- (void) removeFromGuestList: (int) guestID;

@end

@interface InviteFriendCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *friendName;
@property (nonatomic, strong) IBOutlet UISwitch *inviteFriendSwitch; 
@property (nonatomic) int friendUserID;
@property (nonatomic, strong) id <InviteFriendCellDelegate> delegate;

- (IBAction) changedInviteFriendSwitch:(id)sender;

@end


