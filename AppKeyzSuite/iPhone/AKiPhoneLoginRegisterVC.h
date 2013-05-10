//
//  AKiPhoneLoginVC.h
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/29/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum tag_ControllerMode {
    loginMode,
    registerMode,
    editMode
} ControllerMode;

@class AKUser;
@class AppKeyz;

@interface AKiPhoneLoginRegisterVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
    IBOutlet UITableView* loginRegTableView;
    UIImageView* bgImage;
    
    BOOL login;
    UITextField* fieldText;
    UITextField* currentTextfield;
    
    AKUser* user;
    AppKeyz* appKeyz;
    
    NSArray* registerFields, *registerFieldLabels;
    
    UIView* footerView;
    
    NSString* newEmail;
    NSString* newPassword;    
    
}
@property(assign)ControllerMode controllerMode;
@property(strong)IBOutlet UIImageView* bgImage;

-(void)registerUser;
-(void)loginUser;
-(void)loginUserVerified;
-(void)updateUser;

-(NSString*)captureString:(int)row;

@end
