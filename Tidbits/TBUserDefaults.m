//
//  TBUserDefaults.m
//  Tidbits
//
//  Created by Ewan Mellor on 4/20/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <objc/message.h>
#import <objc/runtime.h>

#import "Dispatch.h"
#import "GTMNSString+URLArguments.h"
#import "LoggingMacros.h"
#import "NSDictionary+Map.h"

#import "TBUserDefaults.h"


#if !TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
#define NSFileProtectionNone @""
#endif


@interface TBUserDefaults ()

/**
 * May be nil, in which case all calls will return the given defaultValue.
 */
@property (nonatomic, readonly) NSString * user;

/**
 * NSString -> (NSString -> id NSMutableDictionary).  The outer string is one of the NSFileProtection* constants.
 * The inner dictionary is the key -> value for each setting at that protection level.
 *
 * May only be accessed under @synchronized (settingsByProtection).  The same is true of the enclosed dictionaries.
 */
@property (nonatomic) NSMutableDictionary * settingsByProtection;

/**
 * An NSString set.  The string is one of the NSFileProtection* constants.
 *
 * May only be accessed under @synchronized (dirtyProtectionLevels).
 */
@property (nonatomic) NSMutableSet * dirtyProtectionLevels;

@end


static NSString * currentUser;
static NSString * currentUserType;
static NSString * currentUserAccountId;

/**
 * id -> TBUserDefaults.  The key is either an NSString (the user ID) or [NSNull null] to indicate that the user is unknown.
 *
 * May only be accessed under @synchronized (instancesByUser).
 */
static NSMutableDictionary * instancesByUser;

/**
 * NSString -> NSString.  Setting key -> one of the NSFileProtection* constants.
 *
 * May only be accessed under @synchronized (protectionsByKey).
 */
static NSMutableDictionary * protectionsByKey;

/**
 * NSString -> id.  Setting key -> default value.
 *
 * May only be accessed under @synchronized (protectionsByKey).  (N.B. protectionsByKey is covering itself and this.)
 */
static NSMutableDictionary * defaultValuesbyKey;

/**
 * NSString -> NSString.  Setting key -> the registered type for that setting.
 *
 * May only be accessed under @synchronized (protectionsByKey).  (N.B. protectionsByKey is covering itself and this.)
 */
static NSMutableDictionary * typesByKey;

static NSString* preferencesDir;


#define kUnauthenticatedUser @"TBUserDefaults-unauthenticated"
#define kUser @"USER"
#define kUserType @"USERTYPE"
#define kUserAccountId @"USERACCOUNTID"

@implementation TBUserDefaults


+(void)initialize {
    if (self != [TBUserDefaults class]) {
        return;
    }

    instancesByUser = [NSMutableDictionary dictionary];
    protectionsByKey = [NSMutableDictionary dictionary];
    defaultValuesbyKey = [NSMutableDictionary dictionary];
    typesByKey = [NSMutableDictionary dictionary];

    NSArray *libraryDirs = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (libraryDirs.count == 0) {
        NSLog(@"Failed to find Library directory!  This is a very ill phone!");
        return;
    }
    NSString *libraryDir = libraryDirs[0];
    preferencesDir = [libraryDir stringByAppendingPathComponent:@"Preferences"];

    [self registerSettings];
}


/**
 * Reflectively invoke all methods called registerSetting_*.  A category can define these using the macros in TBUserDefaultsRegisterSettings.h.
 */
+(void)registerSettings {
    void (*method_invoke_void)(id, Method) = (void (*)(id, Method))method_invoke;

    Class class = [self class];
    unsigned count = 0;
    Method * methods = class_copyMethodList(object_getClass(class), &count);
    for (unsigned i = 0; i < count; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        const char* name = sel_getName(sel);
        if (0 == strncmp(name, "registerSetting_", sizeof("registerSetting_") - 1)) {
            method_invoke_void(class, method);
        }
    }

    free(methods);
}


