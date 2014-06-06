//
//  NSObject+SimpleAuthAdditions.m
//  SimpleAuth
//
//  Created by Caleb Davenport on 1/20/14.
//  Copyright (c) 2014 Byliner, Inc. All rights reserved.
//

#import "NSObject+SimpleAuthAdditions.h"
#import "SimpleAuthWebViewController.h"

#import <objc/runtime.h>

@implementation NSObject (SimpleAuthAdditions)

+ (void)SimpleAuth_enumerateSubclassesWithBlock:(void (^) (Class klass, BOOL *stop))block {
    int numberOfClasses = objc_getClassList(NULL, 0);
    Class allClasses[numberOfClasses];
    objc_getClassList(allClasses, numberOfClasses);
    for (int i = 0; i < numberOfClasses; i++) {
        Class klass = allClasses[i];
        BOOL stop = NO;
        if (SimpleAuthClassIsSubclassOfClass(klass, self)) {
            block(klass, &stop);
            if (stop) {
                return;
            }
        }
//        else if(class_conformsToProtocol(klass, @protocol(SimpleAuthWebViewController)))
//        {
//            block(klass, &stop);
//        }
    }
}

@end

static inline BOOL SimpleAuthClassIsSubclassOfClass(Class classOne, Class classTwo) {
    Class superclass = class_getSuperclass(classOne);
    if (superclass == classTwo) {
        return YES;
    }
    else if (superclass == Nil) {
        return NO;
    }
    else {
        return SimpleAuthClassIsSubclassOfClass(superclass, classTwo);
    }
}

