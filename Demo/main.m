//
//  main.m
//  Demo
//
//  Created by TozyZuo on 16/4/1.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryUtility.h"
/*
 *  remove '//' to turn on WeakExtension feature.
 */
//#import "CategoryUtility_WeakExtension.h"


#if __has_feature(objc_arc)
#define Release(obj)    obj = nil
#else
#define Release(obj)    [(obj) release]
#endif

//#define NSLog(...)

#pragma mark - Declaration

typedef void (^MyBlock)();

@interface MyObject : NSObject

- (void)log;

@end

@implementation MyObject

- (id)copyWithZone:(NSZone *)zone
{
    return [[self.class allocWithZone:zone] init];
}

- (void)log
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)dealloc
{
    NSLog(@"[%@(%p) %@]", self.class, self, NSStringFromSelector(_cmd));
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"object:%@, keyPath:%@, change:%@", object, keyPath, change);
}

@end

typedef struct {
    char    a;
    int     b;
    float   c;
    char   *d;
} MyStruct;

#pragma mark

@interface NSObject (Model)

@Property_nonatomic_strong(NSObject *, strongObject1);
@Property_nonatomic_strong(NSObject *, strongObject2);
@Property_nonatomic__copy_(NSObject *, copyObject1);
@Property_nonatomic__copy_(NSObject *, copyObject2);
@Property_nonatomic__copy_( MyBlock  , block);
@Property_nonatomic__weak_(NSObject *, weakObject1);
@Property_nonatomic__weak_(NSObject *, weakObject2);
@Property_nonatomic_assign(   int    , intProperty);
@Property_nonatomic_assign( CGPoint  , pointProperty);
@Property_nonatomic_assign(  CGRect  , rectProperty);
@Property_nonatomic_assign( MyStruct , structProperty);
@Property_nonatomic_assign(  char *  , strProperty);
@Property_nonatomic_assign(MyObject *, assignObject);

@end

@implementation NSObject (Model)

@Synthesize_nonatomic_strong(NSObject_Model, NSObject *, strongObject1);
@Synthesize_nonatomic_strong(NSObject_Model, NSObject *, strongObject2);
@Synthesize_nonatomic__copy_(NSObject_Model, NSObject *, copyObject1);
@Synthesize_nonatomic__copy_(NSObject_Model, NSObject *, copyObject2);
@Synthesize_nonatomic__copy_(NSObject_Model,  MyBlock  , block);
@Synthesize_nonatomic__weak_(NSObject_Model, NSObject *, weakObject1);
@Synthesize_nonatomic__weak_(NSObject_Model, NSObject *, weakObject2);
@Synthesize_nonatomic_assign(NSObject_Model,    int    , intProperty);
@Synthesize_nonatomic_assign(NSObject_Model,  CGPoint  , pointProperty);
@Synthesize_nonatomic_assign(NSObject_Model,   CGRect  , rectProperty);
@Synthesize_nonatomic_assign(NSObject_Model,  MyStruct , structProperty);
@Synthesize_nonatomic_assign(NSObject_Model,   char *  , strProperty);

@Synthesize_nonatomic_assign_object(NSObject_Model, NSObject *, assignObject);

@end

#pragma mark

void TestStrongProperty(NSObject *obj);
void TestCopyProperty(NSObject *obj);
void TestWeakProperty(NSObject *obj);
void TestAssignProperty(NSObject *obj);
void TestWeakExtensionProperty(NSObject *obj);
void TestKVO(NSObject *obj);

#pragma mark - Main

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        NSObject *obj = [[NSObject alloc] init];

        NSLog(@"obj %@", obj);

//        long long i = 0;
//        while (i++ < (1 << 19)) {
//            if (i % 10000 == 0) {
//                printf("%lldn", i);
//            }
//            @autoreleasepool {
//                TestWeakProperty(obj);
//            }
//        }
//        printf("%lld", i);

        TestStrongProperty(obj);
        TestCopyProperty(obj);
        TestWeakProperty(obj);
        TestAssignProperty(obj);
        TestWeakExtensionProperty(obj);
        TestKVO(obj);

        NSLog(@"%s", obj.strProperty);

    }
    return 0;
}

