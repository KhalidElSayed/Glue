//
//  User.h
//  Glue
//
//  Created by Pietro Rea on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property int userid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;

/* Custom init populates User properties */
- (User *) initWithUserID: (int) userID 
              andUserName: (NSString *) userName 
          andUserLastName: (NSString *) userLastName 
             andUserEmail: (NSString *) userEmail
             andUserPhone: (NSString *) userPhone;

@end
