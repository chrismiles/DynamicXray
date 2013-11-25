//
//  TLWobblySpringFlowLayout.m
//  UICollectionView-Spring-Demo
//
//  Created by Ash Furrow on 2013-07-31.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//
//  Modified by Gerald Kim
//  DynamicsXray added by Chris Miles
//

#import "TLWobblySpringFlowLayout.h"

@interface TLWobblySpringFlowLayout ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) DynamicsXRay *dynamicsXray;

// Needed for tiling
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat latestDelta;
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;

@end

@implementation TLWobblySpringFlowLayout

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        self.itemSize = CGSizeMake(300, 44);
        self.sectionInset = UIEdgeInsetsMake(30, 10, 10, 10);

        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];

        self.dynamicsXray = [[DynamicsXRay alloc] init];
        self.dynamicsXray.active = NO;
        [self.dynamicAnimator addBehavior:self.dynamicsXray];

        self.visibleIndexPathsSet = [NSMutableSet set];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] != self.interfaceOrientation) {

        // Remove all behaviors, except DynamicsXray
        [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIDynamicBehavior *behavior, __unused NSUInteger idx, __unused BOOL *stop) {
            if ([behavior isKindOfClass:[DynamicsXRay class]] == NO) {
                [self.dynamicAnimator removeBehavior:behavior];
            }
        }];

        self.visibleIndexPathsSet = [NSMutableSet set];
    }
    
    self.interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    // Need to overflow our actual visible rect slightly to avoid flickering.
    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, -100, -100);
    
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    
    // Step 1: Remove any behaviours that are no longer visible.
    NSArray *noLongerVisibleBehaviours = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, __unused NSDictionary *bindings) {
        BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[[[behaviour items] firstObject] indexPath]] != nil;
        return !currentlyVisible;
    }]];
    
    [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, __unused NSUInteger index, __unused BOOL *stop) {
        if ([obj isKindOfClass:[UIAttachmentBehavior class]]) {
            [self.dynamicAnimator removeBehavior:obj];
            [self.visibleIndexPathsSet removeObject:[[[obj items] firstObject] indexPath]];
        }
    }];
    
    // Step 2: Add any newly visible behaviours.
    // A "newly visible" item is one that is in the itemsInVisibleRect(Set|Array) but not in the visibleIndexPathsSet
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, __unused NSDictionary *bindings) {
        BOOL currentlyVisible = [self.visibleIndexPathsSet member:item.indexPath] != nil;
        return !currentlyVisible;
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, __unused NSUInteger idx, __unused BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item offsetFromCenter:UIOffsetMake(-item.size.width/2, -item.size.height/2) attachedToAnchor:item.frame.origin];
        
        springBehaviour.length = 1.0f;
        springBehaviour.damping = 0.8f;
        springBehaviour.frequency = 1.0f;
        
        UIAttachmentBehavior *spring2Behaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
        spring2Behaviour.length = 1.0f;
        spring2Behaviour.damping = 0.8f;
        spring2Behaviour.frequency = 1.0f;
        
        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            CGFloat distanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
            CGFloat scrollResistance = distanceFromTouch / 1500.0f;
            
            if (self.latestDelta < 0) {
                center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
            }
            else {
                center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
            }
            item.center = center;
        }
        
        [self.dynamicAnimator addBehavior:springBehaviour];
        [self.dynamicAnimator addBehavior:spring2Behaviour];
        [self.visibleIndexPathsSet addObject:item.indexPath];
    }];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    self.latestDelta = delta;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, __unused NSUInteger idx, __unused BOOL *stop) {
        if ([springBehaviour isKindOfClass:[UIAttachmentBehavior class]])
        {
            CGFloat distanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
            CGFloat scrollResistance = distanceFromTouch / 1500.0f;
            
            UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
            CGPoint center = item.center;
            if (delta < 0) {
                center.y += MAX(delta, delta*scrollResistance);
            }
            else {
                center.y += MIN(delta, delta*scrollResistance);
            }
            item.center = center;
            
            [self.dynamicAnimator updateItemUsingCurrentState:item];
        }
    }];
    
    return NO;
}

@end