#pragma mark - Test Function

void TestStrongProperty(NSObject *obj)
{
    // Referenced by single object, check destroyed time.
    NSObject *strongObjectRef = [[MyObject alloc] init];

    obj.strongObject1 = strongObjectRef;

    NSLog(@"%@", obj.strongObject1);

    Release(strongObjectRef);
    obj.strongObject1 = nil;

    // Referenced by multiple properties, check destroyed time.
    strongObjectRef = [[MyObject alloc] init];

    obj.strongObject1 = strongObjectRef;
    obj.strongObject2 = strongObjectRef;

    NSLog(@"1 %@ 2 %@", obj.strongObject1, obj.strongObject2);

    Release(strongObjectRef);
    obj.strongObject1 = nil;
    obj.strongObject2 = nil;

    // Update value, check destroyed time.
    strongObjectRef = [[MyObject alloc] init];

    obj.strongObject1 = strongObjectRef;

    NSLog(@"%@", obj.strongObject1);

    Release(strongObjectRef);

    strongObjectRef = [[MyObject alloc] init];

    obj.strongObject1 = strongObjectRef;

    NSLog(@"%@", obj.strongObject1);

    Release(strongObjectRef);
    obj.strongObject1 = nil;

    // Referenced by multiple objects, check destroyed time.
    NSObject *obj2 = [[NSObject alloc] init];

    strongObjectRef = [[MyObject alloc] init];

    obj.strongObject1 = strongObjectRef;
    obj2.strongObject1 = strongObjectRef;

    NSLog(@"1 %@ 2 %@", obj.strongObject1, obj2.strongObject1);

    Release(strongObjectRef);
    obj.strongObject1 = nil;
    obj2.strongObject1 = nil;

    // Owner destroyed, check destroyed time.
    obj2 = [[NSObject alloc] init];

    strongObjectRef = [[MyObject alloc] init];

    obj2.strongObject1 = strongObjectRef;

    NSLog(@"%@", obj2.strongObject1);

    Release(strongObjectRef);
    Release(obj2);

    // Owner destroyed, check destroyed time.(Referenced by multiple properties)
    obj2 = [[NSObject alloc] init];

    strongObjectRef = [[MyObject alloc] init];

    obj2.strongObject1 = strongObjectRef;
    obj2.strongObject2 = strongObjectRef;

    NSLog(@"1 %@ 2 %@", obj2.strongObject1, obj2.strongObject2);

    Release(strongObjectRef);
    Release(obj2);

    // Owners destroyed, check destroyed time.
    obj2 = [[NSObject alloc] init];
    NSObject *obj3 = [[NSObject alloc] init];

    strongObjectRef = [[MyObject alloc] init];

    obj2.strongObject1 = strongObjectRef;
    obj3.strongObject1 = strongObjectRef;

    NSLog(@"1 %@ 2 %@", obj2.strongObject1, obj3.strongObject1);

    Release(strongObjectRef);
    Release(obj2);
    Release(obj3);
}

