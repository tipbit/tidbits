//
//  StreamPair.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/22/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * An NSInputStream and an NSOutputStream, bound together with a buffer.  Data written to the output stream will appear on the input stream.
 * Unlike CFCreateBoundPair, this is safe to be used between threads.
 */
@interface StreamPair : NSObject

+(void)getStreamPairInput:(NSInputStream**)istream andOutput:(NSOutputStream**)ostream;

@end
