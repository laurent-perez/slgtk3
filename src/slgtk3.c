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

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <gtk/gtk.h>
#include <gdk/gdkkeysyms.h>
#include <gtk/gtkunixprint.h>
#include <pango/pangoft2.h>
#include <gio/gnetworking.h>
/* uncomment these lines if you need functions defined in gsettingsbackend.h */
/* you will also have to uncomment gsettingsbackend.h line in gio.lst file */
/* #define G_SETTINGS_ENABLE_BACKEND */
/* #include <gio/gsettingsbackend.h> */

#include "module.h"
#include "version.h"

static const unsigned int _gtk3_version = 10000 * GTK_MAJOR_VERSION + 
  100 * GTK_MINOR_VERSION + GTK_MICRO_VERSION;

const int slgtk3_version = MODULE_VERSION_NUMBER;
const char *slgtk3_version_string = MODULE_VERSION_STRING;
int slgtk_debug;

typedef struct
{
   SLang_Any_Type **args;
   unsigned int nargs;
} User_Data_Type;

SLang_CStruct_Field_Type GtkBorder_Layout [] =
  {
     MAKE_CSTRUCT_FIELD(GtkBorder, left, "left", SLANG_SHORT_TYPE, 0),
     MAKE_CSTRUCT_FIELD(GtkBorder, right, "right", SLANG_SHORT_TYPE, 0),
     MAKE_CSTRUCT_FIELD(GtkBorder, top, "top", SLANG_SHORT_TYPE, 0),
     MAKE_CSTRUCT_FIELD(GtkBorder, bottom, "bottom", SLANG_SHORT_TYPE, 0),
     SLANG_END_CSTRUCT_TABLE
  };

SLang_CStruct_Field_Type GtkRequisition_Layout [] =
  {
     MAKE_CSTRUCT_FIELD(GtkRequisition, width, "width", SLANG_INT_TYPE, 0),
     MAKE_CSTRUCT_FIELD(GtkRequisition, height, "height", SLANG_INT_TYPE, 0),
     SLANG_END_CSTRUCT_TABLE
  };

SLang_CStruct_Field_Type GtkPageRange_Layout [] =
  {
     MAKE_CSTRUCT_FIELD(GtkPageRange, start, "start", SLANG_INT_TYPE, 0),
     MAKE_CSTRUCT_FIELD(GtkPageRange, end, "end", SLANG_INT_TYPE, 0),
     SLANG_END_CSTRUCT_TABLE
  };

SLang_CStruct_Field_Type PangoColor_Layout [] =
{
   MAKE_CSTRUCT_FIELD(PangoColor, red, "red", SLANG_USHORT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(PangoColor, green, "green", SLANG_USHORT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(PangoColor, blue, "blue", SLANG_USHORT_TYPE, 0),
   SLANG_END_CSTRUCT_TABLE
};

SLang_CStruct_Field_Type PangoRectangle_Layout [] =
{
   MAKE_CSTRUCT_FIELD(PangoRectangle, x, "x", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(PangoRectangle, y, "y", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(PangoRectangle, width, "width", SLANG_INT_TYPE, 0),
   MAKE_CSTRUCT_FIELD(PangoRectangle, height, "height", SLANG_INT_TYPE, 0),
   SLANG_END_CSTRUCT_TABLE
};

SLang_CStruct_Field_Type PangoMatrix_Layout [] =
{
   MAKE_CSTRUCT_FIELD(PangoMatrix, xx, "xx", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(PangoMatrix, xy, "xy", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(PangoMatrix, x0, "x0", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(PangoMatrix, yx, "yx", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(PangoMatrix, yy, "yy", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(PangoMatrix, y0, "y0", SLANG_DOUBLE_TYPE, 0),
   SLANG_END_CSTRUCT_TABLE
};

SLang_CStruct_Field_Type *GtkAllocation_Layout = GdkRectangle_Layout;

typedef struct _slGFunction
{
   SLang_Name_Type *function;
   void		  *widget;
   SLang_Any_Type  **args;
   unsigned int    nargs;
} slGFunction;		/* Used for signal, timer, idle, etc callbacks */

#include "gtk3_glue.c"

/* General signal/idle/timeout callback support {{{ */ 

int function_invoke (slGFunction *pf)
{
   unsigned int arg = 0;

   if (SLang_start_arg_list () == -1)
     return -1;

   if (pf->widget && -1 == SLang_push_opaque (GtkWidget_Type, pf->widget, 0))
     return -1;
   
   if (pf->args)
     {
	for (arg = 0; arg < pf->nargs; arg++)
	  {
	     if (SLang_push_anytype(pf->args[arg]) == -1)
	       break;
	  }      
     }

   if (SLang_get_error () || SLang_end_arg_list () == -1)
     {
	SLdo_pop_n ((pf->widget != NULL) + arg);
	return -1;
     }
   
   (void) SLexecute_function (pf->function);

   /* Unrecoverable S-Lang errors should not cause main loop to hang */
   if (SLang_get_error () < 0)
     {
	slgtk_error_terminate_main_loop (pf->function->name);
	return -1;
     }

   /* Otherwise try our best to recover */
   if (SLang_get_error ())
     {
	SLang_restart (0);
	SLang_set_error (0);
     }

   return 0;
}

static void callback_invoker (GtkWidget *w, gpointer data)
{
   slGFunction *pf = (slGFunction*)data;
   pf->widget = w;
   (void) function_invoke(pf);
}

static int function_marshaller (gpointer data)
{
   int retval;
   slGFunction *pf = (slGFunction*) data;

   if (-1 == function_invoke (pf))
     return 0;

   if (SLang_pop_integer(&retval) == -1 || SLang_get_error() < 0) {
      char msg[192];
      strcpy(msg,"could not pop expected boolean return value from: ");
      strncat(msg,pf->function->name,
	      (size_t) MIN(strlen(pf->function->name),192-strlen(msg)-1));
      slgtk_error_terminate_main_loop(msg);
   }

   return retval;
}

void function_destroy (gpointer data)
{   
   slGFunction *f = (slGFunction*) data;

   if (f) {
      slgtk_free_slang_args(f->nargs, f->args);
      SLang_free_function(f->function);
      SLfree((char*)f);
   }
}

static slGFunction* function_create(void *widget, SLang_Ref_Type **slfunc_ref,
				    SLang_Any_Type **args, unsigned int nargs)
{
   slGFunction *f;
   SLang_Name_Type *slfunc;
   
   if ( (slfunc = SLang_get_fun_from_ref(*slfunc_ref)) == NULL)
      return NULL;

   SLang_free_ref(*slfunc_ref);
   *slfunc_ref = NULL;

   if ( (f = (slGFunction*) SLmalloc(sizeof(slGFunction))) == NULL) {
      SLang_free_function(slfunc);
      return NULL;
   }

   f->function	= slfunc;
   f->widget	= (GtkWidget*)widget;
   f->args	= args;
   f->nargs	= nargs;

   return f;
}

slGFunction* function_pop (unsigned int num_args_to_omit)
{
   slGFunction *f;
   SLang_Any_Type **args = NULL;
   SLang_Ref_Type *func_ref = NULL;
   unsigned int nargs = SLang_Num_Function_Args - num_args_to_omit - 1;

   if (slgtk_extract_slang_args(nargs,&args) == 0
       && SLang_pop_ref(&func_ref) == 0
       && (f = function_create(NULL, &func_ref, args, nargs)))
     return f;

   if (args) slgtk_free_slang_args (nargs,args);
   if (func_ref) SLang_free_ref (func_ref);

   return NULL;
}

/* GtkWidget manipulators {{{ */

#include "slgdk3.c"
#include "slgdkpixbuf.c"
#include "slpango.c"
#include "slglib.c"

/* static void sl_gtk_cell_area_cell_set_property (void) */
/* { */
/* } */

/* static void sl_gtk_cell_area_cell_get_property (void) */
/* { */
/* } */

static void sl_gtk_dialog_new_with_buttons (void)
{
   SLang_Array_Type *id_array = NULL;
   SLang_Array_Type *name_array = NULL;
   GtkDialogFlags flags;
   GtkWidget *dialog, *widget;
   Slirp_Opaque* widget_o = NULL;   
   char *title, **names;
   int *ids;
   SLindex_Type i;

   if (slgtk_usage_err (5, "GtkWidget = gtk_dialog_new_with_buttons (string, GtkWidget, int, [buttons], [ids])"))
     return;
      
   if (-1 == SLang_pop_array_of_type (&id_array, SLANG_INT_TYPE) ||
       -1 == SLang_pop_array_of_type (&name_array, SLANG_STRING_TYPE) ||
       -1 == SLang_pop_int ((int*)&flags) ||
       -1 == pop_nullable (GtkWidget_Type, (void**) &widget_o, (void**) &widget) ||
       -1 == pop_string_or_null(&title))
     goto cleanup;

   names = (char **) name_array->data;
   ids = (int *) id_array->data;
   
   dialog = gtk_dialog_new ();
   gtk_window_set_title (GTK_WINDOW (dialog), title); 
   for (i = 0 ; i < name_array->num_elements ; i ++)
     (void) gtk_dialog_add_button (GTK_DIALOG (dialog), names [i], ids [i]);
   
   (void) SLang_push_opaque (GtkWidget_Type, dialog, 0);
   return;
   
cleanup:
   SLang_free_slstring (title);
   SLang_free_array (name_array);
   SLang_free_array (id_array);
   SLang_free_opaque (widget_o);
}

static void sl_gtk_dialog_add_buttons (void)
{
   SLang_Array_Type *id_array = NULL;
   SLang_Array_Type *name_array = NULL;
   GtkWidget *dialog;
   Slirp_Opaque* dialog_o = NULL;
   char **names;
   int *ids;
   SLindex_Type i;
   
   if (slgtk_usage_err (3, "gtk_dialog_add_buttons (GtkWidget, [buttons], [ids])"))
     return;
   
   if (-1 == SLang_pop_array_of_type (&id_array, SLANG_INT_TYPE) ||
       -1 == SLang_pop_array_of_type (&name_array, SLANG_STRING_TYPE) ||       
       -1 == SLang_pop_opaque (GtkWidget_Type, (void**)&dialog, &dialog_o))
     goto cleanup;

   names = (char **) name_array->data;
   ids = (int *) id_array->data;
   
   for (i = 0 ; i < name_array->num_elements ; i ++)
     (void) gtk_dialog_add_button (GTK_DIALOG (dialog), names [i], ids [i]);
   return;
   
cleanup:
   SLang_free_array (name_array);
   SLang_free_array (id_array);
   SLang_free_opaque (dialog_o);
}

static void sl_gtk_icon_size_lookup (void)
{
   GtkIconSize size;
   gboolean retval;
   gint width, height;
   
   if (slgtk_usage_err (1, "(int, int) = gtk_icon_size_lookup (GtkIconSize)"))
     return;

   if (-1 == SLang_pop_int ((int*) &size))
     return;

   retval = gtk_icon_size_lookup (size, &width, &height);
   if (retval == TRUE)
     {
	(void) SLang_push_int (height);
	(void) SLang_push_int (width);
     }
   else
     {
	(void) SLang_push_null ();
	(void) SLang_push_null ();
     }
}

static void sl_gtk_icon_view_get_item_at_pos (void)
{
   GtkTreePath *path;
   GtkCellRenderer *cell;
   GtkIconView *icon_view;
   Slirp_Opaque* icon_view_o = NULL;
   gint x, y;
   gboolean retval;
   
   if (slgtk_usage_err (3, "(GtkTreePath, GtkCellRenderer) = gtk_icon_view_get_item_at_pos (GtkIconView, int, int)"))
     return;

   if (-1 == SLang_pop_int ((int*)&y))
     return;    
   if (-1 == SLang_pop_int ((int*)&x))
     return;
   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**) &icon_view, &icon_view_o))
     return;

   retval = gtk_icon_view_get_item_at_pos (icon_view, x, y, &path, &cell);
   if (retval)
     {
	(void) SLang_push_opaque (GtkTreePath_Type, (void*) path, 1);
	(void) SLang_push_opaque (GObject_Type, (void*) cell, 0);
     }
   else
     {
	(void) SLang_push_null ();
	(void) SLang_push_null ();
     }
   
   SLang_free_opaque (icon_view_o);
}

static void sl_gtk_icon_view_get_cursor (void)
{
   GtkTreePath *path;
   GtkCellRenderer *cell;
   GtkIconView *icon_view;
   Slirp_Opaque* icon_view_o = NULL;
   gboolean retval;
   
   if (slgtk_usage_err (1, "(GtkTreePath, GtkCellRenderer) = gtk_icon_view_get_cursor (GtkIconView)"))
     return;

   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**) &icon_view, &icon_view_o))
     return;

   retval = gtk_icon_view_get_cursor (icon_view, &path, &cell);
   if (retval)
     {
	(void) SLang_push_opaque (GtkTreePath_Type, (void*) path, 1);
	(void) SLang_push_opaque (GObject_Type, (void*) cell, 0);
     }
   else
     {
	(void) SLang_push_null ();
	(void) SLang_push_null ();
     }
   
   SLang_free_opaque (icon_view_o);
}

static void sl_gtk_icon_view_get_drag_dest_item (void)
{
   GtkTreePath *path;
   GtkIconViewDropPosition pos;
   GtkIconView *icon_view;
   Slirp_Opaque* icon_view_o = NULL;
   
   if (slgtk_usage_err (1, "(GtkTreePath, GtkIconViewDropPosition) = gtk_icon_view_get_drag_dest_item (GtkIconView)"))
     return;

   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**) &icon_view, &icon_view_o))
     return;
   
   gtk_icon_view_get_drag_dest_item (icon_view, &path, &pos);

   (void) SLang_push_opaque (GtkTreePath_Type, (void*) path, 1);
   (void) SLang_push_int (pos);

   SLang_free_opaque (icon_view_o);
}

