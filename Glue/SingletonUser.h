//
//  SingletonUser.h
//  Glue
//
//  Created by Pietro Rea on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//The SingletonUser class represents the user that is currently logged in.
//There is only one instance of the SingletonUser class at any given
//session. Most methods that call the server are implemented in this class.

#import <Foundation/Foundation.h>
#import "User.h"

@interface SingletonUser : NSObject

@property int userid;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSMutableDictionary *invitations;

@property (nonatomic)BOOL shouldUpdateMyEvents;
@property (nonatomic)BOOL shouldUpdateMyFriends;

// Returns SingletonUser instance that represents user currently logged in.
+ (SingletonUser *) sharedInstance;

// This method is called in SignupViewController.m to create a new user.
+ (SingletonUser *) initSharedInstanceWithEmail: (NSString *) userEmail 
                                    andPassword: (NSString *) userPassword;

// Creates event. Returns the event ID of the new event.
- (int) createEvent: (NSString *) eventName 
         ofCategory: (NSString *) eventCategory 
         inLocation: (NSString *) eventLocation 
   withStartingTime: (NSString *) eventStartTime 
     withEndingTime: (NSString *) eventEndingTime 
    withDescription: (NSString *) eventDescription;

// Deletes event with eventID.
- (void) deleteEvent: (int) eventID;

// Adds guest with guestID to event with eventID
- (void) addGuest: (int) guestID inEvent: (int) eventID;

// Returns NSMutableArray of User objects for users that matched searchQuery
- (NSMutableArray *) searchFriendsWithQuery: (NSString *) searchQuery;

// Add friend with friendID to the current user. Returns 1 if successful, 0 otherwise.
- (int) addFriend: (int) friendID;

// Delete friend with friendID from the current user.
- (void) deleteFriend: (int) friendID;

// Returns NSMutableArray populated with the current user's friends (User objects)
- (NSMutableArray *) getFriends;

// Returns NSMutableArray populated with the Events the current user has created
- (NSMutableArray *) getMyEvents;

// Returns NSMutableArray popualted with Events the current user has been invited to
- (NSMutableArray *) getInvitations;

// Returns NSMutableArray with Events current user has created and invited friend w/ userid guestID
- (NSMutableArray *) getMyEventsWithGuest: (int) guestID;

// Returns NSMutableArray with Events to which the current user has been invited to by friend w/ userid hostID
- (NSMutableArray *) getInvitationsFromHost: (int) hostID;

// Returns all Events that contain both the current User and friend w/ userid friendID
- (NSMutableArray *) getAllEventsWithFriend: (int) friendID;

// Returns (unsorted) NSMutableDictionary with guests for Event w/ eventID
- (NSMutableDictionary *) getGuests: (int) eventID;

- (BOOL) amIGoingToEvent: (int) eventID;

- (int) updateResponse: (BOOL) responseBoolean forEvent: (int) eventID;

- (int) updatePassword: (NSString *) newPassword;

- (int) updateUserDetailsWithFirstName: (NSString *) userFirstName 
                       andUserLastName: (NSString *) userLastName 
                          andUserEmail: (NSString *) userEmail 
                          andUserPhone: (NSString *) userPhone;

- (int) updateEventWithEventID: (int) eventID 
               andNewEventName: (NSString *) eventName 
           andNewEventCategory: (NSString *) eventCategory 
           andNewEventLocation: (NSString *) eventLocation 
          andNewEventStartTime: (NSString *) eventStartTime 
            andNewEventEndTime: (NSString *) eventEndTime 
        andNewEventDescription: (NSString *) eventDescriton;

@end
