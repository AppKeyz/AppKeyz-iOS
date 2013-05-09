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
    
    //Call these methods to use AppKeyzSuite
    [AppKeyzSuite setRegisterFields:[NSArray arrayWithObjects:@"Age", @"Sex", nil]];
    [AppKeyzSuite loadLoginScheme:self];
    
    appKeyz = [AppKeyz shared];
    
    //For demonstration purposes
    testEmail = @"testuser@test.com";
    testPassword = @"test";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//User Actions
-(IBAction)editUser:(id)sender
{
    [AppKeyzSuite editUser:self];
}

-(IBAction)logout:(id)sender
{
    [AppKeyzSuite logout:self];
}

//Purchase Actions
-(IBAction)createPurchase:(id)sender
{
    int x = arc4random()%3;
    NSLog(@"%i",x);
    switch (x) {
        case 0:
            [appKeyz createPurchaseWithEmail:testEmail password:testPassword productSku:@"appkeyztest1" purchasePrice:-1 balance:-1 expiration:@""];
            break;
        case 1:
            [appKeyz createPurchaseWithEmail:testEmail password:testPassword productSku:@"appkeyztest2" purchasePrice:-1 balance:-1 expiration:@""];
            break;
        case 2:
            [appKeyz createPurchaseWithEmail:testEmail password:testPassword productSku:@"appkeyztest3" purchasePrice:-1 balance:-1 expiration:@""];
            break;
    }
    
    
}

-(IBAction)listPurchases:(id)sender
{
    [appKeyz listpurchasesWithEmail:testEmail password:testPassword];
}

-(IBAction)readPurchase:(id)sender
{
    [appKeyz readpurchaseWithEmail:testEmail password:testPassword purchaseId:[self randomPurchaseId]];
}

-(IBAction)updatePurchase:(id)sender
{
    [appKeyz updatepurchaseWithEmail:testEmail password:testPassword purchaseId:[self randomPurchaseId] expiration:@"2020-12-31" active:true];
}

-(IBAction)deactivatePurchase:(id)sender
{
    [appKeyz deactivatepurchaseWithEmail:testEmail password:testPassword purchaseId:[self randomPurchaseId]];
}

-(NSString*) randomPurchaseId
{
    NSString* purchId;
    if ([appKeyz.productIds count]>0) {
        int x = arc4random()%[appKeyz.productIds count];
        NSLog(@"%i",x);
        purchId = [[appKeyz.productIds objectAtIndex:x] objectForKey:@"purchaseid"];
    }
    return purchId;
}

//Device Actions
-(IBAction)createDevice:(id)sender
{
    [appKeyz createdeviceWithEmail:testEmail password:testPassword deviceId:@"" deviceIp:@"" deviceToken:@""];
}

-(IBAction)listDevices:(id)sender
{
    [appKeyz listdevicesWithEmail:testEmail password:testPassword];
}

-(IBAction)readDevice:(id)sender
{
    [appKeyz readdeviceWithEmail:testEmail password:testPassword deviceId:@""];
}

-(IBAction)updateDevice:(id)sender
{

    [appKeyz updatedeviceWithEmail:testEmail password:testPassword deviceId:nil newDeviceId:appKeyz.generateUid deviceType:@"Banana" deviceIp:@"" deviceToken:@""];
}

-(IBAction)deactivateDevice:(id)sender
{
    [appKeyz deletedeviceWithEmail:testEmail password:testPassword deviceId:@""];
}

//Consumable Actions
-(IBAction)listConsumables:(id)sender
{
    [appKeyz listconsumablesWithEmail:testEmail password:testPassword];
}

-(IBAction)readConsumable:(id)sender
{
    [appKeyz readconsumableWithEmail:testEmail password:testPassword consumableId:1];
}

-(IBAction)updateConsumable:(id)sender
{
    int y = arc4random()%200;
    int x = arc4random()%200;
    [appKeyz updateconsumableWithEmail:testEmail password:testPassword consumableId:1 adjustBalance:y setBalance:x];
    
}





@end
