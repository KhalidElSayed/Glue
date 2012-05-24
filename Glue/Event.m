//
//  Event.m
//  Glue
//
//  Created by Pietro Rea on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize eventID;
@synthesize eventHostID;
@synthesize eventName;
@synthesize eventCategory;
@synthesize eventLocation;
@synthesize eventStartTime;
@synthesize eventEndTime;
@synthesize eventDescription;
@synthesize eventGuests;


/* Custom init populates Event properties */
- (Event *) initWithEventName: (NSString *) name 
                   andEventID: (int) eventid 
                    andHostID: (int) hostid 
             andEventCategory: (NSString *) category 
             andEventLocation: (NSString *) location
             andEventStarTime: (NSString *) starttime 
              andEventEndTime: (NSString *) endtime
           andEventDesription: (NSString *) description 
            andEventGuestList: (NSDictionary *) guestlist
{
    self = [super init];
    if (self) {
        
        self.eventName = name;
        self.eventID = eventid;
        self.eventHostID = hostid;
        self.eventCategory = category;
        self.eventLocation = location;
        self.eventStartTime = starttime;
        self.eventEndTime = endtime;
        self.eventDescription = description;
        self.eventGuests = guestlist;
        
    }
    return self;
}

/* Compare method used in sorting "My Events" and "Stream" tab. */
- (NSComparisonResult) compare: (Event *)otherEvent
{
    if (self.eventID == otherEvent.eventID){
        return NSOrderedSame;
    }
    else if (self.eventID > otherEvent.eventID){
        return NSOrderedAscending;
    }
    else {
        return NSOrderedDescending;
    }
}

@end
