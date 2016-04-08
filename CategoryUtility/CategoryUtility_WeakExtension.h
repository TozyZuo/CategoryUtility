//
//  CategoryUtility_WeakExtension.h
//
//  Created by TozyZuo.
//  Copyright © 2014年 TozyZuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryUtility.h"


#define TZWeakExtension

/*
 *                 own                 reference
 * object(master) → → → WeakContainer → → → → → → object(slave)
 *
 *                                                                    return
 *  [slave dealloc] → WeakContainer.slave = nil → master.slaveProperty → → → nil .
 *
 */


@interface TZWeakContainer : NSObject
@property (nonatomic, weak) NSObject *object;
@end


#ifdef Synthesize_nonatomic_weak
#undef Synthesize_nonatomic_weak
#endif


#define Synthesize_nonatomic_weak(prefix, varType, varName)\
class NSObject;\
void *prefix##varName##Key = &prefix##varName##Key;\
- (varType)varName\
{\
    TZWeakContainer *weakContainer = objc_getAssociatedObject(self, prefix##varName##Key);\
    varType ret;\
/* ARC will add an 'autorelease''s retain count, so we add an autoreleasepool. */\
/* Actually it's "weakContainer.object.retain.autorelease" */\
    @autoreleasepool {\
        ret = weakContainer.object;\
    }\
    return ret;\
}\
- (void)set##varName:(varType)varName\
{\
    NSObject * var = self.varName;\
    if (![var isEqual:varName]) {\
        TZWeakContainer *weakContainer = objc_getAssociatedObject(self, prefix##varName##Key);\
        if (!weakContainer) {\
            weakContainer = [[TZWeakContainer alloc] init];\
            objc_setAssociatedObject(self, prefix##varName##Key, weakContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
        }\
        weakContainer.object = varName;\
    }\
}

