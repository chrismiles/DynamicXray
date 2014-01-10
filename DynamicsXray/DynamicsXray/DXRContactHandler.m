//
//  DXRContactHandler.m
//  DynamicsXray
//
//  Created by Chris Miles on 10/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRContactHandler.h"
@import UIKit;


@implementation DXRContactHandler

+ (void)handleBeginContactWithPhysicsContact:(PKPhysicsContact *)physicsContact
{

    PKPhysicsBody *bodyA = physicsContact.bodyA;
    PKPhysicsBody *bodyB = physicsContact.bodyB;

    id objectA = bodyA.representedObject;
    id objectB = bodyB.representedObject;

    NSInteger dynamicTypeA = [[bodyA valueForKey:@"_dynamicType"] integerValue];
    NSInteger dynamicTypeB = [[bodyB valueForKey:@"_dynamicType"] integerValue];

    NSInteger shapeTypeA = [[bodyA valueForKey:@"_shapeType"] integerValue];
    NSInteger shapeTypeB = [[bodyB valueForKey:@"_shapeType"] integerValue];

    DLog(@"physicsContact: %@", physicsContact);
    DLog(@"bodyA: %@ objectA: %@ dynamicType=%ld shapeType=%ld", bodyA, objectA, (long)dynamicTypeA, (long)shapeTypeA);
    DLog(@"bodyB: %@ objectB: %@ dynamicType=%ld shapeType=%ld", bodyB, objectB, (long)dynamicTypeB, (long)shapeTypeB);

    [self handleBeginContactWithObject:objectA];
    [self handleBeginContactWithObject:objectB];
}

+ (void)handleEndContactWithPhysicsContact:(PKPhysicsContact *)physicsContact
{
    PKPhysicsBody *bodyA = physicsContact.bodyA;
    PKPhysicsBody *bodyB = physicsContact.bodyB;

    id objectA = bodyA.representedObject;
    id objectB = bodyB.representedObject;

    DLog(@"physicsContact: %@", physicsContact);
    DLog(@"bodyA: %@ objectA: %@", bodyA, objectA);
    DLog(@"bodyB: %@ objectB: %@", bodyB, objectB);

}


+ (void)handleBeginContactWithObject:(id)object
{
    if (object && [object conformsToProtocol:@protocol(UIDynamicItem)]) {
        DLog(@"DynamicItem began contact %@", object);
    }
    else {
        DLog(@"Unhandled contact object: %@", object);
    }
}

@end
