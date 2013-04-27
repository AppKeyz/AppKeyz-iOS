//
//  AppKeyz.h
//
//  Created by Michael Hayes on 1/24/13.
//  Copyright (c) 2013 App Keyz, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum tag_Command {
    createuser,
    readuser,
    updateuser,
    forgotpassword,
    createpurchase,
    listpurchases,
    readpurchase,
    updatepurchase,
    deactivatepurchase,
    createdevice,
    listdevices,
    readdevice,
    updatedevice,
    deletedevice
} Command;

@interface AppKeyz : NSObject

+(AppKeyz*)shared;

-(NSString*)generateUid;
-(void)akPost:(NSDictionary*)params command:(Command)cmd;
-(void)consumeResponse:(id)responseObject withCommand:(Command)cmd;

-(void)createUserWithEmail:(NSString*)email
                  password:(NSString*)pw
                     fname:(NSString*)fn
                     lname:(NSString*)ln
                       lat:(NSString*)lat
                       lon:(NSString*)lon
                    active:(BOOL)active;


-(void)submitAppKey:(NSString*)key;
-(void)revalidateAppKey:(NSString*)key;
-(void)getUserFromKey:(NSString*)key;

@end
