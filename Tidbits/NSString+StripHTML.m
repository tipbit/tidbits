//
//  NSString+StripHTML.m
//  Tipbit
//
//  Created by Ewan Mellor on 5/23/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

// Based originally on NSString+HTML from https://github.com/mwaterfall/MWFeedParser
// Copyright 2010 Michael Waterfall and MIT licensed.

#import "GTMNSString+HTML.h"

#import "NSString+Misc.h"
#import "NSString+StripHTML.h"


static NSCharacterSet* endTagCharacterSet;


@implementation NSString (StripHTML)

+(void)initialize {
    endTagCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" >"];
}


- (NSString *)stripHTML:(int)charCount {
    if (self.length == 0)
        return @"";
    
	NSMutableString *result = [NSMutableString string];
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
	[scanner setCharactersToBeSkipped:nil];
    
    while (result.length < charCount) {
        if (scanner.isAtEnd)
            break;
        
        if ([self characterAtIndex:scanner.scanLocation] != '<') {
            NSUInteger last_location = scanner.scanLocation;
            [scanner scanUpToString:@"<" intoString:NULL];
            [result appendString:[[self substringWithRange:NSMakeRange(last_location, scanner.scanLocation - last_location)] stringByRemovingNewLinesAndWhitespace]];

            if (scanner.isAtEnd)
                break;
        }
        
        scanner.scanLocation += 1;
        
		NSString* tag = nil;
		[scanner scanUpToCharactersFromSet:endTagCharacterSet intoString:&tag];
        
        if ([tag isEqualToStringCaseInsensitive:@"head"] ||
            [tag isEqualToStringCaseInsensitive:@"script"] ||
            [tag isEqualToStringCaseInsensitive:@"style"]) {
            // Skip to end of element.
            NSString* end_tag = [NSString stringWithFormat:@"</%@>", tag];
            [scanner scanUpToString:end_tag intoString:NULL];
            if (scanner.isAtEnd)
                break;
            
            scanner.scanLocation += end_tag.length;
        }
        else {
            if (([tag isEqualToStringCaseInsensitive:@"/p"] ||
                 [tag isEqualToStringCaseInsensitive:@"br"] ||
                 [tag isEqualToStringCaseInsensitive:@"/div"]) &&
                ![result endsWithChar:'\n']) {
                // Add a paragraph separator.
                [result appendString:@"\n"];
            }
            else if (![result endsWithChar:' '] && ![result endsWithChar:'\n']) {
                // Add a space to act as a separator.
                [result appendString:@" "];
            }
            
            [scanner scanUpToString:@">" intoString:NULL];
            if (scanner.isAtEnd)
                break;
            
            scanner.scanLocation += 1;
        }
	}
    
	return [[result gtm_stringByUnescapingFromHTML] trim];
}

- (NSString *)stringByRemovingNewLinesAndWhitespace {
    
	// Strange New lines:
	//	Next Line, U+0085
	//	Form Feed, U+000C
	//	Line Separator, U+2028
	//	Paragraph Separator, U+2029
    
	// Scanner
	NSScanner *scanner = [[NSScanner alloc] initWithString:self];
	[scanner setCharactersToBeSkipped:nil];
	NSMutableString *result = [[NSMutableString alloc] init];
	NSString *temp;
	NSMutableCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r"];
    [newLineAndWhitespaceCharacters addCharactersInRange:NSMakeRange(0x0085, 1)];
    [newLineAndWhitespaceCharacters addCharactersInRange:NSMakeRange(0x000C, 1)];
    [newLineAndWhitespaceCharacters addCharactersInRange:NSMakeRange(0x2028, 2)];
	// Scan
	while (![scanner isAtEnd]) {
        
		// Get non new line or whitespace characters
		temp = nil;
		[scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
		if (temp) [result appendString:temp];
        
		// Replace with a space
		if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
			if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
				[result appendString:@" "];
		}
        
	}
    
	return result;
}

@end
