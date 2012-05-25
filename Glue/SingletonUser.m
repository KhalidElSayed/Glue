//
//  SingletonUser.m
//  Glue
//
//  Created by Pietro Rea on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//The SingletonUser class represents the user that is currently logged in.
//There is only one instance of the SingletonUser class at any given
//session. Most methods that call the server are implemented in this class.


#import "SingletonUser.h"
#import "User.h"
#import "Event.h"

//static NSString * serverIP = @"http://23.23.223.158/";
static NSString * serverIP = @"https://www.ztbinmiyog.us/";
static NSString * sharedKey = @"okXRDgXqnDfyYK11nARRIdUy5xmuGsJi00DQuyzaGYY";

@implementation SingletonUser

@synthesize userid;
@synthesize token;
@synthesize name;
@synthesize lastname;
@synthesize fullName;
@synthesize email;
@synthesize phone;
@synthesize friends;
@synthesize invitations;
@synthesize events;
@synthesize shouldUpdateMyEvents;
@synthesize shouldUpdateMyFriends;

static SingletonUser *sharedInstance = nil;


// Returns SingletonUser instance that represents user currently logged in.
+ (SingletonUser *) sharedInstance
{
    return sharedInstance;
}

// This method is called in SignupViewController.m to create a new user.
+ (SingletonUser *) initSharedInstanceWithEmail: (NSString *) userEmail 
                                    andPassword: (NSString *) userPassword {
    
    sharedInstance = [[super allocWithZone:NULL]
                      initWithUserEmail:userEmail 
                      andUserPassword:userPassword];
    
    return sharedInstance;
}

