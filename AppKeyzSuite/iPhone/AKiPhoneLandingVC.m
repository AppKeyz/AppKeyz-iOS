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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ([[UIDevice currentDevice] orientation]==UIDeviceOrientationPortrait) {
            self.bgImage.image = [UIImage imageNamed:@"Default-Portrait.png"];
        } else {
            self.bgImage.image = [UIImage imageNamed:@"Default-Landscape.png"];
        }
    } else {
        if (UIScreen.mainScreen.bounds.size.height == 568)
            self.bgImage.image = [UIImage imageNamed:@"Default-568h@2x.png"];
        else self.bgImage.image = [UIImage imageNamed:@"Default.png"];
    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    //self.navigationController.navigationBar.hidden = YES;

    loginTableView.delegate = self;
    loginTableView.dataSource = self;
    loginWindow.layer.cornerRadius = 10;
    loginTableView.backgroundView = nil;
    loginTableView.backgroundColor = [UIColor clearColor];
    
    popupView.layer.cornerRadius = 10;
    popupView.hidden = true;
    popupBackground.hidden = true;
    UIImage* buttonImage = [[UIImage imageNamed:@"blackButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blackButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [close setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [close setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [close setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [whyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[whyButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [noThanksButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[noThanksButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    
    AKiPhoneLoginRegisterVC* akilrvc = [[AKiPhoneLoginRegisterVC alloc] initWithNibName:@"AKiPhoneLoginRegisterVC" bundle:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        akilrvc = [[AKiPhoneLoginRegisterVC alloc] initWithNibName:@"AKiPadLoginRegisterVC" bundle:nil];
    
    switch ([AppKeyz shared].directRoute) {
        case directRouteLogin:
        {
            akilrvc.controllerMode = loginMode;
        }
            break;
        case directRouteRegister:
        {
            akilrvc.controllerMode = registerMode;
        }
            break;
        case directRouteEditRegister:
        {
            akilrvc.controllerMode = editMode;
        }
            break;
        case none:
            break;
    }
    
    if ([AppKeyz shared].directRoute==none) {
        id sender;
        [self orientationChanged:sender];
    } else {
        [self.navigationController pushViewController:akilrvc animated:true];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)orientationChanged:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        float xCoord = (self.view.frame.size.width - 320.0)/2;
        float yCoord = (self.view.frame.size.height - 140.0)/2;
        loginTableView.frame = CGRectMake(xCoord, yCoord, 320.0, 140.0);
        whyButton.frame = CGRectMake( xCoord+68, yCoord+160, 184.0, 33.0);
        noThanksButton.frame = CGRectMake( xCoord+109, yCoord+213, 102.0, 33.0);
        if ([[UIDevice currentDevice] orientation]==UIDeviceOrientationPortrait) {
            self.bgImage.image = [UIImage imageNamed:@"Default-Portrait.png"];
        } else {
            self.bgImage.image = [UIImage imageNamed:@"Default-Landscape.png"];
        }
    } else {
        if (UIScreen.mainScreen.bounds.size.height == 568)
            self.bgImage.image = [UIImage imageNamed:@"Default-568h@2x.png"];
        else self.bgImage.image = [UIImage imageNamed:@"Default.png"];
    }
    
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
    AKiPhoneLoginRegisterVC* akilrvc = [[AKiPhoneLoginRegisterVC alloc] initWithNibName:@"AKiPhoneLoginRegisterVC" bundle:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        akilrvc = [[AKiPhoneLoginRegisterVC alloc] initWithNibName:@"AKiPadLoginRegisterVC" bundle:nil];
    
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
    //280 x 312 in Portrait; 312 x 280 in landscape
    
    diaWidth = 312.0;
    diaHeight = 246.0;
    lscpTop = 18.0;
    if ([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortrait) {
        diaWidth = 280.0;
        diaHeight = 312.0;
        lscpTop = 0.0;
    }
    float marginleft = (self.view.bounds.size.width - diaWidth)/2;
    float margintop = (self.view.bounds.size.height - diaHeight)/2;
    popupView.frame = CGRectMake(marginleft, self.view.bounds.size.height, diaWidth, diaHeight);
    popupBackground.alpha = 0.0;
    
    popupView.hidden = NO;
    popupBackground.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    popupBackground.alpha = 0.75;
    [popupView setAlpha:1.0];
    popupView.frame = CGRectMake(marginleft, margintop+lscpTop, diaWidth, diaHeight);
    [UIView commitAnimations];
    [UIView setAnimationDuration:0.0];
}

-(IBAction)closePopover:(id)sender
{
    int marginleft = (self.view.bounds.size.width - diaWidth)/2;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onCompleteCancelPopup)];
    [popupBackground setAlpha:0.0];
    popupView.frame = CGRectMake(marginleft, self.view.bounds.size.height, diaWidth, diaHeight);
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
