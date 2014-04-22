//
//  TBUserDefaultsRegisterSettings.h
//  Tidbits
//
//  Created by Ewan Mellor on 4/22/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//


#import "TBUserDefaults.h"


#define TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, __t, __f, __F, __key, __prot, __def)      \
+(void)registerSetting_ ## __getter {                                                                       \
    [self registerSetting:__key protection:__prot defaultValue:@(__def)];                                   \
}                                                                                                           \
                                                                                                            \
-(__t)__getter {                                                                                            \
    return [self __f ## ForKey:__key protection:__prot defaultValue:__def];                                 \
}                                                                                                           \
                                                                                                            \
-(void)__setter:(__t)value {                                                                                \
    [self set ## __F:value forKey:__key protection:__prot];                                                 \
}                                                                                                           \


#define TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, __t, __f, __F, __key, __prot)                    \
+(void)registerSetting_ ## __getter {                                                                       \
    [self registerSetting:__key protection:__prot defaultValue:nil];                                        \
}                                                                                                           \
                                                                                                            \
-(__t)__getter {                                                                                            \
    return [self __f ## ForKey:__key protection:__prot defaultValue:nil];                                   \
}                                                                                                           \
                                                                                                            \
-(void)__setter:(__t)value {                                                                                \
    [self set ## __F:value forKey:__key protection:__prot];                                                 \
}                                                                                                           \


#define TBUSERDEFAULTS_REGISTER_NSARRAY(__getter, __setter, __key, __prot)                                  \
TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, NSArray*, array, Array, __key, __prot)

#define TBUSERDEFAULTS_REGISTER_NSDICTIONARY(__getter, __setter, __key, __prot)                             \
TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, NSDictionary*, dictionary, Dictionary, __key, __prot)

#define TBUSERDEFAULTS_REGISTER_NSNUMBER(__getter, __setter, __key, __prot)                                 \
TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, NSNumber*, number, Number, __key, __prot)

#define TBUSERDEFAULTS_REGISTER_NSSTRING(__getter, __setter, __key, __prot)                                 \
TBUSERDEFAULTS_REGISTER_OBJECT(__getter, __setter, NSString*, string, String, __key, __prot)

#define TBUSERDEFAULTS_REGISTER_NSINTEGER(__getter, __setter, __key, __prot, __def)                         \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, NSInteger, integer, Integer, __key, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_FLOAT(__getter, __setter, __key, __prot, __def)                             \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, float, float, Float, __key, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_DOUBLE(__getter, __setter, __key, __prot, __def)                            \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, double, double, double, __key, __prot, __def)

#define TBUSERDEFAULTS_REGISTER_BOOL(__getter, __setter, __key, __prot, __def)                              \
TBUSERDEFAULTS_REGISTER_FROM_NSNUMBER(__getter, __setter, BOOL, bool, Bool, __key, __prot, __def)


@interface TBUserDefaults (RegisterSettings)

+(void)registerSetting:(NSString *)key protection:(NSString *)protection defaultValue:(id)def __attribute__((nonnull(1,2)));

@end
