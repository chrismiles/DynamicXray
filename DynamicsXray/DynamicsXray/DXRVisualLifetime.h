//
//  DXRVisualLifetime.h
//  DynamicsXray
//
//  Created by Chris Miles on 21/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXRVisualLifetime : NSObject

@property (assign, nonatomic, readonly) NSUInteger referenceCount;

@property (assign, nonatomic, readonly) float decay;  // 1.0 -> 0

- (void)incrementReferenceCount;
- (void)decrementReferenceCount;

@end
