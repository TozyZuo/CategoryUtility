//
//  NSObject_Model.m
//  Demo
//
//  Created by TozyZuo.
//

#import "NSObject_Model.h"

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

#if defined(TZWeakExtension)
@Synthesize_nonatomic__weak_(NSObject_Model, id, idObject);
@Synthesize_nonatomic__weak_(NSObject_Model, MyBlock, weakBlock);
#endif

@end