// Private method
- (SingletonUser *) initWithUserEmail: (NSString *) userEmail andUserPassword: (NSString *) userPassword
{
    NSString *urlString = [serverIP stringByAppendingString:@"login?"];
    urlString = [urlString stringByAppendingFormat:@"email=%@&password=%@", userEmail, userPassword];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    
    self.token = [NSString stringWithContentsOfURL:url 
                                          encoding:NSUTF8StringEncoding 
                                             error:&error];
    
    urlString = [serverIP stringByAppendingString:@"get_self?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@", self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    
    self.shouldUpdateMyEvents = YES;
    self.shouldUpdateMyFriends = YES;
    
    return self;
}

// Creates event. Returns the event ID of the new event.
- (int) createEvent: (NSString *) eventName ofCategory: (NSString *) eventCategory 
         inLocation: (NSString *) eventLocation 
   withStartingTime: (NSString *) eventStartTime 
     withEndingTime: (NSString *) eventEndingTime 
    withDescription: (NSString *) eventDescription 
{
    NSString *urlString = [serverIP stringByAppendingString:@"create_event?"];
    urlString = [urlString stringByAppendingFormat:@"name=%@&category=%@&location=%@&starttime=%@&endtime=%@&description=%@&token=%@", eventName, eventCategory, eventLocation, eventStartTime, eventEndingTime, eventDescription, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *json = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *eventDictionary = [NSJSONSerialization 
                                     JSONObjectWithData:json 
                                     options:NSJSONReadingMutableContainers 
                                     error:nil];
    
    int eventID = [[eventDictionary objectForKey:@"eventid"] intValue];
    return eventID;
}

// Deletes event with eventID.
- (void) deleteEvent: (int) eventID{    
    NSString *urlString = [serverIP stringByAppendingString:@"remove_event?"];
    urlString = [urlString stringByAppendingFormat:@"eventid=%i&token=%@", eventID, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString *urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    // Change return value to an integer & delete NSLog
    NSLog(@"Server response: %@", urlResponse);
}

// Adds guest with guestID to event with eventID
- (void) addGuest: (int) guestID inEvent: (int) eventID
{
    NSString *urlString = [serverIP stringByAppendingString:@"add_guests?"];
    urlString = [urlString stringByAppendingFormat:@"eventid=%i&token=%@&guestids=%i", eventID, self.token, guestID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    
    NSString *urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    // Change return value to an integer & delete NSLog
    NSLog(@"Server response: %@", urlResponse);
}

// Returns NSMutableArray of User objects for users that matched searchQuery
- (NSMutableArray *) searchFriendsWithQuery: (NSString *) searchQuery
{
    NSMutableArray * mutableArrayOfResults = [[NSMutableArray alloc] init];
    
    NSString *urlString = [serverIP stringByAppendingString:@"search_users?"];
    urlString = [urlString stringByAppendingFormat:@"q=%@&key=%@", searchQuery, sharedKey];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary *friendsDictionary =      [NSJSONSerialization
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
        
        [mutableArrayOfResults addObject:potentialFriend];
    }
    return mutableArrayOfResults;
}

// Add friend with friendID to the current user. Returns 1 if successful, 0 otherwise.
- (int) addFriend: (int) friendID 
{
    NSString *urlString = [serverIP stringByAppendingString:@"add_friends?"];
    urlString = [urlString stringByAppendingFormat:@"friendids=%i&token=%@", friendID, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSError *error = nil;
    NSString *urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    if ([urlResponse isEqualToString:@"yes"]) {
        self.shouldUpdateMyFriends = YES;
        return 1;
    }
    else {
        return 0;
    }
    
    return 0;
}

// Delete friend with friendID from the current user.
- (void) deleteFriend: (int) friendID
{
    NSString *urlString = [serverIP stringByAppendingString:@"remove_friends?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@&friendids=%i", self.token, friendID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString *urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    self.shouldUpdateMyFriends = YES;
    
    // Change return value to an integer & delete NSLog
    NSLog(@"Server response: %@", urlResponse);
}

// Returns NSMutableArray populated with the current user's friends (User objects)
- (NSMutableArray *) getFriends
{
    NSMutableArray *mutableArrayOfFriends = [[NSMutableArray alloc] init];
    
    NSString *urlString = [serverIP stringByAppendingString:@"get_friends?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@", self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary *friendsDictionary = [NSJSONSerialization
                                       JSONObjectWithData:json
                                       options:NSJSONReadingMutableContainers 
                                       error:nil];
    
    NSArray *friendsDictionaryKeys = [friendsDictionary allKeys];
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

// Returns NSMutableArray populated with the Events the current user has created
- (NSMutableArray *) getMyEvents
{
    NSMutableArray *mutableArrayOfEvents = [[NSMutableArray alloc] init];
    
    NSString *urlString = [serverIP stringByAppendingString:@"get_my_events?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@", self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary *eventsDictionary = [NSJSONSerialization
                      JSONObjectWithData:json
                      options:NSJSONReadingMutableContainers 
                      error:nil];
    
    NSArray *eventDictionaryKeys = [eventsDictionary allKeys];
    for (int i = 0; i < eventsDictionary.count; i++) {
        
        NSDictionary *event = [eventsDictionary objectForKey:[eventDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"]
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]  
                                                     andHostID:[[event objectForKey:@"hostid"] intValue] 
                                          andEventHostFullName: self.fullName
                                              andEventCategory:[event objectForKey:@"category"]
                                              andEventLocation:[event objectForKey:@"location"]
                                              andEventStarTime:[event objectForKey:@"starttime"]
                                               andEventEndTime:[event objectForKey:@"endtime"]
                                            andEventDesription:[event objectForKey:@"description"]
                                             andEventGuestList:[event objectForKey:@"guests"]];
        
        [mutableArrayOfEvents addObject:currentEvent];
    }
    
    // Sort NSMutableArray by eventID (latest events appear first) before returning
    NSMutableArray *sortedEventsArray = (NSMutableArray *)[mutableArrayOfEvents sortedArrayUsingSelector:@selector(compare:)];
    return sortedEventsArray;
}

// Returns NSMutableArray popualted with Events the current user has been invited to
- (NSMutableArray *) getInvitations
{
    NSMutableArray *mutableArrayOfInvitations = [[NSMutableArray alloc] init];
    
    NSString *urlString = [serverIP stringByAppendingString:@"get_my_invitations?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@", self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary *invitationsDictionary = [NSJSONSerialization
                                           JSONObjectWithData:json
                                           options:NSJSONReadingMutableContainers 
                                           error:nil];
    
    NSArray *invitationsDictionaryKeys = [invitationsDictionary allKeys];
    for (int i = 0; i < invitationsDictionary.count; i++) {
        
        NSDictionary *event = [invitationsDictionary objectForKey:[invitationsDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"] 
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]
                                                     andHostID:[[event objectForKey:@"hostid"] intValue] 
                                          andEventHostFullName:[event objectForKey:@"hostname"]
                                              andEventCategory:[event objectForKey:@"category"]
                                              andEventLocation:[event objectForKey:@"location"]
                                              andEventStarTime:[event objectForKey:@"starttime"]
                                               andEventEndTime:[event objectForKey:@"endtime"]
                                            andEventDesription:[event objectForKey:@"description"]
                                             andEventGuestList:[event objectForKey:@"guests"]];
        
        [mutableArrayOfInvitations addObject:currentEvent];
    }
    
    // Sort NSMutableArray by eventID (latest events appear first) before returning
    NSMutableArray *sortedInvitationsArray = (NSMutableArray *)[mutableArrayOfInvitations sortedArrayUsingSelector:@selector(compare:)];
    return sortedInvitationsArray;
}

// Returns NSMutableArray with Events current user has created and invited friend w/ userid guestID
- (NSMutableArray *) getMyEventsWithGuest: (int) guestID
{
    NSMutableArray *mutableArrayOfEvents = [[NSMutableArray alloc] init];
    
    NSString *urlString = [serverIP stringByAppendingString:@"get_my_events?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@&guestid=%i", self.token, guestID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString:urlString];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary *eventsDictionary = [NSJSONSerialization
                                       JSONObjectWithData:json
                                       options:NSJSONReadingMutableContainers 
                                       error:nil];
    
    NSArray *eventDictionaryKeys = [eventsDictionary allKeys];
    for (int i = 0; i < eventsDictionary.count; i++) {
        
        NSDictionary *event = [eventsDictionary objectForKey:[eventDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"]
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]  
                                                     andHostID:[[event objectForKey:@"hostid"] intValue] 
                                          andEventHostFullName:[event objectForKey:@"hostname"]
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

// Returns NSMutableArray with Events to which the current user has been invited to by friend w/ userid hostID
- (NSMutableArray *) getInvitationsFromHost: (int) hostID
{
    NSMutableArray *mutableArrayOfInvitations = [[NSMutableArray alloc] init];
    
    NSString *urlString = [serverIP stringByAppendingString:@"get_my_invitations?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@&hostid=%i", self.token, hostID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary * invitationsDictionary = [NSJSONSerialization
                                            JSONObjectWithData:json
                                            options:NSJSONReadingMutableContainers 
                                            error:nil];
    
    NSArray *invitationsDictionaryKeys = [invitationsDictionary allKeys];
    for (int i = 0; i < invitationsDictionary.count; i++) {
        
        NSDictionary *event = [invitationsDictionary objectForKey:[invitationsDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"] 
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]
                                                     andHostID:[[event objectForKey:@"hostid"] intValue]
                                          andEventHostFullName:[event objectForKey:@"hostname"]
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

// Returns all Events that contain both the current User and friend w/ userid friendID
- (NSMutableArray *) getAllEventsWithFriend: (int) friendID
{
    NSMutableArray *mutableArrayOfEvents = [[NSMutableArray alloc] init];
    
    // Step 1: Get events I have created with friendID
    NSString *urlString = [serverIP stringByAppendingString:@"get_my_events?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@&guestid=%i", self.token, friendID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary *eventsDictionary = [NSJSONSerialization
                                       JSONObjectWithData:json
                                       options:NSJSONReadingMutableContainers 
                                       error:nil];
    
    NSArray *eventDictionaryKeys = [eventsDictionary allKeys];
    for (int i = 0; i < eventsDictionary.count; i++) {
        
        NSDictionary *event = [eventsDictionary objectForKey:[eventDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"]
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]  
                                                     andHostID:[[event objectForKey:@"hostid"] intValue]
                                          andEventHostFullName:[event objectForKey:@"hostname"]
                                              andEventCategory:[event objectForKey:@"category"]
                                              andEventLocation:[event objectForKey:@"location"]
                                              andEventStarTime:[event objectForKey:@"starttime"]
                                               andEventEndTime:[event objectForKey:@"endtime"]
                                            andEventDesription:[event objectForKey:@"description"]
                                             andEventGuestList:[event objectForKey:@"guests"]];
        
        [mutableArrayOfEvents addObject:currentEvent];
    }
    
    // Step 2: Get events I have been invited to by friendID
    urlString = [serverIP stringByAppendingString:@"get_my_invitations?"];
    urlString = [urlString stringByAppendingFormat:@"token=%@&hostid=%i", self.token, friendID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [NSURL URLWithString:urlString];
    json = [NSData dataWithContentsOfURL:url];
    NSDictionary *invitationsDictionary = [NSJSONSerialization
                                            JSONObjectWithData:json
                                            options:NSJSONReadingMutableContainers 
                                            error:nil];
    
    NSArray *invitationsDictionaryKeys = [invitationsDictionary allKeys];
    for (int i = 0; i < invitationsDictionary.count; i++) {
        
        NSDictionary *event = [invitationsDictionary objectForKey:[invitationsDictionaryKeys objectAtIndex:i]];
        Event *currentEvent = [[Event alloc] initWithEventName:[event objectForKey:@"name"] 
                                                    andEventID:[[event objectForKey:@"eventid"] intValue]
                                                     andHostID:[[event objectForKey:@"hostid"] intValue]
                                          andEventHostFullName:[event objectForKey:@"hostname"]
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

// Returns (unsorted) NSMutableDictionary with guests for Event w/ eventID
- (NSMutableDictionary *) getGuests: (int) eventID
{
    NSMutableDictionary *guestsDictionaryResult = [[NSMutableDictionary alloc] init];
    
    NSString *urlString = [serverIP stringByAppendingString:@"get_guests?"];
    urlString = [urlString stringByAppendingFormat:@"eventid=%i&token=%@", eventID, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary *guestsDictionary = [NSJSONSerialization
                                            JSONObjectWithData:json
                                            options:NSJSONReadingMutableContainers 
                                            error:nil];
    
    NSArray *guestsDictionaryKeys = [guestsDictionary allKeys];
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
    return NO;
}

- (int) updateResponse: (BOOL) responseBoolean forEvent: (int) eventID
{
    NSString *updatedResponse;
    if (responseBoolean == YES){
        updatedResponse = @"yes";
    }
    else {
        updatedResponse = @"no";
    }
    
    NSString *urlString = [serverIP stringByAppendingString:@"update_response?"];
    urlString = [urlString stringByAppendingFormat:@"eventid=%i&response=%@&token=%@", eventID, updatedResponse, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString *urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    if ([urlResponse isEqualToString:@"yes"]) {
        
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
    NSString *urlString = [serverIP stringByAppendingString:@"update_user?"];
    urlString = [urlString stringByAppendingFormat:@"password=%@&token=%@", newPassword, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString *urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    if ([urlResponse isEqualToString:@"yes"]){
        return 1;
    }
    
    else if ([urlResponse isEqualToString:@"User already exists"]){
        NSLog(@"User already exists"); 
        return 2;
    }
    
    else {
        NSLog(@"Server error");
        return 0;
    }
    
    return 0;
}

- (int) updateUserDetailsWithFirstName: (NSString *) userFirstName andUserLastName: (NSString *) userLastName andUserEmail: (NSString *) userEmail andUserPhone: (NSString *) userPhone
{
    NSString *urlString = [serverIP stringByAppendingString:@"update_user?"];
    urlString = [urlString stringByAppendingFormat:@"name=%@&lastname=%@&email=%@&phone=%@&token=%@", userFirstName, userLastName, userEmail, userPhone, self.token];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString *urlResponse = [NSString stringWithContentsOfURL:url 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:&error];
    
    if ([urlResponse isEqualToString:@"yes"]){
        return 1;
    }
    
    else if ([urlResponse isEqualToString:@"User already exists"]){
        return 2;
    }
    
    else {
        NSLog(@"Server error");
        return 0;
    }
    
    return 0;
}

- (int) updateEventWithEventID: (int) eventID 
               andNewEventName: (NSString *) eventName 
           andNewEventCategory: (NSString *) eventCategory 
           andNewEventLocation: (NSString *) eventLocation 
          andNewEventStartTime: (NSString *) eventStartTime 
            andNewEventEndTime: (NSString *) eventEndTime 
        andNewEventDescription: (NSString *) eventDescriton
{
// Need to implement
    return 1;
}

@end
