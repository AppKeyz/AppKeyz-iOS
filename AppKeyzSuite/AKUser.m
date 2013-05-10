//
//  AKUser.m
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/28/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import "AKUser.h"

static AKUser* sUser;

@implementation AKUser
@synthesize userNameFirst, userNameLast, userEmail, userPassword, uniqueId, isLoggedIn, latitude, longitude, active, didNotRegister, deviceId;
//Optional fields
@synthesize gender, age, custom1, custom2, custom3, custom4, custom5, custom6;

+(AKUser*)shared
{
    if (sUser==nil)
        sUser = [[AKUser alloc] initWithUserFromPlistDict];
    
    [sUser inspect];
    
    return sUser;
}

- (id)initWithUserFromPlistDict
{
    self = [super init];
    
    self.userNameFirst = @"";
    self.userNameLast = @"";
    self.userEmail = @"";
    self.userPassword = @"";
    self.uniqueId = @"";
    self.isLoggedIn = NO;
    self.latitude = @"";
    self.longitude = @"";
    self.active = NO;
    self.didNotRegister = false;
    self.deviceId = @"";
    self.gender = @"";
    self.age = @"";
    
    self.custom1 = self.custom2 = self.custom3 = self.custom4 = self.custom5 = self.custom6 = @"";
    
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/User.plist"];
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    if ([userDict objectForKey:@"userNameFirst"]!=nil) self.userNameFirst = [userDict objectForKey:@"userNameFirst"];
    if ([userDict objectForKey:@"userNameLast"]!=nil) self.userNameLast = [userDict objectForKey:@"userNameLast"];
    if ([userDict objectForKey:@"userEmail"]!=nil) self.userEmail = [userDict objectForKey:@"userEmail"];
    if ([userDict objectForKey:@"userPassword"]!=nil) self.userPassword = [userDict objectForKey:@"userPassword"];
    self.isLoggedIn = [[userDict objectForKey:@"isLoggedIn"] boolValue];
    self.active = [[userDict objectForKey:@"active"] boolValue];
    self.didNotRegister = [[userDict objectForKey:@"didNotRegister"] boolValue];
    if ([userDict objectForKey:@"uniqueId"]!=nil) self.uniqueId = [userDict objectForKey:@"uniqueId"];
    if ([userDict objectForKey:@"latitude"]!=nil) self.latitude = [userDict objectForKey:@"latitude"];
    if ([userDict objectForKey:@"longitude"]!=nil) self.longitude = [userDict objectForKey:@"longitude"];
    if ([userDict objectForKey:@"deviceId"]!=nil) self.deviceId = [userDict objectForKey:@"deviceId"];
    if ([userDict objectForKey:@"gender"]!=nil) self.gender = [userDict objectForKey:@"gender"];
    if ([userDict objectForKey:@"age"]!=nil) self.age = [userDict objectForKey:@"age"];
    return self;
}

- (void) saveSettings
{
    NSString* plistPath = nil;
    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if ((plistPath = [documentsDirectory stringByAppendingPathComponent:@"User.plist"]))
    {
        if ([manager isWritableFileAtPath:plistPath])
        {
            NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            
            if (self.userNameFirst!=nil) [userDict setObject:self.userNameFirst forKey:@"userNameFirst"];
            if (self.userNameLast!=nil) [userDict setObject:self.userNameLast forKey:@"userNameLast"];
            if (self.userEmail!=nil) [userDict setObject:self.userEmail forKey:@"userEmail"];
            if (self.userPassword!=nil) [userDict setObject:self.userPassword forKey:@"userPassword"];
            [userDict setObject:[NSNumber numberWithBool:self.isLoggedIn] forKey:@"isLoggedIn"];
            [userDict setObject:[NSNumber numberWithBool:self.active] forKey:@"active"];
            [userDict setObject:[NSNumber numberWithBool:self.didNotRegister] forKey:@"didNotRegister"];
            if (self.uniqueId!=nil) [userDict setObject:self.uniqueId forKey:@"uniqueId"];
            if (self.latitude!=nil) [userDict setObject:self.latitude forKey:@"latitude"];
            if (self.longitude!=nil) [userDict setObject:self.longitude forKey:@"longitude"];
            if (self.deviceId!=nil) [userDict setObject:self.deviceId forKey:@"deviceId"];
            if (self.gender!=nil) [userDict setObject:self.gender forKey:@"gender"];
            if (self.age!=nil) [userDict setObject:self.age forKey:@"deviceId"];
            
            [userDict writeToFile:plistPath atomically:YES];
            [manager setAttributes:[NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate] ofItemAtPath:NSHomeDirectory() error:nil];
        }
    }
    
}

- (void)logout
{
    self.isLoggedIn = NO;
    self.userNameFirst = @"";
    self.userNameLast = @"";
    self.userEmail = @"";
    self.userPassword = @"";
    self.latitude = @"";
    self.longitude = @"";
    self.active = NO;
    self.didNotRegister = false;
    self.uniqueId = @"";
    self.gender = @"";
    self.age = @"";
    [self saveSettings];
}

- (void)login
{
    self.isLoggedIn = YES;
    [self saveSettings];
}

- (void)notRegister
{
    self.isLoggedIn = YES;
    self.didNotRegister = true;
    [self saveSettings];
}

-(void)inspect
{
    NSMutableDictionary* inspectDict = NSMutableDictionary.new;
    [inspectDict setObject:self.userNameFirst forKey:@"userNameFirst"];
    [inspectDict setObject:self.userNameLast forKey:@"userNameLast"];
    [inspectDict setObject:self.userEmail forKey:@"userEmail"];
    [inspectDict setObject:self.userPassword forKey:@"userPassword"];
    [inspectDict setObject:self.uniqueId forKey:@"uniqueId"];
    NSString* loggedIn = self.isLoggedIn ? @"TRUE" : @"FALSE";
    [inspectDict setObject:loggedIn forKey:@"isLoggedIn"];
    NSString* isActive = self.active ? @"TRUE" : @"FALSE";
    [inspectDict setObject:isActive forKey:@"active"];
    NSString* noRegister = self.didNotRegister ? @"TRUE" : @"FALSE";
    [inspectDict setObject:noRegister forKey:@"notRegistered"];
    [inspectDict setObject:self.latitude forKey:@"latitude"];
    [inspectDict setObject:self.longitude forKey:@"longitude"];
    [inspectDict setObject:self.deviceId forKey:@"deviceId"];
    [inspectDict setObject:self.age forKey:@"age"];
    [inspectDict setObject:self.gender forKey:@"gender"];

    
    NSLog(@"%@",inspectDict);
}

@end
