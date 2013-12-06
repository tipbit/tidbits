//
//  NSInputStream+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/15/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInputStream (Misc)

-(NSInteger)readUint32:(uint32_t*)result;

-(NSInteger)writeToFile:(NSString *)filepath attributes:(NSDictionary*)attributes;

@end
