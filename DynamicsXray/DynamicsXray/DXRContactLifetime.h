//
//  DXRContactLifetime.h
//  DynamicsXray
//
//  Created by Chris Miles on 13/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXRContactLifetime : NSObject

@property (assign, nonatomic, readonly) NSUInteger contactCount;
@property (assign, nonatomic, readonly) float decay;  // 1.0 -> 0

- (void)incrementCount;
- (void)decrementCount;

@end
