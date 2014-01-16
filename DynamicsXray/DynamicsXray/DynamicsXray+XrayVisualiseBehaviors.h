//
//  DynamicsXray+XrayVisualiseBehaviors.h
//  DynamicsXray
//
//  Created by Chris Miles on 16/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicsXray.h"

@interface DynamicsXray (XrayVisualiseBehaviors)

- (void)visualiseAttachmentBehavior:(UIAttachmentBehavior *)attachmentBehavior;

- (void)visualiseCollisionBehavior:(UICollisionBehavior *)collisionBehavior;

- (void)visualiseGravityBehavior:(UIGravityBehavior *)gravityBehavior;

- (void)visualiseSnapBehavior:(UISnapBehavior *)snapBehavior;

@end
