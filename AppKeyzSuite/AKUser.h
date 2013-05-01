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

+ (AKUser*)shared;
- (void)saveSettings;
- (id)initWithUserFromPlistDict;

- (void)logout;
- (void)login;
- (void)inspect;
- (void)notRegister;
@end
