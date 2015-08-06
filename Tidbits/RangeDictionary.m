//
//  RangeDictionary.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/4/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "NSArray+Map.h"

#import "RangeDictionary.h"

NS_ASSUME_NONNULL_BEGIN


@interface RangeDictionaryEntry : NSObject <NSCopying>

@property (nonatomic) id lo;
@property (nonatomic) id hi;
@property (nonatomic) id val;

-(NSDictionary *)toDictionary:(nullable id_to_id_t)kvConverter;

@end


@interface RangeDictionary ()

@property (nonatomic, readonly) NSComparator comparator;

/**
 * RangeDictionaryEntry array.
 */
@property (nonatomic) NSMutableArray * entries;

@end


@implementation RangeDictionary

-(instancetype)initWithComparator:(NSComparator)comparator {
    self = [super init];
    if (self) {
        _comparator = comparator;
        _entries = [NSMutableArray array];
    }
    return self;
}


-(instancetype)initWithShallowCopy:(RangeDictionary *)other withZone:(nullable NSZone *)zone {
    self = [super init];
    if (self) {
        _comparator = other.comparator;
        _entries = [other.entries map:^RangeDictionaryEntry *(RangeDictionaryEntry * entry) {
            return [entry copyWithZone:zone];
        }];
    }
    return self;
}


-(id)copyWithZone:(nullable NSZone *)zone {
    return [[RangeDictionary allocWithZone:zone] initWithShallowCopy:self withZone:zone];
}


-(nullable id)objectForKey:(id)key {
    return [self objectForKeyedSubscript:key];
}


-(nullable id)objectForKeyedSubscript:(id)key {
    RangeDictionaryEntry * __nullable candidate = nil;
    for (RangeDictionaryEntry * entry in self.entries) {
        switch (self.comparator(entry.lo, key)) {
            case NSOrderedSame: {
                return entry.val;
            }

            case NSOrderedDescending: {
                return candidate.val;
            }

            case NSOrderedAscending: {
                switch (self.comparator(entry.hi, key)) {
                    case NSOrderedSame: {
                        // This is a candidate, but we want to check the next entry
                        // above so that if two ranges have equal endpoints we
                        // return the value with lo=key rather than hi=key.
                        // This gives the conventional [A, B) semantics to the ranges.
                        candidate = entry;
                        break;
                    }

                    case NSOrderedAscending: {
                        break;
                    }

                    case NSOrderedDescending: {
                        return entry.val;
                    }
                }
                break;
            }
        }
    }
    return candidate.val;
}


-(void)setObject:(id)obj from:(id<NSCopying>)from to:(id<NSCopying>)to {
    NSParameterAssert(obj);
    NSParameterAssert(from);
    NSParameterAssert(to);
    NSParameterAssert(self.comparator(from, to) == NSOrderedAscending);

    [self setObject_:obj from:from to:to];

#if DEBUG
    [self validate];
#endif
}


