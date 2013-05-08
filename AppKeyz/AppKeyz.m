//
//  AppKeyz.m
//
//  Created by Michael Hayes on 1/24/13.
//  Copyright (c) 2013 App Keyz, Inc. All rights reserved.
//

#import "AppKeyz.h"

NSString* const kAppKeyzHost = @"https://www.appkeyz.com/mobileapp/appkeyzapi";
NSString* const kAppToken = @"ci48xk6m"; //REPLACE WITH YOUR APP TOKEN



@implementation AppKeyz
@synthesize registerFields;

+(AppKeyz*)shared
{
    static AppKeyz* sAppKeyz = nil;
    if (sAppKeyz==nil)
        sAppKeyz = AppKeyz.new;
    return sAppKeyz;
}

-(id)init
{
    cmdStrings = [[NSArray alloc] initWithObjects:@"createuser",@"readuser",@"readuserverified",@"readuserverifiedfail",@"updateuser",@"forgotpassword",@"createpurchase",
                  @"listpurchases",@"readpurchase",@"updatepurchase",@"deactivatepurchase",@"createdevice",
                  @"listdevices",@"readdevice",@"updatedevice",@"deletedevice",@"listconsumables",
                  @"readconsumable",@"updateconsumable", nil];
    return self;
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

-(NSString*)deviceId
{
    return [[UIDevice currentDevice] uniqueDeviceIdentifier];
}

-(NSString*)device
{
    return [NSString stringWithFormat:@"%@ %@%@", [[UIDevice currentDevice] model],
    [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
}

-(NSString*)boolString:(BOOL)bl
{
    return (bl) ? @"true" : @"false";
}

-(void)postParams:(NSDictionary*)params command:(Command)cmd
{
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:kAppKeyzHost]];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    [client postPath:@""
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"%@", responseObject);
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

-(void)consumeUser:(NSDictionary*)responseObject
{
    [AKUser shared].userNameFirst = [responseObject objectForKey:@"firstname"]; //String
    [AKUser shared].userNameLast = [responseObject objectForKey:@"lastname"]; //String
    [responseObject objectForKey:@"deviceids"]; //Array
    [responseObject objectForKey:@"productskus"]; //Array
    [responseObject objectForKey:@"consumables"]; //Array
    [AKUser shared].uniqueId = [responseObject objectForKey:@"uniqueid"]; //String
    [AKUser shared].latitude = [responseObject objectForKey:@"longitude"]; //String
    [AKUser shared].longitude = [responseObject objectForKey:@"latitude"]; //String
    [AKUser shared].active = [[responseObject objectForKey:@"active"] boolValue];// BOOL
    [responseObject objectForKey:@"lastlogin"]; //String
    [responseObject objectForKey:@"created"]; //String
    [responseObject objectForKey:@"updated"]; //String
    [[responseObject objectForKey:@"emailverified"] boolValue]; //BOOL
    [responseObject objectForKey:@"sex"];
    [responseObject objectForKey:@"age"];
    [responseObject objectForKey:@"custom1"];
    [responseObject objectForKey:@"custom2"];
    [responseObject objectForKey:@"custom3"];
    [responseObject objectForKey:@"custom4"];
    [responseObject objectForKey:@"custom5"];
    [responseObject objectForKey:@"custom6"];
    [[AKUser shared] saveSettings];
}

-(void)consumeResponse:(id)responseObject withCommand:(Command)cmd
{
    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    int rspCode = [[responseObject objectForKey:@"error"] intValue];
    NSString* message = [responseObject objectForKey:@"debug"];
    
    if (cmd==readuserverified && [[responseObject objectForKey:@"emailverified"] boolValue]==false)
        cmd = readuserverifiedfail;
    
    if (rspCode==0)
    {
        switch (cmd) {
            case createuser:
                message = @"User created successfully.";
                break;
            case readuser:
                message = @"User accout retreived successfully";
                [self consumeUser:responseObject];
                break;
            case readuserverified:
                message = @"User accout retreived successfully"; 
                if (![[responseObject objectForKey:@"emailverified"] boolValue]) message = @"AppKeyz login is for verified users only.";
                [self consumeUser:responseObject];
                break;
            case readuserverifiedfail:
                message = @"AppKeyz login is for verified users only.";
                break;
            case updateuser:
                message = @"User information updated successfully.";
                break;
            case forgotpassword:
                message = @"Password reset email sent.";
                break;
            case createpurchase:
                break;
            case listpurchases:
                [responseObject objectForKey:@"productskus"]; //Array
                break;
            case readpurchase:
                [responseObject objectForKey:@"productsku"]; //String
                [[responseObject objectForKey:@"purchaseprice"] floatValue]; //float
                [responseObject objectForKey:@"purchasedate"]; //String 2013-01-01 format
                [[responseObject objectForKey:@"balance"] floatValue]; //float
                [responseObject objectForKey:@"expiration"]; //String
                [[responseObject objectForKey:@"active"] boolValue]; //BOOL
                break;
            case updatepurchase:
                break;
            case deactivatepurchase:
                break;
            case createdevice:
                break;
            case listdevices:
                [responseObject objectForKey:@"deviceids"]; //Array
                break;
            case readdevice:
                [responseObject objectForKey:@"deviceid"]; //String
                [responseObject objectForKey:@"devicetype"]; //String
                [responseObject objectForKey:@"deviceip"]; //String
                [responseObject objectForKey:@"devicetoken"]; //String
                break;
            case updatedevice:
                break;
            case deletedevice:
                break;
            case listconsumables:
                [responseObject objectForKey:@"consumables"]; //Array
                break;
            case readconsumable:
                [responseObject objectForKey:@"name"]; //String
                [[responseObject objectForKey:@"balance"] floatValue]; //float
                break;
            case updateconsumable:
                break;
        }
        NSLog(@"%@",[cmdStrings objectAtIndex:cmd]);
        [[NSNotificationCenter defaultCenter] postNotificationName: [NSString stringWithFormat:@"AK%@", [cmdStrings objectAtIndex:cmd]] //exa. AKcreateuser
                                                            object: nil
                                                          userInfo: nil];
    }
    
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ says:", appName]
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    
}

//User Interface
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
    [parameters setObject:[self boolString:active] forKey:@"active"];
    [parameters setObject:[self generateUid] forKey:@"uniqueid"];
    
    [self postParams:parameters command:createuser];
}

-(void)readUserWithEmail:(NSString*)email password:(NSString*)pw
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"readuser" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    
    [self postParams:parameters command:readuser];
}

