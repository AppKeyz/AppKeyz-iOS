//
//  AKiPadLandingVC.h
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/29/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKiPadLandingVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UIImageView* backgroundImage;
    UITableView* loginTableView;
}
@property(nonatomic) IBOutlet UIImageView* backgroundImage;
@property(nonatomic) IBOutlet UITableView* loginTableView;

@end
