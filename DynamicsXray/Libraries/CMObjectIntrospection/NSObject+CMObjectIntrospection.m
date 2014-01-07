//
//  NSObject+CMObjectIntrospection.m
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NSObject+CMObjectIntrospection.h"
@import ObjectiveC.runtime;

@implementation NSObject (CMObjectIntrospection)

- (void)CMObjectIntrospectionDumpInfo
{
    Class myClass = [self class];
    u_int count;
    
    Ivar *ivars = class_copyIvarList(myClass, &count);
    NSMutableArray *ivarArray = [NSMutableArray arrayWithCapacity:count];
    for (u_int i = 0; i < count ; i++)
    {
        const char *ivarName = ivar_getName(ivars[i]);
        [ivarArray addObject:[NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
    }
    free(ivars);
    
    objc_property_t *properties = class_copyPropertyList(myClass, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (u_int i = 0; i < count ; i++)
    {
        const char *propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    Method *methods = class_copyMethodList(myClass, &count);
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
    
    NSLog(@"%@: %@", myClass, classDump);
}

@end
