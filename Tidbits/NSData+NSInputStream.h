//
//  NSData+NSInputStream.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/16/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NSInputStream)

+(NSData*)dataWithContentsOfStream:(NSInputStream*)input initialCapacity:(NSUInteger)capacity;

@end
