//
//  StreamPair.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/22/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StreamPairInputStream;
@class StreamPairOutputStream;

/*!
 * An NSInputStream and an NSOutputStream, bound together with a buffer.  Data written to the output stream will appear on the input stream.
 * Unlike CFCreateBoundPair, this is safe to be used between threads.
 */
@interface StreamPair : NSObject

@property (nonatomic, strong, readonly) StreamPairInputStream* inputStream;
@property (nonatomic, strong, readonly) StreamPairOutputStream* outputStream;

@end


@interface StreamPairInputStream : NSInputStream

@end


@interface StreamPairOutputStream : NSOutputStream

@end
