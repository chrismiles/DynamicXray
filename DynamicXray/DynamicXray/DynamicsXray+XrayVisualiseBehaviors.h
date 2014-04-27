//
//  DynamicsXray+XrayVisualiseBehaviors.h
//  DynamicsXray
//
//  Created by Chris Miles on 16/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicXray.h"

@interface DynamicXray (XrayVisualiseBehaviors)

- (void)visualiseAttachmentBehavior:(UIAttachmentBehavior *)attachmentBehavior;

- (void)visualiseCollisionBehavior:(UICollisionBehavior *)collisionBehavior;

- (void)visualiseGravityBehavior:(UIGravityBehavior *)gravityBehavior;

- (void)visualiseSnapBehavior:(UISnapBehavior *)snapBehavior;

- (void)visualisePushBehavior:(UIPushBehavior *)pushBehavior;
- (void)visualisePushBehavior:(UIPushBehavior *)pushBehavior withTransparency:(CGFloat)transparency;
- (void)visualiseInstantaneousPushBehavior:(UIPushBehavior *)pushBehavior atLocations:(NSArray *)pushLocations withTransparency:(CGFloat)transparency;

@end
