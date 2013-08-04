//
//  NSObject+CMObjectIntrospection.m
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "NSObject+CMObjectIntrospection.h"
@import ObjectiveC.runtime;

@implementation NSObject (CMObjectIntrospection)

- (void)CMObjectIntrospectionDumpInfo
{
    Class clazz = [self class];
    u_int count;
    
    Ivar *ivars = class_copyIvarList(clazz, &count);
    NSMutableArray *ivarArray = [NSMutableArray arrayWithCapacity:count];
    for (u_int i = 0; i < count ; i++)
    {
        const char *ivarName = ivar_getName(ivars[i]);
        [ivarArray addObject:[NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
    }
    free(ivars);
    
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (u_int i = 0; i < count ; i++)
    {
        const char *propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    Method *methods = class_copyMethodList(clazz, &count);
    NSMutableArray *methodArray = [NSMutableArray arrayWithCapacity:count];
    for (u_int i = 0; i < count ; i++)
    {
        SEL selector = method_getName(methods[i]);
        const char *methodName = sel_getName(selector);
        [methodArray addObject:[NSString  stringWithCString:methodName encoding:NSUTF8StringEncoding]];
    }
    free(methods);
    
    NSDictionary *classDump = [NSDictionary dictionaryWithObjectsAndKeys:
                               ivarArray, @"ivars",
                               propertyArray, @"properties",
                               methodArray, @"methods",
                               nil];
    
    NSLog(@"%@", classDump);
}

@end