static void sl_gtk_icon_view_get_dest_item_at_pos (void)
{
   GtkTreePath *path;
   GtkIconViewDropPosition pos;
   GtkIconView *icon_view;
   Slirp_Opaque* icon_view_o = NULL;
   gint x, y;
   gboolean retval;
   
   if (slgtk_usage_err (1, "(GtkTreePath, GtkIconViewDropPosition) = gtk_icon_view_get_dest_item_at_pos (GtkIconView, int, int)"))
     return;

   if (-1 == SLang_pop_int ((int*)&y))
     return;
   if (-1 == SLang_pop_int ((int*)&x))
     return;
   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**) &icon_view, &icon_view_o))
     return;

   retval = gtk_icon_view_get_dest_item_at_pos (icon_view, x, y, &path, &pos);

   if (retval)
     {
	(void) SLang_push_opaque (GtkTreePath_Type, (void*) path, 1);
	(void) SLang_push_int (pos);
     }
   else
     {
	(void) SLang_push_null ();
	(void) SLang_push_null ();
     }

   SLang_free_opaque (icon_view_o);
}

static void sl_gtk_icon_view_get_cell_rect (void)
{
   gboolean retval;
   GtkIconView* arg1;
   Slirp_Opaque* arg1_o = NULL;
   GtkTreePath* arg2;
   Slirp_Opaque* arg2_o = NULL;
   GtkCellRenderer* arg3;
   Slirp_Opaque* arg3_o = NULL;
   GdkRectangle* arg4 = (GdkRectangle*) alloca(sizeof(GdkRectangle));

   if (slgtk_usage_err (3, "GdkRectangle = gtk_icon_view_get_cell_rect (GtkCellRenderer, GtkTreePath [, GtkIconView])"))
     return;
   
   if (-1 == pop_nullable(GObject_Type, (void**)&arg3_o, (void**)&arg3))
     return;
   if (-1 == SLang_pop_opaque(GtkTreePath_Type, (void**)&arg2, &arg2_o))
     goto cleanup_2;
   if (-1 == SLang_pop_opaque(GtkWidget_Type, (void**)&arg1, &arg1_o))
     goto cleanup_1;
   
   retval = gtk_icon_view_get_cell_rect (arg1, arg2, arg3, arg4);
   if (retval)
     (void) SLang_push_cstruct ((VOID_STAR) arg4, GdkRectangle_Layout);
   else
     (void) SLang_push_null ();

      SLang_free_opaque(arg1_o);
cleanup_1:
      SLang_free_opaque(arg2_o);
cleanup_2:
      SLang_free_opaque(arg3_o);
}


static void sl_gtk_info_bar_new_with_buttons (void)
{
   SLang_Array_Type *id_array = NULL;
   SLang_Array_Type *name_array = NULL;
   GtkWidget *infobar;
   char **names;
   int *ids;
   SLindex_Type i;

   if (slgtk_usage_err (2, "GtkWidget = gtk_info_bar_new_with_buttons ([buttons], [ids])"))
     return;
      
   if (-1 == SLang_pop_array_of_type (&id_array, SLANG_INT_TYPE) ||
       -1 == SLang_pop_array_of_type (&name_array, SLANG_STRING_TYPE))
     goto cleanup;

   names = (char **) name_array->data;
   ids = (int *) id_array->data;
   
   infobar = gtk_info_bar_new ();
   for (i = 0 ; i < name_array->num_elements ; i ++)
     (void) gtk_info_bar_add_button (GTK_INFO_BAR (infobar), names [i], ids [i]);
   
   (void) SLang_push_opaque (GtkWidget_Type, infobar, 0);
   return;
   
cleanup:
   SLang_free_array (name_array);
   SLang_free_array (id_array);
}

static void sl_gtk_info_bar_add_buttons (void)
{
   SLang_Array_Type *id_array = NULL;
   SLang_Array_Type *name_array = NULL;
   GtkWidget *infobar;
   Slirp_Opaque* infobar_o = NULL;
   char **names;
   int *ids;
   SLindex_Type i;
   
   if (slgtk_usage_err (3, "gtk_info_bar_add_buttons (GtkWidget, [buttons], [ids])"))
     return;
   
   if (-1 == SLang_pop_array_of_type (&id_array, SLANG_INT_TYPE) ||
       -1 == SLang_pop_array_of_type (&name_array, SLANG_STRING_TYPE) ||       
       -1 == SLang_pop_opaque (GtkWidget_Type, (void**)&infobar, &infobar_o))
     goto cleanup;

   names = (char **) name_array->data;
   ids = (int *) id_array->data;
   
   for (i = 0 ; i < name_array->num_elements ; i ++)
     (void) gtk_info_bar_add_button (GTK_INFO_BAR (infobar), names [i], ids [i]);
   return;
   
cleanup:
   SLang_free_array (name_array);
   SLang_free_array (id_array);
   SLang_free_opaque (infobar_o);
}

static void sl_gtk_print_settings_get_page_ranges (void)
{
   GtkPrintSettings* settings;
   Slirp_Opaque* settings_o = NULL;
   GtkPageRange *ranges;
   gint num_ranges, i;
   SLang_List_Type *lst;
   
   if (slgtk_usage_err (1, "[GtkPageRange] = gtk_print_settings_get_page_ranges (GtkPrintSettings)"))
     return;

   if (-1 == SLang_pop_opaque (GObject_Type, (void**)&settings, &settings_o))
     return;  
   
   ranges = gtk_print_settings_get_page_ranges (settings, &num_ranges);

   if (NULL == (lst = SLang_create_list (0)))
     goto cleanup;
   
   for (i = 0 ; i < num_ranges ; i ++)
     {	
	(void) SLang_push_cstruct ((VOID_STAR) &ranges [i], GtkPageRange_Layout);
	if (-1 == SLang_list_append (lst, -1))
	  goto cleanup;
     }
   
   (void) SLang_push_list (lst, 0);

   /* free_struct ? */
   
cleanup:
   g_free (ranges); 
   SLang_free_opaque (settings_o);
   SLang_free_list (lst);
}

static void sl_gtk_print_settings_set_page_ranges (void)
{
   GtkPrintSettings* settings;
   Slirp_Opaque* settings_o = NULL;
   GtkPageRange *ranges;
   gint val;
   SLang_Array_Type *at = NULL;
   SLindex_Type i;   
   SLang_Struct_Type *st;
   
   if (slgtk_usage_err (2, "gtk_print_settings_set_page_ranges (GtkPrintSettings, [GtkPageRange])"))
     return;

   if (-1 == SLang_pop_array_of_type (&at, SLANG_STRUCT_TYPE))
     return;
   if (-1 == SLang_pop_opaque (GObject_Type, (void**)&settings, &settings_o))
     goto cleanup_3;

   ranges = g_try_new (GtkPageRange, at->num_elements);
   if (ranges == NULL)
     return;

   for (i = 0 ; i < at->num_elements ; i ++)
     {	
	if (-1 == SLang_get_array_element (at, &i, &st))
	  goto cleanup;
	if (-1 == SLang_push_struct_field (st, "start"))
	  goto cleanup;
	if (-1 == SLang_pop_int ((int*) &val))
	  goto cleanup;
	ranges [i].start = (gint) val;
	if (-1 == SLang_push_struct_field (st, "end"))
	  goto cleanup;
	if (-1 == SLang_pop_int ((int*) &val))
	  goto cleanup;
	ranges [i].end = (gint) val;
     }
   
   gtk_print_settings_set_page_ranges (settings, ranges, at->num_elements);
   
   goto cleanup_2;
   
cleanup:
   g_free (ranges);
cleanup_2:
   SLang_free_opaque (settings_o);
cleanup_3:
   SLang_free_array (at);
}

static void sl_gtk_print_job_get_page_ranges (void)
{
   GtkPrintJob* job;
   Slirp_Opaque* job_o = NULL;
   GtkPageRange *ranges;
   gint i, n_ranges;
   SLang_List_Type *lst;
   
   if (slgtk_usage_err (1, "[GtkPageRange] = gtk_print_job_get_page_ranges (GtkPrintJob)"))
     return;

   if (-1 == SLang_pop_opaque (GObject_Type, (void**)&job, &job_o))
     return;  
   
   ranges = gtk_print_job_get_page_ranges (job, &n_ranges);

   if (NULL == (lst = SLang_create_list (0)))
     goto cleanup;
   
   for (i = 0 ; i < n_ranges ; i ++)
     {	
	(void) SLang_push_cstruct ((VOID_STAR) &ranges [i], GtkPageRange_Layout);
	if (-1 == SLang_list_append (lst, -1))
	  goto cleanup;
     }
   
   (void) SLang_push_list (lst, 0);
   
cleanup:
   g_free (ranges); 
   SLang_free_opaque (job_o);
   SLang_free_list (lst);
}

static void sl_gtk_print_job_set_page_ranges (void)
{
   GtkPrintJob* job;
   Slirp_Opaque* job_o = NULL;
   GtkPageRange *ranges;
   gint val;
   SLang_Array_Type *at = NULL;
   SLindex_Type i;   
   SLang_Struct_Type *st;
   
   if (slgtk_usage_err (2, "gtk_print_job_set_page_ranges (GtkPrintJob, [GtkPageRange])"))
     return;

   if (-1 == SLang_pop_array_of_type (&at, SLANG_STRUCT_TYPE))
     return;
   if (-1 == SLang_pop_opaque (GObject_Type, (void**)&job, &job_o))
     goto cleanup_3;

   ranges = g_try_new (GtkPageRange, at->num_elements);
   if (ranges == NULL)
     return;

   for (i = 0 ; i < at->num_elements ; i ++)
     {	
	if (-1 == SLang_get_array_element (at, &i, &st))
	  goto cleanup;
	if (-1 == SLang_push_struct_field (st, "start"))
	  goto cleanup;
	if (-1 == SLang_pop_int ((int*) &val))
	  goto cleanup;
	ranges [i].start = (gint) val;
	if (-1 == SLang_push_struct_field (st, "end"))
	  goto cleanup;
	if (-1 == SLang_pop_int ((int*) &val))
	  goto cleanup;
	ranges [i].end = (gint) val;
     }
   
   gtk_print_job_set_page_ranges (job, ranges, at->num_elements);
   
   goto cleanup_2;
   
cleanup:
   g_free (ranges);
cleanup_2:
   SLang_free_opaque (job_o);
cleanup_3:
   SLang_free_array (at);
}

static void sl_gtk_recent_info_get_application_info (void)
{
   gboolean retval;
   GtkRecentInfo *info;
   Slirp_Opaque *info_o = NULL;
   const gchar *app_name, *app_exec;
   guint count;
   time_t time_;

   if (slgtk_usage_err (2, "(string, int, int) = gtk_recent_info_get_application_info (GtkRecentInfo, string)"))
     return;

   if (-1 == SLang_pop_string ((char**)&app_name))
     return;
   if (-1 == SLang_pop_opaque (GObject_Type, (void**)&info, &info_o))
     goto cleanup;

   retval = gtk_recent_info_get_application_info (info, app_name, &app_exec, &count, &time_);

   if (retval)
     {
	(void) SLang_push_ulong (time_);
	(void) SLang_push_uint (count);
	(void) SLang_push_string ((gchar*) app_exec);	
     }
   else
     {
	(void) SLang_push_null ();
	(void) SLang_push_null ();
	(void) SLang_push_null ();
     }
   
cleanup:
   SLang_free_opaque (info_o);
}

static void sl_gtk_widget_destroy (void)
{
   GtkWidget* arg1;
   Slirp_Opaque* arg1_o = NULL;

   if ((SLang_Num_Function_Args < 1)
       || (-1 == SLang_pop_opaque(GtkWidget_Type, (void**)&arg1, &arg1_o)))
     {
	SLang_verror (SL_USAGE_ERROR, "Usage: gtk_widget_destroy (widget)");
	return;
     }

   gtk_widget_destroy(arg1);
   arg1_o->instance = NULL;
   SLang_free_opaque(arg1_o);
}

/* The object returned here should not be ref-counted. */
static void sl_gdk_pixbuf_animation_iter_get_pixbuf (void)
{
   GdkPixbuf* retval;
   GdkPixbufAnimationIter* arg1;
   Slirp_Opaque* arg1_o = NULL;
   int issue_usage = 1;

   if (SLang_Num_Function_Args != 1)
     goto usage_label;
   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&arg1, &arg1_o))
     goto usage_label;
   issue_usage = 0;

   retval = gdk_pixbuf_animation_iter_get_pixbuf(arg1);
   (void)SLang_push_opaque(GdkPixbuf_Type, (void*)retval, 1);
   goto free_and_return;
free_and_return:
   /* drop */
   SLang_free_opaque(arg1_o);
usage_label:
   if (issue_usage) Slirp_usage (1889, 1889, 0);
}

static gint set_default_sort_func (GtkTreeModel *model, GtkTreeIter *a, GtkTreeIter *b, gpointer data)
{
   (void) SLang_push_opaque (GObject_Type, (void*) model, 0);
   (void) SLang_push_opaque (GtkTreeIter_Type, (void*) a, 1);
   (void) SLang_push_opaque (GtkTreeIter_Type, (void*) b, 1);

   return function_marshaller (data);
}

static void sl_gtk_tree_sortable_set_default_sort_func (void)
{
   GtkTreeSortable *sortable;
   Slirp_Opaque *sortable_o = NULL;
   slGFunction *f;
   
   if (slgtk_usage_err (2, "gtk_tree_sortable_set_default_sort_func (GtkTreeSortable, func_ref, args...)"))
     return;

   if (NULL == (f = function_pop (1)))
     return;
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&sortable, &sortable_o))
     {
	function_destroy ((gpointer) f);
	return;
     }

   gtk_tree_sortable_set_default_sort_func (sortable, (GtkTreeIterCompareFunc) set_default_sort_func, (gpointer) f, function_destroy);

   SLang_free_opaque (sortable_o);
}

static gboolean set_row_separator_func (GtkTreeModel *model, GtkTreeIter *iter, gpointer data)
{
   (void) SLang_push_opaque (GObject_Type, (void*) model, 0);
   (void) SLang_push_opaque (GtkTreeIter_Type, (void*) iter, 1);

   return (gboolean) function_marshaller (data);
}

