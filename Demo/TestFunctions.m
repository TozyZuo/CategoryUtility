//
//  TestFunctions.m
//  Demo
//
//  Created by TozyZuo.
//

#import "TestFunctions.h"
#import "MyObject.h"
#import "NSObject_Model.h"

//#define NSLog(...)

#if __has_feature(objc_arc)
#define Release(obj)    obj = nil
#else
#define Release(obj)    [(obj) release]
#endif


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

    Release(obj2);

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
    MyBlock block1 = ^{
        NSLog(@"%d", __LINE__);
    };

    obj.block = block1;
    obj.block();
    block1();

    MyBlock block2 = ^{
        NSLog(@"%d", __LINE__);
    };
    obj.block = block2;
    obj.block();
    block2();

    obj.block = block1;
    obj.block();

    obj.block = nil;
//    obj.block(); // crash
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

    Release(obj2);

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

    Release(obj2);

#if defined(TZWeakExtension)

    // Reference an id object
    obj.idObject = [MyObject class];

    NSLog(@"%@", obj.idObject);

    // Reference a block
    MyBlock block = ^{
        NSLog(@"%d", __LINE__);
    };

    obj.weakBlock = block;

    obj.weakBlock();

#endif
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

//    NSLog(@"%@", obj.assignObject); // Crash risk

    //    int *ptr = (int *)(assignObject);
    //    *ptr = 10;

//    [obj.assignObject log]; // Crash risk
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

    Release(myObject);
}