+(void)registerSetting:(NSString *)key type:(NSString *)type protection:(NSString *)protection defaultValue:(id)def __attribute__((nonnull)) {
    @synchronized (protectionsByKey) {
        typesByKey[key] = type;
        protectionsByKey[key] = protection;
        if (def != nil) {
            defaultValuesbyKey[key] = def;
        }
    }
}


+(BOOL)isRegisteredSetting:(NSString*)key {
    @synchronized (protectionsByKey) {
        return nil != protectionsByKey[key];
    }
}


+(NSArray *)allRegisteredSettings {
    @synchronized (protectionsByKey) {
        return [protectionsByKey allKeys];
    }
}


+(TBUserDefaults *)standardUserDefaults {
    return [TBUserDefaults userDefaultsForUser:currentUser];
}


+(TBUserDefaults *)userDefaultsForUnauthenticatedUser {
    return [TBUserDefaults userDefaultsForUser:kUnauthenticatedUser];
}


+(TBUserDefaults *)userDefaultsForUser:(NSString *)user {
    @synchronized (instancesByUser) {
        id key = user == nil ? [NSNull null] : user;

        TBUserDefaults* instance = instancesByUser[key];
        if (instance == nil) {
            instance = [[TBUserDefaults alloc] init:user];
            instancesByUser[key] = instance;
        }

        return instance;
    }
}


+(NSString *)user {
    if (currentUser == nil) {
        currentUser = [[TBUserDefaults userDefaultsForUnauthenticatedUser] stringForKey:kUser protection:NSFileProtectionNone defaultValue:nil];
    }
    return currentUser;
}

+(NSString *)userType {
    if (currentUserType == nil) {
        currentUserType = [[TBUserDefaults userDefaultsForUnauthenticatedUser] stringForKey:kUserType protection:NSFileProtectionNone defaultValue:nil];
    }
    return currentUserType;
}

+(NSString *)userAccountId {
    if (currentUserAccountId == nil) {
        currentUserAccountId = [[TBUserDefaults userDefaultsForUnauthenticatedUser] stringForKey:kUserAccountId protection:NSFileProtectionNone defaultValue:nil];
    }
    return currentUserAccountId;
}

+(void)setUser:(NSString *)user{
    [self setUser_:user];
}

+(void)setUserType:(NSString *)type{
    [self setUserType_:type synchronize:YES];
}
+(void)setUserAccountId:(NSString *)accountId{
    [self setUserAccountId_:accountId];
}

+(void)setUserAndSynchronize:(NSString *)user{
    [self setUser_:user synchronize:YES];
}

+(void)setUser_:(NSString *)user{
    assert(![user isEqualToString:kUnauthenticatedUser]);
    
    currentUser = user;
     TBUserDefaults* unauthDefaults = [TBUserDefaults userDefaultsForUnauthenticatedUser];
    [unauthDefaults setString:user forKey:kUser protection:NSFileProtectionNone];
}

+(void)setUserType_:(NSString *)type  synchronize:(BOOL)sync{
    currentUserType = type;
    TBUserDefaults* unauthDefaults = [TBUserDefaults userDefaultsForUnauthenticatedUser];
    [unauthDefaults setString:type forKey:kUserType protection:NSFileProtectionNone];
    
    if (sync) {
        [unauthDefaults synchronize];
    }
}
+(void)setUserAccountId_:(NSString *)accountId {
    currentUserAccountId = accountId;
    TBUserDefaults* unauthDefaults = [TBUserDefaults userDefaultsForUnauthenticatedUser];
    [unauthDefaults setString:accountId forKey:kUserAccountId protection:NSFileProtectionNone];
    [unauthDefaults synchronize];
}

+(void)setUser_:(NSString *)user synchronize:(BOOL)sync {
    assert(![user isEqualToString:kUnauthenticatedUser]);

    TBUserDefaults* unauthDefaults = [TBUserDefaults userDefaultsForUnauthenticatedUser];

    currentUser = user;
    [unauthDefaults setString:user      forKey:kUser protection:NSFileProtectionNone];

    if (sync) {
        [unauthDefaults synchronize];
    }
}


+(BOOL)synchronizeAll {
    BOOL result = YES;
    @synchronized (instancesByUser) {
        for (TBUserDefaults * instance in [instancesByUser allValues]) {
            result &= [instance synchronize];
        }
    }
    return result;
}


