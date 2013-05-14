//
//  AppKeyzSuite.h
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/28/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKiPhoneLandingVC.h"
#import "AKiPhoneLoginRegisterVC.h"

@interface AppKeyzSuite : NSObject  {
    UIViewController* viewController;
}
@property(strong) UIViewController* viewController;

+(void)loadLoginScheme:(UIViewController*)vc;
+(void)editUser:(UIViewController*)vc;
+(void)logout:(UIViewController*)vc;
+(void)setupUserPlist;
+(void)setRegisterFields:(NSArray*)array;

@end
