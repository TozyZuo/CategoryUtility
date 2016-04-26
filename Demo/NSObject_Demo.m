//
//  NSObject_Demo.m
//  Demo
//
//  Created by TozyZuo.
//

#import "NSObject_Demo.h"
#import "CategoryUtility.h"
//#import "CategoryUtility_WeakExtension.h"


@implementation NSObject (Demo)


//@Synthesize_nonatomic_strong(NSObject_Demo, NSObject *, strongProperty);

void *NSObject_DemostrongPropertyKey = &NSObject_DemostrongPropertyKey;

- (NSObject *)strongProperty
{
    return objc_getAssociatedObject(self, NSObject_DemostrongPropertyKey);
}

- (void)setstrongProperty:(NSObject *)strongProperty
{
    NSString *propertyKey = [NSString stringWithUTF8String:"strongProperty"];
    [self willChangeValueForKey:propertyKey];
    if (![strongProperty isEqual:self.strongProperty]) {
        objc_setAssociatedObject(self, NSObject_DemostrongPropertyKey, strongProperty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self didChangeValueForKey:propertyKey];
}


//@Synthesize_nonatomic_copy(NSObject_Demo, NSObject *, copyProperty);

void *NSObject_DemocopyPropertyKey = &NSObject_DemocopyPropertyKey;

- (NSObject *)copyProperty
{
    return objc_getAssociatedObject(self, NSObject_DemocopyPropertyKey);
}

- (void)setcopyProperty:(NSObject *)copyProperty
{
    NSString *propertyKey = [NSString stringWithUTF8String:"copyProperty"];
    [self willChangeValueForKey:propertyKey];
    if (![copyProperty isEqual:self.copyProperty]) {
        if (copyProperty && ![copyProperty respondsToSelector:@selector(copy)]) {
            NSLog(@"-[%@ copy] need to be implemented.", [copyProperty class]);
            return;
        }
        if (copyProperty && ![copyProperty respondsToSelector:@selector(copyWithZone:)]) {
            NSLog(@"-[%@ copyWithZone:] need to be implemented.", [copyProperty class]);
            return;
        }
        objc_setAssociatedObject(self, NSObject_DemocopyPropertyKey, [copyProperty copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self didChangeValueForKey:propertyKey];
}


//@Synthesize_nonatomic_weak(NSObject_Demo, NSObject *, weakProperty);

#if defined(TZWeakExtension)

void *NSObject_DemoweakPropertyKey = &NSObject_DemoweakPropertyKey;

- (NSObject *)weakProperty
{
    TZWeakContainer *weakContainer = objc_getAssociatedObject(self, NSObject_DemoweakPropertyKey);
    NSObject * ret;
    /* ARC will add an 'autorelease''s retain count, so we add an autoreleasepool. */
    /* Actually it's "weakContainer.object.retain.autorelease" */
    @autoreleasepool {
        ret = weakContainer.object;
    }
    return ret;
}

- (void)setweakProperty:(NSObject *)weakProperty
{
    NSString *propertyKey = [NSString stringWithUTF8String:"weakProperty"];
    [self willChangeValueForKey:propertyKey];
    id var = self.weakProperty;
    if (![var isEqual:weakProperty]) {
        TZWeakContainer *weakContainer = objc_getAssociatedObject(self, NSObject_DemoweakPropertyKey);
        if (!weakContainer) {
            weakContainer = [[TZWeakContainer alloc] init];
            objc_setAssociatedObject(self, NSObject_DemoweakPropertyKey, weakContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            TZRelease(weakContainer);
        }
        weakContainer.object = weakProperty;
    }
    [self didChangeValueForKey:propertyKey];
}

#else // defined(TZWeakExtension)

void *NSObject_DemoweakPropertyKey = &NSObject_DemoweakPropertyKey;

- (NSObject *)weakProperty
{
    return objc_getAssociatedObject(self, NSObject_DemoweakPropertyKey);
}

- (void)setweakProperty:(NSObject *)weakProperty
{
    NSString *propertyKey = [NSString stringWithUTF8String:"weakProperty"];
    [self willChangeValueForKey:propertyKey];
    NSObject *var = self.weakProperty;
    if (![var isEqual:weakProperty]) {
        /* remove old var's observation. */
        [[var.observer.owners objectForKey:self] removeObject:propertyKey];
        
        if (weakProperty) {
            /* object.observer -> owner */
            TZObserver *objectObserver = weakProperty.observer;
            if (!objectObserver) {
                objectObserver = [[TZObserver alloc] init];
                weakProperty.observer = objectObserver;
                TZRelease(objectObserver);
            }
            NSMutableArray *observeProperties = [objectObserver.owners objectForKey:self];
            if (!observeProperties) {
                observeProperties = [[NSMutableArray alloc] init];
                [objectObserver.owners setObject:observeProperties forKey:self];
                TZRelease(observeProperties);
            }
            NSAssert(![observeProperties containsObject:propertyKey], @"Shouldn't crash");
            [observeProperties addObject:propertyKey];
            
            /* owner.observer -> object.observer */
            TZObserver *selfObserver = self.observer;
            if (!selfObserver) {
                selfObserver = [[TZObserver alloc] init];
                selfObserver.master = self;
                self.observer = selfObserver;
                TZRelease(selfObserver);
            }
            [selfObserver.objectObservers addObject:objectObserver];
        }
        objc_setAssociatedObject(self, NSObject_DemoweakPropertyKey, weakProperty, OBJC_ASSOCIATION_ASSIGN);
    }
    [self didChangeValueForKey:propertyKey];
}

#endif // defined(TZWeakExtension)


//@Synthesize_nonatomic_assign(NSObject_Demo, int, assignProperty);

void *NSObject_DemoassignPropertyKey = &NSObject_DemoassignPropertyKey;

- (int)assignProperty
{
    NSData *data = objc_getAssociatedObject(self, NSObject_DemoassignPropertyKey);
    const void *retPtr = data.bytes;
    if (!retPtr) {
        int ret;
        memset(&ret, 0, sizeof(int));
        return ret;
    }
    return (*(int *)retPtr);
}
- (void)setassignProperty:(int)assignProperty
{
    NSData *data = [[NSData alloc] initWithBytes:&assignProperty length:sizeof(int)];
    NSString *propertyKey = [NSString stringWithUTF8String:"assignProperty"];
    [self willChangeValueForKey:propertyKey];
    objc_setAssociatedObject(self, NSObject_DemoassignPropertyKey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:propertyKey];
    TZRelease(data);
}

@end