-(id)init:(NSString *)user {
    self = [super init];
    if (self) {
        _user= user;

        _settingsByProtection = [NSMutableDictionary dictionary];
        _dirtyProtectionLevels = [NSMutableSet set];
    }
    return self;
}


-(BOOL)synchronize {
    DLog(@"Synchronizing");
    NSArray* to_sync;
    @synchronized (self.dirtyProtectionLevels) {
        to_sync = [self.dirtyProtectionLevels allObjects];
        [self.dirtyProtectionLevels removeAllObjects];
    }
    NSMutableArray * failed = nil;
    @synchronized (self.settingsByProtection) {
        for (NSString* protection in to_sync) {
            NSDictionary* settings = self.settingsByProtection[protection];
            BOOL ok = [self savePlist:protection settings:settings];
            if (!ok) {
                if (failed == nil) {
                    failed = [NSMutableArray array];
                }
                [failed addObject:protection];
            }
        }
    }
    if (failed != nil) {
        DLog(@"Failed to synchronize %@; marking them as dirty again so that we can try again later.",
             [failed componentsJoinedByString:@", "]);
        @synchronized (self.dirtyProtectionLevels) {
            [self.dirtyProtectionLevels addObjectsFromArray:failed];
        }
    }
    return YES;
}


-(void)synchronizeSoon:(NSString*)protection {
    @synchronized (self.dirtyProtectionLevels) {
        [self.dirtyProtectionLevels addObject:protection];
    }
    dispatchAsyncMainThread(^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(synchronizeBackground) object:nil];
        [self performSelector:@selector(synchronizeBackground) withObject:nil afterDelay:30.0];
    });
}


-(void)synchronizeBackground {
    dispatchAsyncBackgroundThread(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        [self synchronize];
    });
}


-(id)objectForKey:(NSString *)key __attribute__((nonnull))  {
    return [self objectForKey:key wasUnlocked:NULL];
}


-(id)objectForKey:(NSString *)key wasUnlocked:(BOOL *)wasUnlocked __attribute__((nonnull(1))) {
    NSParameterAssert(key);

    NSString* prot;
    id def;
    @synchronized (protectionsByKey) {
        prot = protectionsByKey[key];
        def = defaultValuesbyKey[key];
    }
    if (prot == nil) {
        if (wasUnlocked) {
            *wasUnlocked = NO;
        }
        return nil;
    }
    else {
        return [self objectForKey:key protection:prot defaultValue:def wasUnlocked:wasUnlocked];
    }
}


-(BOOL)setObject:(id)value forKey:(NSString *)key {
    NSString* prot;
    @synchronized (protectionsByKey) {
        prot = protectionsByKey[key];
    }
    if (prot == nil) {
        return NO;
    }
    else {
        return [self setObject:value forKey:key protection:prot];
    }
}


-(BOOL)setObjectFromString:(NSString *)value forKey:(NSString *)key {
    if (value == nil || [value isEqualToString:@""]) {
        [self removeObjectForKey:key];
        return YES;
    }

    NSString* type;
    @synchronized (typesByKey) {
        type = typesByKey[key];
    }
    if (type == nil) {
        type = @"NSString";
    }
    id val = valueFromString(value, type);
    if (val == nil) {
        DLog(@"Refusing to set %@ = %@ because it can't be parsed as a %@", key, value, type);
        return NO;
    }
    return [self setObject:val forKey:key];
}


static id valueFromString(NSString * value, NSString * type) {
    if ([type isEqualToString:@"NSString"]) {
        return value;
    }
    else if ([type isEqualToString:@"NSNumber"] || [type isEqualToString:@"NSInteger"]) {
        NSNumberFormatter* f = [[NSNumberFormatter alloc] init];
        f.lenient = YES;
        return [f numberFromString:value];
    }
    else if ([type isEqualToString:@"BOOL"]) {
        return @([value boolValue]);
    }
    else if ([type isEqualToString:@"float"]) {
        return @([value floatValue]);
    }
    else if ([type isEqualToString:@"double"]) {
        return @([value doubleValue]);
    }
    else if ([type isEqualToString:@"NSArray"]) {
        return nil;
    }
    else if ([type isEqualToString:@"NSDictionary"]) {
        return nil;
    }
    else {
        assert(false);
    }
}


