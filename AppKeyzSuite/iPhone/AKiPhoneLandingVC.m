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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.75];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Log In";
            break;
        case 1:
            cell.textLabel.text = @"Create Accout";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AKiPhoneLoginRegisterVC* akilrvc = AKiPhoneLoginRegisterVC.new;
    
    switch (indexPath.row) {
        case 0:
            akilrvc.login = true;
            [self.navigationController pushViewController:akilrvc animated:true];
            break;
        case 1:
            akilrvc.login = false;
            [self.navigationController pushViewController:akilrvc animated:true];
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