void TestCopyProperty(NSObject *obj)
{
    // Copied by single property, check destroyed time.
    NSObject *copyObjectRef = [[MyObject alloc] init];

    obj.copyObject1 = copyObjectRef;

    NSLog(@"1 %@ 2 %@", copyObjectRef, obj.copyObject1);

    Release(copyObjectRef);
    obj.copyObject1 = nil;

    // Copied by multiple properties, check destroyed time.
    copyObjectRef = [[MyObject alloc] init];

    obj.copyObject1 = copyObjectRef;
    obj.copyObject2 = copyObjectRef;

    NSLog(@"obj.1 %@ obj.2 %@ origin %@", obj.copyObject1, obj.copyObject2, copyObjectRef);

    Release(copyObjectRef);
    obj.copyObject1 = nil;
    obj.copyObject2 = nil;

    // Update value, check destroyed time.
    copyObjectRef = [[MyObject alloc] init];

    obj.copyObject1 = copyObjectRef;

    NSLog(@"1 %@ 2 %@", copyObjectRef, obj.copyObject1);

    Release(copyObjectRef);

    copyObjectRef = [[MyObject alloc] init];

    obj.copyObject1 = copyObjectRef;

    NSLog(@"1 %@ 2 %@", copyObjectRef, obj.copyObject1);

    Release(copyObjectRef);
    obj.copyObject1 = nil;

    // Owner destroyed, check destroyed time.
    NSObject *obj2 = [[NSObject alloc] init];

    copyObjectRef = [[MyObject alloc] init];

    obj2.copyObject1 = copyObjectRef;

    NSLog(@"1 %@ 2 %@", copyObjectRef, obj2.copyObject1);

    Release(copyObjectRef);
    Release(obj2);

    // Owner destroyed, check destroyed time.(Referenced by multiple properties)
    obj2 = [[NSObject alloc] init];

    copyObjectRef = [[MyObject alloc] init];

    obj2.copyObject1 = copyObjectRef;
    obj2.copyObject2 = copyObjectRef;

    NSLog(@"obj.1 %@ obj.2 %@ origin %@", obj2.copyObject1, obj2.copyObject2, copyObjectRef);

    Release(copyObjectRef);
    Release(obj2);

    // Block test
    MyBlock block304 = ^{
        NSLog(@"%d", __LINE__);
    };

    obj.block = block304;
    obj.block();
    block304();

    MyBlock block312 = ^{
        NSLog(@"%d", __LINE__);
    };
    obj.block = block312;
    obj.block();
    block312();

    obj.block = block304;
    obj.block();

    obj.block = nil;
    obj.block(); // crash
}

void TestWeakProperty(NSObject *obj)
{
    // Referenced by single object, check the property statue.
    NSObject *weakObjectRef = [[MyObject alloc] init];

    obj.weakObject1 = weakObjectRef;

    NSLog(@"%@", obj.weakObject1);

    Release(weakObjectRef);

    NSLog(@"%@", obj.weakObject1);

    // Referenced by multiple properties, check the property statue.
    weakObjectRef = [[MyObject alloc] init];

    obj.weakObject1 = weakObjectRef;
    obj.weakObject2 = weakObjectRef;

    NSLog(@"1 %@ 2 %@", obj.weakObject1, obj.weakObject2);


    Release(weakObjectRef);

    NSLog(@"1 %@ 2 %@", obj.weakObject1, obj.weakObject2);

    // Referenced by multiple objects, check the property statue.
    NSObject *obj2 = [[NSObject alloc] init];

    weakObjectRef = [[MyObject alloc] init];

    obj.weakObject1 = weakObjectRef;
    obj2.weakObject1 = weakObjectRef;

    NSLog(@"obj1.1 %@ obj2.1 %@", obj.weakObject1, obj2.weakObject1);

    Release(weakObjectRef);

    NSLog(@"obj1.1 %@ obj2.1 %@", obj.weakObject1, obj2.weakObject1);

    // Referenced by multiple objects and multiple properties, check the property statue.
    weakObjectRef = [[MyObject alloc] init];
    NSObject *weakObjectRef2 = [[MyObject alloc] init];

    obj.weakObject1 = weakObjectRef;
    obj.weakObject2 = weakObjectRef2;
    obj2.weakObject1 = weakObjectRef;
    obj2.weakObject2 = weakObjectRef2;

    NSLog(@"obj1.1 %@ obj1.2 %@ obj2.1 %@ obj2.2 %@", obj.weakObject1, obj.weakObject2, obj2.weakObject1, obj2.weakObject2);

    Release(weakObjectRef);

    NSLog(@"obj1.1 %@ obj1.2 %@ obj2.1 %@ obj2.2 %@", obj.weakObject1, obj.weakObject2, obj2.weakObject1, obj2.weakObject2);

    Release(weakObjectRef2);

    NSLog(@"obj1.1 %@ obj1.2 %@ obj2.1 %@ obj2.2 %@", obj.weakObject1, obj.weakObject2, obj2.weakObject1, obj2.weakObject2);

    // Owner destroyed, check destroyed time.
    obj2 = [[MyObject alloc] init];

    NSLog(@"%@", obj2);

    weakObjectRef = [[MyObject alloc] init];

    obj2.weakObject1 = weakObjectRef;

    NSLog(@"%@", obj2.weakObject1);

    Release(obj2);
    Release(weakObjectRef);

    // Owner destroyed, check destroyed time.(Referenced by multiple properties)
    obj2 = [[MyObject alloc] init];

    NSLog(@"%@", obj2);

    weakObjectRef = [[MyObject alloc] init];

    obj2.weakObject1 = weakObjectRef;
    obj2.weakObject2 = weakObjectRef;

    NSLog(@"1 %@ 2 %@", obj2.weakObject1, obj2.weakObject2);

    Release(obj2);
    Release(weakObjectRef);

    // Owners destroyed, check destroyed time.
    obj2 = [[MyObject alloc] init];
    NSObject *obj3 = [[MyObject alloc] init];

    NSLog(@"2 %@ 3 %@", obj2, obj3);

    weakObjectRef = [[MyObject alloc] init];

    obj2.weakObject1 = weakObjectRef;
    obj3.weakObject1 = weakObjectRef;

    NSLog(@"2 %@ 3 %@", obj2.weakObject1, obj3.weakObject1);

    Release(obj2);

    NSLog(@"3 %@", obj3.weakObject1);

    Release(obj3);
    Release(weakObjectRef);
}

