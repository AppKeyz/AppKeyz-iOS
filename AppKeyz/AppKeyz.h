//
//  AppKeyz.h
//
//  Created by Michael Hayes on 1/24/13.
//  Copyright (c) 2013 App Keyz, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIDevice+IdentifierAddition.h"

typedef enum tag_Command {
    createuser,
    readuser,
    readuserverified,
    readuserverifiedfail,
    updateuser,
    forgotpassword,
    createpurchase,
    listpurchases,
    readpurchase,
    updatepurchase,
    deletepurchase,
    createdevice,
    listdevices,
    readdevice,
    updatedevice,
    deletedevice,
    listconsumables,
    readconsumable,
    updateconsumable
} Command;

typedef enum tag_DirectRoute {
    none,
    directRouteLogin,
    directRouteRegister,
    directRouteEditRegister
} DirectRoute;

@interface AppKeyz : NSObject {
    NSArray* cmdStrings;
    NSArray* registerFields;
    
    //for testing purposes
    NSMutableArray* productIds;
    
    DirectRoute directRoute;
}
@property(strong) NSArray* registerFields;
@property(strong) NSMutableArray* productIds;
@property(assign) DirectRoute directRoute;

+(AppKeyz*)shared;

-(NSString*)generateUid;
-(NSString*)deviceId;
-(NSString*)boolString:(BOOL)bl;
-(void)postParams:(NSDictionary*)params command:(Command)cmd;
-(void)consumeResponse:(id)responseObject withCommand:(Command)cmd;

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
                   custom6:(NSString*)custom6;
-(void)readUserWithEmail:(NSString*)email password:(NSString*)pw;
-(void)readUserVerifiedWithEmail:(NSString*)email password:(NSString*)pw;
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
                   custom6:(NSString*)custom6;
-(void)forgotpasswordWithEmail:(NSString*)email;

//User Purchases Interface
-(void)createPurchaseWithEmail:(NSString*)email
                      password:(NSString*)pw
                    productSku:(NSString*)sku
                 purchasePrice:(float)price
                       balance:(float)balance
                    expiration:(NSString*)expiration;
-(void)listpurchasesWithEmail:(NSString*)email
                     password:(NSString*)pw;
-(void)readpurchaseWithEmail:(NSString*)email
                    password:(NSString*)pw
                  purchaseId:(NSString*)purchaseId;
-(void)updatepurchaseWithEmail:(NSString*)email
                      password:(NSString*)pw
                    purchaseId:(NSString*)purchaseId
                    expiration:(NSString*)expiration
                        active:(BOOL)active;
-(void)deletepurchaseWithEmail:(NSString*)email
                          password:(NSString*)pw
                        purchaseId:(NSString*)purchaseId;

//User Device Interface ***If nil is passed to deviceId, a Uid will be generated automagically
-(void)createdeviceWithEmail:(NSString*)email
                    password:(NSString*)pw
                    deviceId:(NSString*)deviceId
                    deviceIp:(NSString*)deviceIp
                 deviceToken:(NSString*)deviceToken;
-(void)listdevicesWithEmail:(NSString*)email
                   password:(NSString*)pw;
-(void)readdeviceWithEmail:(NSString*)email
                  password:(NSString*)pw
                  deviceId:(NSString*)deviceId;
-(void)updatedeviceWithEmail:(NSString*)email
                    password:(NSString*)pw
                    deviceId:(NSString*)deviceId
                 newDeviceId:(NSString*)newDeviceId
                  deviceType:(NSString*)deviceType
                    deviceIp:(NSString*)deviceIp
                 deviceToken:(NSString*)deviceToken;
-(void)deletedeviceWithEmail:(NSString*)email
                    password:(NSString*)pw
                    deviceId:(NSString*)deviceId;

//User Consumable Interface
-(void)listconsumablesWithEmail:(NSString*)email
                       password:(NSString*)pw;
-(void)readconsumableWithEmail:(NSString*)email
                      password:(NSString*)pw
                  consumableId:(int)consumableId;
-(void)updateconsumableWithEmail:(NSString*)email
                        password:(NSString*)pw
                    consumableId:(int)consumableId
                   adjustBalance:(float)addToBalance
                      setBalance:(float)setBalance;
@end
