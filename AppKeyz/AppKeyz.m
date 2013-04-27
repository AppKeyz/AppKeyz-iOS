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

-(NSString*)generateUid
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 10];
    for (int i=0; i<10; i++) {
        [randomString appendFormat: @"%c", [letters characterAtIndex: arc4random()%[letters length]]];
    }
    return [NSString stringWithFormat:@"%@", randomString];
}

-(void)akPost:(NSDictionary*)params command:(Command)cmd
{
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:kAppKeyzHost]];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    [client postPath:@""
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self consumeResponse:responseObject withCommand:cmd];
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                              message:[NSString stringWithFormat:@"%@",error]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [av show];
                 
             }
     ];
}

-(void)consumeResponse:(id)responseObject withCommand:(Command)cmd
{
    switch (cmd) {
        case createuser:
            switch ([[responseObject objectForKey:@"Error"] intValue]) {
                case 0:
                    <#statements#>
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

-(void)createUserWithEmail:(NSString*)email
                  password:(NSString*)pw
                     fname:(NSString*)fn
                     lname:(NSString*)ln
                       lat:(NSString*)lat
                       lon:(NSString*)lon
                    active:(BOOL)active
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"createuser" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:fn forKey:@"firstname"];
    [parameters setObject:ln forKey:@"lastname"];
    [parameters setObject:lat forKey:@"latitude"];
    [parameters setObject:lon forKey:@"longitude"];
    [parameters setObject:(active) ? @"true" : @"false" forKey:@"active"];
    [parameters setObject:[self generateUid] forKey:@"uniqueid"];
    
    [self akPost:parameters command:createuser];
    
}


@end
