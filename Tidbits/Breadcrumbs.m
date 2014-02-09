//
//  Breadcrumbs.m
//  Tidbits
//
//  Created by Ewan Mellor on 11/17/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "LoggingMacros.h"
#import "TBAsserts.h"

#import "Breadcrumbs.h"


#define MAX_CRUMBS 30


@interface Breadcrumbs ()


/**
 * NSString array.
 * The trail left by the user's path through the code.
 * Accessed by any thread via @synchronized on this object.
 */
@property (nonatomic, strong, readonly) NSMutableArray* breadCrumbs;


/**
 * NSString array.
 * Roughly analogous to the view controller stack.
 * Accessed only on main thread.
 */
@property (nonatomic, strong, readonly) NSMutableArray* crumbStack;


@end


static Breadcrumbs* instance = nil;


@implementation Breadcrumbs


+(void)initialize {
    if (self != [Breadcrumbs class])
        return;
    instance = [[Breadcrumbs alloc] init];
}


+(void)setDelegate:(NSObject<BreadcrumbsDelegate>*)del {
    instance.delegate = del;
}


+(void)push:(NSString*)tag {
    [instance push:tag];

}

+(void)pop:(NSString*)tag {
    [instance pop:tag];
}


+(void)track:(NSString*)tag {
    [instance track:tag];
}


-(instancetype)init {
    self = [super init];
    if (self) {
        _breadCrumbs = [NSMutableArray array];
        _crumbStack = [NSMutableArray array];
    }
    return self;
}


-(void)push:(NSString*)tag {
    AssertOnMainThread();
    [self.crumbStack addObject:tag];
    [self track:tag];
}


-(void)pop:(NSString*)tag {
    AssertOnMainThread();
    if (self.crumbStack.count) {
        NSString *oldTag = [self.crumbStack lastObject];
        if (tag != nil && ![oldTag isEqualToString:tag]) {
            [self track:[NSString stringWithFormat:@"pop-mismatch-%@-%@", tag, oldTag]];
        }
        else {
            NSString *popTag = [NSString stringWithFormat:@"<%@", [self.crumbStack lastObject]];
            [self.crumbStack removeLastObject];
            [self track:popTag];
        }
    }
    else {
        [self track:[NSString stringWithFormat:@"overpopped-%@", tag]];
    }
}


-(void)track:(NSString*)tag {
    NSObject<BreadcrumbsDelegate>* mydelegate = self.delegate;

    @synchronized(self.breadCrumbs) {
        NSArray* bits = lastCrumbBits(self.breadCrumbs);
        if ((bits.count == 1 || bits.count == 2) && [bits[0] isEqualToString:tag]) {
            int count = bits.count == 2 ? [bits[1] intValue] : 1;
            NSString* new_multiple = [NSString stringWithFormat:@"%@*%d", bits[0], count + 1];
            NSLog(@"%@", new_multiple);
            [self.breadCrumbs removeLastObject];
            [self.breadCrumbs addObject:new_multiple];
        }
        else {
            NSLog(@"%@", tag);
            [self.breadCrumbs addObject:tag];
            if (self.breadCrumbs.count == MAX_CRUMBS)
                [self.breadCrumbs removeObjectAtIndex:0];
        }

        if ([mydelegate respondsToSelector:@selector(breadcrumbsSaveTrail:)])
            [mydelegate breadcrumbsSaveTrail:self.breadCrumbs];
    }

    if ([mydelegate respondsToSelector:@selector(breadcrumbsTrack:)])
        [mydelegate breadcrumbsTrack:tag];
}


// Assumes that it is already locked under @synchronized (crumbs).
static NSArray* lastCrumbBits(NSArray* crumbs) {
    if (crumbs.count == 0)
        return nil;
    NSString* lastCrumb = crumbs[crumbs.count - 1];
    return [lastCrumb componentsSeparatedByString:@"*"];
}


@end