static void sl_gtk_combo_box_set_row_separator_func (void)
{
   GtkComboBox *combo_box;
   Slirp_Opaque *combo_box_o = NULL;
   slGFunction *f = NULL;
   
   if (slgtk_usage_err (1, "gtk_combo_box_set_row_separator_func (GtkComboBox, func_ref, args...)"))
     return;

   if ((f = function_pop (1)) == NULL)
     return;
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&combo_box, &combo_box_o))
     return;
   
   gtk_combo_box_set_row_separator_func (GTK_COMBO_BOX (combo_box), (GtkTreeViewRowSeparatorFunc) set_row_separator_func, (gpointer) f, function_destroy);

   SLang_free_opaque (combo_box_o);
}

#ifdef GDK_AVAILABLE_IN_3_8
static gboolean tick_callback (GtkWidget *widget, GdkFrameClock *frame_clock, gpointer data)
{
   (void) SLang_push_opaque (GtkWidget_Type, (void*) widget, 0);
   (void) SLang_push_opaque (GObject_Type, (void*) frame_clock, 0);   

   return (gboolean) function_marshaller (data);
}

static unsigned int sl_gtk_widget_add_tick_callback (void)
{
   GtkWidget *widget;
   Slirp_Opaque *widget_o = NULL;   
   slGFunction *f = NULL;
   
   if (slgtk_usage_err (2, "uint = gtk_widget_add_tick_callback (GtkWidget, func_ref, args...)"))     
     return 0;

   if ((f = function_pop (1)) == NULL ||
       -1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&widget, &widget_o))
     goto cleanup;

   return gtk_widget_add_tick_callback (widget, (GtkTickCallback) tick_callback, (gpointer) f, function_destroy);
   
cleanup:
   SLang_free_opaque (widget_o);
   function_destroy (f);
   return 0;
}
#endif
/* }}} */

/* GtkTextBuffer interface {{{ */

static void sl_gtk_text_buffer_create_tag (void)
{
   GParamSpec *pspec;
   GtkTextBuffer *textbuf = NULL;
   Slirp_Opaque *textbuf_o = NULL;  
   GtkTextTag *tag = NULL;
   GtkTextTagTable *table;
   GValue property_value = G_VALUE_INIT;
   char *property_name, *tag_name = NULL;
   unsigned int nprops = SLang_Num_Function_Args - 2;   
   
   if (slgtk_usage_err (2, "tag = gtk_text_buffer_create_tag (buffer, tag_name, ...)"))
     return;

   if (nprops % 2 != 0)
     {
	SLdo_pop_n (SLang_Num_Function_Args);
	SLang_verror (SL_USAGE_ERROR, "unbalanced name/value property list");
	return;
     }

   (void) SLreverse_stack (SLang_Num_Function_Args);

   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&textbuf, &textbuf_o) ||
       -1 == pop_string_or_null (&tag_name))
	goto cleanup;

   tag = gtk_text_tag_new (tag_name);
   table = gtk_text_buffer_get_tag_table (textbuf);
   gtk_text_tag_table_add (table, tag);
   
   while (nprops)
     {
   	if (-1 == SLang_pop_slstring (&property_name))
   	  {
   	     g_object_unref (tag);
   	     tag = NULL;
   	     break;
   	  }
	pspec = g_object_class_find_property (G_OBJECT_GET_CLASS (tag), property_name);
	if (pspec == NULL)
	  {
	     g_object_unref (tag);
	     tag = NULL;
	     g_message ("This object has no property named : %s", property_name);
	     break;
	  }
	g_value_init (&property_value, G_PARAM_SPEC_VALUE_TYPE (pspec));
	if (-1 == slgtk_pop_g_value (&property_value))
	  {
	     g_message ("Can't pop value for property named : %s", property_name);
	     g_value_unset (&property_value);
	     break;
	  }	
	g_object_set_property (G_OBJECT (tag), property_name, &property_value);
	g_value_unset (&property_value);
	SLang_free_slstring (property_name);
	nprops -= 2;
   }
   
cleanup:
   SLang_free_opaque (textbuf_o);   
   SLang_free_slstring(tag_name);
   if (tag == NULL)
     SLang_push_null();
   else
     SLang_push_opaque (GObject_Type, tag, 1);
}

static void sl_gtk_text_buffer_insert_with_tags (void)
{
   int len, start_offset;
   GtkTextIter start, *iter;
   GtkTextBuffer *textbuf;
   GtkTextTag *tag;
   Slirp_Opaque *iter_o = NULL, *textbuf_o = NULL, *tag_o = NULL;
   char *text = NULL;
   unsigned int i, ntags;

   if (slgtk_usage_err (4, "gtk_text_buffer_insert_with_tags (buffer,iter,string,len,...)"))
     return;

   ntags = SLang_Num_Function_Args - 4;
   (void) SLreverse_stack (SLang_Num_Function_Args);

   if (-1 == SLang_pop_opaque (GObject_Type, (void**)&textbuf, &textbuf_o) ||
       -1 == SLang_pop_opaque (GtkTextIter_Type, (void**)&iter, &iter_o) ||
       -1 == SLang_pop_string ((char **)&text) ||
       -1 == SLang_pop_integer (&len))
     goto cleanup;

   start_offset = gtk_text_iter_get_offset (iter);
   gtk_text_buffer_insert (textbuf, iter, text, len);

   gtk_text_buffer_get_iter_at_offset (textbuf, &start, start_offset);

   for (i = 0 ; i < ntags ; i ++)
     {
        if (-1 == SLang_pop_opaque (GObject_Type, (void**)&tag, &tag_o))
	  break;
	gtk_text_buffer_apply_tag (textbuf, tag, &start, iter);
	SLang_free_opaque (tag_o);
     }
cleanup:
   SLang_free_opaque (textbuf_o);
   SLang_free_opaque (iter_o);
   SLang_free_slstring (text);
}

static void sl_gtk_text_buffer_insert_with_tags_by_name (void)
{
   int len, start_offset;
   GtkTextIter start, *iter;
   GtkTextBuffer *textbuf;
   GtkTextTag *tag;
   GtkTextTagTable *table;
   Slirp_Opaque *iter_o = NULL, *textbuf_o = NULL;
   char *text = NULL, *tag_name = NULL;
   unsigned int i, ntags;

   if (slgtk_usage_err (4, "gtk_text_buffer_insert_with_tags_by_name (buffer,iter,string,len,...)"))
     return;

   ntags = SLang_Num_Function_Args - 4;
   (void) SLreverse_stack (SLang_Num_Function_Args);

   if (-1 == SLang_pop_opaque (GObject_Type, (void**)&textbuf, &textbuf_o) ||
       -1 == SLang_pop_opaque (GtkTextIter_Type, (void**)&iter, &iter_o) ||
       -1 == SLang_pop_string ((char **)&text) ||
       -1 == SLang_pop_integer (&len))
     goto cleanup;

   start_offset = gtk_text_iter_get_offset (iter);
   gtk_text_buffer_insert (textbuf, iter, text, len);
   gtk_text_buffer_get_iter_at_offset (textbuf, &start, start_offset);

   for (i = 0 ; i < ntags ; i ++)
     {
	if (-1 == SLang_pop_slstring (&tag_name))
	  break;
	table = gtk_text_buffer_get_tag_table (textbuf);
	tag = gtk_text_tag_table_lookup (table, tag_name);
	if (tag == NULL)
	  {	     
	     g_warning ("%s : no tag with name '%s'!", G_STRLOC, tag_name);
	     goto cleanup;
	  }	
	gtk_text_buffer_apply_tag (textbuf, tag, &start, iter);
	SLang_free_slstring (tag_name);
     }
cleanup:
   SLang_free_opaque (textbuf_o);
   SLang_free_opaque (iter_o);
   SLang_free_slstring (text);
}

/* }}} */

/* GtkMenu interface {{{ */

/* deprecated */
/* static void sl_gtk_menu_popup(void) */
/* { */
/*    Slirp_Opaque *menu_o = NULL; */
/*    GtkMenu *menu; */
/*    guint button; */
/*    gulong atime; */

/*    if (slgtk_usage_err(3,"gtk_menu_popup(menu,mouse_button_num,activate_event_time)")) */
/*       return; */

/*    if ( -1 == SLang_pop_ulong(&atime) || */
/* 	-1 == SLang_pop_uinteger(&button) || */
/* 	-1 == SLang_pop_opaque(GtkWidget_Type, (void**)&menu, &menu_o)) { */

/* 	SLang_verror (SL_INTRINSIC_ERROR, */
/* 		"Unable to validate arguments to: gtk_menu_popup"); */
/* 	return; */
/*    } */

/*    gtk_menu_popup(menu, NULL, NULL, NULL, NULL, button, (guint32)atime); */
/*    SLang_free_opaque(menu_o); */
/* } */
/* }}} */

/* Tree model interface {{{ */

static void sl_gtk_tree_iter_new (void)
{
   GtkTreeIter *iter;

   if (slgtk_usage_err (0, "GtkTreeIter = gtk_tree_iter_new ()"))
     return;
   
   if ((iter = (GtkTreeIter *) SLmalloc (sizeof(GtkTreeIter))) != NULL)
     {
	iter->stamp = 0;
	iter->user_data = iter->user_data2 = iter->user_data3 = NULL;
	(void) SLang_push_opaque (GtkTreeIter_Type, iter, 1);
     }
   else
     (void) SLang_push_null();
}

static void sl_gtk_tree_model_get_value (void)
{
   GtkTreeModel* model;
   Slirp_Opaque* model_o = NULL;
   GtkTreeIter* iter;
   Slirp_Opaque* iter_o = NULL;
   gint col;   
   GValue value = G_VALUE_INIT;

   if (slgtk_usage_err (3, "value = gtk_tree_model_get_value (GtkTreeModel, GtkTreeIter, int)"))
     return;

   if (-1 == SLang_pop_int((gint*)&col))
     return;
   if (-1 == SLang_pop_opaque(GtkOpaque_Type, (void**)&iter, &iter_o))
     return;
   if (-1 == SLang_pop_opaque(GtkOpaque_Type, (void**)&model, &model_o))
     goto cleanup;

   gtk_tree_model_get_value (model, iter, col, &value);
   (void) slgtk_push_g_value ((const GValue*) &value);
   g_value_unset (&value);
   
cleanup:   
   SLang_free_opaque (model_o);
   SLang_free_opaque (iter_o);
}

static void sl_gtk_tree_model_get (void)
{
   unsigned int nargs, i;
   int col;
   GtkTreeModel* model;
   Slirp_Opaque* model_o = NULL;
   GtkTreeIter* iter;
   Slirp_Opaque* iter_o = NULL;
   GValue value = G_VALUE_INIT;
   
   if (slgtk_usage_err (2, "(...) = gtk_tree_model_get (GtkTreeModel, GtkTreeIter, ...)"))
     return;

   (void) SLreverse_stack (SLang_Num_Function_Args);
   
   if (-1 == SLang_pop_opaque(GtkOpaque_Type, (void**)&model, &model_o))
     goto cleanup_2;
   if (-1 == SLang_pop_opaque(GtkOpaque_Type, (void**)&iter, &iter_o))
     goto cleanup_1;

   nargs = SLang_Num_Function_Args - 2;

   for (i = 0 ; i < nargs ; i ++)
     {
	if (-1 == SLang_pop_int ((int*) &col))
	  {
	     g_message ("Can't pop column number");
	     break;
	  }
	gtk_tree_model_get_value (model, iter, col, &value);
	(void) slgtk_push_g_value ((const GValue*) &value);
	g_value_unset (&value);
	(void) SLroll_stack (nargs);
     }

cleanup_1:
   SLang_free_opaque (iter_o);
cleanup_2:
   SLang_free_opaque (model_o);   
}

static void sl_gtk_tree_model_rows_reordered (void)
{
   GtkTreeModel *tree_model;
   Slirp_Opaque *tree_model_o = NULL;
   GtkTreePath *path;
   Slirp_Opaque *path_o = NULL;
   GtkTreeIter *iter;
   Slirp_Opaque *iter_o = NULL;
   SLang_Array_Type *new_order = NULL;

   if (slgtk_usage_err (4, "gtk_tree_model_rows_reordered (GtkTreeModel, GtkTreePath, GtkTreeIter, [int])"))
     return;

   if (-1 == SLang_pop_array_of_type (&new_order, SLANG_INT_TYPE))
     return;
   if (-1 == SLang_pop_opaque(GtkOpaque_Type, (void**)&iter, &iter_o))
     goto cleanup_3;
   if (-1 == SLang_pop_opaque(GtkOpaque_Type, (void**)&path, &path_o))
     goto cleanup_2;
   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&tree_model, &tree_model_o))
     goto cleanup_1;

   gtk_tree_model_rows_reordered (tree_model, path, iter, (gint *) new_order->data);

   return;

   SLang_free_opaque (tree_model_o);
   
cleanup_1:
   SLang_free_opaque (path_o);
cleanup_2:
   SLang_free_opaque (iter_o);
cleanup_3:
   SLang_free_array (new_order);
}

static void tree_model_filter_set_modify_func (GtkTreeModel *model, GtkTreeIter *iter, GValue *value,
					       gint column, gpointer data)
{
   (void) SLang_push_opaque (GObject_Type, (void*) model, 0);
   (void) SLang_push_opaque (GtkTreeIter_Type, (void*) iter, 1);
   (void) SLang_push_opaque (GObject_Type, (void*) value, 1);
   (void) SLang_push_int (column);
   
   function_invoke ((slGFunction*) data);
}

