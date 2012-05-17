//
//  InviteFriendCell.m
//  Glue
//
//  Created by Pietro Rea on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InviteFriendCell.h"

@implementation InviteFriendCell

@synthesize friendName;
@synthesize friendUserID;
@synthesize inviteFriendSwitch;
@synthesize delegate;

//@synthesize friendName, friendUserID, inviteFriendSegmentedControl, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction) changedInviteFriendSwitch:(id)sender
{

    UISwitch *inviteSwitch = (UISwitch *) sender;
    
    if (inviteSwitch.on){
        NSLog(@"The switch has turned ON");
        NSLog(@"The friendId is %i", friendUserID);
        [self.delegate addToGuestList:friendUserID];
    }
    
    else {
        NSLog(@"The switch has turned OFF");
        NSLog(@"The friendId is %i", friendUserID);
        [self.delegate removeFromGuestList:friendUserID];
    }
    
}

@end