void TestWeakExtensionProperty(NSObject *obj)
{
    // Referenced by single object, check the property statue.
    NSObject *weakObjectRef = [[MyObject alloc] init];

    obj.weakObject1 = weakObjectRef;

    // ARC will add an 'autorelease''s retain count, so we add an autoreleasepool.
    // Actually it's "obj.weakObject1.retain.autorelease".
    @autoreleasepool {
        NSLog(@"%@", obj.weakObject1);
    }

    Release(weakObjectRef);

    NSLog(@"%@", obj.weakObject1);

    // Referenced by multiple properties, check the property statue.
    weakObjectRef = [[MyObject alloc] init];

    obj.weakObject1 = weakObjectRef;
    obj.weakObject2 = weakObjectRef;

    @autoreleasepool {
        NSLog(@"1 %@ 2 %@", obj.weakObject1, obj.weakObject2);
    }

    Release(weakObjectRef);

    NSLog(@"1 %@ 2 %@", obj.weakObject1, obj.weakObject2);

    // Referenced by multiple objects, check the property statue.
    NSObject *obj2 = [[NSObject alloc] init];

    weakObjectRef = [[MyObject alloc] init];

    obj.weakObject1 = weakObjectRef;
    obj2.weakObject1 = weakObjectRef;

    @autoreleasepool {
        NSLog(@"obj1.1 %@ obj2.1 %@", obj.weakObject1, obj2.weakObject1);
    }

    Release(weakObjectRef);

    NSLog(@"obj1.1 %@ obj2.1 %@", obj.weakObject1, obj2.weakObject1);

    // Referenced by multiple objects and multiple properties, check the property statue.
    weakObjectRef = [[MyObject alloc] init];
    NSObject *weakObjectRef2 = [[MyObject alloc] init];

    obj.weakObject1 = weakObjectRef;
    obj.weakObject2 = weakObjectRef2;
    obj2.weakObject1 = weakObjectRef;
    obj2.weakObject2 = weakObjectRef2;

    @autoreleasepool {
        NSLog(@"obj1.1 %@ obj1.2 %@ obj2.1 %@ obj2.2 %@", obj.weakObject1, obj.weakObject2, obj2.weakObject1, obj2.weakObject2);
    }

    Release(weakObjectRef);

    @autoreleasepool {
        NSLog(@"obj1.1 %@ obj1.2 %@ obj2.1 %@ obj2.2 %@", obj.weakObject1, obj.weakObject2, obj2.weakObject1, obj2.weakObject2);
    }

    Release(weakObjectRef2);

    NSLog(@"obj1.1 %@ obj1.2 %@ obj2.1 %@ obj2.2 %@", obj.weakObject1, obj.weakObject2, obj2.weakObject1, obj2.weakObject2);
}

