//
//  NSString+StripHTML.h
//  Tipbit
//
//  Created by Ewan Mellor on 5/23/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

// Based originally on NSString+HTML from https://github.com/mwaterfall/MWFeedParser
// Copyright 2010 Michael Waterfall and MIT licensed.

#import <Foundation/Foundation.h>

@interface NSString (StripHTML)

- (NSString*)stripHTML:(int)charCount;

@end
