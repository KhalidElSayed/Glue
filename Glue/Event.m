//
//  Event.m
//  Glue
//
//  Created by Pietro Rea on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
#import "SingletonUser.h"

SingletonUser *currentUser;
static NSString * serverIP = @"http://23.23.223.158/";

@implementation Event

@synthesize eventID, eventHostID, eventName, eventCategory, eventLocation, 
            eventStartTime, eventEndTime, eventDescription, eventGuests;

- (Event *) initWithEventID: (int) eventid
{
    self.eventID = eventid;
    SingletonUser * currentUser = [SingletonUser sharedInstance];
    
    self = [super init];
    if (self) {
        
        NSString *urlString = [serverIP stringByAppendingString:@"get_event?"];
        urlString = [urlString stringByAppendingFormat:@"eventid=%i&token=%@", eventid, currentUser.token];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *json = [NSData dataWithContentsOfURL:url];
        
        /* Error handling */
        if (json == nil)
            return nil;
        
        /* Only print strings of non-nil events */
        if (json != nil)
            NSLog(@"Get event urlString: %@", urlString);
        
        NSDictionary *eventDictionary = [NSJSONSerialization 
                                        JSONObjectWithData:json 
                                        options:NSJSONReadingMutableContainers 
                                        error:nil];
        
        self.eventHostID = [[eventDictionary objectForKey:@"hostid"] intValue];
        self.eventName = [eventDictionary objectForKey:@"name"];
        self.eventCategory = [eventDictionary objectForKey:@"category"];
        self.eventLocation = [eventDictionary objectForKey:@"location"];
        self.eventStartTime = [eventDictionary objectForKey:@"starttime"];
        self.eventEndTime = [eventDictionary objectForKey:@"endtime"];
        self.eventDescription = [eventDictionary objectForKey:@"description"];
        self.eventGuests = [eventDictionary objectForKey:@"guests"];

    }
    
    return self;
}

- (Event *) initWithEventName: (NSString *) name andEventID: (int) eventid andHostID: (int) hostid 
             andEventCategory: (NSString *) category andEventLocation: (NSString *) location
             andEventStarTime: (NSString *) starttime andEventEndTime: (NSString *) endtime
           andEventDesription: (NSString *) description andEventGuestList: (NSDictionary *) guestlist
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
