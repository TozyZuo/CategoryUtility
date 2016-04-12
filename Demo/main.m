//
//  main.m
//  Demo
//
//  Created by TozyZuo.
//

#import <Foundation/Foundation.h>
#import "TestFunctions.h"

void TestPerformance()
{
    NSObject *obj = [[NSObject alloc] init];

    NSDate *date = [NSDate date];

    long long i = 0, max = 1 << 19;

    while (i++ < max) {
        if (i % 10000 == 0) {
            NSDate *now = [NSDate date];
            printf("%lld %f \n", i, [now timeIntervalSinceDate:date]);
            date = now;
        }
        @autoreleasepool {
            TestStrongProperty(obj);
            TestCopyProperty(obj);
            TestWeakProperty(obj);
            TestAssignProperty(obj);
            TestWeakExtensionProperty(obj);
            TestKVO(obj);
        }
    }
    printf("%lld", i);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
#if defined(TESTPERFORMANCE)
        TestPerformance();
#endif

        NSObject *obj = [[NSObject alloc] init];

        NSLog(@"obj %@", obj);

        TestStrongProperty(obj);
        TestCopyProperty(obj);
        TestWeakProperty(obj);
        TestAssignProperty(obj);
        TestWeakExtensionProperty(obj);
        TestKVO(obj);
    }
    return 0;
}

