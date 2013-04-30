//
//  AKiPhoneLoginVC.h
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/29/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKiPhoneLoginRegisterVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView* loginRegTableView;
    UIImageView* bgImage;
    
    BOOL login;
    UITextField* fieldText;
}
@property(assign)BOOL login;
@property(strong)IBOutlet UIImageView* bgImage;

@end
