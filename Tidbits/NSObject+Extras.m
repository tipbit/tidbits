//
//  NSObject+Extras.m
//  Tidbits
//  From http://stackoverflow.com/questions/2299841/objective-c-introspection-reflection/2304797#2304797
//  Created by Navi Singh on 8/1/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSObject+Extras.h"
#import <objc/runtime.h>

@implementation NSObject (Extras)

-(NSString *)autoDescribe:(Class)classType indent:(NSUInteger)indent
{
    id instance = self;
    
    unsigned int count;
    objc_property_t *propList = class_copyPropertyList(classType, &count);
    NSMutableString *propPrint = [NSMutableString string];

    NSMutableString *indentString = [NSMutableString string];
    for (NSUInteger i = 0; i < indent-1; i++)
	{
		[indentString appendFormat:@"    "];
	}

    NSString *indentBracket = [indentString copy];
    [propPrint appendString:indentBracket];
    [propPrint appendString:@"{"];
    [indentString appendFormat:@"    "];
    
    Class superClass = class_getSuperclass( classType );
    BOOL hasSuperClass = ( superClass != nil && ![superClass isEqual:[NSObject class]] );
        
    for (NSUInteger i = 0; i < count; i++ )
    {
        
        objc_property_t property = propList[i];
        
        const char *propName = property_getName(property);
        NSString *propNameString =[NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
        
        if(propName)
        {
            @try {
                id value = [instance valueForKey:propNameString];
                if (value) {
                    [propPrint appendString:@"\n"];
                    if ([value isKindOfClass:NSNumber.class]) {

                        [propPrint appendString:[NSString stringWithFormat:@"%@\"%@\" : %@", indentString, propNameString, value]];
                    }
                    else{
                        if ([propNameString caseInsensitiveCompare:@"password"] == NSOrderedSame){
                            value = @"********";
                        }
                        [propPrint appendString:[NSString stringWithFormat:@"%@\"%@\" : \"%@\"", indentString, propNameString, value]];
                    }
                    if (i < count-1 || hasSuperClass)
                    {
                        [propPrint appendString:@","];
                    }
                }
            }
            @catch (NSException *exception) {
                [propPrint appendString:[NSString stringWithFormat:@"\n%@\"%@\" : \"Can't get value for property through KVO\"", indentString, propNameString]];
                if (i < count-1) {
                    [propPrint appendString:@","];
                }
            }
        }
    }
    free(propList);
    
    // Now see if we need to map any superclasses as well.
    if ( hasSuperClass )
    {
        NSString *superString = [instance autoDescribe:superClass indent:indent+1];
        [propPrint appendString:@"\n"];
        [propPrint appendString:superString];
    }
    [propPrint appendString:@"\n"];
    [propPrint appendString:indentBracket];
    [propPrint appendString:@"}"];
    
   
    return propPrint;
}

-(NSString *)autoDescribe
{
	// Don't try to autoDescribe NSManagedObject subclasses (Core Data does this already)
    if ([self isKindOfClass:NSClassFromString(@"NSManagedObject")]) {
        return [self description];
    }
    
	Class classType = [self class];
    return [self autoDescribe:classType indent:1];
}

//In the class you want to have a quicklook object, add the following method.
//- (id)debugQuickLookObject
//{
//    return [self autoDescribe];
//}

@end
