//
//  EventDetailViewController.h
//  Glue
//
//  Created by Pietro Rea on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *previousUIView;

@property (nonatomic) int eventID;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *eventCategory;
@property (nonatomic, strong) NSString *eventLocation;
@property (nonatomic, strong) NSString *eventHost;
@property (nonatomic, strong) NSString *eventStartTime;
@property (nonatomic, strong) NSString *eventEndTime;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSDictionary *eventGuestList;
@property (nonatomic, strong) NSArray *eventGuestListKeys;

- (IBAction)refreshEventDetailsButtonPressed:(id)sender;

@end