-(void)setObject_:(id)obj from:(id<NSCopying>)from to:(id<NSCopying>)to {
    for (NSUInteger idx = 0; idx < self.entries.count; idx++) {
        RangeDictionaryEntry * entry = self.entries[idx];

        switch (self.comparator(entry.lo, from)) {
            case NSOrderedSame: {
                switch (self.comparator(entry.hi, to)) {
                    case NSOrderedSame:
                    case NSOrderedAscending: {
                        // from    to
                        // lo      hi
                        // |        |
                        //
                        // or
                        //
                        // from          to
                        // lo     hi      |
                        // |      |       |
                        //
                        // Repurpose entry to be used for the new data.
                        entry.hi = to;
                        entry.val = obj;
                        return;
                    }

                    case NSOrderedDescending: {
                        // from   to
                        // lo     |     hi
                        // |      |     |
                        entry.lo = to;
                        [self insertEntry:obj from:from to:to atIndex:idx];
                        return;
                    }
                }

                // Unreachable.
                assert(false);
            }

            case NSOrderedDescending: {
                switch (self.comparator(entry.lo, to)) {
                    case NSOrderedSame: {
                        // from    to
                        // |       lo    hi
                        // |       |      |
                        RangeDictionaryEntry * newEntry = [self insertEntry:obj from:from to:to atIndex:idx];
                        [self adjustEntriesToMakeRoomFor:newEntry];
                        return;
                    }

                    case NSOrderedAscending: {
                        switch (self.comparator(entry.hi, to)) {
                            case NSOrderedSame: {
                                // from          to
                                // |      lo     hi
                                // |      |       |
                                //
                                // Repurpose entry to be used for the new data.
                                // We may have an entry inside [from, lo] (see two case statements down)
                                // but adjustEntriesToMakeRoomFor will clean that up.
                                entry.lo = from;
                                entry.val = obj;
                                [self adjustEntriesToMakeRoomFor:entry];
                                return;
                            }

                            case NSOrderedDescending: {
                                // from         to
                                // |      lo    |     hi
                                // |      |     |      |
                                // We may have an entry inside [from, lo] (see case statements below)
                                // but adjustEntriesToMakeRoomFor will clean that up.
                                RangeDictionaryEntry * newEntry = [self insertEntry:obj from:from to:to atIndex:idx];
                                entry.lo = to;
                                [self adjustEntriesToMakeRoomFor:newEntry];
                                return;
                            }

                            case NSOrderedAscending: {
                                // from               to
                                // |      lo    hi     |
                                // |      |     |      |
                                // All subsequent entries will have from < lo.
                                // We need to look for the one with to <= hi and then we'll know what to do.
                                // That will be in one of the two case statements immediately above.
                                // In either case, adjustEntriesToMakeRoomFor will delete this entry.
                                break;
                            }
                        }
                        break;
                    }

                    case NSOrderedDescending: {
                        // from    to
                        // |       |    lo    hi
                        // |       |     |     |
                        [self insertEntry:obj from:from to:to atIndex:idx];
                        return;
                    }
                }
                // Unreachable.
                assert(false);
            }

            case NSOrderedAscending: {
                switch (self.comparator(entry.hi, from)) {
                    case NSOrderedSame:
                    case NSOrderedAscending: {
                        //         from    to
                        // lo      hi       |
                        // |       |        |
                        //
                        // or
                        //
                        //                from    to
                        // lo      hi      |       |
                        // |       |       |       |
                        //
                        // Move on so that we look at the next entry before deciding what to do.
                        break;
                    }

                    case NSOrderedDescending: {
                        //        from
                        // lo      |      hi
                        // |       |       |
                        // Insert an entry after this one, then have adjustEntriesToMakeRoomFor
                        // clean up depending on whether to lands inside or outside [lo, hi].
                        RangeDictionaryEntry * newEntry = [self insertEntry:obj from:from to:to atIndex:idx + 1];
                        [self adjustEntriesToMakeRoomFor:newEntry];
                        return;
                    }
                }
                break;
            }
        }
    }

    // We reached the end of self.entries, so we're inserting at the end.
    [self insertEntry:obj from:from to:to atIndex:self.entries.count];
}


-(RangeDictionaryEntry *)insertEntry:(id)obj from:(id<NSCopying>)from to:(id<NSCopying>)to atIndex:(NSUInteger)idx {
    RangeDictionaryEntry * entry = [[RangeDictionaryEntry alloc] init];
    entry.lo = from;
    entry.hi = to;
    entry.val = obj;
    [self.entries insertObject:entry atIndex:idx];
    return entry;
}


-(void)adjustEntriesToMakeRoomFor:(RangeDictionaryEntry *)entry {
    NSIndexSet * to_remove = [self adjustEntriesToMakeRoomFor_:entry];
    if (to_remove.count > 0) {
        [self.entries removeObjectsAtIndexes:to_remove];
    }
}

/**
 * @return The indexes of any entries that need to be removed.
 */
