//
//  CategoryUtility.h
//
//  Created by TozyZuo.
//  Copyright © 2014年 TozyZuo. All rights reserved.
//


/*
 *************************************************************************

 --------- INTRODUCTION ---------
 
 Worked for both ARC and MRC.

 USAGE:

 MODE 1. Directly used.

     @interface NSObject (MyCategory)

     @Property_nonatomic_strong(NSObject *, strongProperty);
     @Property_nonatomic__copy_(NSObject *, copyProperty);
     @Property_nonatomic__copy_( MyBlock  , block);
     @Property_nonatomic__weak_(NSObject *, weakProperty);
     @Property_nonatomic_assign(   int    , intProperty);
     @Property_nonatomic_assign(  CGRect  , rectProperty);
     @Property_nonatomic_assign( MyStruct , structProperty);
     @Property_nonatomic_assign(  char *  , strProperty);
     @Property_nonatomic_assign(NSObject *, assignObject);

     @end

     @implementation NSObject (MyCategory)

     @Synthesize_nonatomic_strong(NSObject_MyCategory, NSObject *, strongProperty);
     @Synthesize_nonatomic__copy_(NSObject_MyCategory, NSObject *, copyProperty);
     @Synthesize_nonatomic__copy_(NSObject_MyCategory,  MyBlock  , block);
     @Synthesize_nonatomic__weak_(NSObject_MyCategory, NSObject *, weakProperty);
     @Synthesize_nonatomic_assign(NSObject_MyCategory,    int    , intProperty);
     @Synthesize_nonatomic_assign(NSObject_MyCategory,   CGRect  , rectProperty);
     @Synthesize_nonatomic_assign(NSObject_MyCategory,  MyStruct , structProperty);
     @Synthesize_nonatomic_assign(NSObject_MyCategory,   char *  , strProperty);

     @Synthesize_nonatomic_assign_object(NSObject_MyCategory, NSObject *, assignObject);
     
     @end


 MODE 2. Mixed used.

     @interface NSString (MyCategory)

     @property (nonatomic, readonly) NSString *  encryptedString;
     @Property__nonatomic___strong__(id,         idProperty);
     @Property__nonatomic____weak___(NSObject *, weakProperty);
     @property (nonatomic,  assign ) float       floatProperty;

     @end

     @implementation NSString (MyCategory)

     @Synthesize_nonatomic_strong(NSString_MyCategory,    id     , idProperty);
     @Synthesize_nonatomic__weak_(NSString_MyCategory, NSObject *, weakProperty);

     - (NSString *)encryptedString
     {
        return self;
     }

     - (float)floatProperty
     {
        return 0;
     }

     - (void)setFloatProperty:(float)floatProperty
     {
        // Do nothing, just demo.
     }

     @end

 *************************************************************************
 */


#import <Foundation/Foundation.h>
#import <objc/runtime.h>


#if __has_feature(objc_arc)
#define TZWEAK_DEFINITION   weak
#define TZWEAK_KEYWORD      __weak
#define TZRelease(obj)      /*!!! do nothing */
#else
#define TZWEAK_DEFINITION   assign
#define TZWEAK_KEYWORD      __unsafe_unretained
#define TZRelease(obj)      [(obj) release]
#endif


/*
    @param prefix
 
    Preventing different category from generating the same set method, resulting in call confusion
 */


/*
 Property_nonatomic_strong
 
 @alias Property__nonatomic__strong_    Used for 'strong' and 'assign' alignment
        Property__nonatomic___strong__  Used for       'readonly'      alignment
 */
