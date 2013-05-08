//
//  AKiPhoneLandingVC.m
//  AppKeyz Sample Application
//
//  Created by Michael Hayes on 4/28/13.
//  Copyright (c) 2013 App Keyz. All rights reserved.
//

#import "AKiPhoneLandingVC.h"

@interface AKiPhoneLandingVC ()

@end

@implementation AKiPhoneLandingVC
@synthesize bgImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    //self.navigationController.navigationBar.hidden = YES;

    loginTableView.delegate = self;
    loginTableView.dataSource = self;
    
    popupBox = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 280, 312)];
    popupBox.borderStyle = UITextBorderStyleRoundedRect;
    popupBox.enabled = false;
    [popupView addSubview:popupBox];
    [popupView addSubview:why];
    [popupView addSubview:close];
    [popupView addSubview:explain];
    
    popupView.hidden = true;
    popupBackground.hidden = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.75];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    fieldText.enabled = false;
    
    switch (indexPath.row) {
        case 0:
            fieldText.text = @"Log In";
            cell.imageView.image = [UIImage imageNamed:@"user.png"];
            break;
        case 1:
            fieldText.text = @"Create Account";
            cell.imageView.image = [UIImage imageNamed:@"plus.png"];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AKiPhoneLoginRegisterVC* akilrvc = AKiPhoneLoginRegisterVC.new;
    
    switch (indexPath.row) {
        case 0:
            akilrvc.controllerMode = loginMode;
            [self.navigationController pushViewController:akilrvc animated:true];
            break;
        case 1:
            akilrvc.controllerMode = registerMode;
            [self.navigationController pushViewController:akilrvc animated:true];
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)whySignUp:(id)sender
{

    
    popupView.frame = CGRectMake(20, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    popupBackground.alpha = 0.0;
    
    popupView.hidden = NO;
    popupBackground.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    popupBackground.alpha = 0.75;
    [popupView setAlpha:1.0];
    popupView.frame = CGRectMake(20, 64, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
    [UIView setAnimationDuration:0.0];
}

-(IBAction)closePopover:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onCompleteCancelPopup)];
    [popupBackground setAlpha:0.0];
    popupView.frame = CGRectMake(20, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
    [UIView setAnimationDuration:0.0];
}

- (void)onCompleteCancelPopup
{
    popupView.hidden = YES;
    popupBackground.hidden = YES;
}

-(IBAction)noThanks:(id)sender
{
    UIAlertView* noThanks = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                       message:@"Cancel sign up?"
                                                      delegate:self
                                             cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [noThanks show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[AKUser shared] notRegister];
        [self.navigationController dismissModalViewControllerAnimated:true];
    }
}



@end