static void sl_gtk_tree_model_filter_set_modify_func (void)
{
   GtkTreeModelFilter *filter;
   Slirp_Opaque *filter_o = NULL;
   slGFunction *f;
   SLang_Array_Type *at = NULL;
   SLindex_Type i;
   GType *types;
   int t;
   
   if (slgtk_usage_err (3, "gtk_tree_model_filter_set_modify_func (GtkTreeModelFilter, [int], Ref_Type)"))
     return;
   
   if (NULL == (f = function_pop (2)))
     return;   
   if (-1 == SLang_pop_array_of_type (&at, SLANG_INT_TYPE))
     goto cleanup_3;
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void **) &filter, &filter_o))
     goto cleanup_2;

   types = g_try_new (GType, at->num_elements);
   if (types == NULL)
     goto cleanup;
   
   for (i = 0 ; i < at->num_elements ; i ++)
     {
	if (-1 == SLang_get_array_element (at, &i, &t))
	  goto cleanup;
	types [i] = (GType) t;
     }
   
   gtk_tree_model_filter_set_modify_func (filter, at->num_elements, types,
					  (GtkTreeModelFilterModifyFunc) tree_model_filter_set_modify_func, (gpointer) f, function_destroy);

   SLang_free_opaque (filter_o);
   SLang_free_array (at);
   
   return;
   
cleanup:
   g_free (types);
   SLang_free_opaque (filter_o);
cleanup_2:
   SLang_free_array (at);
cleanup_3:   
   function_destroy ((gpointer) f);
}

static gboolean tree_model_filter_set_visible_func (GtkTreeModel *model, GtkTreeIter *iter, gpointer data)
{
   (void) SLang_push_opaque (GObject_Type, (void*) model, 0);
   (void) SLang_push_opaque (GtkTreeIter_Type, (void*) iter, 1);

   return (gboolean) function_marshaller (data);
}

static void sl_gtk_tree_model_filter_set_visible_func (void)
{
   GtkTreeModelFilter *filter;
   Slirp_Opaque *filter_o = NULL;
   slGFunction *f;

   if (slgtk_usage_err (2, "gtk_tree_model_filter_set_visible_func (GtkTreeModelFilter, Ref_Type)"))
     return;
   
   if (NULL == (f = function_pop (1)))
     return;
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void **) &filter, &filter_o))
     goto cleanup;
   
   gtk_tree_model_filter_set_visible_func (filter, (GtkTreeModelFilterVisibleFunc) tree_model_filter_set_visible_func, (gpointer) f, function_destroy);
   
   SLang_free_opaque (filter_o);
   
   return;
   
cleanup:   
   function_destroy ((gpointer) f);
}

static void tree_view_column_set_cell_data_func (GtkTreeViewColumn *tree_column, GtkCellRenderer *cell, GtkTreeModel *tree_model,
						 GtkTreeIter *iter, gpointer data)
{
   (void) SLang_push_opaque (GObject_Type, (void*) tree_column, 0);
   (void) SLang_push_opaque (GObject_Type, (void*) cell, 0);
   (void) SLang_push_opaque (GObject_Type, (void*) tree_model, 0);
   (void) SLang_push_opaque (GtkTreeIter_Type, (void*) iter, 1);

   function_invoke ((slGFunction*) data);
}

static void sl_gtk_tree_view_column_set_cell_data_func (void)
{
   GtkTreeViewColumn *tree_column;
   Slirp_Opaque *tree_column_o = NULL;
   GtkCellRenderer *cell_renderer;
   Slirp_Opaque *cell_renderer_o = NULL;
   slGFunction *f;
   
   if (slgtk_usage_err (3, "gtk_tree_view_column_set_cell_data_func (GtkTreeViewColumn, GtkCellRenderer, Ref_Type)"))
     return;
   
   if (NULL == (f = function_pop (2)))
     return;   
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void **) &cell_renderer, &cell_renderer_o))
     goto cleanup_2;   
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void **) &tree_column, &tree_column_o))
     goto cleanup;
   
   gtk_tree_view_column_set_cell_data_func (tree_column, cell_renderer,
					    (GtkTreeCellDataFunc) tree_view_column_set_cell_data_func, (gpointer) f, function_destroy);

   SLang_free_opaque (tree_column_o);
   SLang_free_opaque (cell_renderer_o);
   
   return;
   
cleanup:
   SLang_free_opaque (cell_renderer_o);
cleanup_2:   
   function_destroy ((gpointer) f);   
}

static void sl_gtk_tree_path_get_indices (void)
{
   gint *indices, depth;
   GtkTreePath *path;
   Slirp_Opaque *path_o = NULL;
   SLang_Array_Type *at = NULL;
   
   if (slgtk_usage_err (1, "[int] = gtk_tree_path_get_indices (GtkTreePath)"))
     return;

   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&path, &path_o))
     goto cleanup;
   
   indices = gtk_tree_path_get_indices_with_depth (path, &depth);
   
   at = SLang_create_array (SLANG_INT_TYPE, 0, indices, &depth, 1);
   if (at == NULL)
     goto cleanup;

   (void) SLang_push_array (at, 1);
   
cleanup:
   SLang_free_opaque (path_o);
}

static void sl_gtk_tree_path_new_from_indices (void)
{
   GtkTreePath *tp;
   SLang_Array_Type *indices = NULL;
   
   if (slgtk_usage_err (1, "GtkTreePath = gtk_tree_path_new_from_indices ([int])"))
     return;

   if (-1 == SLang_pop_array_of_type (&indices, SLANG_INT_TYPE))
     return;
#ifdef GDK_AVAILABLE_IN_3_12
   tp = gtk_tree_path_new_from_indicesv ((gint*) indices->data, (gsize) indices->num_elements);
#else
   /* array must be terminated by -1 */
   tp = gtk_tree_path_new_from_indices ((gint*) indices->data);
#endif
   (void) SLang_push_opaque (GtkTreePath_Type, (void*)tp, 1);
}

static void sl_gtk_tree_view_column_new_with_attributes(void)
{
   GtkTreeViewColumn *tvcol;
   GtkCellRenderer *cell;
   Slirp_Opaque *cell_o = NULL;
   unsigned int nattr;
   char *title, *attribute;
   gint colnum;

   if (slgtk_usage_err(2, "GtkTreeViewColumn = gtk_tree_view_column_new_with_attributes (string, GtkCellRenderer, ...)"))
     return;

   nattr = SLang_Num_Function_Args - 2;
   if (nattr % 2 != 0)
     {
	SLdo_pop_n (SLang_Num_Function_Args);
	SLang_verror (SL_USAGE_ERROR, "empty or unbalanced attribute/column list");
	return;
     }
   
   (void) SLreverse_stack (SLang_Num_Function_Args);

   if (	-1 == SLang_pop_slstring (&title) ||
	-1 == SLang_pop_opaque (GtkWidget_Type, (void**)&cell, &cell_o))
     goto cleanup;

   if ((tvcol = gtk_tree_view_column_new ()) == NULL)
     goto cleanup;

   gtk_tree_view_column_pack_start (tvcol, cell, TRUE);
   gtk_tree_view_column_set_title (tvcol,title);

   while (nattr)
     {
	attribute = NULL;
	if (-1 == SLang_pop_slstring (&attribute) || 
	    -1 == SLang_pop_integer (&colnum))
	  {	     
	     if (attribute)
	       SLang_free_slstring (attribute);

	     SLang_verror (SL_INTRINSIC_ERROR,
			  "error popping attribute/column pair");
	     
	     /* slgtk_object_destroyer( GTK_OBJECT(tvcol) ); */
	     tvcol = NULL;
	     break;
	  }

	gtk_tree_view_column_add_attribute (tvcol, cell,attribute, colnum);
	
	SLang_free_slstring (attribute);
	nattr -= 2;
     }

   if (tvcol)
     (void) SLang_push_opaque (GtkWidget_Type, tvcol, 0);
   else
     (void) SLang_push_null ();
   
cleanup:
   SLang_free_slstring (title);
   SLang_free_opaque (cell_o);
}

static void sl_gtk_tree_view_insert_column_with_attributes (void)
{
   GtkTreeView *tv;
   Slirp_Opaque *tv_o = NULL;
   gint position, retval, colnum;
   GtkTreeViewColumn *column;
   GtkCellRenderer *cell;
   Slirp_Opaque *cell_o = NULL;
   unsigned int nattr;
   char *title, *attribute;
   
   if (slgtk_usage_err(4, "gtk_tree_view_insert_column_with_attributes (GtkTreeView, int, string, GtkCellRenderer, ...)"))
     return;

   nattr = SLang_Num_Function_Args - 4;
   if (nattr % 2 != 0)
     {
	SLdo_pop_n (SLang_Num_Function_Args);
	SLang_verror (SL_USAGE_ERROR, "empty or unbalanced attribute/column list");
	return;
     }
   
   (void) SLreverse_stack (SLang_Num_Function_Args);

   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**)&tv, &tv_o) ||
       -1 == SLang_pop_int ((int*)&position) ||
       -1 == SLang_pop_slstring (&title) ||
       -1 == SLang_pop_opaque (GObject_Type, (void**)&cell, &cell_o))     
     goto cleanup;

   if ((column = gtk_tree_view_column_new ()) == NULL)
     goto cleanup;

   gtk_tree_view_column_pack_start (column, cell, TRUE);
   gtk_tree_view_column_set_title (column, title);
   retval = gtk_tree_view_insert_column (tv, column, position);
   
   while (nattr)
     {
	attribute = NULL;
	if (-1 == SLang_pop_slstring (&attribute) || 
	    -1 == SLang_pop_integer (&colnum))
	  {	     
	     if (attribute)
	       SLang_free_slstring (attribute);

	     SLang_verror(SL_INTRINSIC_ERROR,
			  "error popping attribute/column pair");
	     
	     /* slgtk_object_destroyer( GTK_OBJECT(tvcol) ); */
	     column = NULL;
	     break;
	  }

	gtk_tree_view_column_add_attribute (column, cell, attribute, colnum);
	
	SLang_free_slstring(attribute);
	nattr -= 2;
     }

   (void) SLang_push_int (retval);
   
cleanup:
   SLang_free_slstring(title);
   SLang_free_opaque(cell_o);
   SLang_free_opaque(tv_o);
}

static void sl_gtk_tree_view_get_cursor (void)
{
   GtkTreeView *tree_view;
   Slirp_Opaque *tree_view_o = NULL;
   GtkTreePath *path;
   GtkTreeViewColumn *focus_column;
   
   if (slgtk_usage_err(1, "(GtkTreePath, GtkTreeViewColumn) = gtk_tree_view_get_cursor (GtkTreeView)"))
     return;

   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**)&tree_view, &tree_view_o))
     return;

   gtk_tree_view_get_cursor (tree_view, &path, &focus_column);

   (void) SLang_push_opaque (GtkTreePath_Type, path, 1);
   (void) SLang_push_opaque (GtkWidget_Type, focus_column, 0);   

   SLang_free_opaque (tree_view_o);
}

static void sl_gtk_tree_view_get_visible_range (void)
{
   GtkTreeView *tree_view;
   Slirp_Opaque *tree_view_o = NULL;
   GtkTreePath *start_path, *end_path;
   
   if (slgtk_usage_err(1, "(GtkTreePath, GtkTreePath) = gtk_tree_view_get_visible_range (GtkTreeView)"))
     return;

   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**)&tree_view, &tree_view_o))
     return;

   gtk_tree_view_get_visible_range (tree_view, &start_path, &end_path);

   (void) SLang_push_opaque (GtkTreePath_Type, end_path, 1);
   (void) SLang_push_opaque (GtkTreePath_Type, start_path, 1);

   SLang_free_opaque (tree_view_o);
}

static void sl_gtk_tree_selection_get_selected (void)
{
   gboolean retval;
   GtkTreeSelection *selection;
   Slirp_Opaque *selection_o = NULL;
   GtkTreeIter *iter = NULL;
   Slirp_Opaque *iter_o = NULL;
   GtkTreeModel *model = NULL;
   SLang_Ref_Type *model_ref = NULL;
   
   if (slgtk_usage_err (1, "int = gtk_tree_selection_get_selected (GtkTreeSelection [, GtkTreeModel, GtkTreeIter])"))
     return;

   if (SLang_Num_Function_Args == 3)
     {
	if (-1 == pop_nullable (GtkTreeIter_Type, (void**) &iter_o, (void **) &iter))	
	  goto cleanup;
     }
   if (SLang_Num_Function_Args > 1)
     {
	if (-1 == pop_nullable (SLANG_REF_TYPE, (void**) &model_ref, NULL))
	  goto cleanup;
     }   
   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&selection, &selection_o))
     goto cleanup;

   if (model_ref != NULL)
     {
	if ((model = (GtkTreeModel *) SLmalloc (sizeof (GtkTreeModel*))) == NULL)
	  goto cleanup;
     }
   
   retval = gtk_tree_selection_get_selected (selection, &model, iter);
   
   if (model_ref != NULL)
     {
	SLang_MMT_Type *mmt = create_opaque_mmt (GObject_Type, model, 0);
	if (-1 == SLang_assign_to_ref (model_ref, GObject_Type, &mmt))
	  goto cleanup;
	SLang_free_ref (model_ref);
     }
   
   (void)SLang_push_int(retval);

   return;

cleanup:
   SLang_free_ref (model_ref);
   SLang_free_opaque (iter_o);
   SLang_free_opaque (selection_o);
}

/* }}} */

/* List store interface {{{ */

static void list_store_set (GtkListStore *lstore, GtkTreeIter  *iter, unsigned int nvalues)
{
   gint colnum;
   GValue value = G_VALUE_INIT;
   
   if (nvalues % 2 != 0)
     {
	SLdo_pop_n (nvalues);
	SLang_verror (SL_USAGE_ERROR, "unbalanced column/value list");
	return;
     }
   while (nvalues)
     {
	if (-1 == SLang_pop_integer (&colnum))
	  break;
	g_value_init (&value, gtk_tree_model_get_column_type (GTK_TREE_MODEL (lstore), colnum));	
   	if (-1 == slgtk_pop_g_value (&value))
	  {
	     g_message ("Can't pop value for column : %d", colnum);
	     g_value_unset (&value);
	     break;
	  }	
   	gtk_list_store_set_value (GTK_LIST_STORE (lstore), iter, colnum, &value);
   	g_value_unset (&value);
   	nvalues -= 2;
     }
}

