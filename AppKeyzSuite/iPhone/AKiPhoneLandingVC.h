//
//  AKiPhoneLandingVC.h
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/28/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKiPhoneLoginRegisterVC.h"

@interface AKiPhoneLandingVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView* loginTableView;
    IBOutlet UIImageView* bgImage;
}

@end
