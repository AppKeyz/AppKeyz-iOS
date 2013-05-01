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

+(void)loadLoginScheme:(UIViewController*)vc
{
    //self.viewController = vc;
    
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

@end