void TestAssignProperty(NSObject *obj)
{
    // int
    obj.intProperty = 10;

    NSLog(@"%d", obj.intProperty);

    obj.intProperty = 20;

    NSLog(@"%d", obj.intProperty);

    // point
    NSLog(@"{%.f, %.f} %d", obj.pointProperty.x, obj.pointProperty.y, CGPointEqualToPoint(CGPointZero, obj.pointProperty));

    obj.pointProperty = CGPointMake(1, 2);

    NSLog(@"{%.f, %.f}", obj.pointProperty.x, obj.pointProperty.y);

    obj.pointProperty = CGPointMake(10, 20);

    NSLog(@"%@", NSStringFromPoint(obj.pointProperty));

    // rect
    NSLog(@"{{%.f, %.f}, {%.f, %.f}} %d", obj.rectProperty.origin.x, obj.rectProperty.origin.y, obj.rectProperty.size.width, obj.rectProperty.size.height, CGRectEqualToRect(CGRectZero, obj.rectProperty));

    obj.rectProperty = CGRectMake(1, 2, 3, 4);

    NSLog(@"{{%.f, %.f}, {%.f, %.f}}", obj.rectProperty.origin.x, obj.rectProperty.origin.y, obj.rectProperty.size.width, obj.rectProperty.size.height);

    obj.rectProperty = CGRectMake(10, 20, 30, 40);

    NSLog(@"%@", NSStringFromRect(obj.rectProperty));

    // struct
    NSLog(@"{%c, %d, %f, %s}", obj.structProperty.a, obj.structProperty.b, obj.structProperty.c, obj.structProperty.d);

    obj.structProperty = (MyStruct){'a', 33, 3.14159, "string"};

    NSLog(@"{%c, %d, %f, %s}", obj.structProperty.a, obj.structProperty.b, obj.structProperty.c, obj.structProperty.d);

    MyStruct aStruct = {'b', 66, 2.71828, "hello world!"};

    obj.structProperty = aStruct;

    NSLog(@"{%c, %d, %f, %s}", obj.structProperty.a, obj.structProperty.b, obj.structProperty.c, obj.structProperty.d);

    // char *
    NSLog(@"%s", obj.strProperty);

    char a[20] = {0}; // stack
    char *s = "this is a string";

    memcpy(a, s, strlen(s));

    obj.strProperty = a;

    NSLog(@"%s", obj.strProperty);

    MyObject *assignObject = [[MyObject alloc] init];

    NSLog(@"%@", assignObject);

    obj.assignObject = assignObject;

    NSLog(@"%@", obj.assignObject);

    [obj.assignObject log];

    Release(assignObject);

    NSLog(@"%@", obj.assignObject); // Crash risk

//    int *ptr = (int *)(assignObject);
//    *ptr = 10;

    [obj.assignObject log]; // Crash risk
}

void TestKVO(NSObject *obj)
{
    MyObject *myObject = [[MyObject alloc] init];
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld;

    // Strong property KVO test
    [myObject addObserver:myObject forKeyPath:@"strongObject1" options:options context:NULL];

    myObject.strongObject1 = nil;

    MyObject *strongObject = [[MyObject alloc] init];

    NSLog(@"%@", strongObject);

    myObject.strongObject1 = strongObject;

    Release(strongObject);

    strongObject = [[MyObject alloc] init];

    NSLog(@"%@", strongObject);

    myObject.strongObject1 = strongObject;
    myObject.strongObject1 = strongObject;

    Release(strongObject);
    myObject.strongObject1 = nil;

    [myObject removeObserver:myObject forKeyPath:@"strongObject1"];


    // Weak property KVO test
    [myObject addObserver:myObject forKeyPath:@"weakObject1" options:options context:NULL];

    myObject.weakObject1 = nil;

    MyObject *weakObject = [[MyObject alloc] init];

    NSLog(@"%@", weakObject);

    myObject.weakObject1 = weakObject;

    Release(weakObject);

    weakObject = [[MyObject alloc] init];

    NSLog(@"%@", weakObject);

    myObject.weakObject1 = weakObject;
    myObject.weakObject1 = weakObject;

    Release(weakObject);

    [myObject removeObserver:myObject forKeyPath:@"weakObject1"];

    // Assign property KVO test
    [myObject addObserver:myObject forKeyPath:@"intProperty" options:options context:NULL];

    myObject.intProperty = 0;
    myObject.intProperty = 1;
    myObject.intProperty = 1;

    [myObject removeObserver:myObject forKeyPath:@"intProperty"];
}

