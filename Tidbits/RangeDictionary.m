//
//  RangeDictionary.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/4/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "LoggingMacros.h"
#import "NSArray+Map.h"
#if DEBUG
#import "NSDate+ISO8601.h"
#endif
#import "NSDictionary+Misc.h"

#import "RangeDictionary.h"

NS_ASSUME_NONNULL_BEGIN


@interface RangeDictionaryEntry : NSObject <NSCopying>

@property (nonatomic) id lo;
@property (nonatomic) id hi;
@property (nonatomic) id val;

+(RangeDictionaryEntry *)createWithRange:(id)from :(id)to value:(id)value;

-(instancetype)initWithDictionary:(NSDictionary *)dict converter:(nullable id_to_id_t)kvConverter;

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
    return [self initWithComparator:comparator dictionary:nil converter:NULL];
}


-(instancetype)initWithComparator:(NSComparator)comparator dictionary:(nullable NSDictionary *)dict converter:(nullable id_to_id_t)kvConverter {
    self = [super init];
    if (self) {
        _comparator = comparator;
        if (dict == nil) {
            _entries = [NSMutableArray new];
        }
        else {
            NSArray * entries = [dict arrayForKey:@"entries"];
            if (entries == nil) {
                NSLogError(@"Aborting due to bad dict %@", dict);
                return nil;
            }
            _entries = [entries map:^RangeDictionaryEntry *(id entryDict) {
                if (![entryDict isKindOfClass:[NSDictionary class]]) {
                    NSLogError(@"Aborting due to bogus entry %@", entryDict);
                    return nil;
                }
                RangeDictionaryEntry * entry = [[RangeDictionaryEntry alloc] initWithDictionary:(NSDictionary *)entryDict converter:kvConverter];
                if (entry == nil || self.comparator(entry.lo, entry.hi) != NSOrderedAscending) {
                    NSLogError(@"Aborting due to bogus entry %@", entryDict);
                    return nil;
                }
                return entry;
            }];
            if (_entries.count != entries.count) {
                // We aborted above.
                return nil;
            }

#if DEBUG
            [self validate];
#endif
        }
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


-(NSUInteger)rangeCount {
    return self.entries.count;
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


#if DEBUG || RELEASE_TESTING

-(NSUInteger)from:(id<NSCopying>)from to:(id<NSCopying>)to setObject:(id)obj{
    return [self setObject:obj from:from to:to];
}

#endif


-(NSUInteger)setObject:(id)obj from:(id<NSCopying>)from to:(id<NSCopying>)to {
    NSParameterAssert(obj);
    NSParameterAssert(from);
    NSParameterAssert(to);
    NSParameterAssert(self.comparator(from, to) == NSOrderedAscending);

#if DEBUG
    [self validate];
    __unused NSMutableDictionary *testEntries = [self.entries mutableCopy];
#endif

    NSUInteger testCase = 0;
    testCase = [self insertEntry:[RangeDictionaryEntry createWithRange:from:to value:obj]];
//    [self setObject_:obj from:from to:to];

#if DEBUG
    [self validate];
#endif

    return testCase;
}


-(void)setObject_:(id)obj from:(id<NSCopying>)from to:(id<NSCopying>)to {
    for (NSUInteger idx = 0; idx < self.entries.count; idx++) {
        RangeDictionaryEntry * entry = self.entries[idx];

        switch (self.comparator(entry.lo, from)) {
            case NSOrderedSame: {
                switch (self.comparator(entry.hi, to)) {
                    case NSOrderedSame: {
                        // from    to
                        // lo      hi
                        // |        |
                        //
                        // Repurpose entry to be used for the new data.
                        entry.val = obj;
                        return;
                    }

                    case NSOrderedAscending: {
                        // from          to
                        // lo     hi      |
                        // |      |       |
                        //
                        // We may have an entry between hi and to; we need to keep searching until we find it.
                        // adjustEntriesToMakeRoomFor will delete the current entry.
                        break;
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

                break;
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
                                // That will be in one of the two case statements immediately above or the
                                // one immediately below.
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
                        //
                        // We may have an entry between from and to,
                        // either with old.lo = from, or from < old.lo < to.
                        // This happens in the case statements above.
                        // Insert a new entry for [from, to] here, and use
                        // adjustEntriesToMakeRoomFor to clean up the old one if necessary.
                        RangeDictionaryEntry * newEntry = [self insertEntry:obj from:from to:to atIndex:idx];
                        [self adjustEntriesToMakeRoomFor:newEntry];
                        return;
                    }
                }
                break;
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
    // We need to adjust to make room for this entry if we deliberately skipped
    // overlapping ones above.
    RangeDictionaryEntry * newEntry = [self insertEntry:obj from:from to:to atIndex:self.entries.count];
    [self adjustEntriesToMakeRoomFor:newEntry];
}


-(RangeDictionaryEntry *)insertEntry:(id)obj from:(id<NSCopying>)from to:(id<NSCopying>)to atIndex:(NSUInteger)idx {
    RangeDictionaryEntry * entry = [[RangeDictionaryEntry alloc] init];
    entry.lo = from;
    entry.hi = to;
    entry.val = obj;
    [self.entries insertObject:entry atIndex:idx];
    return entry;
}

//returns branch number to ensure we have all scenarios covered in test cases.
-(NSUInteger)insertEntry:(RangeDictionaryEntry *)newEntry{
    id from = newEntry.lo;
    id to = newEntry.hi;

    if (self.entries.count == 0) {
        [self.entries insertObject:newEntry atIndex:0];
        return 1;
    }

    NSUInteger idx = 0;
    for (; idx < self.entries.count; idx++) {
        RangeDictionaryEntry * entry = self.entries[idx];
        switch (self.comparator(entry.lo, from)) {
            case NSOrderedSame: {
                // (from, to) and (lo, hi) cannot be equal or inverted so we're down to three options.
                switch (self.comparator(entry.hi, to)) {
                    case NSOrderedSame: {
                        // from    to  << new entry
                        // lo      hi
                        // |       |
                        //replace existing value with new value.
                        entry.val = newEntry.val;
                        //nothing more to do.
                        return 2;
                    }

                    case NSOrderedDescending: {
                        // from    to  << new entry
                        // lo      |     hi
                        // |       |     |
                        // mutate original  lo-to:val
                        entry.lo = to;
                        // insert newEntry
                        [self.entries insertObject:newEntry atIndex:idx];
                        //we are done.
                        return 3;
                    }

                    case NSOrderedAscending: {
                        // from             to  << new entry
                        // lo      hi
                        // |       |   ...  |
                        // We need to continue the loop because there might be
                        // other ranges between hi and to.
                        NSUInteger idx1 = idx+1;
                        for (; idx1 < self.entries.count; idx1++) {
                            RangeDictionaryEntry *entry1 = self.entries[idx1];
                            switch (self.comparator(entry1.hi, to)) {
                                case NSOrderedAscending: {
                                    // continue looping.
                                    break;
                                }
                                case NSOrderedSame: {
                                    // from           to  << new entry
                                    // lo  ...    lo':hi'
                                    // |   ...       |
                                    // remove entries idx to idx1
                                    for (NSUInteger idx2 = idx1; idx2 >= idx && idx2 < self.entries.count; idx2--) {
                                        [self.entries removeObjectAtIndex:idx2];
                                    }
                                    // insert newEntry
                                    [self.entries insertObject:newEntry atIndex:idx];
                                    //nothing more to do.
                                    return 4;
                                }

                                case NSOrderedDescending: {
                                    // from          to  << new entry
                                    // lo   hi ...   |  lo'   hi'
                                    // |       ...   |  |     |
                                    //remove entries idx to idx1 not including idx1
                                    for (NSUInteger idx2 = idx1-1; idx2 >= idx && idx2 < self.entries.count; idx2--) {
                                        [self.entries removeObjectAtIndex:idx2];
                                    }
                                    if (self.comparator(entry1.lo, to) == NSOrderedAscending) {
                                        entry1.lo = to;
                                    }
                                    [self.entries insertObject:newEntry atIndex:idx];
                                    //nothing more to do.
                                    return 5;
                                }
                            }
                        }
                        //we have reached the end.
                        // from              to  << new entry
                        // idx       idx1    idx
                        // lo   ... lo':hi'  |
                        // |    ...          |

                        // remove entries idx to idx1
                        for (NSUInteger idx2 = self.entries.count-1; idx2 >= idx && idx2 < self.entries.count; idx2--) {
                                [self.entries removeObjectAtIndex:idx2];
                        }
                        // insert newEntry
                        [self.entries insertObject:newEntry atIndex:idx];
                        //nothing more to do.
                        return 6;
                    }
                }
                break;
            }
            case NSOrderedDescending: {
                // (from, to) and (lo, hi) cannot be equal or inverted so we're down to three options.
                switch (self.comparator(entry.hi, to)) {
                    case NSOrderedAscending: {
                        // from                to
                        // |    lo    hi  ...  |
                        // |    |     |   ...  |
                        break; //continue looping.
                    }
                    case NSOrderedDescending: {
                        // from   to
                        // |      |     lo    |    hi
                        // |      |     |     |    |
                        //
                        if (self.comparator(entry.lo, to) == NSOrderedDescending) {
                            [self.entries insertObject:newEntry atIndex:idx];
                            return 7;
                        }
                        //or
                        //
                        // from       to
                        // |    lo    |    hi
                        // |    |     |    |
                        //mutate current
                        entry.lo = to;
                        // insert newEntry
                        [self.entries insertObject:newEntry atIndex:idx];
                        return 8;
                    }
                    case NSOrderedSame: {
                        // from       to
                        // |    lo    hi
                        // |    |     |
                        [self.entries removeObjectAtIndex:idx];
                        [self.entries insertObject:newEntry atIndex:idx];
                        return 17;
                    }

                }
                break;
            }

            case NSOrderedAscending: {
                switch (self.comparator(entry.hi, from)) {
                    case NSOrderedAscending: {
                        //                from                  to
                        // lo      hi     |   ... lo' | hi'     |
                        // |       |      |   ... lo' | hi'     |
                        // continue looping till we hit NSOrderedSame or NSOrderedDescending.
                        break;
                    }
                    case NSOrderedSame:{
                        //         from  to
                        // lo      hi    | ...
                        // |       |     | ...
                        //
                        //
                        // or
                        //
                        //         from          to
                        // lo      hi    ... lo' | hi'
                        // |       |     ... lo' | hi'
                        //
                        //current entry remains untouched.
                        //next entry(s) may need to be removed or mutated.
                        NSUInteger idx1 = idx+1;
                        for (; idx1 < self.entries.count; idx1++) {
                            RangeDictionaryEntry *entry1 = self.entries[idx1];
                            switch (self.comparator(entry1.hi, to)) {
                                case NSOrderedAscending: {
                                    // continue looping.
                                    break;
                                }
                                case NSOrderedSame: {
                                    // from           to  << new entry
                                    // lo  ...    lo':hi'
                                    // |   ...       |
                                    // remove entries idx to idx1
                                    for (NSUInteger idx2 = idx1; idx2 >= idx1 && idx2 < self.entries.count; idx2--) {
                                        [self.entries removeObjectAtIndex:idx2];
                                    }
                                    // insert newEntry after current.
                                    [self.entries insertObject:newEntry atIndex:idx+1];
                                    //nothing more to do.
                                    return 9;
                                }

                                case NSOrderedDescending: {
                                    // from          to  << new entry
                                    // lo   ... lo'  |     hi'
                                    // |    ...      |     |
                                    //remove entries idx to idx1 not including idx1
                                    for (NSUInteger idx2 = idx1-1; idx2 >= idx1 && idx2 < self.entries.count; idx2--) {
                                        [self.entries removeObjectAtIndex:idx2];
                                    }
                                    // mutate original  lo'-to:val
                                    entry1.lo = to;
                                    // insert newEntry before mutated entry
                                    [self.entries insertObject:newEntry atIndex:idx1];
                                    //nothing more to do.
                                    return 10;
                                }
                            }
                        }
                        //remove overlapped entries.
                        for (NSUInteger idx2 = self.entries.count-1; idx2 > idx && idx2 < self.entries.count; idx2--) {
                            [self.entries removeObjectAtIndex:idx2];
                        }

                        // insert newEntry
                        [self.entries insertObject:newEntry atIndex:idx + 1];
                        //nothing more to do.
                        return 11;
                    }
                    case NSOrderedDescending: {
                        switch (self.comparator(entry.hi, to)) {
                            case NSOrderedSame: {
                                //         from   to
                                // lo      |      hi
                                // |       |      |

                                //mutate the existing entry
                                entry.hi = from;
                                // insert newEntry after mutated entry
                                [self.entries insertObject:newEntry atIndex:idx+1];
                                //nothing more to do.
                                return 12;
                            }

                            case NSOrderedAscending: {
                                //         from             to
                                // lo      |      hi  ...   |
                                // |       |      |   ...   |
                                //mutate the existing entry.
                                entry.hi = from;

                                NSUInteger idx1 = idx+1;
                                for (; idx1 < self.entries.count; idx1++) {
                                    RangeDictionaryEntry *entry1 = self.entries[idx1];
                                    switch (self.comparator(entry1.hi, to)) {
                                        case NSOrderedAscending: {
                                            // continue looping.
                                        }
                                        case NSOrderedSame: {
                                            // from           to  << new entry
                                            // lo  ...    lo':hi'
                                            // |   ...       |
                                            // remove entries idx+1 to idx1
                                            for (NSUInteger idx2 = self.entries.count-1; idx2 > idx && idx2 < self.entries.count; idx2--) {
                                                [self.entries removeObjectAtIndex:idx2];
                                            }
                                            // insert newEntry after current.
                                            [self.entries insertObject:newEntry atIndex:idx+1];
                                            //nothing more to do.
                                            return 13;
                                        }

                                        case NSOrderedDescending: {
                                            // from          to  << new entry
                                            // lo   ... lo'  |     hi'
                                            // |    ...      |     |
                                            //remove entries idx+1 to idx1 not including idx1
                                            for (NSUInteger idx2 = idx1-1; idx2 > idx && idx2 < self.entries.count; idx2--) {
                                                [self.entries removeObjectAtIndex:idx2];
                                            }
                                            // mutate original  lo'-to:val
                                            entry1.lo = to;
                                            [self.entries insertObject:newEntry atIndex:idx+1];
                                            //nothing more to do.
                                            return 18;
                                        }
                                    }
                                }
                                // insert newEntry
                                [self.entries insertObject:newEntry atIndex:idx1];
                                //nothing more to do.
                                return 14;
                            }

                            case NSOrderedDescending: {
                                //         from   to
                                // lo      |      |     hi
                                // |       |      |     |
                                // We need to split the range.
                                // Use the current entry as [lo, from)
                                // The next is the current [from, to) which is in the right place.
                                // Create a new one for [to, hi)

                                RangeDictionaryEntry *entry1 = [RangeDictionaryEntry createWithRange:to :entry.hi value:entry.val];
                                //mutate the current.
                                entry.hi = from;

                                // insert newEntry
                                [self.entries insertObject:newEntry atIndex:idx+1];

                                //insert the original split entry.
                                [self.entries insertObject:entry1 atIndex:idx+2];


                                return 15;
                            }
                        }
                        break;
                    }
                }
                break;
            }

        }
    }
    [self.entries addObject:newEntry];
    return 16;
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


-(id)enumerateEntriesWithOptions:(NSEnumerationOptions)opts usingBlock:(IdIdIdIdPtrBoolPtrBlock)block {
    __block id result = nil;

    [self.entries enumerateObjectsWithOptions:opts usingBlock:^(RangeDictionaryEntry * entry, __unused NSUInteger idx, BOOL *stop) {
        block(entry.lo, entry.hi, entry.val, &result, stop);
    }];

    return result;
}


-(NSMutableArray *)map:(RangeDictionaryEntryToIdBlock)mapper {
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:self.entries.count];
    for (RangeDictionaryEntry * entry in self.entries) {
        id new_obj = mapper(entry.lo, entry.hi, entry.val);
        if (new_obj != nil) {
            [result addObject:new_obj];
        }
    }
    return result;
}


-(NSDictionary *)toDictionary {
    return [self toDictionary:NULL];
}


-(NSDictionary *)toDictionary:(nullable id_to_id_t)kvConverter {
#if DEBUG
    [self validate];
#endif

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

+(RangeDictionaryEntry *)createWithRange:(id<NSCopying>)from :(id<NSCopying>)to value:(id)value
{
    RangeDictionaryEntry * entry = [[RangeDictionaryEntry alloc] init];
    entry.lo = from;
    entry.hi = to;
    entry.val = value;
    return entry;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict converter:(nullable id_to_id_t)kvConverter {
    self = [super init];
    if (self) {
        id lo = dict[@"lo"];
        id hi = dict[@"hi"];
        id val = dict[@"val"];
        if (lo == nil || hi == nil || val == nil) {
            return nil;
        }
        if (kvConverter != NULL) {
            lo = kvConverter(lo);
            hi = kvConverter(hi);
            val = kvConverter(val);
            if (lo == nil || hi == nil || val == nil) {
                return nil;
            }
        }
        _lo = lo;
        _hi = hi;
        _val = val;
    }
    return self;
}


-(instancetype)initWithShallowCopy:(RangeDictionaryEntry *)other {
    self = [super init];
    if (self) {
        _hi = other.hi;
        _lo = other.lo;
        _val = other.val;
    }
    return self;
}


-(id)copyWithZone:(nullable NSZone *)zone {
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
    return [NSString stringWithFormat:@"%@ - %@ = %@", describe(self.lo), describe(self.hi), describe(self.val)];
}

static NSString * describe(id obj) {
    if ([obj isKindOfClass:[NSDate class]]) {
        NSDate * date = (NSDate *)obj;
        return date.iso8601String_24;
    }
    else {
        return [obj description];
    }
}

#endif


@end


NS_ASSUME_NONNULL_END
