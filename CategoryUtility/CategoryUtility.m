//
//  CategoryUtility.m
//
//  Created by TozyZuo.
//  Copyright © 2014年 TozyZuo. All rights reserved.
//

#import "CategoryUtility.h"

@implementation TZObserver

- (instancetype)init
{
    if (self = [super init]) {
        NSMapTable *mapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsObjectPersonality valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality capacity:1];
        self.owners = mapTable;

        NSHashTable *hashTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsObjectPersonality capacity:1];
        self.objectObservers = hashTable;

#if !__has_feature(objc_arc)
        [mapTable release];
        [hashTable release];
#endif
    }
    return self;
}

- (void)dealloc
{
    for (NSObject *owner in self.owners) {
        NSMutableArray *properties = [self.owners objectForKey:owner];
        // owner.property = nil.
        for (NSString *property in properties) {
            [owner performSelector:NSSelectorFromString([NSString stringWithFormat:@"set%@:", property]) withObject:nil];
            // @TODO
            // Can't use KVC.
//            [owner setValue:nil forKey:key];
        }

        NSAssert([owner.observer.objectObservers containsObject:self], @"Shouldn't crash");
        
        // Remove self from owner.observer.objectObservers
        [owner.observer.objectObservers removeObject:self];
    }

    for (TZObserver *objectObserver in self.objectObservers) {
        [objectObserver.owners removeObjectForKey:self.master];
    }

#if !__has_feature(objc_arc)
    self.owners = nil;
    self.objectObservers = nil;
    [super dealloc];
#endif
}
@end

@implementation NSObject (TZObserver)
@Synthesize_nonatomic_strong(NSObject_TZObserver, TZObserver *, observer);
@end