-(NSIndexSet *)adjustEntriesToMakeRoomFor_:(RangeDictionaryEntry *)newEntry {
    id from = newEntry.lo;
    id to = newEntry.hi;

    NSMutableIndexSet * __nullable to_remove = nil;

    for (NSUInteger idx = 0; idx < self.entries.count; idx++) {
        RangeDictionaryEntry * entry = self.entries[idx];

        if (entry == newEntry) {
            return to_remove;
        }

#define removeAtIdx()                                  \
        if (to_remove == nil) {                        \
            to_remove = [NSMutableIndexSet indexSet];  \
        }                                              \
        [to_remove addIndex:idx];

        switch (self.comparator(entry.lo, from)) {
            case NSOrderedSame: {
                // (from, to) and (lo, hi) cannot be equal or inverted so we're down to three options.
                switch (self.comparator(entry.hi, to)) {
                    case NSOrderedSame: {
                        // from    to
                        // lo      hi
                        // |       |
                        removeAtIdx();
                        return to_remove;
                    }

                    case NSOrderedDescending: {
                        // from    to
                        // lo      |     hi
                        // |       |     |
                        entry.lo = to;
                        return to_remove;
                    }

                    case NSOrderedAscending: {
                        // from          to
                        // lo      hi
                        // |       |     |
                        removeAtIdx();
                        // We need to continue the loop because there might be
                        // other ranges between hi and to.
                        break;
                    }
                }
                break;
            }

            case NSOrderedAscending: {
                switch (self.comparator(entry.hi, from)) {
                    case NSOrderedSame:
                    case NSOrderedAscending: {
                        //         from     to
                        // lo      hi       |
                        // |       |        |
                        //
                        // or
                        //
                        //                from    to
                        // lo      hi     |        |
                        // |       |      |        |
                        // In the first case, this one is exactly where it needs to be, but
                        // we need to continue the loop because there might be
                        // other ranges between hi and to.
                        // In the second case, we just need to keep looking.
                        break;
                    }

                    case NSOrderedDescending: {
                        switch (self.comparator(entry.hi, to)) {
                            case NSOrderedSame: {
                                //         from   to
                                // lo      |      hi
                                // |       |      |
                                entry.hi = from;
                                return to_remove;
                            }

                            case NSOrderedAscending: {
                                //         from         to
                                // lo      |      hi    |
                                // |       |      |     |
                                entry.hi = from;
                                // We need to continue the loop because there might be
                                // other ranges between hi and to.
                                break;
                            }

                            case NSOrderedDescending: {
                                //         from   to
                                // lo      |      |     hi
                                // |       |      |     |
                                // We need to split the range.
                                // Use the current entry as [lo, from)
                                // The next is the current [from, to) which is in the right place.
                                // Create a new one for [to, hi)

                                RangeDictionaryEntry * entryPlus1 = self.entries[idx + 1];
                                assert(entryPlus1.lo == from);
                                assert(entryPlus1.hi == to);

                                id oldHi = entry.hi;
                                entry.hi = from;

                                RangeDictionaryEntry * newEntry2 = [[RangeDictionaryEntry alloc] init];
                                newEntry2.lo = to;
                                newEntry2.hi = oldHi;
                                newEntry2.val = entry.val;
                                [self.entries insertObject:newEntry2 atIndex:idx + 2];

                                return to_remove;
                            }
                        }
                        break;
                    }
                }
                break;
            }

            case NSOrderedDescending: {
                // (from, to) and (lo, hi) cannot be equal or inverted so we're down to three options.
                switch (self.comparator(entry.hi, to)) {
                    case NSOrderedSame: {
                        // from       to
                        // |    lo    hi
                        // |    |     |
                        removeAtIdx();
                        return to_remove;
                    }

                    case NSOrderedDescending: {
                        // from       to
                        // |    lo    |    hi
                        // |    |     |    |
                        entry.lo = to;
                        return to_remove;
                    }

                    case NSOrderedAscending: {
                        // from             to
                        // |    lo    hi    |
                        // |    |     |     |
                        removeAtIdx();
                        // We need to continue the loop because there might be
                        // other ranges between hi and to.
                        break;
                    }
                }
                break;
            }
        }
    }

    return to_remove;
}


-(void)removeAllObjects {
    [self.entries removeAllObjects];
}


-(NSDictionary *)toDictionary {
    return [self toDictionary:NULL];
}


-(NSDictionary *)toDictionary:(nullable id_to_id_t)kvConverter {
    NSArray * entriesJson = [self.entries map:^NSDictionary *(RangeDictionaryEntry * entry) {
        return [entry toDictionary:kvConverter];
    }];
    return @{@"entries": entriesJson};
}


#if DEBUG

-(void)validate {
    id prev = nil;
    for (RangeDictionaryEntry * entry in self.entries) {
        assert(prev == nil || self.comparator(prev, entry.lo) != NSOrderedDescending);
        assert(self.comparator(entry.lo, entry.hi) == NSOrderedAscending);
        prev = entry.hi;
    }
}


-(NSString *)debugDescription {
    return [NSString stringWithFormat:@"RangeDictionary(%@)",
            [[self.entries map:^NSString *(RangeDictionaryEntry * entry) {
                return [entry debugDescription];
              }] componentsJoinedByString:@", "]];
}

#endif


@end


@implementation RangeDictionaryEntry


-(instancetype)initWithShallowCopy:(RangeDictionaryEntry *)other {
    self = [super init];
    if (self) {
        _hi = other.hi;
        _lo = other.lo;
        _val = other.val;
    }
    return self;
}


-(id)copyWithZone:(NSZone *)zone {
    return [[RangeDictionaryEntry allocWithZone:zone] initWithShallowCopy:self];
}


-(NSDictionary *)toDictionary:(nullable id_to_id_t)kvConverter {
    if (kvConverter == NULL) {
        return @{@"lo": self.lo,
                 @"hi": self.hi,
                 @"val": self.val,
                 };
    }
    else {
        return @{@"lo": kvConverter(self.lo),
                 @"hi": kvConverter(self.hi),
                 @"val": kvConverter(self.val),
                 };
    }
}


#if DEBUG

-(NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@ - %@ = %@", self.lo, self.hi, self.val];
}

#endif


@end


NS_ASSUME_NONNULL_END