#pragma mark - Demo

#if 0
@interface NSObject (Demo)

//@Property_nonatomic_strong(NSObject *, strongProperty);
@property (nonatomic, strong, setter = setstrongProperty:) NSObject *strongProperty;

//@Property_nonatomic_weak(NSObject *, weakProperty);
@property (nonatomic,  weak , setter = setweakProperty:) NSObject *weakProperty;

//@Property_nonatomic_assign(int, assignProperty);
@property (nonatomic, assign, setter = setassignProperty:) int assignProperty;

@end

@implementation NSObject (Demo)


//@Synthesize_nonatomic_strong(NSObject_Demo, NSObject *, strongProperty);
void *NSObject_DemostrongPropertyKey = &NSObject_DemostrongPropertyKey;

- (NSObject *)strongProperty
{
    return objc_getAssociatedObject(self, NSObject_DemostrongPropertyKey);
}

- (void)setstrongProperty:(NSObject *)strongProperty
{
    objc_setAssociatedObject(self, NSObject_DemostrongPropertyKey, strongProperty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//@Synthesize_nonatomic_copy(NSObject_Demo, NSObject *, copyProperty);
void *NSObject_DemocopyPropertyKey = &NSObject_DemocopyPropertyKey;

- (NSObject *)copyProperty
{
    return objc_getAssociatedObject(self, NSObject_DemocopyPropertyKey);
}

- (void)setcopyProperty:(NSObject *)copyProperty
{
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


//@Synthesize_nonatomic_weak(NSObject_Demo, NSObject *, weakProperty);
#if defined(TZWeakExtension)
void *NSObject_DemoweakPropertyKey = &NSObject_DemoweakPropertyKey;

- (NSObject *)weakProperty
{
    TZWeakContainer *weakContainer = objc_getAssociatedObject(self, NSObject_DemoweakPropertyKey);
    NSObject * ret;
    @autoreleasepool {
        ret = weakContainer.object;
    }
    return ret;
}
- (void)setweakProperty:(NSObject *)weakProperty
{
    NSObject * var = self.weakProperty;
    if (![var isEqual:weakProperty]) {
        TZWeakContainer *weakContainer = objc_getAssociatedObject(self, NSObject_DemoweakPropertyKey);
        if (!weakContainer) {
            weakContainer = [[TZWeakContainer alloc] init];
            objc_setAssociatedObject(self, NSObject_DemoweakPropertyKey, weakContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        weakContainer.object = weakProperty;
    }
}

#else // defined(TZWeakExtension)

void *NSObject_DemoweakPropertyKey = &NSObject_DemoweakPropertyKey;

- (NSObject *)weakProperty
{
    return objc_getAssociatedObject(self, NSObject_DemoweakPropertyKey);
}

- (void)setweakProperty:(NSObject *)weakProperty
{
    NSObject * var = self.weakProperty;
    if (![var isEqual:weakProperty]) {
        /* remove old var's observation. */
        NSString *propertyKey = [NSString stringWithUTF8String:""];
        [[var.ownersObserver.objectOwners objectForKey:self] removeObject:propertyKey];
        /* It's 'weak'. No need to release var. */

        if (weakProperty) {
            /* object -> observer -> owner */
            TZObserver *ownersObserver = weakProperty.ownersObserver;
            if (!ownersObserver) {
                ownersObserver = [[TZObserver alloc] init];
                weakProperty.ownersObserver = ownersObserver;
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
        objc_setAssociatedObject(self, NSObject_DemoweakPropertyKey, weakProperty, OBJC_ASSOCIATION_ASSIGN);
    }
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
    objc_setAssociatedObject(self, NSObject_DemoassignPropertyKey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    TZRelease(data);
}

@end
#endif // Demo