#define Property_nonatomic_strong(varType, varName)\
        property (nonatomic, strong, setter = set##varName:) varType varName

#define Property__nonatomic__strong_(varType, varName)\
        Property_nonatomic_strong(varType, varName)

#define Property__nonatomic___strong__(varType, varName)\
        Property_nonatomic_strong(varType, varName)
/*
 Synthesize_nonatomic_strong
 */
#define Synthesize_nonatomic_strong(prefix, varType, varName)\
class NSObject;\
void *prefix##varName##Key = &prefix##varName##Key;\
- (varType)varName\
{\
    return objc_getAssociatedObject(self, prefix##varName##Key);\
}\
- (void)set##varName:(varType)varName\
{\
    objc_setAssociatedObject(self, prefix##varName##Key, varName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}


/*
 Property_nonatomic_copy

 @alias Property_nonatomic__copy_       Used for 'Property_nonatomic_strong' and
                                           'Property_nonatomic_assign' alignment
        Property__nonatomic__copy_      Used for  'copy'  and  'weak'  alignment
        Property__nonatomic___copy__    Used for 'strong' and 'assign' alignment
        Property__nonatomic____copy___  Used for       'readonly'      alignment
 */
#define Property_nonatomic_copy(varType, varName)\
        property (nonatomic, copy, setter = set##varName:) varType varName

#define Property_nonatomic__copy_(varType, varName)\
        Property_nonatomic_copy(varType, varName)

#define Property__nonatomic__copy_(varType, varName)\
        Property_nonatomic_copy(varType, varName)

#define Property__nonatomic___copy__(varType, varName)\
        Property_nonatomic_copy(varType, varName)

#define Property__nonatomic____copy___(varType, varName)\
        Property_nonatomic_copy(varType, varName)
/*
 Synthesize_nonatomic_copy

 @alias Synthesize_nonatomic__copy_     Used for 'Synthesize_nonatomic_strong' and
                                        'Synthesize_nonatomic_assign' alignment
 */
#define Synthesize_nonatomic_copy(prefix, varType, varName)\
class NSObject;\
void *prefix##varName##Key = &prefix##varName##Key;\
- (varType)varName\
{\
    return objc_getAssociatedObject(self, prefix##varName##Key);\
}\
- (void)set##varName:(varType)varName\
{\
    if (varName && ![varName respondsToSelector:@selector(copy)]) {\
        NSLog(@"-[%@ copy] need to be implemented.", [varName class]);\
        return;\
    }\
    if (varName && ![varName respondsToSelector:@selector(copyWithZone:)]) {\
        NSLog(@"-[%@ copyWithZone:] need to be implemented.", [varName class]);\
        return;\
    }\
    objc_setAssociatedObject(self, prefix##varName##Key, [varName copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

#define Synthesize_nonatomic__copy_(prefix, varType, varName)\
        Synthesize_nonatomic_copy(prefix, varType, varName)


/*
 *                             own
 *       object(master) → → → → → → → → → object(slave)
 *                     ↖                 ↙
 *                       ↖             ↙
 *                 observe ↖         ↙ own
 *               (reference) ↖     ↙
 *                             ↖ ↙
 *                           observer
 *
 *
 *  [slave dealloc] → [observer dealloc] → master.slaveProperty = nil .
 */
/*
 Property_nonatomic_weak
 
 @alias Property_nonatomic__weak_       Used for 'Property_nonatomic_strong' and
                                           'Property_nonatomic_assign' alignment
        Property__nonatomic__weak_      Used for  'copy'  and  'weak'  alignment
        Property__nonatomic___weak__    Used for 'strong' and 'assign' alignment
        Property__nonatomic____weak___  Used for       'readonly'      alignment
 */
#define Property_nonatomic_weak(varType, varName)\
        property (nonatomic, TZWEAK_DEFINITION, setter = set##varName:) varType varName

#define Property_nonatomic__weak_(varType, varName)\
        Property_nonatomic_weak(varType, varName)

#define Property__nonatomic__weak_(varType, varName)\
        Property_nonatomic_weak(varType, varName)

#define Property__nonatomic___weak__(varType, varName)\
        Property_nonatomic_weak(varType, varName)

#define Property__nonatomic____weak___(varType, varName)\
        Property_nonatomic_weak(varType, varName)

@interface TZObserver: NSObject
@property (nonatomic, strong) NSMapTable<NSObject *, NSMutableArray *> *objectOwners;
@property (nonatomic, strong) NSHashTable<TZObserver *> *observers;
@property (nonatomic, assign) NSObject *owner;
//@Property__nonatomic__weak_(NSObject *, objectOwner);
//@property (nonatomic, copy) void (^deallocBlock)();
@end

@interface NSObject (TZObserver)
@Property_nonatomic_strong(TZObserver *, ownersObserver);
@Property_nonatomic_strong(TZObserver *, observersObserver);
//@Property_nonatomic_strong(NSMutableArray *, observerList);
@end

/*
 Synthesize_nonatomic_weak

 @alias Synthesize_nonatomic__weak_     Used for 'Synthesize_nonatomic_strong' and
                                            'Synthesize_nonatomic_assign' alignment
 */
#define Synthesize_nonatomic_weak(prefix, varType, varName)\
class NSObject;\
void *prefix##varName##Key = &prefix##varName##Key;\
- (varType)varName\
{\
    return objc_getAssociatedObject(self, prefix##varName##Key);\
}\
- (void)set##varName:(varType)varName\
{\
    NSObject *var = self.varName;\
    if (![var isEqual:varName]) {\
        /* remove old var's observation. */\
        NSString *propertyKey = [NSString stringWithUTF8String:#varName];\
        [[var.ownersObserver.objectOwners objectForKey:self] removeObject:propertyKey];\
        /* It's 'weak'. No need to release var. */\
        if (varName) {\
            /* object -> observer -> owner */\
            TZObserver *ownersObserver = varName.ownersObserver;\
            if (!ownersObserver) {\
                ownersObserver = [[TZObserver alloc] init];\
                varName.ownersObserver = ownersObserver;\
                TZRelease(ownersObserver);\
            }\
            NSMutableArray *observeProperties = [ownersObserver.objectOwners objectForKey:self];\
            if (!observeProperties) {\
                observeProperties = [[NSMutableArray alloc] init];\
                [ownersObserver.objectOwners setObject:observeProperties forKey:self];\
                TZRelease(observeProperties);\
            }\
            NSAssert(![observeProperties containsObject:propertyKey], @"Shouldn't crash");\
            [observeProperties addObject:propertyKey];\
            /* owner -> observer -> object */\
            TZObserver *observersObserver = self.observersObserver;\
            if (!observersObserver) {\
                observersObserver = [[TZObserver alloc] init];\
                observersObserver.owner = self;\
                self.observersObserver = observersObserver;\
                TZRelease(observersObserver);\
            }\
            if (![observersObserver.observers containsObject:ownersObserver]) {\
                [observersObserver.observers addObject:ownersObserver];\
            }\
        }\
        objc_setAssociatedObject(self, prefix##varName##Key, varName, OBJC_ASSOCIATION_ASSIGN);\
    }\
}

#define Synthesize_nonatomic__weak_(prefix, varType, varName)\
        Synthesize_nonatomic_weak(prefix, varType, varName)


/*!
 Property_nonatomic_assign

 @warning Used for base type (int, BOOL, CGPoint, ...)

 @alias Property__nonatomic__assign_    Used for 'strong' and 'assign' alignment
        Property__nonatomic___assign__  Used for       'readonly'      alignment
 */
#define Property_nonatomic_assign(varType, varName)\
        property (nonatomic, assign, setter = set##varName:) varType varName

#define Property__nonatomic__assign_(varType, varName)\
        Property_nonatomic_assign(varType, varName)

#define Property__nonatomic__assign_(varType, varName)\
        Property_nonatomic_assign(varType, varName)
/*!
 Synthesize_nonatomic_assign

 @warning   It could be used for an object of MRC. ARC is not supported. Strongly
            recommended using 'Synthesize_nonatomic_weak' for an object instead.

 @see       Synthesize_nonatomic_assign_object,
            Synthesize_nonatomic_weak
 */
#define Synthesize_nonatomic_assign(prefix, varType, varName)\
class NSObject;\
void *prefix##varName##Key = &prefix##varName##Key;\
- (varType)varName\
{\
    NSData *data = objc_getAssociatedObject(self, prefix##varName##Key);\
    const void *retPtr = data.bytes;\
    if (!retPtr) {\
        varType ret;\
        memset(&ret, 0, sizeof(varType));\
        return ret;\
    }\
    return (*(varType *)retPtr);\
}\
- (void)set##varName:(varType)varName\
{\
    NSData *data = [[NSData alloc] initWithBytes:&varName length:sizeof(varType)];\
    objc_setAssociatedObject(self, prefix##varName##Key, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
    TZRelease(data);\
}

#define Synthesize_nonatomic_assign_object_arc(prefix, varType, varName)\
class NSObject;\
void *prefix##varName##Key = &prefix##varName##Key;\
- (varType)varName\
{\
    NSData *data = objc_getAssociatedObject(self, prefix##varName##Key);\
    const void *retPtr = data.bytes;\
    if (!retPtr) {\
        varType ret;\
        memset(&ret, 0, sizeof(varType));\
        return ret;\
    }\
    return (*(varType __unsafe_unretained *)retPtr);\
}\
- (void)set##varName:(varType)varName\
{\
    NSData *data = [[NSData alloc] initWithBytes:&varName length:sizeof(varType)];\
    objc_setAssociatedObject(self, prefix##varName##Key, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
    TZRelease(data);\
}

/*!
 Synthesize_nonatomic_assign_object

 Used for an object, MRC and ARC are both supported. Strongly recommended using 'Synthesize_nonatomic_weak' instead.
 */
#if __has_feature(objc_arc)
#define Synthesize_nonatomic_assign_object Synthesize_nonatomic_assign_object_arc
#else
#define Synthesize_nonatomic_assign_object Synthesize_nonatomic_assign
#endif