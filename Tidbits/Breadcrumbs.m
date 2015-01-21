//
//  Breadcrumbs.m
//  Tidbits
//
//  Created by Ewan Mellor on 11/17/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "LoggingMacros.h"
#import "NSString+Misc.h"
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
static NSDictionary* customProps = nil;


@implementation Breadcrumbs


+(void)initialize {
    if (self != [Breadcrumbs class]) {
        return;
    }
    instance = [[Breadcrumbs alloc] init];
    
    // Populate dictionary of known custom properties
    // Used in DEBUG to check event properties
    // See Confluence for definition of custom properties
    // https://light.tipbit.com/confluence/display/dev/iOS+in-app+tracking
#if DEBUG
    customProps = @{@"key"        : @true,
                    @"value"      : @true,
                    @"count"      : @true,
                    @"uxType"     : @true,
                    @"listType"   : @true,
                    @"listFilter" : @true
                    };
#endif
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
    [instance track:tag method:Track];
}

+(void)track:(NSString*)tag with:(NSDictionary*)props {
    [instance track:tag with:props];
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
    [self track:tag method:Push];
}


-(void)pop:(NSString*)tag {
    AssertOnMainThread();
    if (self.crumbStack.count) {
        NSUInteger index = [self.crumbStack indexOfObjectWithOptions:NSEnumerationReverse passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [tag isEqualToString:(NSString *) obj];
        }];
        
        if (tag != nil && index == NSNotFound) {
            NSString * popMismatchTag = [NSString stringWithFormat:@"pop-mismatch-%@-%@", tag, [self.crumbStack lastObject]];
#if DEBUG
            TBAssertRaise(@"%@", popMismatchTag);
#else
            [self track:popMismatchTag method:Pop];
#endif
        }
        else {
            NSString *popTag = [NSString stringWithFormat:@"<%@", [self.crumbStack objectAtIndex:index]];
            [self.crumbStack removeObjectAtIndex:index];
            [self track:popTag method:Pop];
        }
    }
    else {
        NSString * overpoppedTag = [NSString stringWithFormat:@"overpopped-%@", tag];
#if DEBUG
        TBAssertRaise(@"%@", overpoppedTag);
#else
        [self track:overpoppedTag method:Pop];
#endif
    }
}


-(void)track:(NSString*)tag method:(TrackMethod)meth{
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

        if ([mydelegate respondsToSelector:@selector(breadcrumbsSaveTrail:)]) {
            [mydelegate breadcrumbsSaveTrail:self.breadCrumbs];
        }
    }

    if ([mydelegate respondsToSelector:@selector(breadcrumbsTrack:method:)]) {
        [mydelegate breadcrumbsTrack:tag method:meth];
    }
}


-(void)track:(NSString*)tag with:(NSDictionary*)props {
    NSLog(@"%@ %@", tag, [[props description] stringByFoldingWhitespace]);

    NSObject<BreadcrumbsDelegate>* mydelegate = self.delegate;

#if DEBUG
    // Check that passed properties are in known custom property list
    for(id prop in props) {
        if (![customProps objectForKey:prop])
            TBAssertRaise(@"Bad event property: %@", prop);
    }
#endif
    
    if ([mydelegate respondsToSelector:@selector(breadcrumbsTrack:with:)]) {
        [mydelegate breadcrumbsTrack:tag with:props];
    }
}


// Assumes that it is already locked under @synchronized (crumbs).
static NSArray* lastCrumbBits(NSArray* crumbs) {
    if (crumbs.count == 0) {
        return nil;
    }
    NSString* lastCrumb = crumbs[crumbs.count - 1];
    return [lastCrumb componentsSeparatedByString:@"*"];
}


@end
