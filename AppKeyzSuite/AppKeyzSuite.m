//
//  AppKeyzSuite.m
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/28/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import "AppKeyzSuite.h"

@implementation AppKeyzSuite
@synthesize viewController;

-(id) init
{
    return self;
}

+(void)setRegisterFields:(NSArray*)array
{
    [AppKeyz shared].registerFields = [NSArray arrayWithArray:array];
}


+(void)setupUserPlist
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destinationPath = [documentsDirectory stringByAppendingPathComponent:@"User.plist"];
    
    if ([NSDictionary dictionaryWithContentsOfFile:destinationPath]==nil) {
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"User.plist"];
        
        NSError *error = nil;
        if([[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error]){
            NSLog(@"File successfully copied");
        } else {
            NSLog(@"Error description-%@ \n", [error localizedDescription]);
            NSLog(@"Error reason-%@", [error localizedFailureReason]);
        }
        
    }
}

+(void)loadLoginScheme:(UIViewController*)vc
{
    //self.viewController = vc;
    if ([AKUser shared].isLoggedIn==false) {
        AKiPhoneLandingVC* landing = [[AKiPhoneLandingVC alloc] initWithNibName:@"AKiPhoneLandingVC" bundle:nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            landing = [[AKiPhoneLandingVC alloc] initWithNibName:@"AKiPadLandingVC" bundle:nil];
            
        }
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:landing];
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [vc presentModalViewController:navController animated:false];
    }
}

+(void)editUser:(UIViewController*)vc
{
        AKiPhoneLandingVC* landing = [[AKiPhoneLandingVC alloc] initWithNibName:@"AKiPhoneLandingVC" bundle:nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            landing = [[AKiPhoneLandingVC alloc] initWithNibName:@"AKiPadLandingVC" bundle:nil];
            
        }
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:landing];
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [vc presentModalViewController:navController animated:true];
}

+(void)logout:(UIViewController*)vc
{
    if ([AKUser shared].isLoggedIn==true) {
        [[AKUser shared] logout];
        AKiPhoneLandingVC* landing = [[AKiPhoneLandingVC alloc] initWithNibName:@"AKiPhoneLandingVC" bundle:nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            landing = [[AKiPhoneLandingVC alloc] initWithNibName:@"AKiPadLandingVC" bundle:nil];
            
        }
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:landing];
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [vc presentModalViewController:navController animated:true];

    }
}

@end
