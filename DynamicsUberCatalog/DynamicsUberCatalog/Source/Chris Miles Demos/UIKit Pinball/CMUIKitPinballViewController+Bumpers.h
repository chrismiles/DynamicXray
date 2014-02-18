//
//  CMUIKitPinballViewController+Bumpers.h
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 18/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController.h"

@interface CMUIKitPinballViewController (Bumpers)

- (void)setupBumpers;

- (void)checkBumperContactWithItem1:(id<UIDynamicItem>)item1 item2:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p;

@end
