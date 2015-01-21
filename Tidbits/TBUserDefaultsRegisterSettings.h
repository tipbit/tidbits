//
//  TBUserDefaultsRegisterSettings.h
//  Tidbits
//
//  Created by Ewan Mellor on 4/22/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//


#import "TBUserDefaults.h"

/*
 * The _STANDARD suffix here indicates that the getter name is used as the key as well.
 * Not all our settings are like that, for legacy reasons, but it's the sensible default.
 */


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#define TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, __t, __f, __F, __key, __prot, __def)      \
+(void)registerSetting_ ## __getter {                                                                       \
    [self registerSetting:__key type:@#__t protection:__prot defaultValue:@(__def)];                        \
}                                                                                                           \
                                                                                                            \
-(__t)__getter {                                                                                            \
    return [self __f ## ForKey:__key protection:__prot defaultValue:__def];                                 \
}                                                                                                           \
                                                                                                            \
-(void)__setter:(__t)value {                                                                                \
    [self set ## __F:value forKey:__key protection:__prot];                                                 \
}                                                                                                           \


#define TBUSERDEFAULTS_REGISTER_OBJECT_WITH_DEFAULT(__getter, __setter, __t, __f, __F, __key, __prot, __def)\
+(void)registerSetting_ ## __getter {                                                                       \
    [self registerSetting:__key type:@#__t protection:__prot defaultValue:__def];                           \
}                                                                                                           \
                                                                                                            \
-(__t*)__getter {                                                                                           \
    return [self __f ## ForKey:__key protection:__prot defaultValue:__def];                                 \
}                                                                                                           \
                                                                                                            \
-(void)__setter:(__t*)value {                                                                               \
    [self set ## __F:value forKey:__key protection:__prot];                                                 \
}                                                                                                           \

#else

#define TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, __t, __f, __F, __key, __prot, __def)      \
+(void)registerSetting_ ## __getter {                                                                       \
    [self registerSetting:__key type:@#__t protection:@"" defaultValue:@(__def)];                           \
}                                                                                                           \
                                                                                                            \
-(__t)__getter {                                                                                            \
    return [self __f ## ForKey:__key protection:@"" defaultValue:__def];                                    \
}                                                                                                           \
                                                                                                            \
-(void)__setter:(__t)value {                                                                                \
    [self set ## __F:value forKey:__key protection:@""];                                                    \
}                                                                                                           \


#define TBUSERDEFAULTS_REGISTER_OBJECT_WITH_DEFAULT(__getter, __setter, __t, __f, __F, __key, __prot, __def)\
+(void)registerSetting_ ## __getter {                                                                       \
    [self registerSetting:__key type:@#__t protection:@"" defaultValue:__def];                              \
}                                                                                                           \
                                                                                                            \
-(__t*)__getter {                                                                                           \
    return [self __f ## ForKey:__key protection:@"" defaultValue:__def];                                    \
}                                                                                                           \
                                                                                                            \
-(void)__setter:(__t*)value {                                                                               \
    [self set ## __F:value forKey:__key protection:@""];                                                    \
}                                                                                                           \

#endif


#define TBUSERDEFAULTS_REGISTER_OBJECT_WITH_DEFAULT_STANDARD(__getter, __setter, __t, __f, __F, __prot, __def) \
TBUSERDEFAULTS_REGISTER_OBJECT_WITH_DEFAULT(__getter, __setter, __t, __f, __F, @#__getter, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER_STANDARD(__getter, __setter, __t, __f, __F, __prot, __def)    \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, __t, __f, __F, @#__getter, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, __t, __f, __F, __key, __prot)                    \
TBUSERDEFAULTS_REGISTER_OBJECT_WITH_DEFAULT(__getter, __setter, __t, __f, __F, __key, __prot, nil)

#define TBUSERDEFAULTS_REGISTER_OBJECT_STANDARD(__getter, __setter, __t, __f, __F, __prot)                  \
TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, __t, __f, __F, @#__getter, __prot)


#define TBUSERDEFAULTS_REGISTER_NSARRAY(__getter, __setter, __key, __prot)                                  \
TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, NSArray, array, Array, __key, __prot)

#define TBUSERDEFAULTS_REGISTER_NSARRAY_STANDARD(__getter, __setter, __key, __prot)                         \
TBUSERDEFAULTS_REGISTER_OBJECT_STANDARD(__getter, __setter, NSArray, array, Array, __prot)

#define TBUSERDEFAULTS_REGISTER_NSDICTIONARY(__getter, __setter, __key, __prot)                             \
TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, NSDictionary, dictionary, Dictionary, __key, __prot)

#define TBUSERDEFAULTS_REGISTER_NSDICTIONARY_STANDARD(__getter, __setter, __prot)                           \
TBUSERDEFAULTS_REGISTER_OBJECT_STANDARD(__getter, __setter, NSDictionary, dictionary, Dictionary, __prot)

#define TBUSERDEFAULTS_REGISTER_NSNUMBER(__getter, __setter, __key, __prot)                                 \
TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, NSNumber, number, Number, __key, __prot)

#define TBUSERDEFAULTS_REGISTER_NSNUMBER_STANDARD(__getter, __setter, __prot)                               \
TBUSERDEFAULTS_REGISTER_OBJECT_STANDARD(__getter, __setter, NSNumber, number, Number, __prot)

#define TBUSERDEFAULTS_REGISTER_NSSTRING(__getter, __setter, __key, __prot)                                 \
TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, NSString, string, String, __key, __prot)

#define TBUSERDEFAULTS_REGISTER_NSSTRING_STANDARD(__getter, __setter, __prot)                               \
TBUSERDEFAULTS_REGISTER_OBJECT_STANDARD(__getter, __setter, NSString, string, String, __prot)

#define TBUSERDEFAULTS_REGISTER_NSSTRING_WITH_DEFAULT(__getter, __setter, __key, __prot, __def)             \
TBUSERDEFAULTS_REGISTER_OBJECT_WITH_DEFAULT(__getter, __setter, NSString, string, String, __key, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_NSSTRING_WITH_DEFAULT_STANDARD(__getter, __setter, __prot, __def)           \
TBUSERDEFAULTS_REGISTER_OBJECT_WITH_DEFAULT_STANDARD(__getter, __setter, NSString, string, String, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_NSINTEGER(__getter, __setter, __key, __prot, __def)                         \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, NSInteger, integer, Integer, __key, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_NSINTEGER_STANDARD(__getter, __setter, __prot, __def)                       \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER_STANDARD(__getter, __setter, NSInteger, integer, Integer, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_FLOAT(__getter, __setter, __key, __prot, __def)                             \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, float, float, Float, __key, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_FLOAT_STANDARD(__getter, __setter, __prot, __def)                           \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER_STANDARD(__getter, __setter, float, float, Float, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_DOUBLE(__getter, __setter, __key, __prot, __def)                            \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, double, double, double, __key, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_DOUBLE_STANDARD(__getter, __setter, __prot, __def)                          \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER_STANDARD(__getter, __setter, double, double, double, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_BOOL(__getter, __setter, __key, __prot, __def)                              \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, BOOL, bool, Bool, __key, __prot, __def)

// Note that we have to define this one in terms of TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER, not
// TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER_STANDARD, because otherwise bool gets expanded as a macro to
// _Bool (from the standard library).
#define TBUSERDEFAULTS_REGISTER_BOOL_STANDARD(__getter, __setter, __prot, __def)                            \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, BOOL, bool, Bool, @#__getter, __prot, __def)


#define TBUSERDEFAULTS_REGISTER_NSDICTIONARY(__getter, __setter, __key, __prot)                                  \
TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, NSDictionary, dictionary, Dictionary, __key, __prot)


@interface TBUserDefaults (RegisterSettings)

+(void)registerSetting:(NSString *)key type:(NSString *)type protection:(NSString *)protection defaultValue:(id)def __attribute__((nonnull(1,2)));

@end