-(BOOL)removeObjectForKey:(NSString *)key {
    NSString* prot;
    @synchronized (protectionsByKey) {
        prot = protectionsByKey[key];
    }
    if (prot == nil) {
        return NO;
    }
    else {
        return [self removeObjectForKey:key protection:prot];
    }
}


-(id)objectForKey:(NSString *)key protection:(NSString *)protection defaultValue:(id)def __attribute__((nonnull(1,2))) {
    return [self objectForKey:key protection:protection defaultValue:def wasUnlocked:NULL];
}

-(id)objectForKey:(NSString *)key protection:(NSString *)protection defaultValue:(id)def wasUnlocked:(BOOL *)wasUnlocked __attribute__((nonnull(1,2))) {
    NSParameterAssert(key);
    NSParameterAssert(protection);

    if (self.user == nil) {
        if (wasUnlocked) {
            *wasUnlocked = NO;
        }
        return def;
    }

    @synchronized (self.settingsByProtection) {
        NSDictionary* settings = self.settingsByProtection[protection];
        if (settings == nil) {
            settings = [self loadPlist:protection];
        }
        if (wasUnlocked) {
            *wasUnlocked = (settings != nil);
        }
        id result = settings[key];
        return result == nil ? def : result;
    }
}


-(BOOL)setObject:(id)value forKey:(NSString *)key protection:(NSString *)protection __attribute__((nonnull(2,3))) {
    if (self.user == nil) {
        return NO;
    }

    if (value == nil) {
        return [self removeObjectForKey:key protection:protection];
    }

    BOOL result;
    @synchronized (self.settingsByProtection) {
        NSMutableDictionary* settings = self.settingsByProtection[protection];
        if (settings == nil) {
            settings = [self loadPlist:protection];
        }
        if (settings == nil) {
            result = NO;
        }
        else {
            settings[key] = value;
            result = YES;
        }
    }

    if (result) {
        [self synchronizeSoon:protection];
    }
    return result;
}


-(BOOL)removeObjectForKey:(NSString *)key protection:(NSString *)protection __attribute__((nonnull)) {
    if (self.user == nil) {
        return NO;
    }

    BOOL result;
    @synchronized (self.settingsByProtection) {
        NSMutableDictionary* settings = self.settingsByProtection[protection];
        if (settings == nil) {
            settings = [self loadPlist:protection];
        }
        if (settings == nil) {
            result = NO;
        }
        else {
            [settings removeObjectForKey:key];
            result = YES;
        }
    }

    if (result) {
        [self synchronizeSoon:protection];
    }
    return result;
}


-(NSMutableDictionary*)loadPlist:(NSString*)protection {
    assert(self.user);

    NSString* defPath = [self defaultsPath:protection];

    NSFileManager* nsfm = [[NSFileManager alloc] init];
    if ([nsfm fileExistsAtPath:defPath]) {
        NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithContentsOfFile:defPath];
        if (settings == nil) {
            settings = [NSMutableDictionary dictionary];
        }
        @synchronized (self.settingsByProtection) {
            self.settingsByProtection[protection] = settings;
        }
        return settings;
    }
    else {
        NSData* blank = [NSData data];
        NSError* err = nil;
        BOOL ok = [blank writeToFile:defPath options:writingOptions(protection) error:&err];
        if (ok) {
            NSMutableDictionary* settings = [NSMutableDictionary dictionary];
            @synchronized (self.settingsByProtection) {
                self.settingsByProtection[protection] = settings;
            }
            return settings;
        }
        else {
            NSLogError(@"Failed to create PList: %@", err);
            return nil;
        }
    }
}


