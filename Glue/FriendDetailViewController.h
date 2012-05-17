//
//  FriendDetailViewController.h
//  Glue
//
//  Created by Pietro Rea on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FriendDetailViewController : UITableViewController

@property (nonatomic, strong) User * currentFriend;

@end
