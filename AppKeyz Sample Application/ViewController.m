//
//  ViewController.m
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/25/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [AppKeyzSuite setRegisterFields:[NSArray arrayWithObjects:@"Age", @"Sex", @"Custom Field1", nil]];
    
    [AppKeyzSuite loadLoginScheme:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)editUser:(id)sender
{
    [AppKeyzSuite editUser:self];
}

-(IBAction)logout:(id)sender
{
    [AppKeyzSuite logout:self];
}

@end
