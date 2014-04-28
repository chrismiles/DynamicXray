//
//  DXRDecayingLifetime.m
//  DynamicXray
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _decayTime = DXRDefaultDecayTime;
    }
    return self;
}

- (void)incrementReferenceCount
{
    self.referenceCount += 1;
    self.allReferencesEndedTime = 0;
}

- (void)decrementReferenceCount
{
    if (self.referenceCount > 0) self.referenceCount -= 1;

    if (self.referenceCount == 0 && self.allReferencesEndedTime <= 0) self.allReferencesEndedTime = [[NSDate date] timeIntervalSinceReferenceDate];
}

- (float)decay
{
    float decay = 1.0;

    if (self.referenceCount == 0) {
        if (self.allReferencesEndedTime <= 0) self.allReferencesEndedTime = [[NSDate date] timeIntervalSinceReferenceDate];

        NSTimeInterval currentTime = [[NSDate date] timeIntervalSinceReferenceDate];
        NSTimeInterval decayTime = self.decayTime;

        if (currentTime - self.allReferencesEndedTime > decayTime) {
            decay = 0;
        }
        else {
            decay = 1.0f - (currentTime - self.allReferencesEndedTime) / decayTime;
        }
    }

    return decay;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p referenceCount=%lu>", [self class], self, (unsigned long)self.referenceCount];
}

@end
