//
//  CategoryUtility.m
//
//  Created by TozyZuo on 16/4/1.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import "CategoryUtility.h"

@implementation TZObserver

//@Synthesize_nonatomic_weak(TZObserver, NSObject *, objectOwner);
#if 0
void *TZObserverobjectOwnerKey = &TZObserverobjectOwnerKey;
- (NSObject *)objectOwner
{
    return objc_getAssociatedObject(self, TZObserverobjectOwnerKey);
}
- (void)setobjectOwner:(NSObject *)objectOwner
{
    NSObject * var = self.objectOwner;
    if (![var isEqual:objectOwner]) {
        NSMutableArray *observerList = var.observerList;
        TZWEAK_KEYWORD TZObserver *removeObserver = nil;
        for (TZObserver *observer in observerList) {
            if ([observer.objectOwner isEqual:self]) {
                observer.objectOwner = nil;
                removeObserver = observer;
                break;
            }
        }
        [observerList removeObject:removeObserver];
        /* It's 'weak'. No need to release var. */
        
        if (objectOwner) {
            NSMutableArray *observerList = objectOwner.observerList;
            if (!observerList) {
                observerList = [[NSMutableArray alloc] init];
                objectOwner.observerList = observerList;
                TZRelease(observerList);
            }
            __block TZObserver *observer = [[TZObserver alloc] init];
            observer.objectOwner = self;
            TZWEAK_KEYWORD __typeof(self) weakSelf = self;
            [observer setDeallocBlock:^{
                weakSelf.objectOwner = nil;
            }];
            [observerList addObject:observer];
            TZRelease(observer);
        }
        objc_setAssociatedObject(self, TZObserverobjectOwnerKey, objectOwner, OBJC_ASSOCIATION_ASSIGN);
    }
}
#endif

- (void)dealloc
{
    if (self.deallocBlock) {
        self.deallocBlock();
    }

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}
@end

@implementation NSObject (TZObserver)
@Synthesize_nonatomic_strong(NSObject_TZObserver, NSMutableArray *, observerList);
@end