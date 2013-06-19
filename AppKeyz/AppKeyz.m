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
@synthesize registerFields, productIds, directRoute;

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
                  @"listpurchases",@"readpurchase",@"updatepurchase",@"deletepurchase",@"createdevice",
                  @"listdevices",@"readdevice",@"updatedevice",@"deletedevice",@"listconsumables",
                  @"readconsumable",@"updateconsumable", nil];
    
    self.productIds = NSMutableArray.new;
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

-(NSString*)floatToString:(float)flt
{
    NSString* floatString;
    if (flt==-1)
        floatString = @"";
    else
        floatString = [NSString stringWithFormat:@"%f",flt];
    return floatString;
}

-(NSString*)nilToString:(id)attr
{
    if (attr==nil) return @"";
    else return (NSString*)attr;
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
    NSLog(@"%@",params);
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
    
    switch (cmd) {
        case createuser:
            switch (rspCode) {
                case 0:
                    message = @"User created successfully.";
                    break;        
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 3:
                    //Uniqueid has already been taken within the scope of this app.
                    break;
                case 4:
                    //This username already exists
                    break;
            }
            break;
        case readuser:
            switch (rspCode) {
                case 0:
                    message = @"User accout retreived successfully";
                    [self consumeUser:responseObject];
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
            }
            break;
        case readuserverified:
            switch (rspCode) {
                case 0:
                    message = @"User accout retreived successfully";
                    if (![[responseObject objectForKey:@"emailverified"] boolValue]) message = @"AppKeyz login is for verified users only.";
                    [self consumeUser:responseObject];
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
            }
            break;
        case readuserverifiedfail:
            switch (rspCode) {
                case 0:
                    message = @"AppKeyz login is for verified users only.";
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
            }
            break;
        case updateuser:
            switch (rspCode) {
                case 0:
                    message = @"User information updated successfully.";
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
            }
            break;
        case forgotpassword:
            switch (rspCode) {
                case 0:
                    message = @"Password reset email sent.";
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
            }
            break;
        case createpurchase:
            switch (rspCode) {
                case 0:
                    message = @"Purchase process successfully.";
                    [self.productIds addObject:responseObject];
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
                case 4:
                    //Invalid Purchase
                    break;
            }
            break;
        case listpurchases:     
            switch (rspCode) {
                case 0:
                    message = nil;
                    self.productIds = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"purchases"]]; //Array
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
            }
            break;
        case readpurchase:
            switch (rspCode) {
                case 0:
                    message = nil;
                    [responseObject objectForKey:@"productsku"]; //String
                    [[responseObject objectForKey:@"purchaseprice"] floatValue]; //float
                    [responseObject objectForKey:@"purchasedate"]; //String 2013-01-01 format
                    [responseObject objectForKey:@"consumableid"]; //String
                    [responseObject objectForKey:@"expiration"]; //String
                    [[responseObject objectForKey:@"active"] boolValue]; //BOOL
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
                case 4:
                    //Invalid Purchase
                    break;
            }
            break;
        case updatepurchase:
            switch (rspCode) {
                case 0:
                    message = nil;
                    //Success
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
                case 4:
                    //Invalid Purchase
                    break;
            }
            break;
        case deletepurchase:
            switch (rspCode) {
                case 0:
                    message = nil;
                    //Success
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
                case 4:
                    //Invalid Purchase
                    break;
            }
            break;
        case createdevice:
            switch (rspCode) {
                case 0:
                    message = nil;
                    //Success
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
                case 3:
                    //Duplicate Device
                    break;
                case 4:
                    //Invalid Device
                    break;
                case 5:
                    //Too many devices
                    break;
            }

            break;
        case listdevices:
            
            switch (rspCode) {
                case 0:
                    message = nil;
                    [responseObject objectForKey:@"deviceids"]; //Array
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
            }
            break;
        case readdevice:
            switch (rspCode) {
                case 0:
                    message = nil;
                    [responseObject objectForKey:@"deviceid"]; //String
                    [responseObject objectForKey:@"devicetype"]; //String
                    [responseObject objectForKey:@"deviceip"]; //String
                    [responseObject objectForKey:@"devicetoken"]; //String
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
                case 4:
                    //Invalid Device
                    break;
            }
            break;
        case updatedevice:
            switch (rspCode) {
                case 0:
                    message = nil;
                    //Success
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
                case 3:
                    //Duplicate Device
                    break;
                case 4:
                    //Invalid Device
                    break;
            }
            break;
        case deletedevice:
            switch (rspCode) {
                case 0:
                    message = nil;
                    //Success
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
                case 4:
                    //Invalid Device
                    break;
            }
            break;
        case listconsumables:
            switch (rspCode) {
                case 0:
                    message = nil;
                    [responseObject objectForKey:@"consumables"]; //Array
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
            }
            break;
        case readconsumable:
            switch (rspCode) {
                case 0:
                    message = nil;
                    [responseObject objectForKey:@"name"]; //String
                    [[responseObject objectForKey:@"balance"] floatValue]; //float
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
            }
            break;
        case updateconsumable:
            switch (rspCode) {
                case 0:
                    message = nil;
                    //Success
                    break;
                case 1:
                    //Bad Parameters.  Usually means you're missing apiaction or apptoken
                    break;
                case 2:
                    //This Email does not does exist in our system, please Register or log in using a different email
                    break;
                case 4:
                    //Invalid Consumable
                    break;
            }
            break;
    }
    
    if (rspCode==100) message = nil; //Server error message for dubugging purposes only
    
    NSLog(@"%@",[cmdStrings objectAtIndex:cmd]);
    [[NSNotificationCenter defaultCenter] postNotificationName: [NSString stringWithFormat:@"AK%@", [cmdStrings objectAtIndex:cmd]] //exa. AKcreateuser
                                                        object: nil
                                                      userInfo: nil];
    
    if (message!=nil) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ says:", appName]
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}

