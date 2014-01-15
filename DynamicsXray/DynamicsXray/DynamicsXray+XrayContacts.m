//
//  DynamicsXray+XrayContacts.m
//  DynamicsXray
//
//  Created by Chris Miles on 16/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicsXray+XrayContacts.h"
#import "DynamicsXray_Internal.h"
#import "DXRContactLifetime.h"


@implementation DynamicsXray (XrayContacts)

#pragma mark - Contact Notifications

- (void)dynamicsXrayContactDidBeginNotification:(NSNotification *)notification
{
    id<UIDynamicItem> dynamicItem = notification.userInfo[@"dynamicItem"];
    if (dynamicItem) {
        //DLog(@"DynamicItem did begin contact: %@", dynamicItem);
        DXRContactLifetime *contactLifetime = [self.dynamicItemsContactCount objectForKey:dynamicItem];
        if (contactLifetime == nil) {
            contactLifetime = [[DXRContactLifetime alloc] init];
            [self.dynamicItemsContactCount setObject:contactLifetime forKey:dynamicItem];
        }
        [contactLifetime incrementCount];
    }

    CGPathRef path = CFBridgingRetain(notification.userInfo[@"path"]);
    if (path) {
        id key = CFBridgingRelease(path);
        DXRContactLifetime *contactLifetime = [self.pathsContactCount objectForKey:key];
        if (contactLifetime == nil) {
            contactLifetime = [[DXRContactLifetime alloc] init];
            [self.pathsContactCount setObject:contactLifetime forKey:key];
        }
        [contactLifetime incrementCount];
    }
}

- (void)dynamicsXrayContactDidEndNotification:(NSNotification *)notification
{
    id<UIDynamicItem> dynamicItem = notification.userInfo[@"dynamicItem"];
    if (dynamicItem) {
        //DLog(@"DynamicItem did end contact: %@", dynamicItem);
        DXRContactLifetime *contactLifetime = [self.dynamicItemsContactCount objectForKey:dynamicItem];
        [contactLifetime decrementCount];

        if ([contactLifetime decay] <= 0) {
            [self.dynamicItemsContactCount removeObjectForKey:dynamicItem];
        }
    }

    CGPathRef path = CFBridgingRetain(notification.userInfo[@"path"]);
    if (path) {
        id key = CFBridgingRelease(path);
        DXRContactLifetime *contactLifetime = [self.pathsContactCount objectForKey:key];
        [contactLifetime decrementCount];

        if ([contactLifetime decay] <= 0) {
            [self.pathsContactCount removeObjectForKey:key];
        }
    }
}

@end
