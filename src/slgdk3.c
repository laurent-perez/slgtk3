/* -*- mode: C; mode: fold; -*- */

/* This file is part of
 *
 * 	SLgtk3 : S-Lang bindings for GTK3 widget set
 *
 * Copyright (C) 2020-2023 Laurent Perez <laurent.perez@unicaen.fr>
 * 
 * SLgtk3 is based on SLgtk : S-Lang bindings for GTK2
 * Large parts of SLgtk3 code have been borrowed to SLgtk
 *
 * Copyright (C) 2003-2010 Massachusetts Institute of Technology 
 * Copyright (C) 2002 Michael S. Noble <mnoble@space.mit.edu> */

#include <gdk/gdk.h>
#include <cairo-gobject.h>

/* S-Lang structure handling {{{ */
SLang_CStruct_Field_Type GdkColor_Layout [] =
{
   MAKE_CSTRUCT_FIELD(GdkColor, pixel, "pixel", SLANG_LONG_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkColor, red, "red", SLANG_USHORT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkColor, green, "green", SLANG_USHORT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkColor, blue, "blue", SLANG_USHORT_TYPE, 0),
   SLANG_END_CSTRUCT_TABLE
};

SLang_CStruct_Field_Type GdkRectangle_Layout [] =
{
   MAKE_CSTRUCT_FIELD(GdkRectangle, x, "x", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkRectangle, y, "y", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkRectangle, width, "width", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkRectangle, height, "height", SLANG_INT_TYPE, 0),
   SLANG_END_CSTRUCT_TABLE
};

SLang_CStruct_Field_Type GdkPoint_Layout [] =
{
   MAKE_CSTRUCT_FIELD(GdkPoint, x, "x", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkPoint, y, "y", SLANG_INT_TYPE, 0),
   SLANG_END_CSTRUCT_TABLE
};

SLang_CStruct_Field_Type GdkRGBA_Layout [] =
{
   MAKE_CSTRUCT_FIELD(GdkRGBA, red, "red", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkRGBA, green, "green", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkRGBA, blue, "blue", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkRGBA, alpha, "alpha", SLANG_DOUBLE_TYPE, 0),
   SLANG_END_CSTRUCT_TABLE
};

SLang_CStruct_Field_Type GdkKeymapKey_Layout [] =
{
   MAKE_CSTRUCT_FIELD(GdkKeymapKey, keycode, "keycode", SLANG_UINT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkKeymapKey, group, "group", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkKeymapKey, level, "level", SLANG_INT_TYPE, 0),
   SLANG_END_CSTRUCT_TABLE
};

SLang_CStruct_Field_Type GdkGeometry_Layout [] =
{
   MAKE_CSTRUCT_FIELD(GdkGeometry, min_width, "min_width", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkGeometry, min_height, "min_height", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkGeometry, max_width, "max_width", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkGeometry, max_height, "max_height", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkGeometry, base_width, "base_width", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkGeometry, base_height, "base_height", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkGeometry, width_inc, "width_inc", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkGeometry, height_inc, "height_inc", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkGeometry, min_aspect, "min_aspect", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkGeometry, max_aspect, "max_aspect", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkGeometry, win_gravity, "win_gravity", SLANG_INT_TYPE, 0),
   SLANG_END_CSTRUCT_TABLE
};

/* }}} */

int slgtk_push_boxed (const GValue* gval)
{
   gpointer boxed = g_value_get_boxed (gval);
   GType gtype = G_VALUE_TYPE (gval);
   
   if (gtype == GDK_TYPE_RECTANGLE)
     return SLang_push_cstruct ((VOID_STAR) boxed, GdkRectangle_Layout);
   
   if (gtype == GTK_TYPE_BORDER)
     return SLang_push_cstruct ((VOID_STAR) boxed, GtkBorder_Layout);
   
   if (gtype == GTK_TYPE_REQUISITION)
     return SLang_push_cstruct ((VOID_STAR) boxed, GtkRequisition_Layout);

   if (gtype == CAIRO_GOBJECT_TYPE_CONTEXT)
     return SLang_push_opaque (Cairo_Type, boxed, 0);
   
   /* return SLang_push_opaque (GtkOpaque_Type, boxed, 0); */
   return SLang_push_opaque (void_ptr_Type, boxed, 0);
}

/* Wrappers {{{ */

/* static void sl_gdk_color_parse (gchar *colorname) */
/* { */
/*    GdkColor color; */

/*    if (gdk_color_parse (colorname, &color)) */
/*      {	    */
/* 	if (SLang_push_cstruct ((VOID_STAR) &color, GdkColor_Layout) == 0) */
/* 	  return; */
/*      } */
/*    (void) SLang_push_null (); */
/* } */

static void sl_gdk_rgba_parse (gchar *colorname)
{
   GdkRGBA rgba;

   if (gdk_rgba_parse (&rgba, colorname))
     {	  
	if (SLang_push_cstruct ((VOID_STAR) &rgba, GdkRGBA_Layout) == 0)
	  return;
     }
   (void) SLang_push_null ();
}

/* static void sl_gdk_query_depths (void) */
/* { */
/*    gint* depths; */
/*    gint num; */
/*    SLang_Array_Type *sarr; */

/*    if (slgtk_usage_err (0, "Integer_Type [] = gdk_query_depths ()")) */
/*      return; */

/*    gdk_query_depths (&depths, &num); */

