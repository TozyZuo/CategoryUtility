//
//  NSObject_Demo.h
//  Demo
//
//  Created by TozyZuo.
//

#import <Foundation/Foundation.h>


@interface NSObject (Demo)

//@Property_nonatomic_strong(NSObject *, strongProperty);
@property (nonatomic, strong, setter = setstrongProperty:) NSObject *strongProperty;

//@Property_nonatomic_copy(NSObject *, copyProperty);
@property (nonatomic, copy, setter = setcopyProperty:) NSObject *copyProperty;

//@Property_nonatomic_weak(NSObject *, weakProperty);
@property (nonatomic, weak, setter = setweakProperty:) NSObject *weakProperty;

//@Property_nonatomic_assign(int, assignProperty);
@property (nonatomic, assign, setter = setassignProperty:) int assignProperty;

@end