static void sl_gtk_list_store_set (void)
{
   GtkListStore *lstore;
   GtkTreeIter  *iter;
   Slirp_Opaque *lstore_o = NULL, *iter_o = NULL;
   unsigned int nvalues = SLang_Num_Function_Args - 2;      
   
   if (slgtk_usage_err (4, "gtk_list_store_set (GtkListStore, GtkTreeIter, uint, G_TYPE, ...)"))
      return;

   (void) SLreverse_stack(SLang_Num_Function_Args);
   if (-1 == SLang_pop_opaque (GObject_Type, (void**)&lstore, &lstore_o))
     return;
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&iter, &iter_o))
     goto cleanup;

   list_store_set (lstore, iter, nvalues);

   SLang_free_opaque(iter_o);
cleanup:
   SLang_free_opaque(lstore_o);   
}

static void sl_gtk_list_store_set_value (void)
{
   if (SLang_Num_Function_Args != 4)
     {
	SLang_verror (SL_USAGE_ERROR, "Usage : gtk_list_store_set_value (GtkListStore, GtkTreeIter, uint, G_TYPE)");
	return;
     }
   sl_gtk_list_store_set ();
}

static void sl_gtk_list_store_append (void)
{
   GtkListStore *lstore;
   Slirp_Opaque *lstore_o = NULL;
   GtkTreeIter *iter;
   
   if (slgtk_usage_err (1, "GtkTreeIter = gtk_list_store_append (GtkListStore, ...)"))
     return;

   if (SLang_Num_Function_Args > 1)
     (void) SLreverse_stack (SLang_Num_Function_Args);

   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&lstore, &lstore_o))
     return;

   if ((iter = (GtkTreeIter *) SLmalloc (sizeof (GtkTreeIter))) != NULL)
     {
	iter->stamp = 0;
	iter->user_data = iter->user_data2 = iter->user_data3 = NULL;
     }
   
   gtk_list_store_append (lstore, iter);
   if (SLang_Num_Function_Args > 1)
     list_store_set (lstore, iter, SLang_Num_Function_Args - 1);
   (void) SLang_push_opaque (GtkTreeIter_Type, iter, 1);

   SLang_free_opaque(lstore_o);
}

static void sl_gtk_list_store_prepend (void)
{
   GtkListStore *lstore;
   Slirp_Opaque *lstore_o = NULL;
   GtkTreeIter *iter;
   
   if (slgtk_usage_err (1, "GtkTreeIter = gtk_list_store_prepend (GtkListStore, ...)"))
     return;

   if (SLang_Num_Function_Args > 1)
     (void) SLreverse_stack (SLang_Num_Function_Args);
   
   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&lstore, &lstore_o))
     return;

   if ((iter = (GtkTreeIter *) SLmalloc (sizeof (GtkTreeIter))) != NULL)
     {
	iter->stamp = 0;
	iter->user_data = iter->user_data2 = iter->user_data3 = NULL;
     }
   gtk_list_store_prepend (lstore, iter);
   if (SLang_Num_Function_Args > 1)
     list_store_set (lstore, iter, SLang_Num_Function_Args - 1);
   (void) SLang_push_opaque (GtkTreeIter_Type, iter, 1);

   SLang_free_opaque(lstore_o);
}

static void sl_gtk_list_store_insert (void)
{
   gint row;
   GtkListStore *lstore;
   Slirp_Opaque *lstore_o = NULL;
   GtkTreeIter *iter;
   
   if (slgtk_usage_err (1, "GtkTreeIter = gtk_list_store_insert (GtkListStore, int...)"))
     return;

   (void) SLreverse_stack (SLang_Num_Function_Args);
   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&lstore, &lstore_o))
     return;
   if (-1 == SLang_pop_integer (&row))
     goto cleanup;

   if ((iter = (GtkTreeIter *) SLmalloc (sizeof (GtkTreeIter))) != NULL)
     {
	iter->stamp = 0;
	iter->user_data = iter->user_data2 = iter->user_data3 = NULL;
     }
   gtk_list_store_insert (lstore, iter, row);
   if (SLang_Num_Function_Args > 2)
     list_store_set (lstore, iter, SLang_Num_Function_Args - 2);
   (void) SLang_push_opaque (GtkTreeIter_Type, iter, 1);

cleanup:
   SLang_free_opaque(lstore_o);
}

/* Tree store interface {{{ */

static void sl_gtk_tree_store_new (void)
{
   GtkTreeStore* retval;
   SLang_Array_Type *arg1;

   if (slgtk_usage_err (1,"GtkTreeStore = gtk_tree_store_new ([GType, ...])") ||
       (-1 == SLang_pop_array_of_type (&arg1, SLANG_ULONG_TYPE)))
     return;

   retval = gtk_tree_store_newv (arg1->dims [0], arg1->data);
   (void) SLang_push_opaque (GObject_Type, (void*) retval, 0);
}

static void tree_store_set (GtkTreeStore *lstore, GtkTreeIter *iter, unsigned int nvalues)
{
   gint colnum;
   GValue value = G_VALUE_INIT;
   
   if (nvalues % 2 != 0)
     {
	SLdo_pop_n (nvalues);
	SLang_verror (SL_USAGE_ERROR, "unbalanced column/value list");
	return;
     }
   while (nvalues)
     {
	if (-1 == SLang_pop_integer (&colnum))
	  break;
	g_value_init (&value, gtk_tree_model_get_column_type (GTK_TREE_MODEL (lstore), colnum));	
   	if (-1 == slgtk_pop_g_value (&value))
	  {
	     g_message ("Can't pop value for column : %d", colnum);
	     g_value_unset (&value);
	     break;
	  }	
   	gtk_tree_store_set_value (GTK_TREE_STORE (lstore), iter, colnum, &value);
   	g_value_unset (&value);
   	nvalues -= 2;
     }
}

static void sl_gtk_tree_store_set (void)
{
   GtkTreeStore *store;
   GtkTreeIter  *iter;
   Slirp_Opaque *store_o = NULL, *iter_o = NULL;
   unsigned int nvalues = SLang_Num_Function_Args - 2;      
   
   if (slgtk_usage_err (2, "gtk_tree_store_set (GtkTreeStore, GtkTreeIter,...)"))
     return;

   (void) SLreverse_stack(SLang_Num_Function_Args);
   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&store, &store_o) ||
       -1 == SLang_pop_opaque(GtkOpaque_Type, (void**)&iter, &iter_o))
     goto cleanup;

   tree_store_set (store, iter, nvalues);
   
cleanup:
   SLang_free_opaque(store_o);
   SLang_free_opaque(iter_o);
}

static void sl_gtk_tree_store_set_value(void)
{
   if (SLang_Num_Function_Args != 4) {
	SLang_verror (SL_USAGE_ERROR,"Usage: gtk_tree_store_set_value (GtkTreeStore, GtkTreeIter, colnum, value);");
	return;
   }
   sl_gtk_tree_store_set();
}

static void sl_gtk_tree_store_append (void)
{
   GtkTreeStore *store;
   Slirp_Opaque *store_o = NULL;
   GtkTreeIter *parent = NULL;
   Slirp_Opaque *parent_o = NULL;   
   GtkTreeIter *iter;
   
   if (slgtk_usage_err (1, "GtkTreeIter = gtk_tree_store_append (GtkTreeStore, [GtkTreeIter], ...)"))
     return;

   (void) SLreverse_stack (SLang_Num_Function_Args);
   
   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&store, &store_o) ||
       -1 == pop_nullable (GtkOpaque_Type, (void**)&parent_o, (void**)&parent))
     goto cleanup;

   if ((iter = (GtkTreeIter *)SLmalloc(sizeof(GtkTreeIter))) != NULL)
     {
	iter->stamp = 0;
	iter->user_data = iter->user_data2 = iter->user_data3 = NULL;
     }
   gtk_tree_store_append (store, iter, parent);
   if (SLang_Num_Function_Args > 2)
     tree_store_set (store, iter, SLang_Num_Function_Args - 2);
   (void) SLang_push_opaque (GtkTreeIter_Type, iter, 1);

cleanup:
   SLang_free_opaque(store_o);
   SLang_free_opaque(parent_o);
}

static void sl_gtk_tree_store_prepend (void)
{
   GtkTreeStore *store;
   Slirp_Opaque *store_o = NULL;
   GtkTreeIter *parent = NULL;
   Slirp_Opaque *parent_o = NULL;   
   GtkTreeIter *iter;
   
   if (slgtk_usage_err (1, "GtkTreeIter = gtk_tree_store_prepend (GtkTreeStore, [GtkTreeIter], ...)"))
     return;

   (void) SLreverse_stack (SLang_Num_Function_Args);

   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&store, &store_o) ||
       -1 == pop_nullable (GtkOpaque_Type, (void**)&parent_o, (void**)parent))
     goto cleanup;
       
   if ((iter = (GtkTreeIter *)SLmalloc(sizeof(GtkTreeIter))) != NULL)
     {
	iter->stamp = 0;
	iter->user_data = iter->user_data2 = iter->user_data3 = NULL;
     }
   gtk_tree_store_prepend (store, iter, parent);
   if (SLang_Num_Function_Args > 2)
     tree_store_set (store, iter, SLang_Num_Function_Args - 2);
   (void) SLang_push_opaque (GtkTreeIter_Type, iter, 1);

cleanup:
   SLang_free_opaque(store_o);
   SLang_free_opaque(parent_o);
}

static void sl_gtk_tree_store_insert (void)
{
   gint row;
   GtkTreeStore *store;
   Slirp_Opaque *store_o = NULL;
   GtkTreeIter *parent = NULL;
   Slirp_Opaque *parent_o = NULL;   
   GtkTreeIter *iter;
   
   if (slgtk_usage_err (1, "GtkTreeIter = gtk_tree_store_insert (GtkTreeStore, ...)"))
     return;

   (void) SLreverse_stack (SLang_Num_Function_Args);

   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&store, &store_o) ||
       -1 == pop_nullable (GtkOpaque_Type, (void**)&parent_o, (void**)parent) ||
       -1 == SLang_pop_integer (&row))
     goto cleanup;
       
   if ((iter = (GtkTreeIter *)SLmalloc(sizeof(GtkTreeIter))) != NULL)
     {
	iter->stamp = 0;
	iter->user_data = iter->user_data2 = iter->user_data3 = NULL;
     }
   gtk_tree_store_prepend (store, iter, parent);
   if (SLang_Num_Function_Args > 3)
     tree_store_set (store, iter, SLang_Num_Function_Args - 3);
   (void) SLang_push_opaque (GtkTreeIter_Type, iter, 1);

cleanup:
   SLang_free_opaque(store_o);
   SLang_free_opaque(parent_o);
}

/* }}} */

/* CellLayout */

static void sl_gtk_cell_layout_set_attributes (void)
{
   unsigned int nattr = SLang_Num_Function_Args - 2;
   GtkCellRenderer *cell;
   Slirp_Opaque *cell_o = NULL;
   GtkCellLayout *layout;
   Slirp_Opaque *layout_o = NULL;
   char *attribute;
   gint colnum;
   
   if (slgtk_usage_err (2, "gtk_cell_layout_set_attributes (GtkCellLayout, GtkCellRenderer, ...)"))
     return;

   if (nattr % 2 != 0)
     {
	SLdo_pop_n(SLang_Num_Function_Args);
	SLang_verror(SL_USAGE_ERROR,"empty or unbalanced attribute/column list");
	return;
     }

   (void) SLreverse_stack(SLang_Num_Function_Args);

   if ( -1 == SLang_pop_opaque(GtkOpaque_Type, (void**)&layout, &layout_o) ||
	-1 == SLang_pop_opaque(GObject_Type, (void**)&cell, &cell_o))
     goto cleanup;

   while (nattr)
     {
	attribute = NULL;
	if (-1 == SLang_pop_slstring(&attribute) || 
 	    -1 == SLang_pop_integer(&colnum))
	  {
	     if (attribute)
	       SLang_free_slstring(attribute);	     
	     SLang_verror(SL_INTRINSIC_ERROR, "error popping attribute/column pair");	     
	     break;
	  }
	gtk_cell_layout_add_attribute (layout, cell, attribute, colnum);
	SLang_free_slstring (attribute);
	nattr -= 2;
     }      

cleanup:
   SLang_free_opaque (cell_o);
   SLang_free_opaque (layout_o);   
}

static void set_cell_data_func (GtkCellLayout *cell_layout, GtkCellRenderer *cell,
				GtkTreeModel *tree_model, GtkTreeIter *iter, gpointer data)
{
   (void) SLang_push_opaque (GObject_Type, (void*) cell_layout, 0);
   (void) SLang_push_opaque (GObject_Type, (void*) cell, 0);
   (void) SLang_push_opaque (GObject_Type, (void*) tree_model, 0);
   (void) SLang_push_opaque (GtkTreeIter_Type, (void*) iter, 1);   

   function_invoke ((slGFunction*) data);
}

static void sl_gtk_cell_layout_set_cell_data_func (void)
{
   slGFunction *f = NULL;
   GtkCellLayout *layout;
   Slirp_Opaque* layout_o = NULL;
   GtkCellRenderer *renderer;
   Slirp_Opaque* renderer_o = NULL;
   
   if (slgtk_usage_err (3, "gtk_cell_layout_set_cell_data_func (GtkCellLayout, GtkCellRenderer, func_ref, args...)"))
     return;

   if (NULL == (f = function_pop (2)))
     return;
   if (-1 == SLang_pop_opaque (GObject_Type, (void**)&renderer, &renderer_o))
     {
	function_destroy ((gpointer) f);
	return;
     }
   if (-1 == SLang_pop_opaque (GObject_Type, (void**)&layout, &layout_o))
     {
	function_destroy ((gpointer) f);
	goto cleanup;
     }

   gtk_cell_layout_set_cell_data_func (layout, renderer, (GtkCellLayoutDataFunc) set_cell_data_func, (gpointer) f, function_destroy);

   SLang_free_opaque (layout_o);
cleanup:   
   SLang_free_opaque (renderer_o);
}

