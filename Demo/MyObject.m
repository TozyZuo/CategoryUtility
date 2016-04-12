//
//  MyObject.m
//  Demo
//
//  Created by TozyZuo.
//

#import "MyObject.h"

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
