//
//  DXRContactHandler.h
//  DynamicXray
//
//  Created by Chris Miles on 10/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXRPhysicsKitPrivate.h"

extern NSString * const DXRDynamicXrayContactDidBeginNotification;
extern NSString * const DXRDynamicXrayContactDidEndNotification;


@interface DXRContactHandler : NSObject

+ (void)handleBeginContactWithPhysicsContact:(PKPhysicsContact *)physicsContact;

+ (void)handleEndContactWithPhysicsContact:(PKPhysicsContact *)physicsContact;

@end