-(void)readUserVerifiedWithEmail:(NSString*)email password:(NSString*)pw
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"readuser" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    
    [self postParams:parameters command:readuserverified];
}

-(void)updateUserWithEmail:(NSString*)email
                  password:(NSString*)pw
                  newemail:(NSString*)newemail
               newpassword:(NSString*)newpw
                     fname:(NSString*)fn
                     lname:(NSString*)ln
                       lat:(NSString*)lat
                       lon:(NSString*)lon
                    active:(BOOL)active
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"updateuser" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:newemail forKey:@"newemail"];
    [parameters setObject:newpw forKey:@"newpassword"];
    [parameters setObject:fn forKey:@"firstname"];
    [parameters setObject:ln forKey:@"lastname"];
    [parameters setObject:lat forKey:@"latitude"];
    [parameters setObject:lon forKey:@"longitude"];
    [parameters setObject:(active) ? @"true" : @"false" forKey:@"active"];
    
    [self postParams:parameters command:updateuser];
}

-(void)forgotpasswordWithEmail:(NSString*)email
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"forgotpassword" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    
    [self postParams:parameters command:forgotpassword];
}

//User Purchases Interface
-(void)createPurchaseWithEmail:(NSString*)email
                      password:(NSString*)pw
                    productSku:(NSString*)sku
                 purchasePrice:(float)price
                       balance:(float)balance
                    expiration:(NSString*)expiration
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"createpurchase" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:sku forKey:@"productsku"];
    [parameters setObject:[NSString stringWithFormat:@"%f",price] forKey:@"purchaseprice"];
    [parameters setObject:[NSString stringWithFormat:@"%f", balance] forKey:@"balance"];
    [parameters setObject:expiration forKey:@"expiration"];
    
    [self postParams:parameters command:createpurchase];
}

-(void)listpurchasesWithEmail:(NSString*)email
                     password:(NSString*)pw
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"listpurchases" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    
    [self postParams:parameters command:listpurchases];
}

-(void)readpurchaseWithEmail:(NSString*)email
                    password:(NSString*)pw
                  productSku:(NSString*)sku
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"readpurchase" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:sku forKey:@"productsku"];
    
    [self postParams:parameters command:readpurchase];
}

