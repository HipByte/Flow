#include "rubymotion.h"
#define CSS_LAYOUT_IMPLEMENTATION
#include "css_layout.h"

static double node_scale = 1.0;

static VALUE
node_set_scale(VALUE rcv, SEL sel, VALUE obj)
{
    node_scale = NUM2DBL(obj);
    assert(node_scale > 0);
    return obj;
}

static VALUE rb_cCSSNode = Qnil;

struct ruby_css_node {
    VALUE parent;
    css_node_t *node;
    VALUE children;
    bool dirty;
};

#define NODE(obj) ((struct ruby_css_node *)rb_class_wrap_get_ptr(obj))

static css_node_t *
node_get_child(void *context, int i)
{
    VALUE ary = ((struct ruby_css_node *)context)->children;
    assert(i >= 0 && i < RARRAY_LEN(ary));
    return NODE(RARRAY_AT(ary, i))->node;
}

static bool
node_is_dirty(void *context)
{
    return ((struct ruby_css_node *)context)->dirty;
}

static VALUE
node_alloc(VALUE rcv, SEL sel)
{
    struct ruby_css_node *node =
	(struct ruby_css_node *)malloc(sizeof(struct ruby_css_node));
    assert(node != NULL);
    node->parent = Qnil;
    node->node = new_css_node();
    assert(node->node != NULL);
    node->node->context = node;
    node->node->get_child = node_get_child;
    node->node->is_dirty = node_is_dirty;
    node->children = rb_retain(rb_ary_new());
    node->dirty = true;
    return rb_class_wrap_new(node, rcv);
}

#define define_property_float(name, expr) \
    static VALUE \
    node_##name##_get(VALUE rcv, SEL sel) \
    { \
	return DBL2NUM(NODE(rcv)->node->expr / node_scale); \
    } \
    static VALUE \
    node_##name##_set(VALUE rcv, SEL sel, VALUE value) \
    { \
	NODE(rcv)->node->expr = NUM2DBL(value) * node_scale; \
	return value; \
    }

define_property_float(flex, style.flex)

define_property_float(width, style.dimensions[CSS_WIDTH])
define_property_float(height, style.dimensions[CSS_HEIGHT])

define_property_float(left, style.position[CSS_LEFT])
define_property_float(right, style.position[CSS_RIGHT])
define_property_float(top, style.position[CSS_TOP])
define_property_float(bottom, style.position[CSS_BOTTOM])

