//
//  SynthesizeAssociatedObject.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/18/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#ifndef TBClientLib_SynthesizeAssociatedObject_h
#define TBClientLib_SynthesizeAssociatedObject_h

#import <objc/runtime.h>


#define SYNTHESIZE_ASSOCIATED_OBJECT(__key, __type, __getter, __setter, __retain)             \
static char* __key = #__key;                                                                  \
-(__type)__getter {                                                                           \
    return objc_getAssociatedObject(self, __key);                                             \
}                                                                                             \
                                                                                              \
-(void)__setter:(__type)value {                                                               \
    objc_setAssociatedObject(self, __key, value, __retain);                                   \
}


#define SYNTHESIZE_ASSOCIATED_BOOL(__key, __getter, __setter)                                 \
static char* __key = #__key;                                                                  \
-(BOOL)__getter {                                                                             \
    NSNumber* n = objc_getAssociatedObject(self, __key);                                      \
    return n.boolValue;                                                                       \
}                                                                                             \
                                                                                              \
-(void)__setter:(BOOL)value {                                                                 \
    objc_setAssociatedObject(self, __key, [NSNumber numberWithBool:value],                    \
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);                              \
}


#define SYNTHESIZE_ASSOCIATED_NSUINTEGER(__key, __getter, __setter)                           \
static char* __key = #__key;                                                                  \
-(NSUInteger)__getter {                                                                       \
    NSNumber* n = objc_getAssociatedObject(self, __key);                                      \
    return n.unsignedIntegerValue;                                                            \
}                                                                                             \
                                                                                              \
-(void)__setter:(NSUInteger)value {                                                           \
    objc_setAssociatedObject(self, __key, [NSNumber numberWithUnsignedInteger:value],         \
    OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                                       \
}




#define SYNTHESIZE_ASSOCIATED_ENUM(__key, __type, __getter, __setter)                         \
static char* __key = #__key;                                                                  \
-(__type)__getter {                                                                           \
    NSNumber* n = objc_getAssociatedObject(self, __key);                                      \
    return (__type)n.unsignedIntegerValue;                                                    \
}                                                                                             \
                                                                                              \
-(void)__setter:(__type)value {                                                               \
    objc_setAssociatedObject(self, __key, [NSNumber numberWithUnsignedInteger:value],         \
    OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                                       \
}


#endif
