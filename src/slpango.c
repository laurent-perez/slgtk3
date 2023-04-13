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

#include <pango/pango.h>

static const unsigned int _pango_version = 10000 * PANGO_VERSION_MAJOR +
  100 * PANGO_VERSION_MINOR + PANGO_VERSION_MICRO;

static void sl_pango_get_attr_shape_rect (void)
{
   PangoAttrShape *attr;
   Slirp_Opaque *attr_o = NULL;

   if (slgtk_usage_err (1, "(PangoRectangle, PangoRectangle) = pango_get_attr_shape_rect (PangoAttrShape)"))
     return;

   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&attr, &attr_o))
     return;

   (void) SLang_push_cstruct ((VOID_STAR) &(attr->logical_rect), PangoRectangle_Layout);
   (void) SLang_push_cstruct ((VOID_STAR) &(attr->ink_rect), PangoRectangle_Layout);

   SLang_free_opaque (attr_o);
}

static void sl_pango_attr_set_index (void)
{
   PangoAttribute *attr;
   Slirp_Opaque *attr_o = NULL;   
   guint start_index, end_index;
   
   if (slgtk_usage_err (3, "pango_attr_set_index (PangoAttribute, uint, uint)"))
     return;

   if (-1 == SLang_pop_uinteger (&end_index))
     return;
   if (-1 == SLang_pop_uinteger (&start_index))
     return;
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&attr, &attr_o))
     return;

   attr->start_index = start_index;
   attr->end_index = end_index;
   
   SLang_free_opaque (attr_o);
}

static void sl_pango_attr_get_index (void)
{
   PangoAttribute *attr;
   Slirp_Opaque *attr_o = NULL;

   if (slgtk_usage_err (1, "(uint, uint) = pango_attr_get_index (PangoAttribute)"))
     return;

   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&attr, &attr_o))
     return;

   (void) SLang_push_uinteger (attr->start_index);
   (void) SLang_push_uinteger (attr->end_index);
   
   SLang_free_opaque (attr_o);
}

static void sl_pango_attr_shape_get_data (void)
{
   PangoAttrShape *attr;
   Slirp_Opaque *attr_o = NULL;
   unsigned int arg;
   User_Data_Type *data;
   
   if (slgtk_usage_err (1, "(...) = pango_attr_get_data (PangoAttribute)"))
     return;

   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&attr, &attr_o))
     return;

   data = (User_Data_Type *) attr->data;
   
   if (data->args)
     {
   	for (arg = 0 ; arg < data->nargs ; arg ++)
   	  {
   	     if (-1 == SLang_push_anytype (data->args [arg]))
   	       break;
   	}      
   }
   SLang_free_opaque (attr_o);
}

static void sl_pango_attr_shape_new_with_data (void)
{
   PangoAttribute *retval = NULL;
   PangoRectangle *ink_rect = (PangoRectangle *) alloca (sizeof (PangoRectangle));
   PangoRectangle *logical_rect = (PangoRectangle *) alloca (sizeof (PangoRectangle));
   User_Data_Type *data = (User_Data_Type *) SLmalloc (sizeof (User_Data_Type));
   
   if (slgtk_usage_err (3, "PangoAttribute = pango_attr_shape_new_with_data (PangoRectangle, PangoRectangle, [...])"))
     return;

   data->nargs = SLang_Num_Function_Args - 2;
   if (slgtk_extract_slang_args (data->nargs, &(data->args)) == -1)
     goto cleanup_3;
   if (-1 == SLang_pop_cstruct ((VOID_STAR) logical_rect, PangoRectangle_Layout))
     goto cleanup_2;     
   if (-1 == SLang_pop_cstruct ((VOID_STAR) ink_rect, PangoRectangle_Layout))
     goto cleanup;

   retval = pango_attr_shape_new_with_data (ink_rect, logical_rect, (gpointer) data,
					    NULL,
					    NULL);

   (void) SLang_push_opaque (GtkOpaque_Type, (void*) retval, 0);   
   
   SLang_free_cstruct ((VOID_STAR) ink_rect, PangoRectangle_Layout);
cleanup:
   SLang_free_cstruct ((VOID_STAR) logical_rect, PangoRectangle_Layout);
   if (retval != NULL)
     return;
cleanup_2:
   slgtk_free_slang_args (data->nargs, data->args);
cleanup_3:
   SLfree ((char *) data);
}

static void set_shape_renderer (cairo_t *cr, PangoAttrShape *attr, gboolean do_path, gpointer data)
{      
   (void) SLang_push_opaque (Cairo_Type, (void*) cr, 0);
   (void) SLang_push_opaque (GtkOpaque_Type, (void*) attr, 0);
   (void) SLang_push_int (do_path);

   /* if (-1 == SLang_push_opaque (Cairo_Type, (void*) cr, 0)) */
   /*   g_message ("Can't push Cairo_Type"); */
   /* if (-1 == SLang_push_opaque (GtkOpaque_Type, (void*) attr, 0)) */
   /*   g_message ("Can't push GtkOpaque_Type"); */
   /* if (-1 == SLang_push_int (do_path)) */
   /*   g_message ("Can't push int"); */

   function_invoke ((slGFunction*) data);
}

static void sl_pango_cairo_context_set_shape_renderer (void)
{
   PangoContext *context;
   Slirp_Opaque *context_o = NULL;
   slGFunction *f;
   
   if (slgtk_usage_err (2, "pango_cairo_context_set_shape_renderer (PangoContext, Slang_Ref, [...])"))
     return;

   if (NULL == (f = function_pop (1)))
     return;
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&context, &context_o))
     {
	function_destroy ((gpointer) f);
	return;
     }
   
   pango_cairo_context_set_shape_renderer (context, (PangoCairoShapeRendererFunc) set_shape_renderer, (gpointer) f, function_destroy);

   SLang_free_opaque (context_o);
}

static SLang_Intrin_Fun_Type Pango_Funcs[] =
{
   MAKE_INTRINSIC_0("pango_get_attr_shape_rect", sl_pango_get_attr_shape_rect, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("pango_attr_set_index", sl_pango_attr_set_index, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("pango_attr_get_index", sl_pango_attr_get_index, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("pango_attr_shape_get_data", sl_pango_attr_shape_get_data, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("pango_attr_shape_new_with_data", sl_pango_attr_shape_new_with_data, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("pango_cairo_context_set_shape_renderer", sl_pango_cairo_context_set_shape_renderer, SLANG_VOID_TYPE),
   /* MAKE_INTRINSIC_0("", sl_, SLANG_VOID_TYPE), */
   SLANG_END_INTRIN_FUN_TABLE
};

static SLang_Intrin_Var_Type Pango_Vars[] =
{
   MAKE_VARIABLE("_pango_version", &_pango_version, SLANG_UINT_TYPE, 1),
   SLANG_END_INTRIN_VAR_TABLE
};

int init_sl_pango(SLang_NameSpace_Type *ns)
{
   if (-1 == SLns_add_intrin_var_table (ns, Pango_Vars, NULL))
     return -1;

   return SLns_add_intrin_fun_table (ns, Pango_Funcs, "__PANGO__");
}
