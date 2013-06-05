//
//  AKiPhoneLoginVC.m
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/29/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import "AKiPhoneLoginRegisterVC.h"

#define FIELD_TEXT_TAG 10

@interface AKiPhoneLoginRegisterVC ()

@end

@implementation AKiPhoneLoginRegisterVC
@synthesize controllerMode, bgImage, loginRegTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Successful Login
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(dismiss:)
                                                     name: @"AKreaduser"
                                                   object: nil];
        
        // Successful Login Verified
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(dismiss:)
                                                     name: @"AKreaduserverified"
                                                   object: nil];
        
        // Successful Account Creation
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(dismiss:)
                                                     name: @"AKcreateuser"
                                                   object: nil];
        
        // Successfull Account Update
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(dismiss:)
                                                     name: @"AKupdateuser"
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:@"UIDeviceOrientationDidChangeNotification"
                                                   object: nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user = [AKUser shared];
    appKeyz = [AppKeyz shared];
    
    registerFieldLabels = [NSArray arrayWithArray:appKeyz.registerFields];
    
    registerFields = [[NSArray alloc] initWithObjects:@"age", @"sex", @"custom1", @"custom2", @"custom3", @"custom4", @"custom5", @"custom6", nil];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortrait) {
            self.bgImage.image = [UIImage imageNamed:@"Default-Portrait.png"];
        } else {
            self.bgImage.image = [UIImage imageNamed:@"Default-Landscape.png"];
        }
    } else {
        self.bgImage.image = [UIImage imageNamed:@"Default.png"];
        if (UIScreen.mainScreen.bounds.size.height == 568) self.bgImage.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }

    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    if (controllerMode==editMode) {
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(dismiss:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
    self.loginRegTableView.delegate = self;
    self.loginRegTableView.dataSource = self;
    self.loginRegTableView.backgroundView = nil;
    self.loginRegTableView.backgroundColor = [UIColor clearColor];
    
    currentTextfield = UITextField.new;
    
    //reloadTv = TRUE;
    if (controllerMode==editMode) [self viewDidAppear:true];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:true];
    
    [currentTextfield resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:false];
    
    UITextField* tf = (UITextField*)[[self.loginRegTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView viewWithTag:FIELD_TEXT_TAG];
    [tf becomeFirstResponder];
    
    id sender;
    [self orientationChanged:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)orientationChanged:(id)sender
{
    float tableHeight = 200.0;
    float topOffset = 44.0;
    float width = 320.0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortrait) {
            tableHeight = 352.0;
            self.bgImage.image = [UIImage imageNamed:@"Default-Portrait.png"];
        } else {
            tableHeight = 696.0;
            self.bgImage.image = [UIImage imageNamed:@"Default-Landscape.png"];
        }
    } else {
        self.bgImage.image = [UIImage imageNamed:@"Default.png"];
        if (UIScreen.mainScreen.bounds.size.height == 568)
            self.bgImage.image = [UIImage imageNamed:@"Default-568h@2x.png"];
        if ([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortrait) {
            tableHeight = 200.0;
            width = 320.0;
            if (UIScreen.mainScreen.bounds.size.height == 568)
                tableHeight = 288.0;
        } else {
            topOffset = 34.0;
            tableHeight = 106.0;
            width = 480.0;
            if (UIScreen.mainScreen.bounds.size.width == 568) {
                tableHeight = 194.0;
                width = 568.0;
            }
            
        }
    }
    float xCoord = (self.view.frame.size.width - width)/2;
    self.loginRegTableView.frame = CGRectMake(xCoord, topOffset, width, tableHeight);
    [self.view setNeedsDisplay];
    
    NSLog(@"%@", CGRectCreateDictionaryRepresentation(self.loginRegTableView.frame));
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return true;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections = 2;
    if (controllerMode==loginMode) sections = 3;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 1;
    
    switch (controllerMode) {
        case akLoginMode:
        case loginMode:
            if (section==0) rows = 2;
            else rows = 1;
            break;
        case registerMode:
        case editMode:
            if (section==0) rows = 4 + [registerFieldLabels count];
            else rows = 1;
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (controllerMode) {
        case loginMode:
            switch (section) {
                case 0:
                    return UITableViewAutomaticDimension;
                    break;
                case 1:
                case 2:
                    return 50;
                    break;
            }
            break;
        case akLoginMode:
            switch (section) {
                case 0:
                    return UITableViewAutomaticDimension;
                    break;
                case 1:
                    return 50;
                    break;
            }
            break;
        case editMode:
        case registerMode:
            return UITableViewAutomaticDimension;
            break;
    }
    return UITableViewAutomaticDimension;
}

- (UIButton*)footerLabel:(NSString*)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(10, 3, 300, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //set action of the button
    [button addTarget:self action:@selector(forgotPassword:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{    
    if (section==1) {
        if (controllerMode==loginMode) {
          //  if (footerView==nil) {
               // footerView = nil;
                footerView  = [[UIView alloc] init];
                [footerView addSubview:[self footerLabel:@"-Or-"]];
        //    }
        } else if (controllerMode==akLoginMode) {
        //    if (footerView==nil) {
             //   footerView = nil;
                footerView  = [[UIView alloc] init];
            [footerView addSubview:[self footerLabel:@"Forgot Password?"]];
         //   }
        }
    } else if (section==2) {
        if (controllerMode==loginMode) {
         //   if(footerView == nil) {
              //  footerView = nil;
                footerView  = [[UIView alloc] init];
            [footerView addSubview:[self footerLabel:@"Forgot Password?"]];
         //   }
        }
    } else if (section==0) {
        footerView = nil;
    }
    return footerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.75];
        
        fieldText = [[UITextField alloc] initWithFrame:CGRectMake(50.0, 12.5, 410.0, 20.0)];
        fieldText.tag = FIELD_TEXT_TAG;
        fieldText.font = [UIFont boldSystemFontOfSize:16.0];
        fieldText.textAlignment = UITextAlignmentLeft;
        fieldText.autoresizingMask = UIViewAutoresizingNone;
        fieldText.textColor = [UIColor whiteColor];
        fieldText.backgroundColor = [UIColor clearColor];
        fieldText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        fieldText.delegate = self;
        [cell.contentView addSubview:fieldText];
        
        UIView* cellView = cell.backgroundView;
        cell.backgroundView = cellView;
        
    } else {
        fieldText = (UITextField*)[cell.contentView viewWithTag:FIELD_TEXT_TAG];
    }
    
    switch (indexPath.section)
    {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryNone;
            switch (controllerMode) {
                case registerMode:
                case editMode:
                    fieldText.secureTextEntry = NO;
                    fieldText.keyboardType = UIKeyboardTypeDefault;
                    fieldText.autocapitalizationType = UITextAutocapitalizationTypeWords;
                    fieldText.enabled = true;
                    switch (indexPath.row) {
                        case 0:
                            fieldText.placeholder = @"First Name";
                            fieldText.text = user.userNameFirst;
                            cell.imageView.image = [UIImage imageNamed:@"user.png"];
                            break;
                        case 1:
                            fieldText.placeholder = @"Last Name";
                            fieldText.text = user.userNameLast;
                            cell.imageView.image = [UIImage imageNamed:@"user.png"];
                            break;
                        case 2:
                            fieldText.placeholder = @"Email";
                            fieldText.text = user.userEmail;
                            fieldText.keyboardType = UIKeyboardTypeEmailAddress;
                            fieldText.autocapitalizationType = UITextAutocapitalizationTypeNone;
                            cell.imageView.image = [UIImage imageNamed:@"inbox.png"];
                            break;
                        case 3:
                            fieldText.placeholder = @"Password";
                            fieldText.text = user.userPassword;
                            if (controllerMode==editMode) fieldText.secureTextEntry = true;
                            fieldText.autocapitalizationType = UITextAutocapitalizationTypeNone;
                            cell.imageView.image = [UIImage imageNamed:@"key.png"];
                            break;
                        case 4:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.text = user.age;
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = [UIImage imageNamed:@"blank.png"];
                            }
                            break;
                        case 5:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.text = user.gender;
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = [UIImage imageNamed:@"blank.png"];
                            }
                            break;
                        case 6:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.text = user.custom1;
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = [UIImage imageNamed:@"blank.png"];
                            }
                            break;
                        case 7:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.text = user.custom2;
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = [UIImage imageNamed:@"blank.png"];
                            }
                            break;
                        case 8:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.text = user.custom3;
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = [UIImage imageNamed:@"blank.png"];
                            }
                        case 9:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.text = user.custom4;
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = [UIImage imageNamed:@"blank.png"];
                            }
                        case 10:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.text = user.custom5;
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = [UIImage imageNamed:@"blank.png"];
                            }
                            break;
                        case 11:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.text = user.custom6;
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = [UIImage imageNamed:@"blank.png"];
                            }
                            break;
                    }
                    break;
                case akLoginMode:
                case loginMode:
                    switch (indexPath.row) {
                        case 0:
                            fieldText.placeholder = @"Email";
                            fieldText.secureTextEntry = NO;
                            fieldText.keyboardType = UIKeyboardTypeEmailAddress;
                            fieldText.autocapitalizationType = UITextAutocapitalizationTypeNone;
                            cell.imageView.image = [UIImage imageNamed:@"inbox.png"];
                            break;
                        case 1:
                            fieldText.placeholder = @"Password";
                            fieldText.secureTextEntry = YES;
                            fieldText.keyboardType = UIKeyboardTypeDefault;
                            fieldText.autocapitalizationType = UITextAutocapitalizationTypeNone;
                            cell.imageView.image = [UIImage imageNamed:@"key.png"];
                            break;
                    }
                    break;
            }
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            fieldText.enabled = false;
            fieldText.secureTextEntry = false;
            switch (controllerMode) {
                case akLoginMode:
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    fieldText.enabled = false;
                    UIImageView* akLogin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_keyz_button.png"]];
                    cell.imageView.image = [UIImage imageNamed:@"blank.png"];
                    //[cell.contentView addSubview:akLogin];
                    cell.backgroundView = akLogin;
                }
                    break;
                case loginMode:
                    fieldText.text = @"Log In";
                    cell.imageView.image = [UIImage imageNamed:@"user.png"];
                    break;
                case registerMode:
                    fieldText.text = @"Create Account";
                    cell.imageView.image = [UIImage imageNamed:@"plus.png"];
                    break;
                case editMode:
                    fieldText.text = @"Save Profile";
                    cell.imageView.image = [UIImage imageNamed:@"user.png"];
                    break;
            }
            break;
        case 2:
            if (controllerMode==loginMode) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                fieldText.enabled = false;
                UIImageView* akLogin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_keyz_button.png"]];
                cell.imageView.image = [UIImage imageNamed:@"blank.png"];
                //[cell.contentView addSubview:akLogin];
                cell.backgroundView = akLogin;
            }
            break;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        //[currentTextfield resignFirstResponder];
        //[self saveFromCurrentField];
        switch (controllerMode) {
            case loginMode:
                [self loginUser];
                break;
            case registerMode:
                [self registerUser];
                break;
            case editMode:
                [self updateUser];
                break;
            case akLoginMode:
                [self loginUserVerified];
                break;
        }
    }
    if (indexPath.section==2) [self akLoginView];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        //[self moveView:0];
        [textField resignFirstResponder];
        return false;
    }
    UITableViewCell* cell = (UITableViewCell*)textField.superview.superview;
    NSIndexPath* indexPath = [self.loginRegTableView indexPathForCell:cell];
    if (controllerMode==editMode && indexPath.row==2)
        newEmail = [NSString stringWithFormat:@"%@%@",textField.text, string];
    else if (controllerMode==editMode && indexPath.row==3)
        newPassword = [NSString stringWithFormat:@"%@%@",textField.text, string];
    else
        [self saveToUserField:indexPath.row withString:[NSString stringWithFormat:@"%@%@",textField.text, string]];
    return true;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    currentTextfield = textField;

    UITableViewCell* cell = (UITableViewCell*)textField.superview.superview;
    NSIndexPath* indexPath = [self.loginRegTableView indexPathForCell:cell];
    
    //[self moveView:textField.superview.superview.frame.origin.y];
    [loginRegTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
    
    return true;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    /*
    UITableViewCell* cell = (UITableViewCell*)textField.superview.superview;
    NSIndexPath* indexPath = [self.loginRegTableView indexPathForCell:cell];
    if (controllerMode==editMode && indexPath.row==2)
        newEmail = textField.text;
    else if (controllerMode==editMode && indexPath.row==3)
        newPassword = textField.text;
    else
        [self saveToUserField:indexPath.row withString:textField.text];
    
    currentTextfield = nil;
    currentTextfield = UITextField.new;
    */
    return true;
}