static void clipboard_text_callback (GtkClipboard *clipboard, const gchar *text, gpointer data)
{
   (void) SLang_push_opaque (GtkWidget_Type, (void*) clipboard, 0);
   (void) SLang_push_string ((gchar*) text);
   function_invoke ((slGFunction*) data);
}

static void sl_gtk_clipboard_request_text (void)
{
   GtkClipboard *clipboard;
   Slirp_Opaque *clipboard_o = NULL;
   slGFunction *fn = NULL;

   if (slgtk_usage_err (2, "gtk_clipboard_request_text = (GtkClipboard, func_ref, args...)"))
     return;

   if ((fn = function_pop (1)) == NULL)
     return;
   if ( -1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&clipboard, &clipboard_o))
     return;

   gtk_clipboard_request_text (clipboard, (GtkClipboardTextReceivedFunc) clipboard_text_callback, (gpointer) fn);

   function_destroy (fn);
   SLang_free_opaque (clipboard_o);
}

static void sl_gtk_builder_get_objects (void)
{
   const gchar *name;
   char *key;
   SLang_Assoc_Array_Type *assoc = NULL;
   GSList *list, *obj;
   GtkBuilder* builder;
   Slirp_Opaque* builder_o = NULL;

   if (slgtk_usage_err (1, "gtk_builder_get_objects (GtkBuilder)"))
     return;
   
   if ( -1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&builder, &builder_o))
     return;

   if (NULL == (assoc = SLang_create_assoc (SLANG_VOID_TYPE, 0)))
     goto cleanup_2;
   
   list = gtk_builder_get_objects (builder);

   obj = list;
   for ( ; obj ; obj = g_slist_next (obj))
     {
	if (GTK_IS_BUILDABLE (obj->data))
	  {	     
	     name = gtk_buildable_get_name (obj->data);
	     if (name != NULL)
	       {
		  (void) SLang_push_opaque (GObject_Type, obj->data, 0);
		  key = SLang_create_slstring ((char *) name);
		  if (-1 == SLang_assoc_put (assoc, key))
		    goto cleanup_1;
		  SLang_free_slstring (key);
	       }
	  }	
   }
   g_slist_free (list);
   (void) SLang_push_assoc (assoc, 1);
   goto cleanup_2;

cleanup_1:
   SLang_free_assoc (assoc);
cleanup_2:
   SLang_free_opaque (builder_o);   
}

static void sl_gtk_builder_add_callback_symbol (void)
{
   GtkBuilder* builder;
   Slirp_Opaque* builder_o = NULL;
   const gchar *callback_name;
   SLang_Name_Type *function;
   SLang_Ref_Type *function_ref = NULL;
   
   if (slgtk_usage_err (3, "gtk_builder_add_callback_symbol (GtkBuilder, string, SLang_Ref_Type"))
     return;

   if (-1 == SLang_pop_ref (&function_ref))
     return;
   if (-1 == SLang_pop_string ((char**) &callback_name))
     goto cleanup_2;
   if ( -1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&builder, &builder_o))
     goto cleanup;

   if ((function = SLang_get_fun_from_ref (function_ref)))
     gtk_builder_add_callback_symbol (builder, callback_name, G_CALLBACK (function));

   SLang_free_opaque (builder_o);
   
   return;
   
cleanup:
   SLang_free_slstring (callback_name);
cleanup_2:
   SLang_free_ref (function_ref);
}

static void sl_gtk_builder_add_callback_symbols (void)
{
   GtkBuilder* builder;
   Slirp_Opaque* builder_o = NULL;
   const gchar *callback_name;
   SLang_Name_Type *function;
   SLang_Ref_Type *function_ref = NULL;
   unsigned int n_symbols = SLang_Num_Function_Args - 1;
   
   if (slgtk_usage_err (3, "gtk_builder_add_callback_symbols (GtkBuilder, string, SLang_Ref_Type, [...]"))
     return;

   if (n_symbols % 2 != 0)
     {
	SLdo_pop_n (SLang_Num_Function_Args);
	SLang_verror (SL_USAGE_ERROR, "unbalanced symbol/callback list");
	return;	
     }

   (void) SLreverse_stack (SLang_Num_Function_Args);

   if ( -1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&builder, &builder_o))
     return;

   while (n_symbols)
     {
	if (-1 == SLang_pop_string ((char**) &callback_name))
	  break;	
	if (-1 == SLang_pop_ref (&function_ref))
	  break;
	if ((function = SLang_get_fun_from_ref (function_ref)))
	  gtk_builder_add_callback_symbol (builder, callback_name, G_CALLBACK (function));
	/* SLang_free_slstring (callback_name); */
	/* SLang_free_ref (function_ref); */
	n_symbols -= 2;
     }
   
   SLang_free_opaque (builder_o);
   /* SLang_free_slstring (callback_name); */
   /* SLang_free_ref (function_ref); */
}

static void connect_signals_full (GtkBuilder *builder,
				  GObject *object,
				  const gchar *signal_name,
				  const gchar *handler_name,
				  GObject *connect_object,
				  GConnectFlags flags,
				  gpointer user_data)
{
   GClosure *closure;
   User_Data_Type *data = (User_Data_Type *) user_data;
   GCallback func;
   SLang_Name_Type *f;
   
   func = gtk_builder_lookup_callback_symbol (builder, handler_name);
   if (func == NULL)
     {
	g_message ("No function provided for handler : %s", handler_name);
	return;
     }   
   f = (SLang_Name_Type *) func;
   
   closure = slgtk_closure_new (f, data->args, data->nargs, NULL);
   /* closure = slgtk_closure_new (f, NULL, 0, NULL); */

   (void) g_signal_connect_closure (object, signal_name, closure, (flags) ? 1 : 0);
   /* (void) g_signal_connect_closure (object, signal_name, closure, 0); */
}

static void sl_gtk_builder_connect_signals (void)
{
   GtkBuilder* builder;
   Slirp_Opaque* builder_o = NULL;
   User_Data_Type *data = NULL;
   
   if (slgtk_usage_err (1, "gtk_builder_connect_signals (GtkBuilder, [...])"))
     return;

   if (NULL == (data = (User_Data_Type *) SLmalloc (sizeof (User_Data_Type))))
     return;	

   data->nargs = SLang_Num_Function_Args - 1;
   if (slgtk_extract_slang_args (data->nargs, &(data->args)) == -1)
     goto cleanup_2;
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&builder, &builder_o))
     goto cleanup;

   gtk_builder_connect_signals_full (builder, (GtkBuilderConnectFunc) connect_signals_full,
				     (gpointer) data);
   
   SLang_free_opaque (builder_o);

   return;
   
cleanup:
   slgtk_free_slang_args (data->nargs, data->args);
cleanup_2:
   SLfree ((char*) data);
}

static void sl_gtk_container_foreach (void)
{
   GtkWidget *widget;
   Slirp_Opaque *widget_o = NULL;
   slGFunction *f = NULL;

   if (slgtk_usage_err (1, "id = gtk_container_foreach(container, func_ref [, arg1, ...])"))
     return;
   
   if (((f = function_pop (1)) == NULL) ||
       (-1 == SLang_pop_opaque (GtkWidget_Type, (void**) &widget, &widget_o)))
     {
	function_destroy (f);
	SLang_free_opaque (widget_o);
	return;
     }

   gtk_container_foreach (GTK_CONTAINER (widget), callback_invoker, (gpointer) f);
}

static void sl_gtk_container_forall (void)
{
   GtkWidget *widget;
   Slirp_Opaque *widget_o = NULL;
   slGFunction *f = NULL;   

   if (slgtk_usage_err (1, "id = gtk_container_forall (container, func_ref [, arg1, ...])"))
     return;
   
   if (((f = function_pop (1)) == NULL) ||
       (-1 == SLang_pop_opaque (GtkWidget_Type, (void**) &widget, &widget_o)))
     {	
	function_destroy (f);
	SLang_free_opaque (widget_o);
	return;
     }

   gtk_container_forall (GTK_CONTAINER (widget), callback_invoker, (gpointer) f);
}

static void sl_gtk_container_child_get_property (void)
{
   GtkContainer *container;
   Slirp_Opaque *container_o = NULL;
   GtkWidget *child;
   Slirp_Opaque *child_o = NULL;
   char *property_name;
   GValue property_value = G_VALUE_INIT;
   GParamSpec *pspec;

   if (slgtk_usage_err (3, "GValue = gtk_container_child_get (GtkContainer, GtkWidget, string)"))
     return;

   if (-1 == SLang_pop_slstring ((char **) &property_name))
     return;
   if (-1 == SLang_pop_opaque(GtkWidget_Type, (void**)&child, &child_o))
     goto cleanup_3;
   if (-1 == SLang_pop_opaque(GtkOpaque_Type, (void**)&container, &container_o))
     goto cleanup_2;

   pspec = gtk_container_class_find_child_property (G_OBJECT_GET_CLASS (container), property_name);
   if (pspec == NULL)
     {
	g_message ("This object has no property named : %s", property_name);
	goto cleanup;     
     }   
   g_value_init (&property_value, G_PARAM_SPEC_VALUE_TYPE (pspec));
   gtk_container_child_get_property (container, child, property_name, &property_value);
   (void) slgtk_push_g_value ((const GValue*) &property_value);
   g_value_unset (&property_value);

cleanup:
   SLang_free_opaque (container_o);
cleanup_2:      
   SLang_free_opaque (child_o);
cleanup_3:
   SLang_free_slstring (property_name);
}

static void sl_gtk_container_child_set_property (void)
{
   GtkContainer *container;
   Slirp_Opaque *container_o = NULL;
   GtkWidget *child;
   Slirp_Opaque *child_o = NULL;
   GParamSpec *pspec;
   char *property;
   GValue value = G_VALUE_INIT;
   
   if (slgtk_usage_err (4, "gtk_container_child_set_property (GtkContainer, GtkWidget, string, )"))
     return;
   
   (void) SLreverse_stack (SLang_Num_Function_Args);
   
   if (-1 == SLang_pop_opaque(GtkOpaque_Type, (void**)&container, &container_o))     
     return;
   if (-1 == SLang_pop_opaque(GtkWidget_Type, (void**)&child, &child_o))
     goto cleanup_3;
   if (-1 == SLang_pop_string ((char**)&property))
     goto cleanup_2;   
   
   pspec = gtk_container_class_find_child_property (G_OBJECT_GET_CLASS (container), property);
   if (pspec == NULL)
     {
	g_message ("This object has no property named : %s", property);
	goto cleanup;   
     }   
   g_value_init (&value, G_PARAM_SPEC_VALUE_TYPE (pspec));

   if (-1 == slgtk_pop_g_value (&value))
     {
	g_message ("Can't pop value for property named : %s", property);
	g_value_unset (&value);
	goto cleanup;
     }   
   
   gtk_container_child_set_property (container, child, property, &value);

cleanup:      
   SLang_free_slstring (property);
   g_value_unset (&value);
cleanup_2:   
   SLang_free_opaque (child_o);
cleanup_3:   
   SLang_free_opaque (container_o);
}

static void sl_gtk_main_quit (void)
{
   /* Automatically clear stack of any args passed in, which helps */
   /* tidy up when called from a connected signal handler/callback */
   SLdo_pop_n(SLang_Num_Function_Args);
   gtk_main_quit();
}

/* Miscellaneous {{{ */

static void swallow_error (char* msg) { (void)msg; }

static int is_callable(void)
{
   int callable;
   SLang_Ref_Type *ref = NULL;
   SLang_Name_Type *func = NULL;
   void (*save_error_hook)(char *);

   if (SLang_Num_Function_Args == 0)
	return 0;

   /* Don't leave detritus on stack if called incorrectly */
   if (SLang_Num_Function_Args > 1)
	(void) SLdo_pop_n(SLang_Num_Function_Args - 1);

   if (SLang_peek_at_stack() != SLANG_REF_TYPE) {
        (void) SLdo_pop();
	return 0;
   }

   if (SLang_pop_ref(&ref) != 0) {
	SLang_verror (SL_INTRINSIC_ERROR,"unable to pop reference");
	return -1;
   }

   save_error_hook = SLang_Error_Hook;
   SLang_Error_Hook = swallow_error;
   callable = ((func = SLang_get_fun_from_ref(ref)) != NULL);
   SLang_Error_Hook = save_error_hook;

   SLang_free_ref(ref);
   SLang_free_function(func);	/* should quietly accept NULL */

   return callable;
}

static void recover_unrecoverable_error_hook(char *error_msg)
{
   fputs(error_msg,stderr);	/* support function, which lets scripts */
   fputs("\r\n", stderr);	/* catch "unrecoverable" errors within  */
   fflush (stderr);		/* an ERROR_BLOCK */
   SLang_restart(0);
   SLang_set_error(SL_USAGE_ERROR);

}

static void toggle_error_hook(void)
{
   static void (*previous_error_hook)(char *);

   if (SLang_Error_Hook == recover_unrecoverable_error_hook)
     SLang_Error_Hook = previous_error_hook;
   else {
      previous_error_hook = SLang_Error_Hook;
      SLang_Error_Hook = recover_unrecoverable_error_hook;
   }
}

static void sl_gtk_file_chooser_dialog_new (void)
{
   void *title;
   unsigned int nbutt = SLang_Num_Function_Args - 3;
   int action, respcode [3], i = 0;
   char *button [3] = {NULL, NULL, NULL};
   GtkWidget *retval;
   GtkWindow *parent = NULL;
   Slirp_Opaque* parent_o = NULL;

   if (slgtk_usage_err (3, "gtk_file_chooser_dialog_new (string, GtkWidget, GtkFileChooserAction, ...)"))
     return;

   if (nbutt % 2 != 0)
     {
	SLdo_pop_n (SLang_Num_Function_Args);
	SLang_verror (SL_USAGE_ERROR,"empty or unbalanced button / response code");
	return;
     }

   (void) SLreverse_stack (SLang_Num_Function_Args);

   if (-1 == pop_string_or_null (&title) ||
       -1 == pop_nullable (GtkWidget_Type, (void**)&parent_o, (void**)parent) ||
       -1 == SLang_pop_integer (&action))
     goto cleanup;

   while (nbutt)
     {
   	if (-1 == SLang_pop_slstring (&button [i]) || 
	    -1 == SLang_pop_integer (&respcode [i]))
	  {	     
	     if (button [i])
	       SLang_free_slstring (button [i]);
	     SLang_verror (SL_INTRINSIC_ERROR, "error popping button / response code pair");
	     break;
	  }
	nbutt -= 2;
	i ++;
	if (i > 2)
	  break;
   }
   retval = gtk_file_chooser_dialog_new (title, parent, action,
					 button [0], respcode [0], button [1], respcode [1], button [2], respcode [2], NULL);
   SLang_push_opaque (GtkWidget_Type, retval, 0);
   
cleanup:
   SLang_free_slstring (title);
   SLang_free_opaque (parent_o);   
}

