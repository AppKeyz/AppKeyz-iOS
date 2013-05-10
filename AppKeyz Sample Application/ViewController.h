//
//  ViewController.h
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/25/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppKeyz;

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    AppKeyz* appKeyz;
    
    NSString* testEmail;
    NSString* testPassword;
    
    IBOutlet UITableView* samplesTableView;
}

//User Actions
-(IBAction)editUser:(id)sender;
-(IBAction)logout:(id)sender;

//Purchase Actions
-(IBAction)createPurchase:(id)sender;
-(IBAction)listPurchases:(id)sender;
-(IBAction)readPurchase:(id)sender;
-(IBAction)updatePurchase:(id)sender;
-(IBAction)deactivatePurchase:(id)sender;

//Device Actions
-(IBAction)createDevice:(id)sender;
-(IBAction)listDevices:(id)sender;
-(IBAction)readDevice:(id)sender;
-(IBAction)updateDevice:(id)sender;
-(IBAction)deactivateDevice:(id)sender;

//Consumable Actions
-(IBAction)listConsumables:(id)sender;
-(IBAction)readConsumable:(id)sender;
-(IBAction)updateConsumable:(id)sender;

@end
