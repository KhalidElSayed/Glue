//
//  InviteFriendCell.m
//  Glue
//
//  Created by Pietro Rea on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//InviteFriendCells are used in the second step of creating a new
//event. They allow you to invite a friend using a UISwitch (On/Off)

#import "InviteFriendCell.h"

@implementation InviteFriendCell

@synthesize friendName;
@synthesize friendUserID;
@synthesize inviteFriendSwitch;
@synthesize delegate;

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

/* This private method is called whenever UISwitch changes value. */
- (IBAction) changedInviteFriendSwitch:(id)sender
{

    UISwitch *inviteSwitch = (UISwitch *) sender;
    
    if (inviteSwitch.on){
        [self.delegate addToGuestList:self];
    }
    
    else {
        [self.delegate removeFromGuestList:self];
    }
    
}

@end
