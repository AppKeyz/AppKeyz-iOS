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
	
    samplesTableView.dataSource = self;
    samplesTableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //Call these methods to use AppKeyzSuite
    [AppKeyzSuite setRegisterFields:[NSArray arrayWithObjects:@"Age", @"Gender", nil]];
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

#pragma TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
        case 2:
            return 5;
            break;
        case 3:
            return 3;
            break;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"User Actions";
            break;
        case 1:
            return @"Purchase Actions";
            break;
        case 2:
            return @"Device Actions";
            break;
        case 3:
            return @"Consumable Actions";
            break;
    }
}

#define FIELD_TEXT_TAG 1

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Edit Accout";
                    break;
                case 1:
                    cell.textLabel.text = @"Logout";
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Create Purchase";
                    break;
                case 1:
                    cell.textLabel.text = @"List Purchases";
                    break;
                case 2:
                    cell.textLabel.text = @"Read Purchase";
                    break;
                case 3:
                    cell.textLabel.text = @"Update Purchase";
                    break;
                case 4:
                    cell.textLabel.text = @"Deactivate Purchase";
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Create Device";
                    break;
                case 1:
                    cell.textLabel.text = @"List Devices";
                    break;
                case 2:
                    cell.textLabel.text = @"Read Device";
                    break;
                case 3:
                    cell.textLabel.text = @"Update Device";
                    break;
                case 4:
                    cell.textLabel.text = @"Delete Device";
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"List Consumables";
                    break;
                case 1:
                    cell.textLabel.text = @"Read Consumable";
                    break;
                case 2:
                    cell.textLabel.text = @"Update Consumable";
                    break;
            }
            break;
    }
    
    return cell;
}



#pragma TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id sender;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self editUser:sender];
                    break;
                case 1:
                    [self logout:sender];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self createPurchase:sender];
                    break;
                case 1:
                    [self listPurchases:sender];
                    break;
                case 2:
                    [self readPurchase:sender];
                    break;
                case 3:
                    [self updatePurchase:sender];
                    break;
                case 4:
                    [self deactivatePurchase:sender];
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    [self createDevice:sender];
                    break;
                case 1:
                    [self listDevices:sender];
                    break;
                case 2:
                    [self readDevice:sender];
                    break;
                case 3:
                    [self updateDevice:sender];
                    break;
                case 4:
                    [self deactivateDevice:sender];
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    [self listConsumables:sender];
                    break;
                case 1:
                    [self readConsumable:sender];
                    break;
                case 2:
                    [self updateConsumable:sender];
                    break;
            }
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [[AKUser shared] logout];//Logout to present login alertview
    
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
    [appKeyz deletepurchaseWithEmail:testEmail password:testPassword purchaseId:[self randomPurchaseId]];
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
    int y = arc4random()%2;
    int x = arc4random()%200;
    switch (y) {
        case 0:
            [appKeyz updateconsumableWithEmail:testEmail password:testPassword consumableId:1 adjustBalance:-1 setBalance:x];
            break;
        case 1:
            [appKeyz updateconsumableWithEmail:testEmail password:testPassword consumableId:1 adjustBalance:x setBalance:-1];
            break;
    }
}





@end
