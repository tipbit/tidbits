//
//  Breadcrumbs.h
//  Tidbits
//
//  Created by Ewan Mellor on 11/17/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * This delegate is called whenever one of the Breadcrumbs methods is called.  You can use this to persist the breadcumb trail somewhere
 * (e.g. Crashlytics).
 */
@protocol BreadcrumbsDelegate <NSObject>

@optional

/**
 * @param trail An NSString array.  This is not yours to own or mutate.  If you need it beyond the lifetime of this call, then copy it.
 * @discussion This call is executed inline with the call to Breadcrumbs.track and under the internal lock inside Breadcrumbs -- be quick!
 */
-(void)breadcrumbsSaveTrail:(NSArray*)trail;

/**
 * @discussion This call is executed inline with the call to Breadcrumbs.track -- be quick!
 * Note that Breadcrumbs.push and Breadcrumbs.pop call Breadcrumbs.track internally, so you'll see those calls too.
 */
-(void)breadcrumbsTrack:(NSString*)tag;

@end


@interface Breadcrumbs : NSObject

/**
 * @param delegate This is retained _strongly_ by this module.  May be nil, in which case the delegate is cleared.
 * This call is intended to be set at start-of-day.  If you use it at other times, ensure that no Breadcrumbs calls are in progress at the time.
 */
+(void)setDelegate:(NSObject<BreadcrumbsDelegate>*)delegate;

/**
 * Roughly: push a view controller or dialog.
 */
+(void)push:(NSString*)tag;

/**
 * Roughly: pop a view controller or dialog.  Breadcrumb is tag + "-popped".
 */
+(void)pop:(NSString*)tag;

/**
 * General event.
 */
+(void)track:(NSString*)tag;


/**
 * May be nil.  Is accessed with no locking, since it is intended to be set at start-of-day.
 */
@property (nonatomic, strong) NSObject<BreadcrumbsDelegate>* delegate;


-(void)push:(NSString*)tag;
-(void)pop:(NSString*)tag;
-(void)track:(NSString*)tag;


@end
