//
//  NSSet+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 1/15/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"

@interface NSSet (Misc)

/**
 * @abstract Create a new NSArray with the contents set to mapper(v) for each v in self.
 *
 * @discussion mapper may return nil, in which case no entry is added to the result
 * (i.e. the result will have fewer members than self).
 */
-(NSArray*)mapToArray:(id_to_id_t)mapper;

@end
