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
	// Do any additional setup after loading the view, typically from a nib.
    
    akSuite = AppKeyzSuite.new;
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [akSuite loadLoginScheme:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)fakeLogin:(id)sender
{
    [[AppKeyz shared] createUserWithEmail:@"blah" password:@"blah" fname:@"blah" lname:@"blah" lat:@"blah" lon:@"blah" active:YES];
}

@end