-(void)saveFromCurrentField
{
    if (currentTextfield!=nil) {
        UITableViewCell* cell = (UITableViewCell*)currentTextfield.superview.superview;
        NSIndexPath* indexPath = [self.loginRegTableView indexPathForCell:cell];
        if (controllerMode==editMode && indexPath.row==2)
            newEmail = currentTextfield.text;
        else if (controllerMode==editMode && indexPath.row==3)
            newPassword = currentTextfield.text;
        else
            [self saveToUserField:indexPath.row withString:currentTextfield.text];
    }
}

-(void)saveToUserField:(NSInteger)row withString:(NSString*)string
{
    switch (controllerMode) {
        case editMode:
        case registerMode:
        switch (row) {
            case 0:
                user.userNameFirst = string;
                break;
            case 1:
                user.userNameLast = string;
                break;
            case 2:
                user.userEmail = string;
                break;
            case 3:
                user.userPassword = string;
                break;
            case 4:
                user.age = string;
                break;
            case 5:
                user.gender = string;
                break;
        }
        break;
    case loginMode:
        switch (row) {
            case 0:
                user.userEmail = string;
                break;
            case 1:
                user.userPassword = string;
                break;
        }
        break;
    }
    [user saveSettings];
    NSLog(@"%@", string);
    [user inspect];
}

