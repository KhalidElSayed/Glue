//
//  SingletonUser.m
//  Glue
//
//  Created by Pietro Rea on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingletonUser.h"
#import "User.h"
#import "Event.h"

@implementation SingletonUser
//static NSString * serverIP = @"http://23.23.223.158/";
static NSString * serverIP = @"https://www.ztbinmiyog.us/";
static NSString * sharedKey = @"okXRDgXqnDfyYK11nARRIdUy5xmuGsJi00DQuyzaGYY";

@synthesize userid, token, name,lastname, fullName, email, phone, friends, invitations, events;
@synthesize shouldUpdateMyEvents, shouldUpdateMyFriends;

static SingletonUser * sharedInstance = nil;

+ (SingletonUser *) initSharedInstanceWithEmail: (NSString *) userEmail andPassword: (NSString *) userPassword {
    
    sharedInstance = [[super allocWithZone:NULL]
                      initWithUserEmail:userEmail 
                      andUserPassword:userPassword];    
    return sharedInstance;
}

+ (SingletonUser *) sharedInstance
{
    /* Should never be caleld before init method */
    return sharedInstance;
}

/* Does not work with incorrect user or password*/
/* Fills in token, name, lastname, e-mail - leaves everything else nil */
- (SingletonUser *) initWithUserEmail: (NSString *) userEmail andUserPassword: (NSString *) userPassword
{
    NSString * urlString = [serverIP stringByAppendingString:@"login?"];
    urlString = [urlString stringByAppendingFormat:@"email=%@&password=%@", userEmail, userPassword];
    NSURL * url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    
    self.token = [NSString stringWithContentsOfURL:url 
                                          encoding:NSUTF8StringEncoding 
                                             error:&error];
    
    urlString = [serverIP stringByAppendingString:@"get_self?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@", self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString: %@", urlString);
    url = [NSURL URLWithString:urlString];
    
    NSData *json = [NSData dataWithContentsOfURL:url];
    
    //json returns nil when get_self failed to authenticate
    if (json == nil)
        return nil;
    
    NSDictionary *userDictionary = [NSJSONSerialization 
                                    JSONObjectWithData:json 
                                    options:NSJSONReadingMutableContainers 
                                    error:nil];
    
    self.userid = [[userDictionary objectForKey:@"userid"] intValue];
    self.name = [userDictionary objectForKey:@"name"];
    self.lastname = [userDictionary objectForKey:@"lastname"];
    self.fullName = [NSString stringWithFormat:@"%@ %@", self.name, self.lastname];
    self.email = [userDictionary objectForKey:@"email"];
    self.phone = [userDictionary objectForKey:@"phone"];
    self.friends = [userDictionary objectForKey:@"friends"];
    self.invitations = [userDictionary objectForKey:@"invitations"];
    self.events = [userDictionary objectForKey:@"events"];
    
    NSLog(@"self.phone is %@", self.phone);
    
    self.shouldUpdateMyEvents = YES;
    self.shouldUpdateMyFriends = YES;
    
    return self;
}

/* Returns 1 if successful, 0 otherwise */
- (int) addFriend: (int) friendID 
{
    NSLog(@"addFriend was called");
    NSString * urlString = [serverIP stringByAppendingString:@"add_friends?"];
    urlString = [urlString stringByAppendingFormat:@"friendids=%i&token=%@", friendID, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSError *error = nil;
    NSString * urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    if ([urlResponse isEqualToString:@"yes"]) {
        NSLog(@"Added friend with userID %i", friendID);
        self.shouldUpdateMyFriends = YES;
        return 1;
    }
    else {
        NSLog(@"Could not add friend with userID %i", friendID);
        return 0;
    }
    
    return 0;
}

- (NSMutableArray *) getFriends
{
    
    NSLog(@"getFriends was called");
    NSMutableArray * mutableArrayOfFriends = [[NSMutableArray alloc] init];
    
    NSString * urlString = [serverIP stringByAppendingString:@"get_friends?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@", self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString: %@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * json = [NSData dataWithContentsOfURL:url];
    NSDictionary * friendsDictionary = [NSJSONSerialization
                                       JSONObjectWithData:json
                                       options:NSJSONReadingMutableContainers 
                                       error:nil];
    
    
    NSArray * friendsDictionaryKeys = [friendsDictionary allKeys];
    for (int i = 0; i < friendsDictionary.count; i++) {

        NSDictionary *friend = [friendsDictionary objectForKey:[friendsDictionaryKeys objectAtIndex:i]];
        User *currentFriend = [[User alloc] initWithUserID:[[friend objectForKey:@"userid"] intValue]
                                               andUserName:[friend objectForKey:@"name"]
                                           andUserLastName:[friend objectForKey:@"lastname"]
                                              andUserEmail:[friend objectForKey:@"email"] 
                                              andUserPhone:[friend objectForKey:@"phone"]];
        
        [mutableArrayOfFriends addObject:currentFriend];
    }
    
    return mutableArrayOfFriends;
}

- (NSMutableArray *) getMyEvents
{
    NSLog(@"getMyEvents was called");
    NSMutableArray * mutableArrayOfEvents = [[NSMutableArray alloc] init];
    
    NSString * urlString = [serverIP stringByAppendingString:@"get_my_events?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@", self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString: %@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * json = [NSData dataWithContentsOfURL:url];
    NSDictionary * eventsDictionary = [NSJSONSerialization
                      JSONObjectWithData:json
                      options:NSJSONReadingMutableContainers 
                      error:nil];
    
    
    NSArray * eventDictionaryKeys = [eventsDictionary allKeys];
    for (int i = 0; i < eventsDictionary.count; i++) {
        
        NSDictionary *event = [eventsDictionary objectForKey:[eventDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"]
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]  
                                                     andHostID:[[event objectForKey:@"hostid"] intValue]
                                              andEventCategory:[event objectForKey:@"category"]
                                              andEventLocation:[event objectForKey:@"location"]
                                              andEventStarTime:[event objectForKey:@"starttime"]
                                               andEventEndTime:[event objectForKey:@"endtime"]
                                            andEventDesription:[event objectForKey:@"description"]
                                             andEventGuestList:[event objectForKey:@"guests"]];
        
        [mutableArrayOfEvents addObject:currentEvent];
    }
    
    NSMutableArray *sortedEventsArray = (NSMutableArray *)[mutableArrayOfEvents sortedArrayUsingSelector:@selector(compare:)];
    return sortedEventsArray;
}

- (NSMutableArray *) getMyEventsWithGuest: (int) guestID
{
    NSLog(@"getMyEventsWithGuest was called");
    NSMutableArray * mutableArrayOfEvents = [[NSMutableArray alloc] init];
    
    NSString * urlString = [serverIP stringByAppendingString:@"get_my_events?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@&guestid=%i", self.token, guestID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString: %@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * json = [NSData dataWithContentsOfURL:url];
    NSDictionary * eventsDictionary = [NSJSONSerialization
                                       JSONObjectWithData:json
                                       options:NSJSONReadingMutableContainers 
                                       error:nil];
    
    
    NSArray * eventDictionaryKeys = [eventsDictionary allKeys];
    for (int i = 0; i < eventsDictionary.count; i++) {
        
        NSDictionary *event = [eventsDictionary objectForKey:[eventDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"]
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]  
                                                     andHostID:[[event objectForKey:@"hostid"] intValue]
                                              andEventCategory:[event objectForKey:@"category"]
                                              andEventLocation:[event objectForKey:@"location"]
                                              andEventStarTime:[event objectForKey:@"starttime"]
                                               andEventEndTime:[event objectForKey:@"endtime"]
                                            andEventDesription:[event objectForKey:@"description"]
                                             andEventGuestList:[event objectForKey:@"guests"]];
        
        
        [mutableArrayOfEvents addObject:currentEvent];
    }
    
    return mutableArrayOfEvents;
}


- (NSMutableArray *) getInvitations
{
    
    NSLog(@"getMyInvitations was called");
    NSMutableArray * mutableArrayOfInvitations = [[NSMutableArray alloc] init];
    
    NSString * urlString = [serverIP stringByAppendingString:@"get_my_invitations?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@", self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString: %@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * json = [NSData dataWithContentsOfURL:url];
    NSDictionary * invitationsDictionary = [NSJSONSerialization
                                       JSONObjectWithData:json
                                       options:NSJSONReadingMutableContainers 
                                       error:nil];
    
    
    NSArray * invitationsDictionaryKeys = [invitationsDictionary allKeys];
    for (int i = 0; i < invitationsDictionary.count; i++) {
        
        NSDictionary *event = [invitationsDictionary objectForKey:[invitationsDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"] 
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]
                                                     andHostID:[[event objectForKey:@"hostid"] intValue]
                                              andEventCategory:[event objectForKey:@"category"]
                                              andEventLocation:[event objectForKey:@"location"]
                                              andEventStarTime:[event objectForKey:@"starttime"]
                                               andEventEndTime:[event objectForKey:@"endtime"]
                                            andEventDesription:[event objectForKey:@"description"]
                                             andEventGuestList:[event objectForKey:@"guests"]];
        
        
        NSLog(@"Full host name is %@", [event objectForKey:@"hostname"]);
        [mutableArrayOfInvitations addObject:currentEvent];
    }
    
    NSMutableArray *sortedInvitationsArray = (NSMutableArray *)[mutableArrayOfInvitations sortedArrayUsingSelector:@selector(compare:)];
    return sortedInvitationsArray;
}

- (NSMutableArray *) getInvitationsFromHost: (int) hostID
{
    
    NSLog(@"getMyInvitationsFromHost was called");
    NSMutableArray * mutableArrayOfInvitations = [[NSMutableArray alloc] init];
    
    NSString * urlString = [serverIP stringByAppendingString:@"get_my_invitations?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@&hostid=%i", self.token, hostID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString: %@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * json = [NSData dataWithContentsOfURL:url];
    NSDictionary * invitationsDictionary = [NSJSONSerialization
                                            JSONObjectWithData:json
                                            options:NSJSONReadingMutableContainers 
                                            error:nil];
    
    
    NSArray * invitationsDictionaryKeys = [invitationsDictionary allKeys];
    for (int i = 0; i < invitationsDictionary.count; i++) {
        
        NSDictionary *event = [invitationsDictionary objectForKey:[invitationsDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"] 
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]
                                                     andHostID:[[event objectForKey:@"hostid"] intValue]
                                              andEventCategory:[event objectForKey:@"category"]
                                              andEventLocation:[event objectForKey:@"location"]
                                              andEventStarTime:[event objectForKey:@"starttime"]
                                               andEventEndTime:[event objectForKey:@"endtime"]
                                            andEventDesription:[event objectForKey:@"description"]
                                             andEventGuestList:[event objectForKey:@"guests"]];
        
        
        [mutableArrayOfInvitations addObject:currentEvent];
    }
    
    return mutableArrayOfInvitations;
}

//Returns mutable array with all events + invitations from friend
- (NSMutableArray *) getAllEventsWithFriend: (int) friendID{
    
    NSLog(@"getAllEventsWithFriend was called");
    NSMutableArray * mutableArrayOfEvents = [[NSMutableArray alloc] init];
    
    NSString * urlString = [serverIP stringByAppendingString:@"get_my_events?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@&guestid=%i", self.token, friendID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString: %@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * json = [NSData dataWithContentsOfURL:url];
    NSDictionary * eventsDictionary = [NSJSONSerialization
                                       JSONObjectWithData:json
                                       options:NSJSONReadingMutableContainers 
                                       error:nil];
    
    
    NSArray * eventDictionaryKeys = [eventsDictionary allKeys];
    for (int i = 0; i < eventsDictionary.count; i++) {
        
        NSDictionary *event = [eventsDictionary objectForKey:[eventDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"]
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]  
                                                     andHostID:[[event objectForKey:@"hostid"] intValue]
                                              andEventCategory:[event objectForKey:@"category"]
                                              andEventLocation:[event objectForKey:@"location"]
                                              andEventStarTime:[event objectForKey:@"starttime"]
                                               andEventEndTime:[event objectForKey:@"endtime"]
                                            andEventDesription:[event objectForKey:@"description"]
                                             andEventGuestList:[event objectForKey:@"guests"]];
        
        [mutableArrayOfEvents addObject:currentEvent];
    }
    
    
    urlString = [serverIP stringByAppendingString:@"get_my_invitations?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@&hostid=%i", self.token, friendID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString: %@", urlString);
    
    url = [NSURL URLWithString:urlString];
    json = [NSData dataWithContentsOfURL:url];
    NSDictionary * invitationsDictionary = [NSJSONSerialization
                                            JSONObjectWithData:json
                                            options:NSJSONReadingMutableContainers 
                                            error:nil];
    
    
    NSArray * invitationsDictionaryKeys = [invitationsDictionary allKeys];
    for (int i = 0; i < invitationsDictionary.count; i++) {
        
        NSDictionary *event = [invitationsDictionary objectForKey:[invitationsDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"] 
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]
                                                     andHostID:[[event objectForKey:@"hostid"] intValue]
                                              andEventCategory:[event objectForKey:@"category"]
                                              andEventLocation:[event objectForKey:@"location"]
                                              andEventStarTime:[event objectForKey:@"starttime"]
                                               andEventEndTime:[event objectForKey:@"endtime"]
                                            andEventDesription:[event objectForKey:@"description"]
                                             andEventGuestList:[event objectForKey:@"guests"]];
        
        
        [mutableArrayOfEvents addObject:currentEvent];
    }
    
    return mutableArrayOfEvents;
}

- (int) createEvent: (NSString *) eventName ofCategory: (NSString *) eventCategory inLocation: (NSString *) eventLocation withStartingTime: (NSString *) eventStartTime withEndingTime: (NSString *) eventEndingTime withDescription: (NSString *) eventDescription 
{
    NSString * urlString = [serverIP stringByAppendingString:@"create_event?"];
    urlString = [urlString stringByAppendingFormat:@"name=%@&category=%@&location=%@&starttime=%@&endtime=%@&description=%@&token=%@", eventName, eventCategory, eventLocation, eventStartTime, eventEndingTime, eventDescription, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * json = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *eventDictionary = [NSJSONSerialization 
                                    JSONObjectWithData:json 
                                    options:NSJSONReadingMutableContainers 
                                    error:nil];
    
    int eventID = [[eventDictionary objectForKey:@"eventid"] intValue];
    
    NSLog(@"Event has been created! Event ID is %i", eventID);
    return eventID;
}

- (void) deleteEvent: (int) eventID{
    
    NSString * urlString = [serverIP stringByAppendingString:@"remove_event?"];
    urlString = [urlString stringByAppendingFormat:@"eventid=%i&token=%@", eventID, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString * urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    NSLog(@"%@", urlString);
    NSLog(@"Server response: %@", urlResponse);
    NSLog(@"Removed event %i", eventID);
}

- (void) addGuest: (int) guestID inEvent: (int) eventID
{
    NSString * urlString = [serverIP stringByAppendingString:@"add_guests?"];
    urlString = [urlString stringByAppendingFormat:@"eventid=%i&token=%@&guestids=%i", eventID, self.token, guestID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    
    NSString * urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    NSLog(@"Server response: %@", urlResponse);
    NSLog(@"urlString: %@", urlString);
    NSLog(@"Added guest %i", guestID);
}


/* The key is the guest's full name and the value is "ATTENDING" or "NOT ATTENDING" */
- (NSMutableDictionary *) getGuests: (int) eventID
{
    
    NSLog(@"getGuests was called");
    NSMutableDictionary * guestsDictionaryResult = [[NSMutableDictionary alloc] init];
    
    NSString * urlString = [serverIP stringByAppendingString:@"get_guests?"];
    urlString = [urlString stringByAppendingFormat:@"eventid=%i&token=%@", eventID, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString: %@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * json = [NSData dataWithContentsOfURL:url];
    NSDictionary * guestsDictionary = [NSJSONSerialization
                                            JSONObjectWithData:json
                                            options:NSJSONReadingMutableContainers 
                                            error:nil];
    
    
    NSArray * guestsDictionaryKeys = [guestsDictionary allKeys];
    for (int i = 0; i < guestsDictionary.count; i++) {
        
        NSDictionary *userInfo = [guestsDictionary objectForKey:[guestsDictionaryKeys objectAtIndex:i]];
        NSString *userFirstName = [userInfo objectForKey:@"name"];
        NSString *userLastName = [userInfo objectForKey:@"lastname"];
        NSString *userFullName = [NSString stringWithFormat:@"%@ %@", userFirstName, userLastName];
       
        NSDictionary *userInvitations = [userInfo objectForKey:@"invitations"];
        NSString *eventIDString = [NSString stringWithFormat:@"%i", eventID];
        NSString *userResponse = [userInvitations objectForKey:eventIDString];
        
        if ([userResponse isEqualToString:@"yes"]){
            [guestsDictionaryResult setObject:@"ATTENDING" forKey:userFullName];
        }
        
        else if ([userResponse isEqualToString:@"no"]){
            [guestsDictionaryResult setObject:@"NOT ATTENDING" forKey:userFullName];
        }
        
    }
    
    return guestsDictionaryResult;
    
}

/* Makes it slow */
- (NSString *) getUserFullName: (int) userID
{
    NSString * urlString = [serverIP stringByAppendingString:@"get_user?"];
    urlString = [urlString stringByAppendingFormat:@"userid=%i&key=%@", userID, sharedKey];
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * json = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *userDictionary = [NSJSONSerialization 
                                    JSONObjectWithData:json 
                                    options:NSJSONReadingMutableContainers 
                                    error:nil];
    
    NSString * firstName = [userDictionary objectForKey:@"name"];
    NSString * lastName = [userDictionary objectForKey:@"lastname"];
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
}

- (void) deleteFriend: (int) friendID
{
    NSString * urlString = [serverIP stringByAppendingString:@"remove_friends?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@&friendids=%i", self.token, friendID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString * urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    self.shouldUpdateMyFriends = YES;

    NSLog(@"urlString: %@", urlString);
    NSLog(@"Added guest %i", friendID);
    NSLog(@"Server response: %@", urlResponse);
}

- (NSMutableArray *) searchFriendsWithQuery: (NSString *) searchQuery
{
    NSLog(@"searchFriendsWithQuery was called");
    NSMutableArray * mutableArrayOfResults = [[NSMutableArray alloc] init];
    
    NSString * urlString = [serverIP stringByAppendingString:@"search_users?"];
    urlString = [urlString stringByAppendingFormat:@"q=%@&key=%@", searchQuery, sharedKey];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString: %@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * json = [NSData dataWithContentsOfURL:url];
    NSDictionary * friendsDictionary =      [NSJSONSerialization
                                            JSONObjectWithData:json
                                            options:NSJSONReadingMutableContainers 
                                            error:nil];
    
    
    NSArray * friendsDictionaryKeys = [friendsDictionary allKeys];
    for (int i = 0; i < friendsDictionary.count; i++) {
        
        NSDictionary *friend = [friendsDictionary objectForKey:[friendsDictionaryKeys objectAtIndex:i]];
        
        int friendUserID = [[friend objectForKey:@"userid"] intValue];
        NSString *friendFirstName = [friend objectForKey:@"name"];
        NSString *friendLastName = [friend objectForKey:@"lastname"];
        NSString *friendEmail = [friend objectForKey:@"email"];
        NSString *friendPhone = [friend objectForKey:@"phone"];
        
        User *potentialFriend = [[User alloc] initWithUserID:friendUserID 
                                                 andUserName:friendFirstName 
                                             andUserLastName:friendLastName 
                                                andUserEmail:friendEmail 
                                                andUserPhone:friendPhone];
        
        
        NSLog(@"Potential friend: %@ %@", friendFirstName, friendLastName);
        [mutableArrayOfResults addObject:potentialFriend];
    }
    
    return mutableArrayOfResults;
    
}

- (BOOL) amIGoingToEvent: (int) eventID
{
    NSString *eventIDString = [NSString stringWithFormat:@"%i", eventID];
    NSString *currentResponse = [self.invitations objectForKey:eventIDString];
    
    if ([currentResponse isEqualToString:@"yes"]){
        return YES;
    }
    else {
        return NO;
    }
}

- (int) updateResponse: (BOOL) responseBoolean forEvent: (int) eventID
{
    NSLog(@"updateResponse was called");
    NSString *updatedResponse;
    if (responseBoolean == YES){
        updatedResponse = @"yes";
    }
    else {
        updatedResponse = @"no";
    }
    
    NSString * urlString = [serverIP stringByAppendingString:@"update_response?"];
    urlString = [urlString stringByAppendingFormat:@"eventid=%i&response=%@&token=%@", eventID, updatedResponse, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString * urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    if ([urlResponse isEqualToString:@"yes"]) {
        NSLog(@"Response was updated!");
        
        /* Update local copy of invitations dictionary */
        NSString *eventIDString = [NSString stringWithFormat:@"%i", eventID];
        if (responseBoolean == YES)
            [self.invitations setObject:@"yes" forKey:eventIDString];
        else
            [self.invitations setObject:@"no" forKey:eventIDString];
        
        return 1;
    }
    else {
        NSLog(@"Error: Response was not updated");
        return 0;
    }
    
    return 0;
}

- (int) updatePassword: (NSString *) newPassword
{
    NSString * urlString = [serverIP stringByAppendingString:@"update_user?"];
    urlString = [urlString stringByAppendingFormat:@"password=%@&token=%@", newPassword, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString: %@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString * urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    if ([urlResponse isEqualToString:@"yes"]){
        NSLog(@"Password has been changed successfully");
        return 1;
    }
    
    else if ([urlResponse isEqualToString:@"User already exists"]){
        NSLog(@"Error: User already exists");
        return 2;
    }
    
    else {
        NSLog(@"Error: Password could not be changed");
        return 0;
    }
    
    
    return 0;
}

- (int) updateUserDetailsWithFirstName: (NSString *) userFirstName andUserLastName: (NSString *) userLastName andUserEmail: (NSString *) userEmail andUserPhone: (NSString *) userPhone
{
    NSString * urlString = [serverIP stringByAppendingString:@"update_user?"];
    urlString = [urlString stringByAppendingFormat:@"name=%@&lastname=%@&email=%@&phone=%@&token=%@", userFirstName, userLastName, userEmail, userPhone, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString: %@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString * urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    if ([urlResponse isEqualToString:@"yes"]){
        NSLog(@"User details have been updated successfully");
        return 1;
    }
    
    else if ([urlResponse isEqualToString:@"User already exists"]){
        NSLog(@"Error: User already exists");
        return 2;
    }
    
    else {
        NSLog(@"Error: User details could not be changed");
        return 0;
    }
    
    return 0;
}

- (int) updateEventWithEventID: (int) eventID andNewEventName: (NSString *) eventName andNewEventCategory: (NSString *) eventCategory andNewEventLocation: eventLocation andNewEventStartTime: (NSString *) eventStartTime andNewEventEndTime: (NSString *) eventEndTime andNewEventDescription: (NSString *) eventDescriton
{
// Need to implement
    return 1;
}

@end