-(BOOL)savePlist:(NSString*)protection settings:(NSDictionary*)settings __attribute__((nonnull)) {
    NSParameterAssert(protection);
    NSParameterAssert(settings);

    if (self.user == nil) {
        return NO;
    }

    NSString* defPath = [self defaultsPath:protection];
    BOOL ok = [settings writeToFile:defPath atomically:YES];
    if (!ok) {
        NSLog(@"Failed to serialize PList");
        return NO;
    }

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    NSFileManager* nsfm = [[NSFileManager alloc] init];
    NSError* err = nil;
    ok = [nsfm setAttributes:@{NSFileProtectionKey: protection} ofItemAtPath:defPath error:&err];
    if (!ok) {
        NSLogError(@"Failed to set attributes on PList: %@", err);
    }
#endif

    return ok;
}


-(NSString*)defaultsPath:(NSString*)protection __attribute__((nonnull)) {
    NSString* plistName = [NSString stringWithFormat:@"%@-%@-%@.plist",
                           [[NSBundle mainBundle] bundleIdentifier],
                           [self.user gtm_stringByEscapingForURLArgument],
                           protection];
    return [preferencesDir stringByAppendingPathComponent:plistName];
}


static NSDataWritingOptions writingOptions(NSString* protection) {
    return writingOptionForProtection(protection) | NSDataWritingWithoutOverwriting;
}

static NSDataWritingOptions writingOptionForProtection(NSString* protection) {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    if ([protection isEqualToString:NSFileProtectionNone]) {
        return NSDataWritingFileProtectionNone;
    }
    else if ([protection isEqualToString:NSFileProtectionCompleteUntilFirstUserAuthentication]) {
        return NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication;
    }
    else if ([protection isEqualToString:NSFileProtectionCompleteUnlessOpen]) {
        return NSDataWritingFileProtectionCompleteUnlessOpen;
    }
    else if ([protection isEqualToString:NSFileProtectionComplete]) {
        return NSDataWritingFileProtectionComplete;
    }
    else {
        assert(false);
    }
#else
    return 0;
#endif
}


#define FROM_NSOBJECT(__t, __f, __F)                                                                                                \
-(__t *)__f ## ForKey:(NSString *)key protection:(NSString *)protection defaultValue:(__t *)def {                                   \
    return [self __f ## ForKey:key protection:protection defaultValue:def wasUnlocked:NULL];                                        \
}                                                                                                                                   \
                                                                                                                                    \
-(__t *)__f ## ForKey:(NSString *)key {                                                                                             \
    return [self __f ## ForKey:key wasUnlocked:NULL];                                                                               \
}                                                                                                                                   \
                                                                                                                                    \
-(__t *)__f ## ForKey:(NSString *)key wasUnlocked:(BOOL *)wasUnlocked {                                                             \
    id obj = [self objectForKey:key wasUnlocked:wasUnlocked];                                                                       \
    return [obj isKindOfClass:[__t class]] ? (__t *)obj : nil;                                                                      \
}                                                                                                                                   \
                                                                                                                                    \
-(__t *)__f ## ForKey:(NSString *)key protection:(NSString *)protection defaultValue:(__t *)def wasUnlocked:(BOOL *)wasUnlocked {   \
    id obj = [self objectForKey:key protection:protection defaultValue:def wasUnlocked:wasUnlocked];                                \
    return [obj isKindOfClass:[__t class]] ? (__t *)obj : nil;                                                                      \
}                                                                                                                                   \
                                                                                                                                    \
-(void)set ## __F:(__t *)value forKey:key {                                                                                         \
    [self setObject:value forKey:key];                                                                                              \
}                                                                                                                                   \
                                                                                                                                    \
-(BOOL)set ## __F:(__t *)value forKey:(NSString *)key protection:(NSString *)protection {                                           \
    return [self setObject:value forKey:key protection:protection];                                                                 \
}

FROM_NSOBJECT(NSArray, array, Array)
FROM_NSOBJECT(NSDictionary, dictionary, Dictionary)
FROM_NSOBJECT(NSNumber, number, Number)
FROM_NSOBJECT(NSString, string, String)

#undef FROM_NSOBJECT