-(void)moveView:(float)offset
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    rect.origin.y = -offset;
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)registerUser
{
    
    if (IsValidEmail(user.userEmail)==YES && [user.userPassword length]>=6) {

        [appKeyz createUserWithEmail:user.userEmail
                            password:user.userPassword
                               fname:user.userNameFirst
                               lname:user.userNameLast
                                 lat:@""
                                 lon:@""
                              active:true
                                 age:user.age
                                 sex:user.gender
                             custom1:user.custom1
                             custom2:user.custom2
                             custom3:user.custom3
                             custom4:user.custom4
                             custom5:user.custom5
                             custom6:user.custom6];
        
    } else if (IsValidEmail(user.userEmail)==NO) {
        UIAlertView* badEmail = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                            message:@"Please enter a valid email."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [badEmail show];
    } else if ([user.userPassword length] < 6) {
        UIAlertView* pwLength = [[UIAlertView alloc] initWithTitle:@"Passwords Too Short"
                                                            message:@"Password must be at least 6 characters."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [pwLength show];
    }

    
    
}

-(void)loginUser
{
    
    if (user.userEmail.length>0 && user.userPassword.length>0) {
        [appKeyz readUserWithEmail:user.userEmail password:user.userPassword];
    } else {
        UIAlertView* noStuff = [[UIAlertView alloc] initWithTitle:@"Invalid Email or Password"
                                                           message:@"Please enter something here."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
        [noStuff show];
    }
}

-(void)akLoginView
{
    AKiPhoneLoginRegisterVC* akilrvc = [[AKiPhoneLoginRegisterVC alloc] initWithNibName:@"AKiPhoneLoginRegisterVC" bundle:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        akilrvc = [[AKiPhoneLoginRegisterVC alloc] initWithNibName:@"AKiPadLoginRegisterVC" bundle:nil];
    
    akilrvc.controllerMode = akLoginMode;
    [self.navigationController pushViewController:akilrvc animated:true];
}

-(void)loginUserVerified
{
    
    if (user.userEmail.length>0 && user.userPassword.length>0) {
        [appKeyz readUserVerifiedWithEmail:user.userEmail password:user.userPassword];
    } else {
        UIAlertView* noStuff = [[UIAlertView alloc] initWithTitle:@"Invalid Email or Password"
                                                          message:@"Please enter something here."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
        [noStuff show];
    }
}


-(void)updateUser
{
    if (newPassword.length==0)
        newPassword = user.userPassword;
    if (newEmail.length==0)
        newEmail = user.userEmail;
    
    if (IsValidEmail(newEmail)==YES && [newPassword length]>=6) {
        
        [appKeyz updateUserWithEmail:user.userEmail
                            password:user.userPassword
                            newemail:newEmail
                         newpassword:newPassword
                               fname:user.userNameFirst
                               lname:user.userNameLast
                                 lat:@""
                                 lon:@""
                              active:true
                                 age:user.age
                                 sex:user.gender
                             custom1:user.custom1
                             custom2:user.custom2
                             custom3:user.custom3
                             custom4:user.custom4
                             custom5:user.custom5
                             custom6:user.custom6];
        
    } else if (IsValidEmail(newEmail)==NO) {
        UIAlertView* badEmail = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                           message:@"Please enter a valid email."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
        [badEmail show];
    } else if ([newPassword length] < 6) {
        UIAlertView* pwLength = [[UIAlertView alloc] initWithTitle:@"Passwords Too Short"
                                                           message:@"Password must be at least 6 characters."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
        [pwLength show];
    }

}

-(IBAction)forgotPassword:(id)sender
{
    UIAlertView* forgotPass = [[UIAlertView alloc] initWithTitle:@"Forgot Password?"
                                                         message:@"Enter email to receive password reset instructions"
                                                        delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    forgotPass.alertViewStyle = UIAlertViewStylePlainTextInput;
    forgotPass.tag = 22;
    [forgotPass show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 22:
            if (buttonIndex==1) {
                UITextField* tf = (UITextField*)[alertView textFieldAtIndex:0];
                if (IsValidEmail(tf.text)) {
                    [appKeyz forgotpasswordWithEmail:tf.text];
                } else {
                    UIAlertView* badEmail = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                                       message:@"Please enter a valid email."
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles: nil];
                    [badEmail show];
                }
            }
            break;
    }
}

- (IBAction)dismiss:(id)sender
{
    user.isLoggedIn=YES;
    [user saveSettings];
    
    [self dismissModalViewControllerAnimated:YES];
}

BOOL IsValidEmail(NSString* email)
{
	if ([email length] < 6) return NO;
	if ([email rangeOfString:@"@"].location == NSNotFound) return NO;
	NSArray* array = [email componentsSeparatedByString:@"@"];
	if ([array count]>2) return NO;
	NSString* addr = [array objectAtIndex:0];
	NSString* domain = [array objectAtIndex:1];
	if ([addr length]<1) return NO;
	if ([domain length]<4) return NO;
	if ([domain rangeOfString:@"."].location == NSNotFound) return NO;
	return YES;
}


@end
