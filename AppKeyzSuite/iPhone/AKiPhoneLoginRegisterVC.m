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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (UIScreen.mainScreen.bounds.size.height == 568)
        self.bgImage.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    else self.bgImage.image = [UIImage imageNamed:@"Default.png"];
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
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
    return 2;
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
            if (section==0) rows = 4;
            else rows = 1;
            break;
    }
    return rows;
}

#define FIELD_TEXT_TAG 1

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        fieldText = [[UITextField alloc] initWithFrame:CGRectMake(50.0, 12.5, 230.0, 20.0)];
        fieldText.tag = FIELD_TEXT_TAG;
        fieldText.font = [UIFont boldSystemFontOfSize:16.0];
        fieldText.textAlignment = UITextAlignmentLeft;
        fieldText.autoresizingMask = UIViewAutoresizingNone;
        fieldText.textColor = [UIColor whiteColor];
        fieldText.backgroundColor = [UIColor clearColor];
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
                    switch (indexPath.row) {
                        case 0:
                            fieldText.placeholder = @"First Name";
                            cell.imageView.image = [UIImage imageNamed:@"111-user.png"];
                            break;
                        case 1:
                            fieldText.placeholder = @"Last Name";
                            cell.imageView.image = [UIImage imageNamed:@"111-user.png"];
                            break;
                        case 2:
                            fieldText.placeholder = @"Email";
                            cell.imageView.image = [UIImage imageNamed:@"40-inbox.png"];
                            break;
                        case 3:
                            fieldText.placeholder = @"Password";
                            cell.imageView.image = [UIImage imageNamed:@"30-key.png"];
                            break;
                     /*   case 4:
                            fieldText.placeholder = @"Password Confirmation";
                            cell.imageView.image = [UIImage imageNamed:@"30-key.png"];
                            break; */
                    }
                    break;
                case loginMode:
                    switch (indexPath.row) {
                        case 0:
                            fieldText.placeholder = @"Email";
                            cell.imageView.image = [UIImage imageNamed:@"40-inbox.png"];
                            break;
                        case 1:
                            fieldText.placeholder = @"Password";
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
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return false;
    }
    return true;
}

-(void)registerUser
{
    
}

-(void)loginUser
{
    
}

-(void)updateUser
{
    
}


@end
