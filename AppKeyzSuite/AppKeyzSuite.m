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
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            AKiPadLandingVC* landing = AKiPadLandingVC.new;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:landing];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [vc presentModalViewController:navController animated:YES];
        }
        else
        {
            AKiPhoneLandingVC* landing = AKiPhoneLandingVC.new;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:landing];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [vc presentModalViewController:navController animated:YES];
        }
    }
}

+(void)editUser:(UIViewController*)vc
{
    if ([AKUser shared].didNotRegister==true) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            AKiPadLandingVC* landing = AKiPadLandingVC.new;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:landing];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [vc presentModalViewController:navController animated:YES];
        }
        else
        {
            AKiPhoneLandingVC* landing = AKiPhoneLandingVC.new;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:landing];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [vc presentModalViewController:navController animated:YES];
        }
        
    } else {
        if ([AKUser shared].isLoggedIn==true) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                
            }
            else
            {
                AKiPhoneLoginRegisterVC* akilrvc = AKiPhoneLoginRegisterVC.new;
                akilrvc.controllerMode = editMode;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:akilrvc];
                navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [vc presentModalViewController:navController animated:YES];
            }
        }
    }
}

+(void)logout:(UIViewController*)vc
{
    if ([AKUser shared].isLoggedIn==true) {
        [[AKUser shared] logout];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            AKiPadLandingVC* landing = AKiPadLandingVC.new;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:landing];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [vc presentModalViewController:navController animated:YES];
        }
        else
        {
            AKiPhoneLandingVC* landing = AKiPhoneLandingVC.new;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:landing];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [vc presentModalViewController:navController animated:YES];
        }

    }
}

@end
