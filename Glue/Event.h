//
//  Event.h
//  Glue
//
//  Created by Pietro Rea on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic) int eventID;
@property (nonatomic) int eventHostID;
@property (nonatomic, strong) NSString * eventName;
@property (nonatomic, strong) NSString * eventCategory;
@property (nonatomic, strong) NSString * eventLocation;
@property (nonatomic, strong) NSString * eventStartTime;
@property (nonatomic, strong) NSString * eventEndTime;
@property (nonatomic, strong) NSString * eventDescription;
@property (nonatomic, strong) NSDictionary * eventGuests;

- (Event *) initWithEventID: (int) eventid;

- (Event *) initWithEventName: (NSString *) name andEventID: (int) eventid andHostID: (int) hostid 
             andEventCategory: (NSString *) category andEventLocation: (NSString *) location
             andEventStarTime: (NSString *) starttime andEventEndTime: (NSString *) endtime
           andEventDesription: (NSString *) description andEventGuestList: (NSDictionary *) guestlist;

@end
