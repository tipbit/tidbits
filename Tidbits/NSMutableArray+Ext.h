//
//  NSMutableArray+Ext.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Ext)

-(instancetype)initWithEnumeration:(id<NSFastEnumeration>)objects;

@end