#define define_property_float_6(name) \
    define_property_float(name##_left, style.name[CSS_LEFT]) \
    define_property_float(name##_right, style.name[CSS_RIGHT]) \
    define_property_float(name##_top, style.name[CSS_TOP]) \
    define_property_float(name##_bottom, style.name[CSS_BOTTOM]) \
    define_property_float(name##_start, style.name[CSS_START]) \
    define_property_float(name##_end, style.name[CSS_END]) \

define_property_float_6(padding)
define_property_float_6(margin)
define_property_float_6(border)

#undef define_property_float_6

#define define_property_float_ary(name) \
    static VALUE \
    node_##name##_set(VALUE rcv, SEL sel, VALUE obj) \
    { \
	css_node_t *node = NODE(rcv)->node; \
	float top, right, bottom, left; \
	if (rb_obj_is_kind_of(obj, rb_cArray)) { \
	    switch (RARRAY_LEN(obj)) { \
		case 4: \
		    top = NUM2DBL(RARRAY_AT(obj, 0)); \
		    right = NUM2DBL(RARRAY_AT(obj, 1)); \
		    bottom = NUM2DBL(RARRAY_AT(obj, 2)); \
		    left = NUM2DBL(RARRAY_AT(obj, 3)); \
		    break; \
		case 3: \
		    top = NUM2DBL(RARRAY_AT(obj, 0)); \
		    right = bottom = NUM2DBL(RARRAY_AT(obj, 1)); \
		    left = NUM2DBL(RARRAY_AT(obj, 2)); \
		    break; \
		case 2: \
		    top = bottom = NUM2DBL(RARRAY_AT(obj, 0)); \
		    right = left = NUM2DBL(RARRAY_AT(obj, 1)); \
		    break; \
		default: \
		    rb_raise(rb_eArgError, \
			    "expected Array of 2, 3 or 4 elements"); \
	    } \
	} \
	else { \
	    top = right = bottom = left = NUM2DBL(obj); \
	} \
	node->style.name[CSS_TOP] = top * node_scale; \
	node->style.name[CSS_RIGHT] = right * node_scale; \
	node->style.name[CSS_BOTTOM] = bottom * node_scale; \
	node->style.name[CSS_LEFT] = left * node_scale; \
	return obj; \
    } \
    static VALUE \
    node_##name##_get(VALUE rcv, SEL sel) \
    { \
	VALUE ary = rb_ary_new(); \
	css_node_t *node = NODE(rcv)->node; \
	rb_ary_push(ary, DBL2NUM(node->style.name[CSS_TOP] / node_scale)); \
	rb_ary_push(ary, DBL2NUM(node->style.name[CSS_RIGHT] / node_scale)); \
	rb_ary_push(ary, DBL2NUM(node->style.name[CSS_BOTTOM] / node_scale)); \
	rb_ary_push(ary, DBL2NUM(node->style.name[CSS_LEFT] / node_scale)); \
	return ary; \
    }

define_property_float_ary(padding)
define_property_float_ary(margin)
define_property_float_ary(border)

#undef define_property_float_ary

#define define_property_sym(name, count) \
    static VALUE node_##name##s[count] = { Qnil } ; \
    static VALUE \
    node_##name##_get(VALUE rcv, SEL sel) \
    { \
        int value = NODE(rcv)->node->style.name; \
	if (value >= count) { \
	    rb_raise(rb_eArgError, "incorrect value for %s", #name); \
	} \
        return node_##name##s[value]; \
    } \
    static VALUE \
    node_##name##_set(VALUE rcv, SEL sel, VALUE value) \
    { \
	struct ruby_css_node *node = NODE(rcv); \
        for (int i = 0; i < count; i++) { \
	    if (node_##name##s[i] == value) { \
		(*(int *)&node->node->style.name) = i; \
		return value; \
	    } \
	} \
	rb_raise(rb_eArgError, "incorrect value for %s", #name); \
    }

define_property_sym(direction, 3)
define_property_sym(flex_direction, 4)
define_property_sym(justify_content, 5)
define_property_sym(align_content, 5)
define_property_sym(align_items, 5)
define_property_sym(align_self, 5)
define_property_sym(position_type, 2)
define_property_sym(flex_wrap, 2)

#undef define_property_sym

static VALUE
node_add_child(VALUE rcv, SEL sel, VALUE child)
{
    struct ruby_css_node *node = NODE(rcv);
    rb_ary_push(node->children, child);
    node->node->children_count++;
    NODE(child)->parent = rcv; // weak
    return child;
}

static VALUE
node_delete_child(VALUE rcv, SEL sel, VALUE child)
{
    struct ruby_css_node *node = NODE(rcv);
    if (rb_ary_delete(node->children, child) != Qnil) {
	node->node->children_count--;
	NODE(child)->parent = Qnil;
	return child;
    }	
    return Qnil;
}

static VALUE
node_children(VALUE rcv, SEL sel)
{
    return NODE(rcv)->children;
}

static VALUE
node_parent(VALUE rcv, SEL sel)
{
    return NODE(rcv)->parent;
}

static VALUE
node_root(VALUE rcv, SEL sel)
{
    VALUE node = rcv;
    while (true) {
	VALUE parent = NODE(node)->parent;
	if (parent == Qnil) {
	    break;
	}
	node = parent;
    }
    return node;
}

static VALUE
node_dirty(VALUE rcv, SEL sel)
{
    NODE(rcv)->dirty = true;
    return Qnil;
}

static void
reset_layout(css_node_t *node)
{
    node->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
    node->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
    node->layout.position[CSS_LEFT] = 0;
    node->layout.position[CSS_TOP] = 0;
    for (int i = 0; i < node->children_count; i++) {
	reset_layout(node->get_child(node->context, i));
    }
}

static VALUE
node_update_layout(VALUE rcv, SEL sel, int argc, VALUE *argv)
{
    VALUE max_width = Qnil, max_height = Qnil;
    rb_scan_args(argc, argv, "02", &max_width, &max_height);

    struct ruby_css_node *node = NODE(rcv);
    reset_layout(node->node);
    layoutNode(node->node,
	    max_width == Qnil ? CSS_UNDEFINED : NUM2DBL(max_width),
	    max_height == Qnil ? CSS_UNDEFINED : NUM2DBL(max_height),
	    CSS_DIRECTION_INHERIT);
    return Qnil;
}

static VALUE
node_layout(VALUE rcv, SEL sel)
{
    css_node_t *node = NODE(rcv)->node;
    VALUE ary = rb_ary_new();
    rb_ary_push(ary, DBL2NUM(node->layout.position[CSS_LEFT]));
    rb_ary_push(ary, DBL2NUM(node->layout.position[CSS_TOP]));
    rb_ary_push(ary, DBL2NUM(node->layout.dimensions[CSS_WIDTH]));
    rb_ary_push(ary, DBL2NUM(node->layout.dimensions[CSS_HEIGHT]));
    return ary;
}

#if defined(__cplusplus)
extern "C"
#endif
void
Init_CSSNode(void)
{
    rb_cCSSNode = rb_define_class("CSSNode", rb_cObject);

    rb_define_singleton_method(rb_cCSSNode, "set_scale", node_set_scale, 1);
    rb_define_singleton_method(rb_cCSSNode, "alloc", node_alloc, 0);

#define declare_property(name) \
    rb_define_method(rb_cCSSNode, #name, node_##name##_get, 0); \
    rb_define_method(rb_cCSSNode, #name "=", node_##name##_set, 1);

    declare_property(flex)

    declare_property(width)
    declare_property(height)

    declare_property(left)
    declare_property(right)
    declare_property(top)
    declare_property(bottom)

#define declare_property_6(name) \
    declare_property(name##_left) \
    declare_property(name##_right) \
    declare_property(name##_top) \
    declare_property(name##_bottom) \
    declare_property(name##_start) \
    declare_property(name##_end)

    declare_property(padding)
    declare_property(margin)
    declare_property(border)
    declare_property_6(padding)
    declare_property_6(margin)
    declare_property_6(border)

#undef declare_property_6

#define declare_property_sym(name, ...) \
    do { \
	const char *value_name[] = { __VA_ARGS__ }; \
	const size_t value_size = sizeof(value_name) / sizeof(const char *); \
	assert(value_size == sizeof(node_##name##s) / sizeof(VALUE)); \
	for (int i = 0; i < value_size; i++) { \
	    node_##name##s[i] = rb_name2sym(value_name[i]); \
	} \
    } \
    while (0); \
    declare_property(name)

    declare_property_sym(direction, "inherit", "ltr", "rtl")
    declare_property_sym(flex_direction, "column", "column_reverse", "row",
	    "row_reverse")
    declare_property_sym(justify_content, "flex_start", "center", "flex_end",
	    "space_between", "space_around")
    declare_property_sym(align_content, "auto", "flex_start", "center",
	    "flex_end", "stretch")
    declare_property_sym(align_items, "auto", "flex_start", "center",
	    "flex_end", "stretch")
    declare_property_sym(align_self, "auto", "flex_start", "center",
	    "flex_end", "stretch")
    declare_property_sym(position_type, "relative", "absolute")
    declare_property_sym(flex_wrap, "no_wrap", "wrap")

#undef declare_property_sym
#undef declare_property

    rb_define_method(rb_cCSSNode, "add_child", node_add_child, 1);
    rb_define_method(rb_cCSSNode, "delete_child", node_delete_child, 1);
    rb_define_method(rb_cCSSNode, "children", node_children, 0);
    rb_define_method(rb_cCSSNode, "parent", node_parent, 0);
    rb_define_method(rb_cCSSNode, "root", node_root, 0);
    rb_define_method(rb_cCSSNode, "dirty!", node_dirty, 0);
    rb_define_method(rb_cCSSNode, "update_layout", node_update_layout, -1);
    rb_define_method(rb_cCSSNode, "layout", node_layout, 0);
}
