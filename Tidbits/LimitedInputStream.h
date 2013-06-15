//
//  LimitedInputStream.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/15/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LimitedInputStream : NSInputStream

@property (nonatomic, strong) NSInputStream* underStream;
@property (nonatomic, assign) NSUInteger bytesRead;
@property (nonatomic, assign) NSUInteger bytesLimit;

-initWithStream:(NSInputStream*)stream andLimit:(NSUInteger)limit;

@end
