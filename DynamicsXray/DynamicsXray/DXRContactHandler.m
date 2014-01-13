//
//  DXRContactHandler.m
//  DynamicsXray
//
//  Created by Chris Miles on 10/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRContactHandler.h"
@import UIKit;

@import ObjectiveC.runtime;

#import "NSObject+CMObjectIntrospection.h"


typedef NS_ENUM(NSInteger, DXRPhysicsBodyShapeType)
{
    DXRPhysicsBodyShapeTypeUnknown0 = 0,
    DXRPhysicsBodyShapeTypeUnknown1,
    DXRPhysicsBodyShapeTypeRectangle,
    DXRPhysicsBodyShapeTypeUnknown3,
    DXRPhysicsBodyShapeTypeUnknown4,
    DXRPhysicsBodyShapeTypeUnknown5,
    DXRPhysicsBodyShapeTypeEdgeLoop,
};


NSString * const DXRDynamicsXrayContactDidBeginNotification = @"DXRDynamicsXrayContactDidBeginNotification";
NSString * const DXRDynamicsXrayContactDidEndNotification = @"DXRDynamicsXrayContactDidEndNotification";


@implementation DXRContactHandler

#pragma mark - Handle Contact with PKPhysicsContact

+ (void)handleBeginContactWithPhysicsContact:(PKPhysicsContact *)physicsContact
{
    PKPhysicsBody *bodyA = physicsContact.bodyA;
    PKPhysicsBody *bodyB = physicsContact.bodyB;

    [self handleBeginContactWithPhysicsBody:bodyA];
    [self handleBeginContactWithPhysicsBody:bodyB];
}

+ (void)handleEndContactWithPhysicsContact:(PKPhysicsContact *)physicsContact
{
    PKPhysicsBody *bodyA = physicsContact.bodyA;
    PKPhysicsBody *bodyB = physicsContact.bodyB;

    [self handleEndContactWithPhysicsBody:bodyA];
    [self handleEndContactWithPhysicsBody:bodyB];
}


#pragma mark - Handle Contact with Physics Bodies

+ (void)handleBeginContactWithPhysicsBody:(PKPhysicsBody *)body
{
    NSInteger shapeType = [[body valueForKey:@"_shapeType"] integerValue];

    if (shapeType == DXRPhysicsBodyShapeTypeEdgeLoop) {
        Class bodyClass = NSClassFromString(@"PKPhysicsBody");

        if ([self isMinimumSystemVersion:@"7.1"]) {
            // object_getIvar() crashes on 7.0; works on 7.1
            CGPathRef path = CFBridgingRetain([body getValueForIvarWithName:@"_path" class:bodyClass]);
            if (path) {
                [self handleBeginContactWithShapePath:path];
            }
        }
    }

    id object = body.representedObject;

    //DLog(@"physicsContact: %@", physicsContact);
    //NSInteger dynamicType = [[body valueForKey:@"_dynamicType"] integerValue];
    //DLog(@"body: %@ object: %@ dynamicType=%ld shapeType=%ld", body, object, (long)dynamicType, (long)shapeType);

    if (object) [self handleBeginContactWithObject:object];
}

+ (void)handleEndContactWithPhysicsBody:(PKPhysicsBody *)body
{
    NSInteger shapeType = [[body valueForKey:@"_shapeType"] integerValue];

    if (shapeType == DXRPhysicsBodyShapeTypeEdgeLoop) {
        Class bodyClass = NSClassFromString(@"PKPhysicsBody");

        if ([self isMinimumSystemVersion:@"7.1"]) {
            // object_getIvar() crashes on 7.0; works on 7.1
            CGPathRef path = CFBridgingRetain([body getValueForIvarWithName:@"_path" class:bodyClass]);
            if (path) {
                [self handleEndContactWithShapePath:path];
            }
        }
    }

    id object = body.representedObject;

    //DLog(@"physicsContact: %@", physicsContact);
    //DLog(@"bodyA: %@ objectA: %@", bodyA, objectA);
    //DLog(@"bodyB: %@ objectB: %@", bodyB, objectB);

    [self handleEndContactWithObject:object];
}


#pragma mark - Handle Contact with Objects

+ (void)handleBeginContactWithObject:(id)object
{
    if (object && [object conformsToProtocol:@protocol(UIDynamicItem)]) {
        //DLog(@"DynamicItem began contact %@", object);

        NSDictionary *userInfo = @{@"dynamicItem": object};
        [[NSNotificationCenter defaultCenter] postNotificationName:DXRDynamicsXrayContactDidBeginNotification object:self userInfo:userInfo];
    }
    else {
        DLog(@"Unhandled contact object: %@", object);
    }
}

+ (void)handleEndContactWithObject:(id)object
{
    if (object && [object conformsToProtocol:@protocol(UIDynamicItem)]) {
        //DLog(@"DynamicItem end contact %@", object);

        NSDictionary *userInfo = @{@"dynamicItem": object};
        [[NSNotificationCenter defaultCenter] postNotificationName:DXRDynamicsXrayContactDidEndNotification object:self userInfo:userInfo];
    }
    else {
        DLog(@"Unhandled contact object: %@", object);
    }
}


#pragma mark - Handle Contact with Shape Path

+ (void)handleBeginContactWithShapePath:(CGPathRef)path
{
    if (path) {
        id obj = (__bridge id)(path);
        NSDictionary *userInfo = @{@"path": obj};
        [[NSNotificationCenter defaultCenter] postNotificationName:DXRDynamicsXrayContactDidBeginNotification object:self userInfo:userInfo];
    }
}

+ (void)handleEndContactWithShapePath:(CGPathRef)path
{
    if (path) {
        id obj = (__bridge id)(path);
        NSDictionary *userInfo = @{@"path": obj};
        [[NSNotificationCenter defaultCenter] postNotificationName:DXRDynamicsXrayContactDidEndNotification object:self userInfo:userInfo];
    }
}


#pragma mark - System Version Comparison

+ (BOOL)isMinimumSystemVersion:(NSString *)minimumVersion
{
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return ([minimumVersion compare:systemVersion options:NSNumericSearch] != NSOrderedDescending);
}

@end
