//
//  AKUser.h
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/28/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKUser : NSObject {
    NSString* userNameFirst;
    NSString* userNameLast;
    NSString* userEmail;
    NSString* userPassword;
    NSString* latitude;
    NSString* longitude;
    NSString* uniqueId;
    BOOL active;
    BOOL didNotRegister;
    BOOL isLoggedIn;
    NSString* deviceId;
    NSString* gender;
    NSString* age;
    NSString* custom1;
    NSString* custom2;
    NSString* custom3;
    NSString* custom4;
    NSString* custom5;
    NSString* custom6;
}
@property (strong) NSString* userNameFirst;
@property (strong) NSString* userNameLast;
@property (strong) NSString* userEmail;
@property (strong) NSString* userPassword;
@property (strong) NSString* uniqueId;
@property (strong) NSString* latitude;
@property (strong) NSString* longitude;
@property (assign) BOOL active;
@property (assign) BOOL isLoggedIn;
@property (assign) BOOL didNotRegister;
@property (strong) NSString* deviceId;
@property (strong) NSString* gender;
@property (strong) NSString* age;
@property (strong) NSString* custom1;
@property (strong) NSString* custom2;
@property (strong) NSString* custom3;
@property (strong) NSString* custom4;
@property (strong) NSString* custom5;
@property (strong) NSString* custom6;

+ (AKUser*)shared;
- (void)saveSettings;
- (id)initWithUserFromPlistDict;

- (void)logout;
- (void)login;
- (void)inspect;
- (void)notRegister;
@end