/*    if ((sarr = SLang_create_array (SLANG_INT_TYPE, 1, NULL, &num, 1)) == NULL) */
/*      SLang_verror(SL_INTRINSIC_ERROR, "creating array in %s", "gdk_query_depths"); */
/*    else { */
/*       while (num--) */
/* 	((int*)sarr->data)[num] = depths[num]; */
/*       SLang_push_array(sarr, 1); */
/*    } */
/* } */

static void sl_gdk_device_get_state (void)
{
   SLang_verror (SL_RunTime_Error, "Not wrapped yet.");
}

static void sl_gdk_rectangle_intersect (void)
{
   gboolean retval;
   GdkRectangle src1, src2, dest;
   
   if (slgtk_usage_err (2, "GdkRectangle = gdk_rectangle_intersect (GdkRectangle, GdkRectangle)"))
     return;

   if (-1 == SLang_pop_cstruct ((VOID_STAR) &src2, GdkRectangle_Layout) ||
       -1 == SLang_pop_cstruct ((VOID_STAR) &src1, GdkRectangle_Layout))
     goto cleanup;

   retval = gdk_rectangle_intersect (&src1, &src2, &dest);
   if (retval)
     {	
	if (0 ==  SLang_push_cstruct ((VOID_STAR) &dest, GdkRectangle_Layout))
	  SLang_free_cstruct ((VOID_STAR) &dest, GdkRectangle_Layout);
     }   
   else
     SLang_push_null ();

cleanup:
   SLang_free_cstruct ((VOID_STAR) &src1, GdkRectangle_Layout);
   SLang_free_cstruct ((VOID_STAR) &src2, GdkRectangle_Layout);
}

static void sl_gdk_rectangle_union (void)
{
   GdkRectangle src1, src2, dest;
   
   if (slgtk_usage_err (2, "GdkRectangle = gdk_rectangle_union (GdkRectangle, GdkRectangle)"))
     return;

   if (-1 == SLang_pop_cstruct ((VOID_STAR) &src2, GdkRectangle_Layout) ||
       -1 == SLang_pop_cstruct ((VOID_STAR) &src1, GdkRectangle_Layout))
     goto cleanup;

   gdk_rectangle_union (&src1, &src2, &dest);
   if (0 ==  SLang_push_cstruct ((VOID_STAR) &dest, GdkRectangle_Layout))
     SLang_free_cstruct ((VOID_STAR) &dest, GdkRectangle_Layout);

cleanup:
   SLang_free_cstruct ((VOID_STAR) &src1, GdkRectangle_Layout);
   SLang_free_cstruct ((VOID_STAR) &src2, GdkRectangle_Layout);   
}

static void sl_gdk_cairo_get_clip_rectangle (void)
{   
   gboolean retval;
   cairo_t* arg1;
   Slirp_Opaque* arg1_o = NULL;
   GdkRectangle* arg2 = (GdkRectangle*) alloca(sizeof(GdkRectangle));

   if (slgtk_usage_err (1, "GdkRectangle = gdk_cairo_get_clip_rectangle (Cairo)"))
     return;

   if (-1 == SLang_pop_opaque(Cairo_Type, (void**)&arg1, &arg1_o))
     return;
   
   retval = gdk_cairo_get_clip_rectangle (arg1, arg2);

   if (retval)
     (void) SLang_push_cstruct ((VOID_STAR) arg2, GdkRectangle_Layout);
   else
     (void) SLang_push_null ();

   SLang_free_opaque(arg1_o);
}

static void sl_gdk_make_atom (void)
{
   guint val;
   
   if (slgtk_usage_err (1, "GdkAtom = gdk_make_atom (uint)"))
     return;

   if (-1 == SLang_pop_uinteger (&val))
     return;

   SLang_push_opaque (GObject_Type, _GDK_MAKE_ATOM (val), 0);
}

/* }}} */

static SLang_Intrin_Fun_Type Gdk_Funcs[] =
{
   MAKE_INTRINSIC_0("sl_gdk_device_get_state",sl_gdk_device_get_state,SLANG_VOID_TYPE),
   /* MAKE_INTRINSIC_1("gdk_color_parse",sl_gdk_color_parse,SLANG_VOID_TYPE,SLANG_STRING_TYPE), */
   MAKE_INTRINSIC_1("gdk_rgba_parse",sl_gdk_rgba_parse,SLANG_VOID_TYPE,SLANG_STRING_TYPE),
   /* MAKE_INTRINSIC_0("gdk_query_depths",sl_gdk_query_depths,SLANG_VOID_TYPE), */
   MAKE_INTRINSIC_0("gdk_cairo_get_clip_rectangle",sl_gdk_cairo_get_clip_rectangle,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gdk_device_get_state",sl_gdk_device_get_state,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gdk_rectangle_intersect",sl_gdk_rectangle_intersect,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gdk_rectangle_union",sl_gdk_rectangle_union,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("_gdk_make_atom",sl_gdk_make_atom,SLANG_VOID_TYPE),
   /* MAKE_INTRINSIC_0("",sl_,SLANG_VOID_TYPE), */
   SLANG_END_INTRIN_FUN_TABLE
};

static int init_sl_gdk(SLang_NameSpace_Type *ns)
{
   /* slgtk_patch_ftable(Gdk_Funcs, 255, GtkOpaque_Type); */
   return SLns_add_intrin_fun_table (ns, Gdk_Funcs, "__GDK__");
}
