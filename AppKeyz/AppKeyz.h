//
//  AppKeyz.h
//
//  Created by Michael Hayes on 1/24/13.
//  Copyright (c) 2013 App Keyz, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "JSON.h"

@interface AppKeyz : NSObject

+(AppKeyz*)shared;

-(void)submitAppKey:(NSString*)key;
-(void)revalidateAppKey:(NSString*)key;
-(void)getUserFromKey:(NSString*)key;

@end
