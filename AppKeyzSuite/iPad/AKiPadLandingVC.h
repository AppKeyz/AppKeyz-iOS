//
//  AKiPadLandingVC.h
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/29/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKiPadLandingVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    IBOutlet UITableView* loginTableView;
    UIImageView* bgImage;
    
    IBOutlet UIView* popupBackground;
    IBOutlet UIView* popupView;
    IBOutlet UITextField* popupBox;
    
    IBOutlet UILabel* why;
    IBOutlet UIButton* close;
    IBOutlet UITextView* explain;
    
    UITextField* fieldText;
}
@property(strong) IBOutlet UIImageView* bgImage;
-(IBAction)whySignUp:(id)sender;
-(IBAction)noThanks:(id)sender;
-(IBAction)closePopover:(id)sender;
-(void)onCompleteCancelPopup;

@end
