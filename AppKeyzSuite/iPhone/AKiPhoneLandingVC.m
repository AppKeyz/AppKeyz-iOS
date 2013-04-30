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
        bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
    else bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default@2x.png"]];
    
    //self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:bg];
    self.navigationController.navigationBar.hidden = YES;
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    //loginTableView.backgroundColor = [UIColor clearColor];
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
            [self.navigationController pushViewController:akilrvc animated:true];
            break;
        case 1:
            [self.navigationController pushViewController:akilrvc animated:true];
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