//User Interface
-(void)createUserWithEmail:(NSString*)email
                  password:(NSString*)pw
                     fname:(NSString*)fn
                     lname:(NSString*)ln
                       lat:(NSString*)lat
                       lon:(NSString*)lon
                    active:(BOOL)active
                       age:(NSString*)age
                       sex:(NSString*)sex
                   custom1:(NSString*)custom1
                   custom2:(NSString*)custom2
                   custom3:(NSString*)custom3
                   custom4:(NSString*)custom4
                   custom5:(NSString*)custom5
                   custom6:(NSString*)custom6
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"createuser" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:[self nilToString:fn] forKey:@"firstname"];
    [parameters setObject:[self nilToString:ln] forKey:@"lastname"];
    [parameters setObject:lat forKey:@"latitude"];
    [parameters setObject:lon forKey:@"longitude"];
    [parameters setObject:[self nilToString:age] forKey:@"age"];
    [parameters setObject:[self nilToString:sex] forKey:@"sex"];
    [parameters setObject:[self nilToString:custom1] forKey:@"custom1"];
    [parameters setObject:[self nilToString:custom2] forKey:@"custom2"];
    [parameters setObject:[self nilToString:custom3] forKey:@"custom3"];
    [parameters setObject:[self nilToString:custom4] forKey:@"custom4"];
    [parameters setObject:[self nilToString:custom5] forKey:@"custom5"];
    [parameters setObject:[self nilToString:custom6] forKey:@"custom6"];
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
                       age:(NSString*)age
                       sex:(NSString*)sex
                   custom1:(NSString*)custom1
                   custom2:(NSString*)custom2
                   custom3:(NSString*)custom3
                   custom4:(NSString*)custom4
                   custom5:(NSString*)custom5
                   custom6:(NSString*)custom6
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"updateuser" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:[self nilToString:newemail] forKey:@"newemail"];
    [parameters setObject:[self nilToString:newpw] forKey:@"newpassword"];
    [parameters setObject:[self nilToString:fn] forKey:@"firstname"];
    [parameters setObject:[self nilToString:ln] forKey:@"lastname"];
    [parameters setObject:lat forKey:@"latitude"];
    [parameters setObject:lon forKey:@"longitude"];
    [parameters setObject:[self nilToString:age] forKey:@"age"];
    [parameters setObject:[self nilToString:sex] forKey:@"sex"];
    [parameters setObject:[self nilToString:custom1] forKey:@"custom1"];
    [parameters setObject:[self nilToString:custom2] forKey:@"custom2"];
    [parameters setObject:[self nilToString:custom3] forKey:@"custom3"];
    [parameters setObject:[self nilToString:custom4] forKey:@"custom4"];
    [parameters setObject:[self nilToString:custom5] forKey:@"custom5"];
    [parameters setObject:[self nilToString:custom6] forKey:@"custom6"];
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
    NSLog(@"user logged out: %i",[AKUser shared].isLoggedIn);
    if ([AKUser shared].isLoggedIn != true)
    {
        NSLog(@"isn't logged in"); 
        [AppKeyzSuite loginRegAlertView];
    }
    else
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"createpurchase" forKey:@"apiaction"];
        [parameters setObject:kAppToken forKey:@"apptoken"];
        
        [parameters setObject:email forKey:@"email"];
        [parameters setObject:pw forKey:@"password"];
        [parameters setObject:sku forKey:@"productsku"];
        [parameters setObject:[self floatToString:price] forKey:@"purchaseprice"];
        [parameters setObject:[self floatToString:balance] forKey:@"balance"];
        [parameters setObject:expiration forKey:@"expiration"];
        
        [self postParams:parameters command:createpurchase];
    }
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
                  purchaseId:(NSString*)purchaseId
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"readpurchase" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:purchaseId forKey:@"purchaseid"];
    
    [self postParams:parameters command:readpurchase];
}

-(void)updatepurchaseWithEmail:(NSString*)email
                      password:(NSString*)pw
                    purchaseId:(NSString*)purchaseId
                    expiration:(NSString*)expiration
                        active:(BOOL)active
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"updatepurchase" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:purchaseId forKey:@"purchaseid"];
    [parameters setObject:expiration forKey:@"expiration"];
    [parameters setObject:[self boolString:active] forKey:@"active"];
    
    [self postParams:parameters command:updatepurchase];
}

-(void)deletepurchaseWithEmail:(NSString*)email
                          password:(NSString*)pw
                        purchaseId:(NSString*)purchaseId
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"deletepurchase" forKey:@"apiaction"];
    [parameters setObject:kAppToken forKey:@"apptoken"];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:pw forKey:@"password"];
    [parameters setObject:purchaseId forKey:@"purchaseid"];
    
    [self postParams:parameters command:deletepurchase];
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
    [parameters setObject:[self deviceId] forKey:@"deviceid"];
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
    [parameters setObject:[self deviceId] forKey:@"deviceid"];
    
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
    [parameters setObject:[self deviceId] forKey:@"deviceid"];
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
    [parameters setObject:[self deviceId] forKey:@"deviceid"];
    
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
    if (addToBalance!=-1)[parameters setObject:[NSString stringWithFormat:@"%f",addToBalance] forKey:@"adjustbalance"];
    if (setBalance!=-1)[parameters setObject:[NSString stringWithFormat:@"%f",setBalance] forKey:@"setbalance"];
    
    [self postParams:parameters command:updateconsumable];
}



@end
