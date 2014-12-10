//
//  NSOperation+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/10/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSOperation (Misc)

/**
 * Note that NSOperation.name is only available on iOS 8 and above.
 * We use this property instead, to support iOS 7.
 */
@property (nonatomic) NSString * tb_name;

@end
