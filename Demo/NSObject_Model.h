//
//  NSObject_Model.h
//  Demo
//
//  Created by TozyZuo.
//

#import <Foundation/Foundation.h>
#import "MyObject.h"
#import "CategoryUtility.h"
/*
 *  remove '//' to turn on WeakExtension feature.
 */
//#import "CategoryUtility_WeakExtension.h"


typedef void (^MyBlock)();


typedef struct {
    char    a;
    int     b;
    float   c;
    char   *d;
} MyStruct;


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

#if defined(TZWeakExtension)
@Property_nonatomic__weak_(id, idObject);
@Property_nonatomic__weak_(MyBlock, weakBlock);
#endif

@end