#define FROM_NSNUMBER(__t, __f, __F, __c)                                                                                           \
-(__t)__f ## ForKey:(NSString *)key {                                                                                               \
    return [self __f ## ForKey:key wasUnlocked:NULL];                                                                               \
}                                                                                                                                   \
                                                                                                                                    \
-(__t)__f ## ForKey:(NSString *)key wasUnlocked:(BOOL *)wasUnlocked {                                                               \
    NSNumber* num = [self numberForKey:key wasUnlocked:wasUnlocked];                                                                \
    return [num __c];                                                                                                               \
}                                                                                                                                   \
                                                                                                                                    \
-(__t)__f ## ForKey:(NSString *)key protection:(NSString *)protection defaultValue:(__t)def {                                       \
    return [self __f ## ForKey:key protection:protection defaultValue:def wasUnlocked:NULL];                                        \
}                                                                                                                                   \
                                                                                                                                    \
-(__t)__f ## ForKey:(NSString *)key protection:(NSString *)protection defaultValue:(__t)def wasUnlocked:(BOOL *)wasUnlocked {       \
    NSNumber* num = [self numberForKey:key protection:protection defaultValue:nil wasUnlocked:wasUnlocked];                         \
    return num == nil ? def : [num __c];                                                                                            \
}                                                                                                                                   \
                                                                                                                                    \
-(void)set ## __F:(__t)value forKey:(NSString *)key {                                                                               \
    NSNumber* num = @(value);                                                                                                       \
    [self setObject:num forKey:key];                                                                                                \
}                                                                                                                                   \
                                                                                                                                    \
-(BOOL)set ## __F:(__t)value forKey:(NSString *)key protection:(NSString *)protection {                                             \
    NSNumber* num = @(value);                                                                                                       \
    return [self setObject:num forKey:key protection:protection];                                                                   \
}

FROM_NSNUMBER(NSInteger, integer, Integer, integerValue)
FROM_NSNUMBER(float, float, Float, floatValue)
FROM_NSNUMBER(double, double, Double, doubleValue)
FROM_NSNUMBER(BOOL, bool, Bool, boolValue)

#undef FROM_NSNUMBER


-(NSMutableDictionary *)toJSON {
    NSMutableDictionary* result = [TBUserDefaults registeredSettingsToJSON];
    for (NSString* key in [result allKeys]) {
        NSMutableDictionary* dict = result[key];
        dict[@"context"] = @"none";
    }

    @synchronized (self.settingsByProtection) {
        for (NSString* prot in [self.settingsByProtection allKeys]) {
            NSDictionary* settings = self.settingsByProtection[prot];

            for (NSString* key in [settings allKeys]) {
                id val = settings[key];

                NSMutableDictionary* dict = result[key];
                if (dict == nil) {
                    // A setting with no registration.  Acceptable, but unusual.
                    dict = [NSMutableDictionary dictionary];
                    dict[@"key"] = key;
                    dict[@"protection"] = prot;
                    result[key] = dict;
                }
                else {
                    if (![dict[@"protection"] isEqualToString:prot]) {
                        DLog(@"Found setting %@ at the wrong protection level %@ != %@", key, dict[@"protection"], prot);
                        dict[@"protection"] = prot;
                        dict[@"error"] = @"Wrong protection level";
                    }
                }

                dict[@"context"] = self.userContext;
                dict[@"value"] = val;
            }
        }
    }

    return result;
}


-(NSString*)userContext {
    if (self.user == nil) {
        return @"none";
    }
    else if ([self.user isEqualToString:kUnauthenticatedUser]) {
        return @"unauth";
    }
    else {
        return @"user";
    }
}


+(NSMutableDictionary *)registeredSettingsToJSON {
    @synchronized (protectionsByKey) {
        return [protectionsByKey dictionaryWithKeysAndMappedValues:^id(id key_, id prot_) {
            NSString * key = key_;
            NSString * prot = prot_;
            NSString * type = typesByKey[key];
            id def = defaultValuesbyKey[key];

            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:@{@"key": key,
                                                                                        @"protection": prot,
                                                                                        @"type": type}];
            if (def != nil) {
                dict[@"defaultValue"] = def;
            }
            return dict;
        }];
    }
}


@end
