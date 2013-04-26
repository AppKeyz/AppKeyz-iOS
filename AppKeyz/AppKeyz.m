//
//  AppKeyz.m
//
//  Created by Michael Hayes on 1/24/13.
//  Copyright (c) 2013 App Keyz, Inc. All rights reserved.
//

#import "AppKeyz.h"

NSString* const kAppKeyzHost = @"https://www.appkeyz.com/mobileapp/appkeyz";
NSString* const kAppToken = @"REPLACE WITH YOUR APP TOKEN";

static AppKeyz* sAppKeyz = nil;

@implementation AppKeyz

+(AppKeyz*)shared
{
    static AppKeyz* sAppKeyz = nil;
    if (sAppKeyz==nil)
        sAppKeyz = AppKeyz.new;
    return sAppKeyz;
}

-(void)submitAppKey:(NSString*)key
{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kAppKeyzHost]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"validate" forKey:@"ApiAction"];
    [request setPostValue:kAppToken forKey:@"AppToken"];
    [request setPostValue:key forKey:@"AppKey"];
    [request setDelegate:self];
    [request startAsynchronous];

}

-(void)revalidateAppKey:(NSString*)key
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kAppKeyzHost]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"revalidate" forKey:@"ApiAction"];
    [request setPostValue:kAppToken forKey:@"AppToken"];
    [request setPostValue:key forKey:@"AppKey"];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)getUserFromKey:(NSString*)key
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kAppKeyzHost]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"getuser" forKey:@"ApiAction"];
    [request setPostValue:kAppToken forKey:@"AppToken"];
    [request setPostValue:key forKey:@"AppKey"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *responseDict = [responseString JSONValue];
    NSLog(@"AServer Response %@", responseDict);
    
    if ([[responseDict objectForKey:@"ValidKey"]intValue] == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"appkeyzsuccess"
                                                            object: nil
                                                          userInfo: nil];
        
        UIAlertView* appKeyzSuccess = [[[UIAlertView alloc] initWithTitle:@"App Keyz"
                                                                  message:@"Your code was accepted. Enjoy your upgrade."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil] autorelease];
        [appKeyzSuccess show];
    } else {
        UIAlertView* appKeyzFailure = [[[UIAlertView alloc] initWithTitle:@"App Keyz"
                                                                  message:[responseDict objectForKey:@"ErrorMessage"]
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil] autorelease];
        [appKeyzFailure show];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    // [MBProgressHUD hideHUDForView:self.previousViewController.view animated:YES];
    NSError *error = [request error];
    NSLog(@"Failure! %@", error);
    NSLog(@"headers: %@", [request responseHeaders]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"commFailure"
                                                        object: nil
                                                      userInfo: nil];
    
    UIAlertView* aServerFail = [[[UIAlertView alloc] initWithTitle:@"Communication Failure"
                                                           message:@"StoryPress failed to contact the server. Please try again soon."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil] autorelease];
    
    [aServerFail show];
}


@end