-(void)updatepurchaseWithEmail:(NSString*)email
                      password:(NSString*)pw
                    productSku:(NSString*)sku
                       balance:(float)balance
                    expiration:(NSString*)expiration
                        active:(BOOL)active
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"updatepurchase" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:sku forKey:@"productsku"];
    [parameters setObject:[NSString stringWithFormat:@"%f", balance] forKey:@"balance"];
    [parameters setObject:expiration forKey:@"expiration"];
    [parameters setObject:[self boolString:active] forKey:@"active"];
    
    [self postParams:parameters command:updatepurchase];
}

-(void)deactivatepurchaseWithEmail:(NSString*)email
                          password:(NSString*)pw
                        productSku:(NSString*)sku
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"deactivatepurchase" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:sku forKey:@"productsku"];
    
    [self postParams:parameters command:deactivatepurchase];
}

//User Device Interface
-(void)createdeviceWithEmail:(NSString*)email
                    password:(NSString*)pw
                    deviceId:(NSString*)deviceId
                    deviceIp:(NSString*)deviceIp
                 deviceToken:(NSString*)deviceToken
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"createdevice" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    if (deviceId==nil) [parameters setObject:[self deviceId] forKey:@"deviceid"];
    [parameters setObject:[self device] forKey:@"devicetype"];
    [parameters setObject:deviceIp forKey:@"deviceip"];
    [parameters setObject:deviceToken forKey:@"devicetoken"];
    
    [self postParams:parameters command:createdevice];
}
-(void)listdevicesWithEmail:(NSString*)email
                   password:(NSString*)pw
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"listdevices" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];

    [self postParams:parameters command:listdevices];
}

-(void)readdeviceWithEmail:(NSString*)email
                  password:(NSString*)pw
                  deviceId:(NSString*)deviceId
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"readdevice" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    if (deviceId==nil) [parameters setObject:[self deviceId] forKey:@"deviceid"];
    
    [self postParams:parameters command:readdevice];
}

-(void)updatedeviceWithEmail:(NSString*)email
                    password:(NSString*)pw
                    deviceId:(NSString*)deviceId
                 newDeviceId:(NSString*)newDeviceId
                  deviceType:(NSString*)deviceType
                    deviceIp:(NSString*)deviceIp
                 deviceToken:(NSString*)deviceToken
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"updatedevice" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    if (deviceId==nil) [parameters setObject:[self deviceId] forKey:@"deviceid"];
    [parameters setObject:newDeviceId forKey:@"newdeviceid"];
    [parameters setObject:[self device] forKey:@"devicetype"];
    [parameters setObject:deviceIp forKey:@"deviceip"];
    [parameters setObject:deviceToken forKey:@"devicetoken"];
    
    [self postParams:parameters command:updatedevice];
}

-(void)deletedeviceWithEmail:(NSString*)email
                    password:(NSString*)pw
                    deviceId:(NSString*)deviceId
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"deletedevice" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    if (deviceId==nil) [parameters setObject:[self deviceId] forKey:@"deviceid"];
    
    [self postParams:parameters command:deletedevice];
}

//User Consumable Interface
-(void)listconsumablesWithEmail:(NSString*)email
                       password:(NSString*)pw
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"listconsumables" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    
    [self postParams:parameters command:listconsumables];
}

-(void)readconsumableWithEmail:(NSString*)email
                      password:(NSString*)pw
                  consumableId:(int)consumableId
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"readconsumable" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:[NSString stringWithFormat:@"%i",consumableId] forKey:@"consumableid"];
    
    [self postParams:parameters command:readconsumable];
}

-(void)updateconsumableWithEmail:(NSString*)email
                        password:(NSString*)pw
                    consumableId:(int)consumableId
                   adjustBalance:(float)addToBalance
                      setBalance:(float)setBalance
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"updateconsumable" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:[NSString stringWithFormat:@"%i",consumableId] forKey:@"consumableid"];
    [parameters setObject:[NSString stringWithFormat:@"%f",addToBalance] forKey:@"adjustbalance"];
    [parameters setObject:[NSString stringWithFormat:@"%f",setBalance] forKey:@"setbalance"];
    
    [self postParams:parameters command:updateconsumable];
}

@end
