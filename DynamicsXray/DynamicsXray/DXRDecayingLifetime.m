//
//  DXRDecayingLifetime.m
//  DynamicsXray
//
//  Created by Chris Miles on 21/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRDecayingLifetime.h"

static NSTimeInterval const DXRDefaultDecayTime = 0.2;    // decay time in seconds


@interface DXRDecayingLifetime ()

@property (assign, nonatomic, readwrite) NSUInteger referenceCount;

@property (assign, nonatomic) NSTimeInterval allReferencesEndedTime;

@end


@implementation DXRDecayingLifetime

- (void)incrementReferenceCount
{
    self.referenceCount += 1;
}

- (void)decrementReferenceCount
{
    if (self.referenceCount > 0) self.referenceCount -= 1;

    if (self.referenceCount == 0) self.allReferencesEndedTime = [[NSDate date] timeIntervalSinceReferenceDate];
}

- (float)decay
{
    float decay = 1.0;

    if (self.referenceCount == 0) {
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSinceReferenceDate];

        if (currentTime - self.allReferencesEndedTime > DXRDefaultDecayTime) {
            decay = 0;
        }
        else {
            decay = 1.0f - (currentTime - self.allReferencesEndedTime) / DXRDefaultDecayTime;
        }
    }

    return decay;
}

@end
