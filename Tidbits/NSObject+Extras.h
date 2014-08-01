//
//  NSObject+Extras.h
//  Tidbits
//
//  Created by Navi Singh on 8/1/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extras)
-(NSString *)autoDescribe;

//In the class you want to have a quicklook object, add the following method.
//- (id)debugQuickLookObject
//{
//    return [self autoDescribe];
//}

@end
