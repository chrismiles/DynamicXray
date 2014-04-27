//
//  DynamicsXray+XrayContacts.h
//  DynamicsXray
//
//  Created by Chris Miles on 16/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicXray.h"

@interface DynamicXray (XrayContacts)

- (void)dynamicsXrayContactDidBeginNotification:(NSNotification *)notification;
- (void)dynamicsXrayContactDidEndNotification:(NSNotification *)notification;

@end
