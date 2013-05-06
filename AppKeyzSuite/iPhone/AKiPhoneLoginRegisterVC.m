//
//  AKiPhoneLoginVC.m
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/29/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import "AKiPhoneLoginRegisterVC.h"

@interface AKiPhoneLoginRegisterVC ()

@end

@implementation AKiPhoneLoginRegisterVC
@synthesize controllerMode, bgImage;

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

    
    if (UIScreen.mainScreen.bounds.size.height == 568)
        self.bgImage.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    else self.bgImage.image = [UIImage imageNamed:@"Default.png"];
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    if (controllerMode==editMode) {
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(dismiss:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
    loginRegTableView.delegate = self;
    loginRegTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (section==2 && controllerMode==loginMode)
        return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (controllerMode==loginMode) {
        if(footerView == nil) {
            //allocate the view if it doesn't exist yet
            footerView  = [[UIView alloc] init];
            
            //create the button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            //the button should be as big as a table view cell
            [button setFrame:CGRectMake(10, 3, 300, 44)];
            
            //set title, font size and font color
            [button setTitle:@"Forgot Password?" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            //set action of the button
            [button addTarget:self action:@selector(forgotPassword:)
             forControlEvents:UIControlEventTouchUpInside];
            
            //add the button to the view
            [footerView addSubview:button];
        }
    }
    //return the view for the footer
    return footerView;
}

#define FIELD_TEXT_TAG 10

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
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
        
    } else {
        fieldText = (UITextField*)[cell.contentView viewWithTag:FIELD_TEXT_TAG];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.75];
    
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
                            fieldText.autocapitalizationType = UITextAutocapitalizationTypeNone;
                            cell.imageView.image = [UIImage imageNamed:@"key.png"];
                            break;
                        case 4:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = nil;
                            }
                            break;
                        case 5:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = nil;
                            }
                            break;
                        case 6:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = nil;
                            }
                            break;
                        case 7:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = nil;
                            }
                            break;
                        case 8:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = nil;
                            }
                        case 9:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = nil;
                            }
                        case 10:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = nil;
                            }
                            break;
                        case 11:
                            if (indexPath.row-4 <= [registerFieldLabels count]-1) {
                                fieldText.placeholder = [registerFieldLabels objectAtIndex:indexPath.row-4];
                                cell.imageView.image = nil;
                            }
                            break;
                    }
                    break;
                case loginMode:
                    switch (indexPath.row) {
                        case 0:
                            fieldText.placeholder = @"Email";
                            fieldText.secureTextEntry = NO;
                            fieldText.keyboardType = UIKeyboardTypeEmailAddress;
                            fieldText.autocapitalizationType = UITextAutocapitalizationTypeNone;
                            cell.imageView.image = [UIImage imageNamed:@"40-inbox.png"];
                            break;
                        case 1:
                            fieldText.placeholder = @"Password";
                            fieldText.secureTextEntry = YES;
                            fieldText.keyboardType = UIKeyboardTypeDefault;
                            fieldText.autocapitalizationType = UITextAutocapitalizationTypeNone;
                            cell.imageView.image = [UIImage imageNamed:@"30-key.png"];
                            break;
                    }
                    break;
            }
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            fieldText.enabled = false;
            
            switch (controllerMode) {
                case loginMode:
                    fieldText.text = @"Log In";
                    cell.imageView.image = [UIImage imageNamed:@"111-user.png"];
                    break;
                case registerMode:
                    fieldText.text = @"Create Account";
                    cell.imageView.image = [UIImage imageNamed:@"10-medical.png"];
                    break;
                case editMode:
                    fieldText.text = @"Save Profile";
                    cell.imageView.image = [UIImage imageNamed:@"111-user.png"];
                    break;
            }
            break;
        case 2:
            if (controllerMode==loginMode) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                fieldText.enabled = false;
                UIImageView* akLogin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_keyz_button.png"]];
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
        }
    }
    if (indexPath.section==2) [self loginUserVerified];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [self moveView:0];
        [textField resignFirstResponder];
        return false;
    }
    return true;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textfield origin_y %f",textField.superview.superview.frame.origin.y);
    
    [self moveView:textField.superview.superview.frame.origin.y];
    
    return true;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    return true;
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
    
    user.userNameFirst = [self captureString:0];
    user.userNameLast = [self captureString:1];
    user.userEmail = [self captureString:2];
    user.userPassword = [self captureString:3];
    
    if (IsValidEmail(user.userEmail)==YES && [user.userPassword length]>=6) {

        [appKeyz createUserWithEmail:user.userEmail password:user.userPassword fname:user.userNameFirst lname:user.userNameLast lat:@"" lon:@"" active:true];
        
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
    user.userEmail = [self captureString:0];
    user.userPassword = [self captureString:1];
    
    if ([self captureString:0].length>0 && [self captureString:1].length > 0) {
        [user saveSettings];
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

-(void)loginUserVerified
{
    user.userEmail = [self captureString:0];
    user.userPassword = [self captureString:1];
    
    if ([self captureString:0].length>0 && [self captureString:1].length > 0) {
        [user saveSettings];
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
    /*
    user.userNameFirst = [self captureString:0];
    user.userNameLast = [self captureString:1];
    user.userEmail = [self captureString:2];
    user.userPassword = [self captureString:3];
    */
    
    if (IsValidEmail([self captureString:2])==YES && [[self captureString:3] length]>=6) {
        
        [appKeyz updateUserWithEmail:user.userEmail password:user.userPassword newemail:[self captureString:2] newpassword:[self captureString:3] fname:[self captureString:0] lname:[self captureString:1] lat:@"" lon:@"" active:true];
        
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

-(NSString*)captureString:(int)row
{
    UITableViewCell* cell = (id)[loginRegTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    UITextField* tf = [cell.contentView viewWithTag:FIELD_TEXT_TAG];
    NSLog(@"%@", tf.text);
    return tf.text;
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
