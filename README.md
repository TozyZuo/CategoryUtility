# CategoryUtility

 --------- INTRODUCTION ---------
 
 Worked for both ARC and MRC. Support KVO. NOT support KVC, weak(id, block).

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
     @Property__nonatomic___strong__(    id    , idProperty);
     @Property__nonatomic____weak___(NSObject *, weakProperty);
     @property (nonatomic,  assign )    float    floatProperty;

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
     
# CategoryUtility WeakExtension

 --------- INTRODUCTION ---------

 Support weak(id, block). 
 
 Better performance. 
 
 ARC only.
