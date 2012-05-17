//
//  SingletonUser.h
//  Glue
//
//  Created by Pietro Rea on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface SingletonUser : NSObject

@property int userid;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * lastname;
@property (nonatomic, strong) NSString * fullName;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSArray * friends;
@property (nonatomic, strong) NSMutableDictionary * invitations;
@property (nonatomic, strong) NSArray * events;

@property (nonatomic)BOOL shouldUpdateMyEvents;
@property (nonatomic)BOOL shouldUpdateMyFriends;

+ (SingletonUser *) initSharedInstanceWithEmail: (NSString *) userEmail andPassword: (NSString *) userPassword;

+ (SingletonUser *) sharedInstance;

- (int) addFriend: (int) friendID;

- (NSMutableArray *) getFriends;

- (NSMutableArray *) getMyEvents;

- (NSMutableArray *) getMyEventsWithGuest: (int) guestID;

- (NSMutableArray *) getInvitations;

- (NSMutableArray *) getInvitationsFromHost: (int) hostID;

- (NSMutableArray *) getAllEventsWithFriend: (int) friendID;

- (int) createEvent: (NSString *) eventName ofCategory: (NSString *) eventCategory inLocation: (NSString *) eventLocation withStartingTime: (NSString *) eventStartTime withEndingTime: (NSString *) eventEndingTime withDescription: (NSString *) eventDescription;

- (void) deleteEvent: (int) eventID;

- (void) addGuest: (int) guestID inEvent: (int) eventID;

- (NSMutableDictionary *) getGuests: (int) eventID;

- (NSString *) getUserFullName: (int) userID;

- (void) deleteFriend: (int) friendID;

- (NSMutableArray *) searchFriendsWithQuery: (NSString *) searchQuery;

- (BOOL) amIGoingToEvent: (int) eventID;

- (int) updateResponse: (BOOL) responseBoolean forEvent: (int) eventID;

- (int) updatePassword: (NSString *) newPassword;

- (int) updateUserDetailsWithFirstName: (NSString *) userFirstName andUserLastName: (NSString *) userLastName andUserEmail: (NSString *) userEmail andUserPhone: (NSString *) userPhone;

- (int) updateEventWithEventID: (int) eventID andNewEventName: (NSString *) eventName andNewEventCategory: (NSString *) eventCategory andNewEventLocation: eventLocation andNewEventStartTime: (NSString *) eventStartTime andNewEventEndTime: (NSString *) eventEndTime andNewEventDescription: (NSString *) eventDescriton;


@end