static void sl_gtk_scale_button_new (void)
{
   int i;
   const gchar **icons = NULL;
   SLang_Array_Type *at;   
   GtkWidget* retval;
   GtkIconSize size;
   gdouble min, max, step;

   if (slgtk_usage_err (4, "GtkScaleButton = gtk_scale_button_new (GtkIconSize, double, double, double [, [string]])"))
     return;   
   if (SLang_Num_Function_Args == 5)
     {
	if (-1 == SLang_pop_array_of_type (&at, SLANG_STRING_TYPE))
	  return;
	icons = g_try_malloc ((at->num_elements + 1) * sizeof (gchar *));
	if (icons == NULL)
	  goto cleanup;
	for (i = 0 ; i < at->num_elements ; i ++)
	  icons [i] = (((char **) at->data) [i]);
	icons [i] = NULL;
     }
   if (-1 == SLang_pop_double ((double*) &step) ||
       -1 == SLang_pop_double ((double*) &max) ||
       -1 == SLang_pop_double ((double*) &min) ||
       -1 == SLang_pop_int ((int*) &size))
     goto cleanup;

   retval = gtk_scale_button_new (size, min, max, step, icons);
   SLang_push_opaque (GtkWidget_Type, retval, 0);
      
cleanup:
   g_free (icons);
   SLang_free_array (at);
}

static void sl_gtk_scale_button_set_icons (void)
{
   int i;
   const gchar **icons = NULL;
   SLang_Array_Type *at;
   GtkScaleButton* arg1;
   Slirp_Opaque* arg1_o = NULL;
   
   if (slgtk_usage_err (2, "gtk_scale_button_set_icons (GtkScaleButton, [string])"))
     return;

   if (-1 == SLang_pop_array_of_type (&at, SLANG_STRING_TYPE) ||
       -1 == SLang_pop_opaque(GtkWidget_Type, (void**)&arg1, &arg1_o))
     goto cleanup;

   icons = g_try_malloc ((at->num_elements + 1) * sizeof (gchar *));
   if (icons == NULL)
     goto cleanup;
   for(i = 0 ; i < at->num_elements ; i ++)
     icons [i] = (((char **) at->data) [i]);
   icons [i] = NULL;
   
   gtk_scale_button_set_icons (arg1, icons);

   g_free (icons);
   
cleanup:
   SLang_free_array (at);
   SLang_free_opaque(arg1_o);
}

static void sl_gtk_icon_theme_set_search_path (void)
{
   GtkIconTheme *theme;
   Slirp_Opaque* theme_o = NULL;
   SLang_Array_Type *at;
   
   if (slgtk_usage_err (2, "gtk_icon_theme_set_search_path (GtkIconTheme, [string])"))
     return;

   if (-1 == SLang_pop_array_of_type (&at, SLANG_STRING_TYPE) ||
       -1 == SLang_pop_opaque(GtkWidget_Type, (void**)&theme, &theme_o))
     goto cleanup;

   gtk_icon_theme_set_search_path (theme, (const char **) at->data, at->num_elements);

cleanup:
   SLang_free_array (at);
   SLang_free_opaque(theme_o);
}

static void sl_gtk_icon_theme_get_search_path (void)
{
   gchar **path;
   gint n;
   GtkIconTheme *theme;
   Slirp_Opaque* theme_o = NULL;
   SLang_Array_Type *at;
   
   if (slgtk_usage_err (1, "gtk_icon_theme_get_search_path (GtkIconTheme)"))
     return;

   if (-1 == SLang_pop_opaque(GtkWidget_Type, (void**)&theme, &theme_o))
     goto cleanup;

   gtk_icon_theme_get_search_path (theme, &path, &n);

   at = SLang_create_array (SLANG_STRING_TYPE, 0, path, &n, 1);
   if (at == NULL)
     goto cleanup;

   (void) SLang_push_array (at, 0);
   
cleanup:
   /* g_strfreev (path); */
   SLang_free_opaque(theme_o);
}

static void sl_gtk_icon_theme_get_icon_sizes (void)
{
   int n = 0;
   gchar *name;
   gint *sizes = NULL, i;
   GtkIconTheme *theme;
   Slirp_Opaque* theme_o = NULL;
   SLang_Array_Type *at = NULL;
   
   if (slgtk_usage_err (2, "[int] = gtk_icon_theme_get_icon_sizes (GtkIconTheme, string)"))
     return;

   if (-1 == SLang_pop_string ((gchar**) &name) ||
       -1 == SLang_pop_opaque(GtkWidget_Type, (void**)&theme, &theme_o))
     goto cleanup;

   sizes = gtk_icon_theme_get_icon_sizes (theme, name);

   for (i = 0 ; sizes [i]; i ++)
     n ++;

   at = SLang_create_array (SLANG_INT_TYPE, 0, NULL, &n, 1);
   if (at == NULL)
     goto cleanup;

   for (i = 0 ; sizes [i]; i ++)
     {
	if (-1 == SLang_set_array_element (at, &i, &sizes [i]))
	  goto cleanup;
     }
   
   (void) SLang_push_array (at, 0);

cleanup:
   g_free (sizes);
   SLang_free_array (at);
   SLang_free_opaque(theme_o);   
}

static void sl_gtk_drag_dest_set (void)
{
   GtkDestDefaults flags;
   GdkDragAction actions;
   GtkWidget *widget;
   Slirp_Opaque* widget_o = NULL;
   SLang_Array_Type *targets = NULL;
   
   if (slgtk_usage_err (4, "gtk_drag_dest_set (GtkWidget, GtkDestDefaults, [GtkTargetEntry], GdkDragAction"))
     return;
   
   if (-1 == SLang_pop_int ((int*) &actions))
     return;
   if (SLANG_NULL_TYPE == SLang_peek_at_stack ())
     {
	if (-1 == SLang_pop_null ())
	  return;
     }
   else
     {
	if (-1 == SLang_pop_array_of_type (&targets, GObject_Type))
	  return;
     }   
   if (-1 == SLang_pop_int ((int*) &flags))
     goto cleanup;
   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**)&widget, &widget_o))
     goto cleanup;

   if (targets != NULL)
     gtk_drag_dest_set (widget, flags, targets->data, targets->num_elements, actions);	
   else
     gtk_drag_dest_set (widget, flags, NULL, 0, actions);

   SLang_free_opaque (widget_o);

   return;
   
cleanup:
   SLang_free_array (targets);
}

static void sl_gtk_drag_source_set (void)
{
   GdkModifierType mask;
   GdkDragAction actions;
   GtkWidget *widget;
   Slirp_Opaque* widget_o = NULL;
   SLang_Array_Type *targets = NULL;
   
   if (slgtk_usage_err (4, "gtk_drag_source_set (GtkWidget, GdkModifierType, [GtkTargetEntry], GdkDragAction"))
     return;
   
   if (-1 == SLang_pop_int ((int*) &actions))
     return;
   if (SLANG_NULL_TYPE == SLang_peek_at_stack ())
     {
	if (-1 == SLang_pop_null ())
	  return;
     }
   else
     {
	if (-1 == SLang_pop_array_of_type (&targets, GObject_Type))
	  return;
     }   
   if (-1 == SLang_pop_int ((int*) &mask))
     goto cleanup;
   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**)&widget, &widget_o))
     goto cleanup;

   if (targets != NULL)
     gtk_drag_source_set (widget, mask, targets->data, targets->num_elements, actions);
   else
     gtk_drag_source_set (widget, mask, NULL, 0, actions);

   SLang_free_opaque (widget_o);
   
   return;
   
cleanup:
   SLang_free_array (targets);
}

static void sl_gtk_clipboard_set_can_store (void)
{
   GtkClipboard *widget;
   Slirp_Opaque* widget_o = NULL;
   SLang_Array_Type *targets = NULL;
   
   if (slgtk_usage_err (2, "gtk_clipboard_set_can_store (GtkClipboard, [GtkTargetEntry])"))
     return;

   if (SLANG_NULL_TYPE == SLang_peek_at_stack ())
     {
	if (-1 == SLang_pop_null ())
	  return;
     }
   else
     {	
	if (-1 == SLang_pop_array_of_type (&targets, GObject_Type))
	  return;
     }
   
   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**)&widget, &widget_o))
     goto cleanup;

   if (targets != NULL)
     gtk_clipboard_set_can_store (widget, targets->data, targets->num_elements);	
   else
     gtk_clipboard_set_can_store (widget, NULL, 0);      

   SLang_free_opaque(widget_o);

   return;
   
cleanup:
   SLang_free_array (targets);
}

static void sl_gtk_menu_attach_to_widget (void)
{
   GtkMenu *menu;
   Slirp_Opaque* menu_o = NULL;
   GtkWidget *widget;
   Slirp_Opaque* widget_o = NULL;

   if (slgtk_usage_err (2, "gtk_menu_attach_to_widget (GtkMenu, GtkWidget)"))
     return;

   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**)&widget, &widget_o) ||
       -1 == SLang_pop_opaque (GtkWidget_Type, (void**)&menu, &menu_o))
     goto cleanup;

   gtk_menu_attach_to_widget (menu, widget, NULL);

cleanup:
   SLang_free_opaque(menu_o);
   SLang_free_opaque(widget_o);
}

static void sl_gtk_recent_chooser_dialog_new (void)
{
   char *title, *cancel, *open;
   GtkWidget *retval;
   GtkWindow *parent = NULL;
   Slirp_Opaque* parent_o = NULL;

   if (slgtk_usage_err (2, "GtkWidget = gtk_recent_chooser_dialog_new (string, GtkWindow)"))
     return;

   if (-1 == SLang_pop_string ((char**) &open) ||
       -1 == SLang_pop_string ((char**) &cancel) ||
       -1 == pop_string_or_null (&title) ||
       -1 == pop_nullable (GtkWidget_Type, (void**)&parent_o, (void**)parent))
     goto cleanup;

   retval = gtk_recent_chooser_dialog_new (title, parent,
					   cancel, GTK_RESPONSE_CANCEL,
					   open, GTK_RESPONSE_ACCEPT,
					   NULL);
   
   (void) SLang_push_opaque (GtkWidget_Type, (void*) retval, 0);   

cleanup:
   SLang_free_slstring (title);
   SLang_free_slstring (cancel);
   SLang_free_slstring (open);
   SLang_free_opaque (parent_o);
}

static void sl_gtk_style_context_get (void)
{
   GParamSpec *pspec;
   GtkTextBuffer *textbuf = NULL;
   Slirp_Opaque *textbuf_o = NULL;  
   GtkTextTag *tag = NULL;
   GtkTextTagTable *table;
   GValue property_value = G_VALUE_INIT;
   char *property_name, *tag_name = NULL;
   unsigned int nprops = SLang_Num_Function_Args - 2;   
   
   if (slgtk_usage_err (2, "(...) = gtk_style_context_get (GtkStyleContext, GtkStateFlags, ...)"))
     return;

   if (nprops % 2 != 0)
     {
	SLdo_pop_n (SLang_Num_Function_Args);
	SLang_verror (SL_USAGE_ERROR, "unbalanced name/value property list");
	return;
     }

   (void) SLreverse_stack (SLang_Num_Function_Args);

   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&textbuf, &textbuf_o))
     return;
   if (-1 == pop_string_or_null (&tag_name))
     goto cleanup;

   tag = gtk_text_tag_new (tag_name);
   table = gtk_text_buffer_get_tag_table (textbuf);
   gtk_text_tag_table_add (table, tag);
   
   while (nprops)
     {
   	if (-1 == SLang_pop_slstring (&property_name))
   	  {
   	     g_object_unref (tag);
   	     tag = NULL;
   	     break;
   	  }
	pspec = g_object_class_find_property (G_OBJECT_GET_CLASS (tag), property_name);
	if (pspec == NULL)
	  {
	     g_message ("This object has no property named : %s", property_name);
	     g_object_unref (tag);
	     tag = NULL;
	     break;
	  }
	g_value_init (&property_value, G_PARAM_SPEC_VALUE_TYPE (pspec));
	if (-1 == slgtk_pop_g_value (&property_value))
	  {
	     g_message ("Can't pop value for property named : %s", property_name);
	     g_value_unset (&property_value);
	     break;
	  }	
	g_object_set_property (G_OBJECT (tag), property_name, &property_value);
	g_value_unset (&property_value);
	SLang_free_slstring (property_name);
	nprops -= 2;
   }
   
   if (tag == NULL)
     SLang_push_null();
   else
     SLang_push_opaque (GObject_Type, tag, 0);

cleanup:
   SLang_free_opaque (textbuf_o);   
   SLang_free_slstring(tag_name);   
}

/* }}} */

static void sl_gtk_gesture_multi_press_get_area (void)
{
   gboolean retval;
   GtkGestureMultiPress* arg1;
   Slirp_Opaque* arg1_o = NULL;
   GdkRectangle* arg2 = (GdkRectangle*) alloca(sizeof(GdkRectangle));

   if (slgtk_usage_err (1, "GdkRectangle = gtk_gesture_multi_press_get_area (GtkGestureMultiPress)"))
     return;

   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&arg1, &arg1_o))
     return;
   
   retval = gtk_gesture_multi_press_get_area (arg1, arg2);
   
   if (retval)
     (void) SLang_push_cstruct ((VOID_STAR) arg2, GdkRectangle_Layout);
   else
     (void) SLang_push_null ();

   SLang_free_opaque(arg1_o);
}

