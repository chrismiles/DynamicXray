//
//  DXRPhysicsKitPrivate.h
//  DynamicXray
//
//  Created by Chris Miles on 10/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import <Foundation/Foundation.h>


//@interface PKPhysicsWorld : NSObject <NSCoding>
//
//@property(nonatomic) id /* <PKPhysicsContactDelegate> */ contactDelegate;
//
//@end
//
//
//@interface UIDynamicAnimator (DynamicXrayPrivateAccess)
//
//@property (strong, readonly) PKPhysicsWorld *_world;
//
//@end

@interface PKPhysicsBody : NSObject <NSCopying, NSCoding>

//- (id)allContactedBodies;

@property(nonatomic) __weak id <NSObject> representedObject;

@end


@interface PKPhysicsContact : NSObject

@property(readonly, nonatomic) float collisionImpulse;
@property(readonly, nonatomic) struct CGPoint contactPoint;
@property(readonly, nonatomic) PKPhysicsBody *bodyB;
@property(readonly, nonatomic) PKPhysicsBody *bodyA;

@end


