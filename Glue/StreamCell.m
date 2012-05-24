//
//  StreamCell.m
//  Glue
//
//  Created by Pietro Rea on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

/* StreamCells are used in the "My Events" and the "Stream" tabs */

#import "StreamCell.h"

@implementation StreamCell

@synthesize eventName;
@synthesize eventHost;
@synthesize eventTime;

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

@end
