//
//  User.m
//  Glue
//
//  Created by Pietro Rea on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

#import "User.h"

@implementation User

//static NSString * serverIP = @"http://23.23.223.158/";
static NSString *serverIP = @"https://www.ztbinmiyog.us/";
static NSString *sharedKey = @"okXRDgXqnDfyYK11nARRIdUy5xmuGsJi00DQuyzaGYY";

@synthesize userid;
@synthesize name;
@synthesize lastname;
@synthesize fullName;
@synthesize email;
@synthesize phone;

/* Custom init populates User properties */
- (User *) initWithUserID: (int) userID 
              andUserName: (NSString *) userName 
          andUserLastName: (NSString *) userLastName 
             andUserEmail: (NSString *) userEmail
             andUserPhone: (NSString *) userPhone {
    
    self = [super init];
    if (self){
        
        self.userid = userID;
        self.name = userName;
        self.lastname = userLastName;
        self.email = userEmail;
        self.phone = userPhone;
        
        NSString *firstAndLastName = [NSString stringWithFormat:@"%@ %@", self.name, self.lastname];
        self.fullName =  firstAndLastName;
    }
    
    return self;
}

@end
