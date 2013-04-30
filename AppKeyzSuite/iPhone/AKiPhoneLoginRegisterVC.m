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
@synthesize login, bgImage;

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
    
    if (login==true) {
        if (section==0) rows = 2;
        else rows = 1;
    } else {
        if (section==0) rows = 5;
        else rows = 1;
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
            if (login==false)
            {
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
                    case 4:
                        fieldText.placeholder = @"Password Confirmation";
                        cell.imageView.image = [UIImage imageNamed:@"30-key.png"];
                        break;
                } 
            }
            else
            {
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
            }
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            fieldText.enabled = false;
            
            if (login==true) {
                fieldText.placeholder = @"Log In";
                cell.imageView.image = [UIImage imageNamed:@"111-user.png"];
            } else {
                fieldText.placeholder = @"Create Account";
                cell.imageView.image = [UIImage imageNamed:@"10-medical.png"];

            }
            break;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
