//
//  DXRContactLifetime.m
//  DynamicsXray
//
//  Created by Chris Miles on 13/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRContactLifetime.h"

static NSTimeInterval const DXRContactDecayTime = 0.2;    // decay time in seconds


@interface DXRContactLifetime ()

@property (assign, nonatomic, readwrite) NSUInteger contactCount;

@property (assign, nonatomic) NSTimeInterval allContactsEndedTime;

@end


@implementation DXRContactLifetime

- (void)incrementCount
{
    self.contactCount += 1;
}

- (void)decrementCount
{
    if (self.contactCount > 0) self.contactCount -= 1;

    if (self.contactCount == 0) self.allContactsEndedTime = [[NSDate date] timeIntervalSinceReferenceDate];
}

- (float)decay
{
    float decay = 1.0;

    if (self.contactCount == 0) {
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSinceReferenceDate];

        if (currentTime - self.allContactsEndedTime > DXRContactDecayTime) {
            decay = 0;
        }
        else {
            decay = 1.0f - (currentTime - self.allContactsEndedTime) / DXRContactDecayTime;
        }
    }

    return decay;
}

@end
