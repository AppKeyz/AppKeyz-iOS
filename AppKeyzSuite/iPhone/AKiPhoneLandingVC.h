//
//  AKiPhoneLandingVC.h
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/28/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKiPhoneLoginRegisterVC.h"
#import "AppKeyzLogin.h"

@interface AKiPhoneLandingVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    IBOutlet UITableView* loginTableView;
    UIImageView* bgImage;
    
    IBOutlet UIView* popupBackground;
    IBOutlet UIView* popupView;
    IBOutlet UITextField* popupBox;
    
    IBOutlet UILabel* why;
    IBOutlet UIButton* close;
    
    UITextField* fieldText;
    
}
@property(strong) IBOutlet UIImageView* bgImage;

-(IBAction)whySignUp:(id)sender;
-(IBAction)noThanks:(id)sender;
-(IBAction)closePopover:(id)sender;
-(IBAction)appKeyzLogin:(id)sender;
-(void)onCompleteCancelPopup;

@end