static void sl_gtk_scrollable_get_border (void)
{   
   gboolean retval;
   GtkScrollable* arg1;
   Slirp_Opaque* arg1_o = NULL;
   GtkBorder* arg2 = (GtkBorder*) alloca(sizeof(GtkBorder));

   if (slgtk_usage_err (1, "GtkBorder = gtk_scrollable_get_border (GtkScrollable)"))
     return;
   
   if (-1 == SLang_pop_opaque(GObject_Type, (void**)&arg1, &arg1_o))
     return;
   
   retval = gtk_scrollable_get_border (arg1, arg2);
   if (retval)
     (void) SLang_push_cstruct ((VOID_STAR) arg2, GtkBorder_Layout);
   else
     (void) SLang_push_null ();

   SLang_free_opaque(arg1_o);
}

/* Intrinsic function and variable tables {{{ */

static SLang_Intrin_Fun_Type GtkWidget_Funcs[] =
{
   MAKE_INTRINSIC_0("gdk_pixbuf_animation_iter_get_pixbuf",sl_gdk_pixbuf_animation_iter_get_pixbuf,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_dialog_new_with_buttons",sl_gtk_dialog_new_with_buttons,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_dialog_add_buttons",sl_gtk_dialog_add_buttons,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_info_bar_new_with_buttons",sl_gtk_info_bar_new_with_buttons,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_info_bar_add_buttons",sl_gtk_info_bar_add_buttons,SLANG_VOID_TYPE),
#ifdef GDK_AVAILABLE_IN_3_8
   MAKE_INTRINSIC_0("gtk_widget_add_tick_callback",sl_gtk_widget_add_tick_callback,SLANG_UINT_TYPE),
#endif
   MAKE_INTRINSIC_0("gtk_clipboard_request_text",sl_gtk_clipboard_request_text,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_sortable_set_default_sort_func",sl_gtk_tree_sortable_set_default_sort_func,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_combo_box_set_row_separator_func",sl_gtk_combo_box_set_row_separator_func,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_widget_destroy",sl_gtk_widget_destroy,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_main_quit",sl_gtk_main_quit,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_container_foreach",sl_gtk_container_foreach,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_container_forall",sl_gtk_container_forall,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_container_child_get_property",sl_gtk_container_child_get_property,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_container_child_set_property",sl_gtk_container_child_set_property,SLANG_VOID_TYPE),
   /* MAKE_INTRINSIC_0("gtk_menu_popup",sl_gtk_menu_popup,SLANG_VOID_TYPE), */
   MAKE_INTRINSIC_0("gtk_message_dialog_new",sl_gtk_message_dialog_new,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_message_dialog_new_with_markup",sl_gtk_message_dialog_new_with_markup,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_message_dialog_format_secondary_text", sl_gtk_message_dialog_format_secondary_text,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_message_dialog_format_secondary_markup", sl_gtk_message_dialog_format_secondary_markup,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_print_settings_get_page_ranges", sl_gtk_print_settings_get_page_ranges,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_print_settings_set_page_ranges", sl_gtk_print_settings_set_page_ranges,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_print_job_get_page_ranges", sl_gtk_print_job_get_page_ranges,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_print_job_set_page_ranges", sl_gtk_print_job_set_page_ranges,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_file_chooser_dialog_new", sl_gtk_file_chooser_dialog_new,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_recent_chooser_dialog_new", sl_gtk_recent_chooser_dialog_new,SLANG_VOID_TYPE),   
   MAKE_INTRINSIC_0("gtk_scale_button_new", sl_gtk_scale_button_new,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_scale_button_set_icons", sl_gtk_scale_button_set_icons,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_style_context_get",sl_gtk_style_context_get,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_icon_size_lookup",sl_gtk_icon_size_lookup,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_icon_theme_set_search_path", sl_gtk_icon_theme_set_search_path,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_icon_theme_get_search_path", sl_gtk_icon_theme_get_search_path,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_icon_theme_get_icon_sizes", sl_gtk_icon_theme_get_icon_sizes,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_icon_view_get_item_at_pos", sl_gtk_icon_view_get_item_at_pos,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_icon_view_get_cursor", sl_gtk_icon_view_get_cursor,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_icon_view_get_drag_dest_item", sl_gtk_icon_view_get_drag_dest_item,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_icon_view_get_dest_item_at_pos", sl_gtk_icon_view_get_dest_item_at_pos,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_icon_view_get_cell_rect",sl_gtk_icon_view_get_cell_rect,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_drag_dest_set", sl_gtk_drag_dest_set,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_drag_source_set", sl_gtk_drag_source_set,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_clipboard_set_can_store", sl_gtk_clipboard_set_can_store,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_menu_attach_to_widget", sl_gtk_menu_attach_to_widget,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_recent_info_get_application_info", sl_gtk_recent_info_get_application_info,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("_is_callable",is_callable,SLANG_INT_TYPE),
   MAKE_INTRINSIC_0("_toggle_error_hook",toggle_error_hook,SLANG_VOID_TYPE),   
   /* MAKE_INTRINSIC_0("",sl_,SLANG_VOID_TYPE), */
   SLANG_END_INTRIN_FUN_TABLE
};

static SLang_Intrin_Fun_Type GObject_Funcs[] =
{
   MAKE_INTRINSIC_0("gtk_gesture_multi_press_get_area",sl_gtk_gesture_multi_press_get_area,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_scrollable_get_border",sl_gtk_scrollable_get_border,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_text_buffer_create_tag", sl_gtk_text_buffer_create_tag,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_text_buffer_insert_with_tags", sl_gtk_text_buffer_insert_with_tags,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_text_buffer_insert_with_tags_by_name", sl_gtk_text_buffer_insert_with_tags_by_name,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_view_get_cursor", sl_gtk_tree_view_get_cursor, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_view_get_visible_range", sl_gtk_tree_view_get_visible_range, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_view_column_new_with_attributes",
		    sl_gtk_tree_view_column_new_with_attributes,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_view_insert_column_with_attributes",
		    sl_gtk_tree_view_insert_column_with_attributes, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_list_store_set", sl_gtk_list_store_set,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_list_store_set_value", sl_gtk_list_store_set_value,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_iter_new", sl_gtk_tree_iter_new,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_list_store_append", sl_gtk_list_store_append, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_list_store_prepend", sl_gtk_list_store_prepend, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_list_store_insert", sl_gtk_list_store_insert, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_path_get_indices", sl_gtk_tree_path_get_indices, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_path_new_from_indices", sl_gtk_tree_path_new_from_indices, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_store_new", sl_gtk_tree_store_new, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_store_set", sl_gtk_tree_store_set,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_store_set_value", sl_gtk_tree_store_set_value,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_store_append", sl_gtk_tree_store_append, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_store_prepend", sl_gtk_tree_store_prepend, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_store_insert", sl_gtk_tree_store_insert, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_store_insert_before", sl_gtk_tree_store_insert_before, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_store_insert_after", sl_gtk_tree_store_insert_after, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_model_get_value", sl_gtk_tree_model_get_value, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_model_get", sl_gtk_tree_model_get, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_model_rows_reordered", sl_gtk_tree_model_rows_reordered, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_model_filter_set_modify_func",sl_gtk_tree_model_filter_set_modify_func,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_model_filter_set_visible_func",sl_gtk_tree_model_filter_set_visible_func,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_view_column_set_cell_data_func",sl_gtk_tree_view_column_set_cell_data_func,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_cell_layout_set_attributes", sl_gtk_cell_layout_set_attributes, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_cell_layout_set_cell_data_func", sl_gtk_cell_layout_set_cell_data_func, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_builder_get_objects", sl_gtk_builder_get_objects, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_builder_add_callback_symbol",sl_gtk_builder_add_callback_symbol,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_builder_add_callback_symbols",sl_gtk_builder_add_callback_symbols,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_builder_connect_signals",sl_gtk_builder_connect_signals,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gtk_tree_selection_get_selected", sl_gtk_tree_selection_get_selected, SLANG_VOID_TYPE),
   /* MAKE_INTRINSIC_0("",sl_,SLANG_VOID_TYPE), */
   SLANG_END_INTRIN_FUN_TABLE
};

static SLang_IConstant_Type Generic_IConsts [] =
{
   MAKE_ICONSTANT("TRUE", TRUE),
   MAKE_ICONSTANT("FALSE", FALSE),
   MAKE_ICONSTANT("G_SOURCE_CONTINUE", TRUE),
   MAKE_ICONSTANT("G_SOURCE_REMOVE", FALSE),
   SLANG_END_ICONST_TABLE
};

static SLang_Intrin_Var_Type Global_Intrin_Vars[] =
{
   MAKE_VARIABLE("_gtk3_module_version", &slgtk3_version, SLANG_UINT_TYPE, 1),
   MAKE_VARIABLE("_gtk3_module_version_string", &slgtk3_version_string,SLANG_STRING_TYPE, 1),
   SLANG_END_INTRIN_VAR_TABLE
};

static SLang_Intrin_Var_Type Local_Intrin_Vars[] =
{
   MAKE_VARIABLE("_slgtk3_debug", &slgtk_debug,SLANG_INT_TYPE,0),
   MAKE_VARIABLE("_gtk3_version", &_gtk3_version,SLANG_INT_TYPE,1),
   SLANG_END_INTRIN_VAR_TABLE
};

/* }}} */

/* Module initialization {{{ */

static int init_sl_gtk(SLang_NameSpace_Type *ns)
{
   slgtk_patch_ftable(gtk3_Funcs, DUMMY_TYPE, GtkWidget_Type);
   slgtk_patch_ftable(GtkWidget_Funcs, DUMMY_TYPE, GtkWidget_Type);
   slgtk_patch_ftable(GObject_Funcs, DUMMY_TYPE, GObject_Type);

   if (-1 == SLns_add_intrin_fun_table (ns, gtk3_Funcs, "__GTK3__"))
	return -1;

   if (-1 == SLns_add_intrin_fun_table (ns, GtkWidget_Funcs, NULL))
	return -1;

   if (-1 == SLns_add_intrin_fun_table (ns, GObject_Funcs, NULL))
	return -1;

   if (-1 == SLns_add_iconstant_table (ns, Generic_IConsts, NULL)
       || -1 == SLns_add_iconstant_table (ns, gtk3_IConsts, NULL)
       || -1 == SLns_add_lconstant_table (ns, gtk3_LConsts, NULL)
       || -1 == SLns_add_dconstant_table (ns, gtk3_DConsts, NULL))
     return -1;

#ifdef __CYGWIN__
   _gtk_major_version = gtk_major_version;
   _gtk_minor_version = gtk_minor_version;
   _gtk_micro_version = gtk_micro_version;
#endif

   if (-1 == SLns_add_intrin_var_table (ns, Local_Intrin_Vars, NULL)
       || -1 == SLns_add_intrin_var_table (ns, gtk3_IVars, NULL))
     return -1;
   
   /* Unlike above, where we load the various intrinsics into the */
   /* given namespace, here we add them to the global namespace   */
   if (SLang_is_defined("Global->_gtk_module_version") == 0 &&
	SLadd_intrin_var_table (Global_Intrin_Vars, NULL) == -1)
	return -1;

#ifdef SLGTK_STATIC_MODULE
   if (SLdefine_for_ifdef ((char*)"GTK_MODULE_STATIC_BINARY") != 0)
	return -1;
#endif

   slgtk_debug = 0;
   return 0;
}

SLANG_MODULE(gtk3);
int init_gtk3_module_ns(char *ns_name)
{
   int argc = 1;
   static char *ARGV[2] = { MODULE_NAME, NULL};
   char **argv = ARGV;
   SLang_NameSpace_Type *ns = NULL;

   if (slang_abi_mismatch()) return -1;

   if (SLang_is_defined("min") == 0) {
	if (SLang_init_array_extra() == -1)
	   return -1;
   }

   if (ns_name != NULL) {
	ns = SLns_create_namespace (ns_name);
	if (ns == NULL || (slns = SLmalloc(strlen(ns_name)+1)) == NULL)
	   return -1;
   }

   /* slirp_debug_pause(MODULE_NAME); */
   
   if (!GtkOpaque_Type) {			/* Already initialized */

      /* Support lite module testing w/out connecting to display system */
      /* int needs_display = getenv("SLGTK_NO_DISPLAY") == NULL; */
      
      if (allocate_reserved_opaque_types() == -1 ||
	  allocate_gtk3_opaque_types() == -1)
	return -1;

      /* FIXME: is this still necessary? */
      /* putenv("GTK_IM_MODULE_FILE=/dev/null"); */
      
      /* if (gtk_init_check(&argc,&argv) != TRUE && needs_display) { */
      /* 	 SLang_verror(SL_INTRINSIC_ERROR, "could not initialize Gtk (check $DISPLAY, etc)"); */
      /* 	 return -1;  */
      /* } */      
      
      if (gtk_init_check (&argc,&argv) != TRUE)
	{
	   SLang_verror (SL_INTRINSIC_ERROR, "could not initialize Gtk");
	   return -1; 	     
	}
   }
   
   /* Initialize each subsystem */
   if (init_sl_glib(ns) == -1)
     return -1;
   
   if (init_sl_pango(ns) == -1)
      return -1;

   if (init_sl_gdk(ns) == -1)
      return -1;

   if (init_sl_gdkpixbuf(ns) == -1)
      return -1;

   if (init_sl_gtk(ns) == -1)
      return -1;

   if ( gtk_major_version != GTK_MAJOR_VERSION ||
	gtk_minor_version != GTK_MINOR_VERSION ||
	gtk_micro_version != GTK_MICRO_VERSION)
	fprintf(stderr, "Warning: SLgtk3 compiled with Gtk %d.%d.%d but runtime linked to version %d.%d.%d\n",
		GTK_MAJOR_VERSION, GTK_MINOR_VERSION, GTK_MICRO_VERSION,
		gtk_major_version, gtk_minor_version, gtk_micro_version);

	  return 0;
}
/* }}} */
