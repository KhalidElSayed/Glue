//
//  StreamCell.h
//  Glue
//
//  Created by Pietro Rea on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

/* StreamCells are used in the "My Events" and the "Stream" tabs */

#import <UIKit/UIKit.h>

@interface StreamCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *eventName;
@property (nonatomic, strong) IBOutlet UILabel *eventHost;
@property (nonatomic, strong) IBOutlet UILabel *eventTime;

@end
