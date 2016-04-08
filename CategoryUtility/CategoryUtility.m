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
        self.objectOwners = [NSMapTable weakToStrongObjectsMapTable];
        self.observers = [NSHashTable hashTableWithOptions:NSPointerFunctionsOpaqueMemory];
    }
    return self;
}

//@Synthesize_nonatomic_weak(TZObserver, NSObject *, objectOwner);
#if 1
void *TZObserverobjectOwnerKey = &TZObserverobjectOwnerKey;
- (NSObject *)objectOwner
{
    return objc_getAssociatedObject(self, TZObserverobjectOwnerKey);
}
- (void)setobjectOwner:(NSObject *)objectOwner
{
    NSObject * var = self.objectOwner;
    if (![var isEqual:objectOwner]) {
        /* remove old var's observation. */
        NSString *propertyKey = [NSString stringWithUTF8String:""];
        [[var.ownersObserver.objectOwners objectForKey:self] removeObject:propertyKey];
        /* It's 'weak'. No need to release var. */
        
        if (objectOwner) {
            /* object -> observer -> owner */
            TZObserver *ownersObserver = objectOwner.ownersObserver;
            if (!ownersObserver) {
                ownersObserver = [[TZObserver alloc] init];
                objectOwner.ownersObserver = ownersObserver;
                TZRelease(ownersObserver);
            }
            NSMutableArray *observeProperties = [ownersObserver.objectOwners objectForKey:self];
            if (!observeProperties) {
                observeProperties = [[NSMutableArray alloc] init];
                [ownersObserver.objectOwners setObject:observeProperties forKey:self];
                TZRelease(observeProperties);
            }
            NSAssert(![observeProperties containsObject:propertyKey], @"Shouldn't crash");
            [observeProperties addObject:propertyKey];
            /* owner -> observer -> object */
            TZObserver *observersObserver = self.observersObserver;
            if (!observersObserver) {
                observersObserver = [[TZObserver alloc] init];
                observersObserver.owner = self;
                self.observersObserver = observersObserver;
                TZRelease(observersObserver);
            }
            [observersObserver.observers addObject:ownersObserver];
        }
        objc_setAssociatedObject(self, TZObserverobjectOwnerKey, objectOwner, OBJC_ASSOCIATION_ASSIGN);
    }
}
#endif

- (void)dealloc
{
//    if (self.deallocBlock) {
//        self.deallocBlock();
//    }

//    NSLog(@"[%@(%p) %@]", self.class, self, NSStringFromSelector(_cmd));

    for (NSObject *owner in self.objectOwners) {
        NSMutableArray *properties = [self.objectOwners objectForKey:owner];
        for (NSString *key in properties) {
            [owner performSelector:NSSelectorFromString([NSString stringWithFormat:@"set%@:", key]) withObject:nil];
//            [owner setValue:nil forKey:key];
        }
    }

    for (TZObserver *observer in self.observers) {
        [observer.objectOwners removeObjectForKey:self.owner];
    }

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}
@end

@implementation NSObject (TZObserver)
@Synthesize_nonatomic_strong(NSObject_TZObserver, TZObserver *, ownersObserver);
@Synthesize_nonatomic_strong(NSObject_TZObserver, TZObserver *, observersObserver);
//@Synthesize_nonatomic_strong(NSObject_TZObserver, NSMutableArray *, observerList);
@end