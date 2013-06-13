//
//  NSArray+Map.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/5/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)

typedef id (^id_to_id_t)(id obj);

/*!
 * @abstract Create a new NSArray with the contents set to mapper(x) for each x in self.
 *
 * @discussion mapper may return nil, in which case no entry is added to the result
 * (i.e. the result will be shorter than self).
 */
-(NSArray*) map:(id_to_id_t)block;

@end
