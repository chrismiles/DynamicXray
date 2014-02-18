//
//  CMUIKitPinballViewController+Bumpers.h
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 18/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController.h"

extern NSString * const CMUIKitPinballBumperBoundaryIdentifierPrefix;


@interface CMUIKitPinballViewController (Bumpers)

- (void)setupBumpers;

- (void)handleBumperContactWithBoundaryIdentifier:(NSString *)boundaryID item:(id<UIDynamicItem>)item atPoint:(CGPoint)p;

@end
