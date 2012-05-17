//
//  User.m
//  Glue
//
//  Created by Pietro Rea on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

static NSString * serverIP = @"http://23.23.223.158/";
static NSString * sharedKey = @"okXRDgXqnDfyYK11nARRIdUy5xmuGsJi00DQuyzaGYY";

@synthesize userid, name, lastname, email, phone;

/* This initialization method fills in every property */
- (User *) initWithUserID: (int) userID
{
    self.userid = userID;
    
    self = [super init];
    if (self){
        
        NSString *urlString = [serverIP stringByAppendingString:@"get_user?"];
        urlString = [urlString stringByAppendingFormat:@"userid=%i&key=%@", userid, sharedKey];
        NSLog(@"Get user urlString: %@", urlString);
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *json = [NSData dataWithContentsOfURL:url];
        
        NSDictionary *userDictionary = [NSJSONSerialization 
                                        JSONObjectWithData:json 
                                        options:NSJSONReadingMutableContainers 
                                        error:nil];
        
        self.name = [userDictionary objectForKey:@"name"];
        self.lastname = [userDictionary objectForKey:@"lastname"];
        self.email = [userDictionary objectForKey:@"email"];
    }
    
    return self;
}

- (User *) initWithUserID: (int) userID andUserName: (NSString *) userName 
          andUserLastName: (NSString *) userLastName andUserEmail: (NSString *) userEmail
             andUserPhone: (NSString *) userPhone {
    
    self = [super init];
    if (self){
        
        self.userid = userID;
        self.name = userName;
        self.lastname = userLastName;
        self.email = userEmail;
        self.phone = userPhone;
    }
    
    return self;
}

@end
