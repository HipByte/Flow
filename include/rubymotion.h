#ifndef __RUBYMOTION_H_
#define __RUBYMOTION_H_

#include <assert.h>
#include <stdlib.h>

#if defined(__cplusplus)
extern "C" {
#endif

#define VALUE		unsigned long
#define SIGNED_VALUE	long
#define ID		unsigned long

#define Qfalse  0x0
#define Qtrue   0x2
#define Qnil    0x4
#define Qundef  0x6

#if CC_TARGET_OS_IPHONE || CC_TARGET_OS_APPLETV

#include <objc/runtime.h>

long rb_ary_len(VALUE);
VALUE rb_ary_elt(VALUE, long);
#define RARRAY_LEN(a) (rb_ary_len((VALUE)a))
#define RARRAY_AT(a,i) (rb_ary_elt((VALUE)a, (long)i))

double rb_num2dbl(VALUE);
VALUE rb_float_new(double);
#define NUM2DBL(x) rb_num2dbl((VALUE)(x))
#define DBL2NUM(x) rb_float_new(x)

#define FIXNUM_FLAG	0x01
#define IMMEDIATE_MASK	0x03
#define FIXNUM_P(f) ((((SIGNED_VALUE)(f)) & IMMEDIATE_MASK) == FIXNUM_FLAG)
long rb_num2long(VALUE);
#define FIX2LONG(x) (x >> 2)
#define NUM2LONG(x) (FIXNUM_P(x) ? FIX2LONG(x) : rb_num2long((VALUE)x))
VALUE rb_uint2big(VALUE);
#define LONG2FIX(i) ((VALUE)(((SIGNED_VALUE)(i))<<2 | FIXNUM_FLAG))
#define FIXNUM_MAX (LONG_MAX>>2)
#define POSFIXABLE(f) (((VALUE)f) < FIXNUM_MAX+1)
#define INT2NUM(x) (POSFIXABLE(x) ? LONG2FIX(x) : rb_uint2big(x))
#define LONG2NUM(x) INT2NUM(x)
long rb_num2int(VALUE);
#define FIX2INT(x) ((int)FIX2LONG(x))
#define NUM2INT(x) (FIXNUM_P(x) ? FIX2INT(x) : rb_num2int((VALUE)x))

const char *rb_str_cstr(VALUE);
#define RSTRING_PTR(str) (rb_str_cstr((VALUE)str))

VALUE rb_obj_is_kind_of(VALUE, VALUE);

void rb_objc_define_method(VALUE klass, const char *name, void *imp,
	const int arity);
#define rb_define_method(klass, name, imp, arity) \
    rb_objc_define_method(klass, name, (void *)imp, arity)

#define RB_GET_CLASS(obj) (VALUE)object_getClass((id)obj)
#define rb_define_singleton_method(klass, name, imp, arity) \
    rb_define_method(RB_GET_CLASS(klass), name, imp, arity)

VALUE rb_define_module(const char *);
VALUE rb_define_module_under(VALUE, const char *);

#define rb_selector(str) sel_registerName(str)

VALUE rb_vm_call_s(VALUE self, SEL sel, int argc, const VALUE *argv);
#define rb_send(rcv, sel, argc, argv) rb_vm_call_s(rcv, sel, argc, argv)

struct rb_class_ptr {
    VALUE klass;
    VALUE flags;
    void *ptr;
};

static inline
VALUE
rb_class_wrap_new(void *ptr, VALUE klass)
{
#define T_NATIVE 0x16
    struct rb_class_ptr *obj =
	(struct rb_class_ptr *)class_createInstance((Class)klass,
		sizeof(struct rb_class_ptr));
    assert(obj != NULL);
    obj->klass = klass;
    obj->flags = T_NATIVE;
    obj->ptr = ptr;
    return (VALUE)obj;
}

#define rb_class_wrap_get_ptr(obj) \
    ((struct rb_class_ptr *)obj)->ptr

void *rb_objc_retain(void *addr);
#define rb_retain(obj) \
    ({ \
	VALUE _obj = (VALUE)obj; \
	rb_objc_retain((void *)_obj); \
	_obj; \
    })

void *rb_objc_release(void *addr);
#define rb_release(obj) \
    ({ \
	VALUE _obj = (VALUE)obj; \
	rb_objc_release((void *)_obj); \
	_obj; \
    })

#define rb_weak(obj) obj

void *rb_vm_current_block(void);
#define rb_current_block() \
    ({ \
	VALUE _b = (VALUE)rb_vm_current_block(); \
	_b == 0 ? Qnil : _b; \
    })

VALUE rb_vm_block_eval(void *block, int argc, const VALUE *argv);
#define rb_block_call(block, argc, argv) \
    rb_vm_block_eval((void *)block, argc, argv)

VALUE rb_define_class(const char*,VALUE);
VALUE rb_define_class_under(VALUE, const char*, VALUE);

const char *rb_sym2name(VALUE sym);

#elif CC_TARGET_OS_ANDROID

#include <jni.h>

#define VM_FIXNUM_ENABLED	1
#define VM_FIXNUM_MASK	((unsigned long)0xdead0000)
#define VM_FIXNUM_MAX	0xffff

#if VM_FIXNUM_ENABLED
#  define VM_FIXNUM_P(val) \
    ({ \
	VALUE _val = (VALUE)val; \
	((_val & VM_FIXNUM_MASK) == VM_FIXNUM_MASK) && (_val ^ VM_FIXNUM_MASK) >= 0 && (_val ^ VM_FIXNUM_MASK) <= VM_FIXNUM_MAX; \
    })
#else
#  define VM_FIXNUM_P(val) false
#endif

JNIEnv *rb_vm_current_jni_env(void);
#define VM_JNI_ENV() rb_vm_current_jni_env()
JavaVM *rb_vm_java_vm(void);
#define VM_JAVA_VM() rb_vm_java_vm()

#define SPECIAL_CONST_P(ref) \
    ({ \
	VALUE _ref = (VALUE)ref; \
	_ref <= 6 || VM_FIXNUM_P(_ref); \
    })

#define _VM_GLOBAL(ref) VM_JNI_ENV()->NewGlobalRef(ref)
static inline jobject
vm_global(jobject ref)
{
    if (!SPECIAL_CONST_P(ref)) {
        return _VM_GLOBAL(ref);
    }
    return ref;
}

#define _VM_GLOBAL_DELETE(ref) VM_JNI_ENV()->DeleteGlobalRef(ref)
static inline void
vm_global_delete(jobject ref)
{
    if (!SPECIAL_CONST_P(ref)) {
        _VM_GLOBAL_DELETE(ref);
    }
}

#define _VM_LOCAL(ref) VM_JNI_ENV()->NewLocalRef(ref)
static inline jobject
vm_local(jobject ref)
{
    if (!SPECIAL_CONST_P(ref)) {
        return _VM_LOCAL(ref);
    }
    return ref;
}

#define _VM_WEAK(ref) VM_JNI_ENV()->NewWeakGlobalRef(ref)
static inline jobject
vm_weak(jobject ref)
{
    if (!SPECIAL_CONST_P(ref)) {
        return _VM_WEAK(ref);
    }
    return ref;
}

#define rb_retain(obj) (VALUE)vm_global((jobject)obj)
#define rb_release(obj) \
    ({ \
	VALUE _obj = obj; \
	VALUE _local = VM_LOCAL(_obj); \
	VM_GLOBAL_DELETE(_obj); \
	_local; \
    })
#define rb_weak(obj) (VALUE)vm_weak((jobject)obj)

#define IMP void *
#define SEL const char *
SEL sel_registerName(const char *name);
ID rb_intern(const char *name);

extern jobject vm_jobject_true;
extern jobject vm_jobject_false;

jdouble rb_vm_jobject_to_jdouble(jobject obj);
jobject rb_vm_jdouble_to_jobject(jdouble value);
jint rb_vm_jobject_to_jint(jobject obj);
jobject rb_vm_jint_to_jobject(jint value);

static inline jobject
vm_rb2jv(VALUE obj)
{
    if (obj == Qtrue) {
        return vm_jobject_true;
    }
    if (obj == Qfalse) {
        return vm_jobject_false;
    }
    if (obj == Qnil) {
        return NULL;
    }
#if VM_FIXNUM_ENABLED
    if ((obj & VM_FIXNUM_MASK) == VM_FIXNUM_MASK) {
	long value = obj ^ VM_FIXNUM_MASK;
	if (value >= 0 && value <= VM_FIXNUM_MAX) {
	    return rb_vm_jint_to_jobject(value);
	}
    }
#endif
    return (jobject)obj;
}
#define RB2JV(obj) vm_rb2jv((VALUE)obj)

#define NUM2DBL(x) rb_vm_jobject_to_jdouble(RB2JV(x))
#define DBL2NUM(x) (VALUE)(rb_vm_jdouble_to_jobject(x))

#define NUM2INT(x) rb_vm_jobject_to_jint(RB2JV(x))
#define NUM2LONG(x) (long)(rb_vm_jobject_to_jint(RB2JV(x)))
#define LONG2NUM(x) (VALUE)(rb_vm_jint_to_jobject(x))

bool rb_vm_kind_of(VALUE obj, VALUE klass);
#define rb_obj_is_kind_of(obj, klass) rb_vm_kind_of(obj, (VALUE)klass)

#define rb_selector(str) sel_registerName(str)

VALUE rb_vm_dispatch(VALUE rcv, SEL sel, void *block, int mode, int argc,
        VALUE *argv);
#define rb_send(rcv, sel, argc, argv) \
    rb_vm_dispatch(rcv, sel, NULL, 0, argc, argv)

void rb_define_method(jclass klass, const char *name, int arity, IMP imp);
#define rb_define_method(klass, name, imp, arity) \
    rb_define_method((jclass)klass, name, arity, (IMP)imp)

void rb_define_static_method(jclass klass, const char *name, int argc,
        IMP imp);
#define rb_define_singleton_method(klass, name, imp, arity) \
    rb_define_static_method((jclass)klass, name, arity, (IMP)imp)

jclass rb_define_module_under(jclass outer, const char *name);
#define rb_define_module_under(mod, name) \
    (VALUE)rb_define_module_under((jclass)mod, name)
#define rb_define_module(name) \
    (VALUE)rb_define_module_under(rb_cObject, name)

jclass rb_vm_define_ruby_class(const char *path, VALUE super, VALUE outer);
#define rb_define_class_under(module, name, super) \
    rb_retain(rb_vm_define_ruby_class(name, (VALUE)super, (VALUE)module))

#define rb_define_class(name, super) \
    rb_define_class_under(rb_cObject, name, super)

VALUE rb_object_new(jclass klass, void *ptr);
#define rb_class_wrap_new(ptr, klass) rb_object_new((jclass)klass, ptr)

void *rb_object_ptr(VALUE obj);
#define rb_class_wrap_get_ptr(obj) rb_object_ptr(obj)

const char *rb_str_to_cstr(VALUE obj);
#define RSTRING_PTR(str) rb_str_to_cstr(str)

VALUE rb_vm_current_block_object(void);
#define rb_current_block() rb_vm_current_block_object()

void *rb_proc_wrapper_get_block(VALUE obj);
VALUE rb_vm_block_dispatch2(void *block, VALUE self, int argc,
        VALUE *argv);
#define rb_block_call(block, argc, argv) \
    rb_vm_block_dispatch2(rb_proc_wrapper_get_block(block), Qundef, argc, argv)

int rb_ary_len(VALUE ary);
#define RARRAY_LEN(obj) rb_ary_len((VALUE)obj)

VALUE rb_ary_at(VALUE ary, int pos);
#define RARRAY_AT(obj, i) rb_ary_at((VALUE)obj, (int)i)

VALUE rb_vm_get_const(VALUE outer, ID path, bool lexical_lookup,
        bool defined, void *outer_stack);
#define rb_const_get(_outer, _path) \
    rb_vm_get_const((VALUE)_outer, rb_intern(_path), false, false, NULL)

void rb_vm_raise(VALUE) __attribute__ ((noreturn));
#define JAVA_EXC_RETHROW() \
    do { \
        JNIEnv *__env = VM_JNI_ENV(); \
        jthrowable exc = __env->ExceptionOccurred(); \
        if (exc != NULL) { \
            __env->ExceptionClear(); \
            rb_vm_raise((VALUE)exc); \
        } \
    } \
    while (0)

class Frame {
    public:
        bool cleaned;
        Frame(void) {
            if (VM_JNI_ENV()->PushLocalFrame(32) < 0) {
                // An error happened (probably java.lang.OutOfMemoryError).
                cleaned = true;
                JAVA_EXC_RETHROW();
            }
            else {
                cleaned = false;
            }
        }
        ~Frame() {
            if (!cleaned) {
                VM_JNI_ENV()->PopLocalFrame(NULL);
            }
        }
        void clear(void) {
            cleaned = true;
        }
        VALUE pop_retval(VALUE retval) {
            clear();
	    if (SPECIAL_CONST_P(retval)) {
		VM_JNI_ENV()->PopLocalFrame(NULL);
		return retval;
	    }
	    else {
		return (VALUE)VM_JNI_ENV()->PopLocalFrame((jobject)retval);
	    }
        }
};

SEL rb_sym_to_sel(VALUE sym);
#define rb_sym2name(sym) (const char *)rb_sym_to_sel(sym)

#endif

extern VALUE rb_cArray;
extern VALUE rb_cSymbol;
extern VALUE rb_cObject;
extern VALUE rb_cInteger;
extern VALUE rb_eArgError;
extern VALUE rb_eRuntimeError;

void rb_raise(VALUE exc, const char *fmt, ...) __attribute__ ((noreturn));
int rb_scan_args(int, const VALUE*, const char*, ...);
VALUE rb_ary_new(void);
VALUE rb_ary_push(VALUE, VALUE);
VALUE rb_ary_delete(VALUE ary, VALUE item);
VALUE rb_name2sym(const char *);

#define RTEST(obj) \
    ({ \
        VALUE _rtest_obj = (VALUE)obj; \
        _rtest_obj != Qfalse && _rtest_obj != Qnil; \
    })

VALUE rb_str_new2(const char *);
#define RSTRING_NEW(cstr) rb_str_new2(cstr)

#if defined(__cplusplus)
}
#endif

#endif // __RUBYMOTION_H_
