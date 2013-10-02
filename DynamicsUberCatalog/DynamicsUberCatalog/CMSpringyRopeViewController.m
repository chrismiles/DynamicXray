//
//  CMSpringyRopeViewController.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 30/09/13.
//  Copyright (c) 2013 Apple Inc. All rights reserved.
//
//  Based on CMTraerPhysics demo by Chris Miles, https://github.com/chrismiles/CMTraerPhysics
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

#import "CMSpringyRopeViewController.h"
#import "CMSpringyRopeView.h"

@interface CMSpringyRopeViewController ()

@end

@implementation CMSpringyRopeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO
//    NSMutableArray *toolbarItems = [NSMutableArray array];
//    [toolbarItems addObject:[[UIBarButtonItem alloc] initWithCustomView:self.smoothToggleView]];
//    [toolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
//    [toolbarItems addObject:[[UIBarButtonItem alloc] initWithCustomView:self.fpsLabel]];
//    [toolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
//    if ([self.springyRopeView isDeviceMotionAvailable]) {
//	[toolbarItems addObject:[[UIBarButtonItem alloc] initWithCustomView:self.accelerometerToggleView]];
//    }
//    
//    self.toolbarItems = toolbarItems;
    [self.navigationController setToolbarHidden:NO animated:YES];
    
//    [self.springyRopeView setFpsLabel:self.fpsLabel];
}

- (CMSpringyRopeView *)springyRopeView
{
    return (CMSpringyRopeView *)self.view;
}

@end
