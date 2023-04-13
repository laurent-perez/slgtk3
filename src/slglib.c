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
#include "gtk/gtk.h"

static const unsigned int _glib_version = 10000 * GLIB_MAJOR_VERSION +
  100 * GLIB_MINOR_VERSION + GLIB_MICRO_VERSION;

/* S-Lang structure handling {{{ */

SLang_CStruct_Field_Type GParamSpec_Layout [] =
{
  MAKE_CSTRUCT_FIELD(GParamSpec,g_type_instance,"g_type_instance", SLANG_STRUCT_TYPE,0),
  MAKE_CSTRUCT_FIELD(GParamSpec,name,"name",SLANG_STRING_TYPE,0),
  MAKE_CSTRUCT_FIELD(GParamSpec,flags,"flags",SLANG_INT_TYPE,0),
  MAKE_CSTRUCT_FIELD(GParamSpec,value_type,"value_type",SLANG_ULONG_TYPE,0),
  MAKE_CSTRUCT_FIELD(GParamSpec,owner_type,"owner_type",SLANG_ULONG_TYPE,0),
  MAKE_CSTRUCT_FIELD(GParamSpec,_nick,"_nick",SLANG_STRING_TYPE,0),
  MAKE_CSTRUCT_FIELD(GParamSpec,_blurb,"_blurb",SLANG_STRING_TYPE,0),
  MAKE_CSTRUCT_FIELD(GParamSpec,qdata,"qdata", SLANG_DATATYPE_TYPE,0),
  MAKE_CSTRUCT_FIELD(GParamSpec,ref_count,"ref_count",SLANG_UINT_TYPE,0),
  MAKE_CSTRUCT_FIELD(GParamSpec,param_id,"param_id",SLANG_UINT_TYPE,0),
  SLANG_END_CSTRUCT_TABLE
};

/* deprecated but still needed in gdk-pixbuf-animation.h */
SLang_CStruct_Field_Type GTimeVal_Layout[] =
{
  MAKE_CSTRUCT_FIELD(GTimeVal, tv_sec, "tv_sec", SLANG_LONG_TYPE, 0),
  MAKE_CSTRUCT_FIELD(GTimeVal, tv_usec, "tv_usec", SLANG_LONG_TYPE, 0),
  SLANG_END_CSTRUCT_TABLE
};

SLang_CStruct_Field_Type GActionEntry_Layout [] =
{
   MAKE_CSTRUCT_FIELD(GActionEntry, name, "name", SLANG_STRING_TYPE,0),
   MAKE_CSTRUCT_FIELD(GActionEntry, activate, "activate", SLANG_REF_TYPE,0),
   MAKE_CSTRUCT_FIELD(GActionEntry, parameter_type, "parameter_type", SLANG_STRING_TYPE,0),
   MAKE_CSTRUCT_FIELD(GActionEntry, state, "state", SLANG_STRING_TYPE,0),
   MAKE_CSTRUCT_FIELD(GActionEntry, change_state, "change_state", SLANG_REF_TYPE,0),
   SLANG_END_CSTRUCT_TABLE
};

/* borrowed from sltime.c */
SLang_CStruct_Field_Type TM_Struct [] =
{
   MAKE_CSTRUCT_INT_FIELD(struct tm, tm_sec, "tm_sec", 0),
   MAKE_CSTRUCT_INT_FIELD(struct tm, tm_min, "tm_min", 0),
   MAKE_CSTRUCT_INT_FIELD(struct tm, tm_hour, "tm_hour", 0),
   MAKE_CSTRUCT_INT_FIELD(struct tm, tm_mday, "tm_mday", 0),
   MAKE_CSTRUCT_INT_FIELD(struct tm, tm_mon, "tm_mon", 0),
   MAKE_CSTRUCT_INT_FIELD(struct tm, tm_year, "tm_year", 0),
   MAKE_CSTRUCT_INT_FIELD(struct tm, tm_wday, "tm_wday", 0),
   MAKE_CSTRUCT_INT_FIELD(struct tm, tm_yday, "tm_yday", 0),
   MAKE_CSTRUCT_INT_FIELD(struct tm, tm_isdst, "tm_isdst", 0),
   SLANG_END_CSTRUCT_TABLE
};

/* }}} */


/* GValue handling {{{ */

int slgtk_push_g_value (const GValue *arg)
{
   switch (G_TYPE_FUNDAMENTAL (G_VALUE_TYPE (arg)))
     {
      case G_TYPE_CHAR:
	return SLang_push_char (g_value_get_schar (arg));
	break;

      case G_TYPE_UCHAR:
	return SLang_push_uchar (g_value_get_uchar (arg));
	break;

      case G_TYPE_BOOLEAN:
	return SLang_push_integer (g_value_get_boolean (arg));
	break;

      case G_TYPE_ENUM:
	return SLang_push_integer (g_value_get_enum (arg));
	break;

      case G_TYPE_FLAGS:
	return SLang_push_uinteger (g_value_get_flags (arg));
	break;

      case G_TYPE_INT:
	return SLang_push_integer (g_value_get_int (arg));
	break;

      case G_TYPE_UINT:
	return SLang_push_uinteger (g_value_get_uint (arg));
	break;

      case G_TYPE_LONG:
      case G_TYPE_INT64:
	return SLang_push_long (g_value_get_long (arg));
	break;

      case G_TYPE_ULONG:
      case G_TYPE_UINT64:
	return SLang_push_ulong (g_value_get_ulong (arg));
	break;

      case G_TYPE_FLOAT:
	return SLang_push_float (g_value_get_float (arg));
	break;

      case G_TYPE_DOUBLE:
	return SLang_push_double (g_value_get_double (arg));
	break;

      case G_TYPE_STRING:
	return SLang_push_string ((char*) g_value_get_string (arg));
	break;

      case G_TYPE_OBJECT:
	return SLang_push_opaque (GObject_Type, g_value_get_object (arg), 0);
	break;

      case G_TYPE_BOXED:
	return slgtk_push_boxed (arg);
	break;

      case G_TYPE_PARAM:
	return SLang_push_opaque (GtkOpaque_Type, g_value_get_param (arg), 0);
	break;

      case G_TYPE_POINTER:
	return SLang_push_opaque (GtkOpaque_Type, g_value_get_pointer (arg), 0);
	break;

      default:
	if (slgtk_debug > 0) 
	  fprintf (stderr, "WARNING: GValue type <%s> ignored (push_g_value)\n",
		   G_VALUE_TYPE_NAME (arg));
	return -1;
     }
}

static int push_g_values (const GValue *args, int nargs)
{
   int i;

   for (i = 0 ; i < nargs ; i ++)
     {
	if (slgtk_push_g_value ((const GValue *) args + i) != 0)
	  return -1;
     }

   return 0;
}

int slgtk_pop_g_value (GValue *arg)
{
   if (G_VALUE_TYPE (arg) == GDK_TYPE_PIXBUF)
     {
	GdkPixbuf *pixbuf;
	Slirp_Opaque* pixbuf_o = NULL;
	
	if (-1 == SLang_pop_opaque (GdkPixbuf_Type, (void**) &pixbuf, &pixbuf_o))
	  return -1;
	g_value_set_object (arg, pixbuf);
	SLang_free_opaque (pixbuf_o);
	/* g_object_unref (pixbuf); */
	return 0;
     }

   switch (G_TYPE_FUNDAMENTAL (G_VALUE_TYPE (arg))) {

    case G_TYPE_STRING:
	{
	   void *v;
	   if (pop_nullable (SLANG_STRING_TYPE, &v, NULL) == -1)
	     return -1;
	   g_value_set_string (arg, (const char*) v);
	}
      break;

    case G_TYPE_CHAR:
	{
	   char c;
	   if (SLang_pop_char (&c) == -1)
	     return -1;
	   g_value_set_schar (arg,c);
	}
      break;

    case G_TYPE_UCHAR:
	{
	   unsigned char uc;
	   if (SLang_pop_uchar (&uc) == -1)
	     return -1;
	   g_value_set_uchar (arg,uc);
	}
      break;

    case G_TYPE_BOOLEAN:
	{
	   int b;
	   if (SLang_pop_integer (&b) == -1)
	     return -1;
	   g_value_set_boolean (arg, b);
	}
      break;

    case G_TYPE_ENUM:
	{	   
	   int i;
	   if (SLang_pop_integer (&i) == -1)
	     return -1;
	   g_value_set_enum (arg, i);
	}
      break;

    case G_TYPE_FLAGS:
	{	   
	   unsigned int ui;
	   if (SLang_pop_uinteger (&ui) == -1)
	     return -1;
	   g_value_set_flags (arg, ui);
	}
      break;
      
    case G_TYPE_INT:
	{
	   int i;
	   if (SLang_pop_integer (&i) == -1)
	     return -1;
	   g_value_set_int (arg, i);
	}
      break;

    case G_TYPE_UINT:
	{
	   unsigned int ui;
	   if (SLang_pop_uinteger (&ui) == -1)
	     return -1;
	   g_value_set_uint (arg, ui);
	}
      break;

    case G_TYPE_LONG:
    	{
	   long l;
	   if (SLang_pop_long(&l) == -1)
    	   return -1;
	   g_value_set_long (arg, l);
	}
      break;

    case G_TYPE_ULONG:
	{
	   unsigned long ul;
	   if (SLang_pop_ulong (&ul) == -1)
	     return -1;
	   g_value_set_ulong (arg, ul);
	}
      break;

    case G_TYPE_FLOAT:
	{
	   float f;
	   if (SLang_pop_float (&f) == -1)
	     return -1;
	   g_value_set_float (arg, f);
	}
      break;

    case G_TYPE_DOUBLE:
	{
	   double d;
	   if (SLang_pop_double (&d) == -1)
	     return -1;
	   g_value_set_double (arg, d);
	}
      break;
      
    case G_TYPE_INTERFACE:
     {
	GObject *obj;
	Slirp_Opaque *obj_o = NULL;
	if (-1 == SLang_pop_opaque (GObject_Type, (void**) &obj, &obj_o))
    	  return -1;
    	g_value_set_object (arg, obj);
    	SLang_free_opaque (obj_o);
    	break;
     }

    default:
      g_message ("Can't pop GValue of type %ld for %s",
		 G_TYPE_FUNDAMENTAL (G_VALUE_TYPE (arg)),
		 G_VALUE_TYPE_NAME (arg));
      if (slgtk_debug > 0) 
	fprintf (stderr, "WARNING: GValue type of <%s> ignored (g_value_pop_arg)\n",
		 G_VALUE_TYPE_NAME (arg));
      return -1;
  }
  return 0;
}
/*  }}} */

/* Signal callbacks {{{ */

/* all this callback stuff has been borrowed to SLgtk */

struct _slGClosure
{
   GClosure closure;
   SLang_Name_Type *function;
   SLang_Any_Type **args;	/* func args passd in from S-Lang scope */
   unsigned int  nargs;		/* how many of them? */
   void *swap_data;		/* for _swapped signal connection calls */
};

typedef struct _slGClosure slGClosure;

static void slg_closure_marshal (GClosure *closure, /*{{{*/
				 GValue *return_value,
				 guint n_param_values,
				 const GValue *param_values,
				 gpointer invocation_hint,
				 gpointer marshal_data)
{
   slGClosure *pcl;
   unsigned int i;

   (void) invocation_hint; (void) marshal_data;
   pcl = (slGClosure*)closure;

   if (SLang_start_arg_list() == -1)
	return;

   if (pcl->swap_data) {
      (void) push_g_values(param_values+1,n_param_values-1);
      /* !!! needs failure check */
      SLang_push_anytype((SLang_Any_Type *)pcl->swap_data);
   }
   else
      (void) push_g_values(param_values, n_param_values);

   /* !!! needs failure check */
   for (i = 0; i < pcl->nargs; i++)
	(void)SLang_push_anytype(pcl->args[i]);

   if (SLang_end_arg_list() == -1) {
      SLdo_pop_n(n_param_values + pcl->nargs);
      return;
   }

   (void) SLexecute_function(pcl->function);

   /* Unrecoverable S-Lang errors should not cause main loop to hang */
   if (SLang_get_error() < 0) {
	slgtk_error_terminate_main_loop(pcl->function->name);
	return;
   }

   if (SLang_get_error()) {
      SLang_restart(0);
      SLang_set_error(0);
      return;
   }

   if (return_value && G_IS_VALUE(return_value))
     if (slgtk_pop_g_value(return_value) == -1 || SLang_get_error() < 0) {
	char msg[192];
	strcpy(msg,"could not pop expected return value from: ");
	strncat(msg,pcl->function->name,
		(size_t) MIN(strlen(pcl->function->name),192-strlen(msg)-1));
	slgtk_error_terminate_main_loop(msg);
     }
} /*}}}*/

static void slg_closure_destroy(gpointer data, GClosure *cl) /*{{{*/
{
   unsigned int i;
   slGClosure *pcl = (slGClosure*)cl;

   (void) data;

   /* we need to check if data have already been freed */
   /* as the same data may be used by many functions */
   /* see : 'gtk_builder_connect_signals' */ 
   if (data != NULL)
     {	  
	for (i=0; i < pcl->nargs; i++)
	  SLang_free_anytype(pcl->args[i]);
	
	SLfree((char*)pcl->args);
	
	data = NULL;
     }
                 
   if (pcl->swap_data != NULL)
     SLang_free_anytype((SLang_Any_Type *)pcl->swap_data);
   
   SLang_free_function(pcl->function);
} /*}}}*/

GClosure* slgtk_closure_new(SLang_Name_Type *function,  /*{{{*/
	SLang_Any_Type **args, unsigned int nargs, SLang_Any_Type *swap_data)
{
   GClosure *closure;

   closure = g_closure_new_simple( sizeof(slGClosure), NULL);
   g_closure_add_finalize_notifier(closure, NULL, slg_closure_destroy);
   g_closure_set_marshal(closure, slg_closure_marshal);
   ((slGClosure*)closure)->function = function;
   ((slGClosure*)closure)->swap_data = swap_data;
   ((slGClosure*)closure)->args = args;
   ((slGClosure*)closure)->nargs = nargs;
   
  return closure;
} /*}}}*/

int slgtk_extract_slang_args(unsigned int nargs, SLang_Any_Type ***pargs) /*{{{*/
{
   SLang_Any_Type **args;
   SLang_Any_Type *arg;
   unsigned int narg;

   if (nargs <= 0) {
	*pargs = NULL;
	return 0;
   }

   args = (SLang_Any_Type**) SLmalloc(SIZEOF_POINTER*nargs);
   narg = nargs;
   while (narg) {
	if (pop_anytype_or_null(&arg) == -1) {
	   while (nargs > narg)
		SLang_free_anytype(args[--nargs]);
	   SLfree((char*)args);
	   return -1;
	}
	args[--narg] = arg;

   }
   *pargs = args;
   return 0;
} /*}}}*/

void slgtk_free_slang_args(unsigned int nargs, SLang_Any_Type **args) /*{{{*/
{
   while (nargs > 0)
	SLang_free_anytype(args[--nargs]);
   SLfree((char*)args);
} /*}}}*/

static void sig_conn_generic(gboolean after, char *usg) /*{{{*/
{
   GObject *obj ;
   Slirp_Opaque *obj_o = NULL;
   int  connid = -1;
   SLang_Any_Type **args;
   SLang_Name_Type *function;
   char *signame = NULL;
   SLang_Ref_Type *function_ref = NULL;
   unsigned int nargs;

   if (slgtk_usage_err(3, usg))
     return;

   nargs = SLang_Num_Function_Args - 3;
   if (slgtk_extract_slang_args(nargs,&args) == -1)
     goto cleanup;

   if ( -1 == SLang_pop_ref(&function_ref) ||
	-1 == SLang_pop_slstring(&signame) ||
	-1 == SLang_pop_opaque( GObject_Type, (void**)&obj, &obj_o))
     goto cleanup;

   if ( (function = SLang_get_fun_from_ref(function_ref)))
     connid = g_signal_connect_closure(obj, signame,
				       slgtk_closure_new(function,args,nargs,NULL), after);

cleanup:

   if (connid <= 0)
     SLang_verror(SL_INTRINSIC_ERROR,"could not connect signal");

   SLang_free_ref(function_ref);
   SLang_free_opaque(obj_o);
   SLang_free_slstring(signame);
   SLang_push_integer(connid);
} /*}}}*/

static void sl_g_signal_connect(void) /*{{{*/
{
   sig_conn_generic(0,"id = g_signal_connect(GObject,string,function_ref,...)");
} /*}}}*/

static void sl_g_signal_connect_after(void) /*{{{*/
{
   sig_conn_generic(1, "id = g_signal_connect_after(GObject,string,function_ref,...)");
} /*}}}*/

static void sl_g_signal_connect_swapped(void) /*{{{*/
{
   int  connid = -1;
   GObject *obj;
   Slirp_Opaque *obj_o = NULL;
   char *signame = NULL;
   SLang_Any_Type *data;
   SLang_Any_Type **args;
   SLang_Name_Type *function;
   SLang_Ref_Type *function_ref = NULL;
   unsigned int nargs;

   if (slgtk_usage_err(4, "id = g_signal_connect_swapped(GObject,string,function_ref,data,...)"))
     return;

   nargs = SLang_Num_Function_Args - 4;
   if (slgtk_extract_slang_args(nargs,&args) == -1)
     goto cleanup;

   if ( -1 == pop_anytype_or_null(&data)   ||
	-1 == SLang_pop_ref(&function_ref) ||
	-1 == SLang_pop_slstring(&signame) ||
	-1 == SLang_pop_opaque( GObject_Type, (void**)&obj, &obj_o))
     goto cleanup;


   if ( (function = SLang_get_fun_from_ref(function_ref)))
     connid = g_signal_connect_closure(obj, signame,
				       slgtk_closure_new(function,args,nargs,data),FALSE);

cleanup:

   if (connid <= 0)
     SLang_verror(SL_INTRINSIC_ERROR,"could not connect signal");

   SLang_free_ref(function_ref);
   SLang_free_opaque(obj_o);
   SLang_free_slstring(signame);
   SLang_push_integer(connid);
} /*}}}*/

/* !!! currently ignores sig hdlr args */
static void sl_g_signal_emit_by_name(Slirp_Opaque *obj, char *name)
{
   g_signal_emit_by_name(obj->instance,name);
}
/* }}} */

/* Timeout & idle callbacks {{{ */

static unsigned int sl_g_timeout_add (void)
{
   slGFunction *f = NULL;
   guint interval;
   
   if (slgtk_usage_err (2, "uint = g_timeout_add (uint, func_ref, args...)"))
     return 0;
   
   if ((f = function_pop (1)) == NULL ||
       -1 == SLang_pop_uint (&interval))       
     goto cleanup;

   return g_timeout_add_full (G_PRIORITY_DEFAULT, interval,
			      (GSourceFunc) function_marshaller, f, function_destroy);
   
cleanup:
   function_destroy (f);
   return 0;
}

/* deprecated */
/* static void sl_g_source_get_current_time (void) */
/* { */
/*    GSource *src; */
/*    Slirp_Opaque *src_o = NULL; */
/*    GTimeVal tv; */

/*    if (slgtk_usage_err (1, "GTimeVal = g_source_get_current_time (GSource)")) */
/*      return; */

/*    if (-1 == SLang_pop_opaque (GSource_Type, (void**) &src, &src_o)) */
/*      goto cleanup; */

/*    g_source_get_current_time (src, &tv); */

/*    (void) SLang_push_cstruct ((VOID_STAR) &tv, GTimeVal_Layout); */

/* cleanup:    */
/*    SLang_free_opaque (src_o); */
/* } */

static unsigned int sl_g_timeout_add_seconds (void)
{
   slGFunction *f = NULL;
   guint interval;
   
   if (slgtk_usage_err (2, "uint = g_timeout_add_seconds (uint, func_ref, args...)"))
     return 0;
   
   if ((f = function_pop (1)) == NULL ||
       -1 == SLang_pop_uint (&interval))       
     goto cleanup;

   return g_timeout_add_seconds_full (G_PRIORITY_DEFAULT, interval,
				      (GSourceFunc) function_marshaller, f, function_destroy);
   
cleanup:
   function_destroy (f);
   return 0;
}

static unsigned int sl_g_timeout_add_priority (void)
{
   slGFunction *f = NULL;
   guint interval;
   gint priority;
   
   if (slgtk_usage_err (4, "uint = g_timeout_add_priority (int, uint, func_ref, args...)"))
     return 0;
   
   if ((f = function_pop (2)) == NULL ||
       -1 == SLang_pop_uint (&interval) ||
       -1 == SLang_pop_int (&priority))
     goto cleanup;

   return g_timeout_add_full (priority, interval, (GSourceFunc) function_marshaller, f, function_destroy);
   
cleanup:
   function_destroy (f);
   return 0;
}

static unsigned int sl_g_timeout_add_seconds_priority (void)
{
   slGFunction *f = NULL;
   guint interval;
   gint priority;
   
   if (slgtk_usage_err (4, "uint = g_timeout_add_seconds_priority (int, uint, func_ref, args...)"))
     return 0;
   
   if ((f = function_pop (2)) == NULL ||
       -1 == SLang_pop_uint (&interval) ||
       -1 == SLang_pop_int (&priority))
     goto cleanup;

   return g_timeout_add_seconds_full (priority, interval,
				      (GSourceFunc) function_marshaller, f, function_destroy);
   
cleanup:
   function_destroy (f);
   return 0;
}

static unsigned int sl_g_idle_add (void)
{
   slGFunction *f = NULL;
   
   if (slgtk_usage_err (1, "uint = g_idle_add (func_ref, args...)"))
     return 0;
   
   if ((f = function_pop (0)) == NULL)
     goto cleanup;

   return g_idle_add_full (G_PRIORITY_DEFAULT_IDLE,
			   (GSourceFunc) function_marshaller, f, function_destroy);
   
cleanup:
   function_destroy (f);
   return 0;
}

static unsigned int sl_g_idle_add_priority (void)
{
   slGFunction *f = NULL;
   gint priority;
   
   if (slgtk_usage_err (1, "uint = g_idle_add_priority (priority, func_ref, args...)"))
     return 0;
   
   if ((f = function_pop (1)) == NULL ||
       -1 == SLang_pop_int (&priority))
     goto cleanup;

   return g_idle_add_full (priority,
			   (GSourceFunc) function_marshaller, f, function_destroy);
   
cleanup:
   function_destroy (f);
   return 0;
}
/* }}} */

/* misc functions {{{ */

static void sl_g_object_get_property (void)
{
   GObject* object;
   Slirp_Opaque* object_o = NULL;
   const gchar *name;
   GValue value = G_VALUE_INIT;
   GParamSpec *pspec;
   
   if (slgtk_usage_err (2, "GValue = g_object_get_property (GObject, string)"))
     return;   

   if (-1 == SLang_pop_string ((char **)&name))
     return;
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**) &object, &object_o))       
     goto cleanup_2;

   pspec = g_object_class_find_property (G_OBJECT_GET_CLASS (object), name);
   if (pspec == NULL)
     goto cleanup;
   g_value_init (&value, G_PARAM_SPEC_VALUE_TYPE (pspec));
   g_object_get_property (object, name, &value);
   (void) slgtk_push_g_value ((GValue*) &value);
   g_value_unset (&value);

cleanup:
   SLang_free_opaque (object_o);   
cleanup_2:
   SLang_free_slstring (name);   
}

static void sl_g_object_get (void)
{
   GObject* object;
   Slirp_Opaque* object_o = NULL;
   const gchar *name;
   GValue value = G_VALUE_INIT;
   GParamSpec *pspec;
   unsigned int nprops = (SLang_Num_Function_Args - 1) / 2;
   
   if (slgtk_usage_err (2, "(GValue, ...) = g_object_get (GObject, string, ...)"))
     return;   

   if (nprops % 2 != 0)
     {
	SLdo_pop_n (SLang_Num_Function_Args);
	SLang_verror (SL_USAGE_ERROR, "unbalanced name/type property list");
	return;
     }

   (void) SLreverse_stack (SLang_Num_Function_Args);
   
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**) &object, &object_o))
     return;
   
   while (nprops)
     {
	if (-1 == SLang_pop_slstring ((char**) &name))
	  break;
	pspec = g_object_class_find_property (G_OBJECT_GET_CLASS (object), name);
	if (pspec == NULL)
	  break;
	g_value_init (&value, G_PARAM_SPEC_VALUE_TYPE (pspec));
	g_object_get_property (object, name, &value);
	(void) slgtk_push_g_value ((GValue*) &value);
	g_value_unset (&value);
	SLang_free_slstring (name);
	nprops -= 1;
     }
   
   SLang_free_opaque (object_o);   
}

static void sl_g_object_set (void)
{
   GObject* object;
   Slirp_Opaque* object_o = NULL;
   const gchar *name;
   GValue value = G_VALUE_INIT;
   GParamSpec *pspec;
   unsigned int nprops = SLang_Num_Function_Args - 1;
   
   if (slgtk_usage_err (3, "g_object_set ((GObject, string, GValue, ..."))
     return;

   if (nprops % 2 != 0)
     {	
	SLdo_pop_n (SLang_Num_Function_Args);
	SLang_verror (SL_USAGE_ERROR, "unbalanced name/value property list");
	return;
     }

   (void) SLreverse_stack (SLang_Num_Function_Args);

   if (-1 == SLang_pop_opaque (GObject_Type, (void**) &object, &object_o))
     goto cleanup;

   while (nprops)
     {
	if (-1 == SLang_pop_slstring ((char**) &name))
	  break;

	pspec = g_object_class_find_property (G_OBJECT_GET_CLASS (object), name);
	if (pspec == NULL)
	  break;

	g_value_init (&value, G_PARAM_SPEC_VALUE_TYPE (pspec));
	if (-1 == slgtk_pop_g_value (&value))
	  {	     
	     g_message ("Can't pop value for property named : %s", name);
	     g_value_unset (&value);
	     break;
	  }	
	g_object_set_property (G_OBJECT (object), name, &value);
	g_value_unset (&value);
	SLang_free_slstring (name);
	nprops -= 2;
     }

cleanup:
   SLang_free_opaque (object_o);   
}

static void sl_g_object_set_property (void)
{
   GObject* object;
   Slirp_Opaque* object_o = NULL;
   const gchar *name;
   GValue value = G_VALUE_INIT;
   GParamSpec *pspec;
   
   if (slgtk_usage_err (3, "g_object_set_property (GObject, string, GValue)"))
     return;   

   (void) SLreverse_stack (SLang_Num_Function_Args);
   
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**) &object, &object_o) ||
       -1 == SLang_pop_string ((char **)&name))
     goto cleanup;

   pspec = g_object_class_find_property (G_OBJECT_GET_CLASS (object), name);
   if (pspec == NULL)
     {
	g_message ("This object has no property named : %s", name);
	goto cleanup;
     }   

   g_value_init (&value, G_PARAM_SPEC_VALUE_TYPE (pspec));
   if (-1 == slgtk_pop_g_value (&value))
     {	
	g_message ("Can't pop value for property named : %s", name);
	g_value_unset (&value);
     }   
   else
     {	
	g_object_set_property (G_OBJECT (object), name, &value);
	g_value_unset (&value);
     }   

cleanup:
   SLang_free_slstring (name);
   SLang_free_opaque (object_o);
}

static void data_destroy(gpointer data)
{
   SLang_free_anytype((SLang_Any_Type*)data);
}

static void sl_g_object_set_data(void)
{
   GObject *obj;
   char *key  = NULL;
   Slirp_Opaque *obj_o = NULL;
   SLang_Any_Type *data = NULL;

   if (SLang_Num_Function_Args != 3) {
	SLang_verror (SL_USAGE_ERROR,
		"Usage: g_object_set_data(GObject,string,data);");
	return;
   }

   if (	SLang_pop_anytype(&data) == 0	&&
	SLang_pop_slstring(&key) == 0	&&
	SLang_pop_opaque( GObject_Type, (void**)&obj, &obj_o) == 0)
   
	/* This implicitly destroys data previously registered w/ same key */
	g_object_set_data_full(obj, key, (gpointer)data, data_destroy);
   else {

	SLang_verror (SL_INTRINSIC_ERROR,
		"Unable to validate arguments to: g_object_set_data");
	if (data) SLang_free_anytype(data);
   }

   SLang_free_opaque(obj_o);
   if (key) SLang_free_slstring(key);
}

static void sl_g_object_get_data(Slirp_Opaque *ot, char *key)
{
   (void)SLang_push_anytype(
      	(SLang_Any_Type*) g_object_get_data(G_OBJECT(ot->instance),key));
}

static void sl_g_param_spec_set_qdata(void)
{
   GParamSpec *pspec;
   Slirp_Opaque *pspec_o = NULL;
   SLang_Any_Type *data = NULL;
   GQuark quark;

   if (SLang_Num_Function_Args != 3) {
	SLang_verror (SL_USAGE_ERROR,
		"Usage: g_param_spec_set_qdata(GParamSpec, uint, Any_Type);");
	return;
   }

   if (	SLang_pop_anytype(&data) == 0	&&
	SLang_pop_uinteger(&quark) == 0 &&
	SLang_pop_opaque( GtkOpaque_Type, (void**)&pspec, &pspec_o) == 0)

	/* Implicitly destroys data previously registered / same quark */
	g_param_spec_set_qdata_full( pspec, quark,(gpointer)data,data_destroy);
   else {
  	 
	SLang_verror (SL_INTRINSIC_ERROR,
		"Unable to validate arguments to: g_param_spec_get_qdata");

	if (data) SLang_free_anytype(data);
   }

   SLang_free_opaque(pspec_o);
}

static void sl_g_param_spec_get_qdata(void)
{
   GQuark quark;
   GParamSpec *pspec;
   Slirp_Opaque *pspec_o = NULL;

   if (SLang_Num_Function_Args != 2) {
	SLang_verror (SL_USAGE_ERROR,
		"Usage: Any_Type = g_param_spec_get_qdata(GParamSpec,uint);");
	return;
   }

   if (	SLang_pop_uinteger(&quark) == 0 &&
	SLang_pop_opaque( GtkOpaque_Type, (void**)&pspec, &pspec_o) == 0)

	(void) SLang_push_anytype( (SLang_Any_Type*)
				g_param_spec_get_qdata( pspec, quark));
   else 

	SLang_verror (SL_INTRINSIC_ERROR,
		"Unable to validate arguments to: g_param_spec_get_qdata");

   SLang_free_opaque(pspec_o);
}

static void sl_g_param_spec_steal_qdata(void)
{
   GQuark quark;
   GParamSpec *pspec;
   Slirp_Opaque *pspec_o = NULL;

   if (SLang_Num_Function_Args != 2) {
	SLang_verror (SL_USAGE_ERROR,
		"Usage: Any_Type = g_param_spec_steal_qdata(GParamSpec,uint);");
	return;
   }

   if (	SLang_pop_uinteger(&quark) == 0 &&
	SLang_pop_opaque( GtkOpaque_Type, (void**)&pspec, &pspec_o) == 0)

	(void) SLang_push_anytype( (SLang_Any_Type*)
		g_param_spec_get_qdata(pspec, quark));
   else 

	SLang_verror (SL_INTRINSIC_ERROR,
		"Unable to validate arguments to: g_param_spec_steal_qdata");

   SLang_free_opaque(pspec_o);
}

static void sl_g_date_strftime (void)
{
   char *format, buf [1000];
   const GDate* date;
   Slirp_Opaque* date_o = NULL;
   gsize len;
   
   if (slgtk_usage_err (2, "string = g_date_strftime (string, GDate)"))
     return;

   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&date, &date_o) ||
       -1 == SLang_pop_slstring (&format))
     goto cleanup;

   len = g_date_strftime (buf, sizeof(buf), format, date);

   if (len == 0)
     buf [0] = 0;
   
   (void) SLang_push_string (buf);
   
cleanup:   
   SLang_free_slstring (format);
   SLang_free_opaque (date_o);
}

static void sl_g_date_to_struct_tm (void)
{
   struct tm tm;
   const GDate* date;
   Slirp_Opaque* date_o = NULL;
   
   if (slgtk_usage_err (1, "Struct_Type = g_date_to_struct_tm (GDate)"))
     return;

   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&date, &date_o))
     goto cleanup;

   g_date_to_struct_tm (date, &tm);
   
   SLang_push_cstruct ((VOID_STAR) &tm, TM_Struct);      
   
cleanup:   
   SLang_free_opaque (date_o);   
}

static void sl_g_action_map_add_action_entries (void)
{
   GActionMap *action_map;
   Slirp_Opaque *action_map_o = NULL;
   SLang_Array_Type *at;
   SLindex_Type i, n;
   SLang_Struct_Type *s;
   GActionEntry *entries;
   char *str;
   
   if (slgtk_usage_err (2, "g_action_map_add_action_entries (GActionMap, list)"))
     return;
   
   if (-1 == SLang_pop_array_of_type (&at, SLANG_STRUCT_TYPE))
     return;
   if (-1 == SLang_pop_opaque (GObject_Type, (void**) &action_map, &action_map_o))
     goto cleanup_2;

   entries = (GActionEntry *) alloca (at->num_elements * sizeof (GActionEntry));

   n = at->num_elements;
   for (i = 0 ; i < n ; i ++)
     {	
   	if (-1 == SLang_get_array_element (at, &i, &s))
	  goto cleanup;
	if (-1 == SLang_push_struct_field (s, "name"))
	  goto cleanup;
	if (-1 == pop_string_or_null (&str))
	  goto cleanup;
	entries [i].name = g_strdup (str);
	entries [i].activate = NULL;
	if (-1 == SLang_push_struct_field (s, "parameter_type"))
	  goto cleanup;
	if (-1 == pop_string_or_null (&str))
	  goto cleanup;
	entries [i].parameter_type = g_strdup (str);
	if (-1 == SLang_push_struct_field (s, "state"))
	  goto cleanup;
	if (-1 == pop_string_or_null (&str))
	  goto cleanup;
	entries [i].state = g_strdup (str);		
	entries [i].change_state = NULL;		
     }

   g_action_map_add_action_entries (action_map, entries, n, NULL);

cleanup:
   SLang_free_slstring (str);
   for (i = 0 ; i < n ; i ++)
     {
	g_free ((gpointer) entries [i].name);
	g_free ((gpointer) entries [i].parameter_type);
	g_free ((gpointer) entries [i].state);
     }   
   SLang_free_opaque (action_map_o);
cleanup_2:
   SLang_free_array (at);
}

static void sl_g_build_filename (void)
{
   int i;
   gchar **args = NULL, *str;
   SLang_Array_Type *at;

   if (slgtk_usage_err (1, "string = g_build_filename ([string])"))
     return;

   if (-1 == SLang_pop_array_of_type (&at, SLANG_STRING_TYPE))
     return;

   args = g_try_malloc ((at->num_elements + 1) * sizeof (gchar *));
   if (args == NULL)
     goto cleanup;
   for(i = 0 ; i < at->num_elements ; i ++)
     args [i] = (((char **) at->data) [i]);
   args [i] = NULL;
   
   str = g_build_filenamev (args);
   (void) SLang_push_string (str);
   g_free (str);
   g_free (args);
   
cleanup:
   SLang_free_array (at);
}

static void sl_g_build_path (void)
{
   const gchar *sep;
   int i;
   gchar **args = NULL, *str;
   SLang_Array_Type *at;

   if (slgtk_usage_err (2, "string = g_build_path (string, [string])"))
          return;

   if (-1 == SLang_pop_array_of_type (&at, SLANG_STRING_TYPE) ||
       -1 == SLang_pop_string ((gchar **) &sep))
     return;

   args = g_try_malloc ((at->num_elements + 1) * sizeof (gchar *));
   if (args == NULL)
     goto cleanup;
   for (i = 0 ; i < at->num_elements ; i ++)
     args [i] = (((char **) at->data) [i]);
   args [i] = NULL;
   
   str = g_build_pathv (sep, args);
   (void) SLang_push_string (str);
   g_free (str);
   g_free (args);

cleanup:
   SLang_free_array (at);
}

/* deprecated */
/* static void sl_g_get_current_time (void) */
/* { */
/*    GTimeVal tv; */

/*    if (slgtk_usage_err (0, "struct GTimeVal = g_get_current_time ()")) */
/*      return; */
   
/*    g_get_current_time (&tv); */

/*    SLang_push_cstruct ((VOID_STAR) &tv, GTimeVal_Layout); */
/* } */

/* deprecated */
/* static void sl_g_time_val_add (void) */
/* { */
/*    GTimeVal tv; */
/*    glong usec; */

/*    if (slgtk_usage_err (2, "g_time_val_add (struct GTimeVal, long)")) */
/*      return; */

/*    if (-1 == SLang_pop_long ((long*)&usec) || */
/*        -1 == SLang_pop_cstruct ((VOID_STAR) &tv, GTimeVal_Layout)) */
/*      goto cleanup; */

/*    g_time_val_add (&tv, usec); */

/*    SLang_push_cstruct ((VOID_STAR) &tv, GTimeVal_Layout); */
   
/* cleanup: */
/*    SLang_free_cstruct((VOID_STAR) &tv, GTimeVal_Layout); */
/* } */

/* deprecated */
/* static void sl_g_time_val_from_iso8601 (void) */
/* { */
/*    const gchar *date; */
/*    gboolean retval; */
/*    GTimeVal tv; */

/*    if (slgtk_usage_err (1, "struct GTimeVal = g_time_val_from_iso8601 (string)")) */
/*      return; */

/*    if (-1 == SLang_pop_string ((gchar **) &date)) */
/*      return; */

/*    retval = g_time_val_from_iso8601 (date, &tv); */
/*    if (retval) */
/*      SLang_push_cstruct ((VOID_STAR) &tv, GTimeVal_Layout); */
/*    else */
/*      SLang_push_null(); */
     
/*    SLang_free_slstring (date);    */
/* } */

static void sl_g_error_matches (void)
{
   GError *error;
   Slirp_Opaque* error_o = NULL;
   GQuark domain;
   gboolean retval;
   gint code;
   
   if (slgtk_usage_err (3, "int = g_error_matches (GError, int, int)"))
     return;

   if (-1 == SLang_pop_int ((int*) &code) ||
       -1 == SLang_pop_uint ((unsigned int*) &domain) ||
       -1 == SLang_pop_opaque (GObject_Type, (void**)&error, &error_o))
     goto cleanup;

   retval =  g_error_matches (error, domain, code);
   (void) SLang_push_int (retval);
   
cleanup:
   SLang_free_opaque (error_o);
   SLang_push_null();
}

static void sl_g_unichar_to_utf8 (void)
{
   gunichar c;
   char outbuf [7];
   int retval;
   
   if (slgtk_usage_err (1, "string = g_unichar_to_utf8 (gunichar)"))
     return;

   if (-1 == SLang_pop_uint ((unsigned int*) &c))
     return;

   retval = g_unichar_to_utf8 (c, outbuf);
   outbuf [retval] = 0;
   
   (void) SLang_push_string (outbuf);
}

static void sl_g_convert (void)
{
   char *str, *to, *from, *dest;
   gsize bytes_written;
   GError *error = NULL;
   
   if (slgtk_usage_err (3, "string = g_convert (string, string, string)"))
     return;
   
   if (-1 == SLang_pop_string ((char**)&from) ||
       -1 == SLang_pop_string ((char**)&to) ||
       -1 == SLang_pop_string ((char**)&str))
     goto cleanup;

   dest = g_convert (str, -1, to, from, NULL, &bytes_written, &error);

   if (error != NULL)
     throw_gerror (error);

   (void) SLang_push_string (dest);
   g_free (dest);
   
cleanup:
   SLang_free_slstring (str);
   SLang_free_slstring (to);
   SLang_free_slstring (from);
}

static void sl_g_convert_with_fallback (void)
{
   char *str, *to, *from, *fallback, *dest;
   gsize bytes_written;
   GError *error = NULL;
   
   if (slgtk_usage_err (4, "string = g_convert (string, string, string [,string])"))
     return;
   
   if (-1 == pop_string_or_null (&fallback) ||
       -1 == SLang_pop_string ((char**)&from) ||
       -1 == SLang_pop_string ((char**)&to) ||
       -1 == SLang_pop_string ((char**)&str))
     goto cleanup;

   dest = g_convert_with_fallback (str, -1, to, from, fallback, NULL, &bytes_written, &error);

   if (error != NULL)
     throw_gerror (error);

   (void) SLang_push_string (dest);
   g_free (dest);
   
cleanup:
   SLang_free_slstring (str);
   SLang_free_slstring (to);
   SLang_free_slstring (from);
   SLang_free_slstring (fallback);
}

static void sl_g_convert_with_iconv (void)
{
   char *str, *dest;
   gsize bytes_written;
   GIConv converter;
   Slirp_Opaque* converter_o = NULL;
   GError *error = NULL;
   
   if (slgtk_usage_err (2, "string = g_convert (string, GIConv)"))
     return;
   
   if (-1 == SLang_pop_opaque (GtkOpaque_Type, (void**)&converter, &converter_o) ||
       -1 == SLang_pop_string ((char**)&str))
     goto cleanup;

   dest = g_convert_with_iconv (str, -1, converter, NULL, &bytes_written, &error);

   if (error != NULL)
     throw_gerror (error);

   (void) SLang_push_string (dest);
   g_free (dest);
   
cleanup:
   SLang_free_slstring (str);
}

static void sl_g_locale_to_utf8 (void)
{
   char *str, *dest;
   gsize bytes_written;
   GError *error = NULL;
   
   if (slgtk_usage_err (1, "string = g_locale_to_utf8 (string)"))
     return;
   
   if (-1 == SLang_pop_string ((char**)&str))       
     goto cleanup;

   dest = g_locale_to_utf8 (str, -1, NULL, &bytes_written, &error);

   if (error != NULL)
     throw_gerror (error);

   (void) SLang_push_string (dest);
   g_free (dest);
   
cleanup:
   SLang_free_slstring (str);
}

static void sl_g_locale_from_utf8 (void)
{
   char *str, *dest;
   gsize bytes_written;
   GError *error = NULL;
   
   if (slgtk_usage_err (1, "string = g_locale_from_utf8 (string)"))
     return;
   
   if (-1 == SLang_pop_string ((char**)&str))       
     goto cleanup;

   dest = g_locale_from_utf8 (str, -1, NULL, &bytes_written, &error);

   if (error != NULL)
     throw_gerror (error);

   (void) SLang_push_string (dest);
   g_free (dest);
   
cleanup:
   SLang_free_slstring (str);
}

static void sl_g_filename_to_utf8 (void)
{
   char *str, *dest;
   gsize bytes_written;
   GError *error = NULL;
   
   if (slgtk_usage_err (1, "string = g_filename_to_utf8 (string)"))
     return;
   
   if (-1 == SLang_pop_string ((char**)&str))       
     goto cleanup;

   dest = g_filename_to_utf8 (str, -1, NULL, &bytes_written, &error);

   if (error != NULL)
     throw_gerror (error);

   (void) SLang_push_string (dest);
   g_free (dest);
   
cleanup:
   SLang_free_slstring (str);
}

static void sl_g_filename_from_utf8 (void)
{
   char *str, *dest;
   gsize bytes_written;
   GError *error = NULL;
   
   if (slgtk_usage_err (1, "string = g_filename_from_utf8 (string)"))
     return;
   
   if (-1 == SLang_pop_string ((char**)&str))       
     goto cleanup;

   dest = g_filename_from_utf8 (str, -1, NULL, &bytes_written, &error);

   if (error != NULL)
     throw_gerror (error);

   (void) SLang_push_string (dest);
   g_free (dest);
   
cleanup:
   SLang_free_slstring (str);
}

static void sl_g_get_filename_charsets (void)
{
   const char **charset;
   
   if (slgtk_usage_err (0, "[string] = g_get_filename_charsets ()"))
     return;

   g_get_filename_charsets (&charset);

   push_null_term_str_array ((char **) charset, "g_get_filename_charsets", 0);
}

static void sl_g_get_charset (void)
{
   const char *charset;
   
   if (slgtk_usage_err (0, "[string] = g_get_charset ()"))
     return;

   g_get_charset (&charset);

   (void) SLang_push_string ((char *) charset);
}

static void sl_g_input_stream_read (void)
{
   GCancellable *cancellable;
   Slirp_Opaque *cancellable_o = NULL;
   GInputStream *stream;
   Slirp_Opaque *stream_o = NULL;
   gsize count;
   gssize byte_read;
   guchar *buf = NULL;
   GError *error = NULL;
   int retval = -1;
   SLang_Ref_Type *ref;
   SLang_BString_Type *bstring;
   
   if (slgtk_usage_err (4, "int = g_input_stream_read (GInputStream, SLang_Ref_Type, int , [GCancellable])"))
     return;

   if (-1 == pop_nullable (GtkOpaque_Type, (void**) &cancellable, (void**) &cancellable_o))
     return;
   if (-1 == SLang_pop_ulong ((unsigned long*) &count))
     goto cleanup_4;
   if (-1 == SLang_pop_ref (&ref))
     goto cleanup_4;
   if (-1 == SLang_pop_opaque (GObject_Type, (void**) &stream, &stream_o))
     goto cleanup_3;

   buf = g_try_new (guchar, count);
   if (buf == NULL)
     goto cleanup_2;
   
   byte_read = g_input_stream_read (stream, buf, count, cancellable, &error);
   if (byte_read == -1)
     goto cleanup;
   
   if (error != NULL)
     throw_gerror (error);

   bstring = SLbstring_create_malloced ((unsigned char *) buf, byte_read, 1);
   retval = SLang_assign_to_ref (ref, SLANG_BSTRING_TYPE, (VOID_STAR) &bstring);
   SLbstring_free (bstring);
   buf = NULL;
   
   if (retval == -1)
     (void) SLang_push_integer (retval);
   else
     (void) SLang_push_uinteger (byte_read);

cleanup:
   if (buf != NULL)
     g_free (buf);
cleanup_2:   
   SLang_free_opaque (stream_o);
cleanup_3:
   SLang_free_ref (ref);
cleanup_4:
   SLang_free_opaque (cancellable_o);
}

static void sl_g_input_stream_read_bytes (void)
{
   GCancellable *cancellable;
   Slirp_Opaque *cancellable_o = NULL;
   GInputStream *stream;
   Slirp_Opaque *stream_o = NULL;
   gsize count, size;
   GBytes *bytes = NULL;
   GError *error = NULL;
   guint8 *data;
   
   if (slgtk_usage_err (3, "[UChar_Type] = g_input_stream_read_bytes (GInputStream, int , [GCancellable])"))
     return;

   if (-1 == pop_nullable (GtkOpaque_Type, (void**) &cancellable, (void**) &cancellable_o))
     return;
   if (-1 == SLang_pop_ulong ((unsigned long*) &count))
     goto cleanup_2;
   if (-1 == SLang_pop_opaque (GObject_Type, (void**) &stream, &stream_o))
     goto cleanup_2;

   bytes = g_input_stream_read_bytes (stream, count, cancellable, &error);

   if (error != NULL)
     throw_gerror (error);
   
   if (bytes == NULL)
     {	
	(void) SLang_push_null ();
	goto cleanup;
     }   
   else
     {
	SLang_Array_Type *at;
	data = g_bytes_unref_to_data (bytes, &size);
	SLindex_Type num_read = (SLindex_Type) size;
	at = SLang_create_array (SLANG_UCHAR_TYPE, 0, (VOID_STAR) data, &num_read, 1);
	if (at == NULL)
	  {
	     (void) SLang_push_null ();
	     goto cleanup;
	  }
	(void) SLang_push_array (at, 0);
     }   
cleanup:
   SLang_free_opaque (stream_o);
cleanup_2:
   SLang_free_opaque (cancellable_o);
}

static void sl_g_key_file_get_integer_list (void)
{
   GKeyFile *key_file;
   Slirp_Opaque *key_file_o = NULL;
   SLang_Array_Type *at = NULL;
   gint *retval;
   gchar *group_name, *key;
   gsize length;
   GError *error = NULL;
   
   if (slgtk_usage_err (3, "[int] = g_key_file_get_integer_list (GKeyFile, string, string)"))
     return;
   
   if (-1 == SLang_pop_string ((char**) &key))
     return;
   if (-1 == SLang_pop_string ((char**) &group_name))
     goto cleanup_3;
   if (-1 == SLang_pop_opaque (GKeyFile_Type, (void**) &key_file, &key_file_o))
     goto cleanup_2;

   retval = g_key_file_get_integer_list (key_file, group_name, key, &length, &error);
   if (error != NULL)
     throw_gerror (error);

   at = SLang_create_array (SLANG_INT_TYPE, 0, retval, (SLindex_Type *) &length, 1);
   if (at == NULL)
     goto cleanup;

   (void) SLang_push_array (at, 0);

cleanup:
   g_free (retval);
   SLang_free_opaque (key_file_o);
cleanup_2:
   SLang_free_slstring (group_name);   
cleanup_3:
   SLang_free_slstring (key);
}

static void sl_g_key_file_get_double_list (void)
{
   GKeyFile *key_file;
   Slirp_Opaque *key_file_o = NULL;
   SLang_Array_Type *at = NULL;
   gdouble *retval;
   gchar *group_name, *key;
   gsize length;
   GError *error = NULL;
   
   if (slgtk_usage_err (3, "[double] = g_key_file_get_double_list (GKeyFile, string, string)"))
     return;
   
   if (-1 == SLang_pop_string ((char**) &key))
     return;
   if (-1 == SLang_pop_string ((char**) &group_name))
     goto cleanup_3;
   if (-1 == SLang_pop_opaque (GKeyFile_Type, (void**) &key_file, &key_file_o))
     goto cleanup_2;

   retval = g_key_file_get_double_list (key_file, group_name, key, &length, &error);
   if (error != NULL)
     throw_gerror (error);
   
   at = SLang_create_array (SLANG_DOUBLE_TYPE, 0, retval, (SLindex_Type *) &length, 1);
   if (at == NULL)
     goto cleanup;
   
   (void) SLang_push_array (at, 0);
   
cleanup:
   g_free (retval);
   SLang_free_opaque (key_file_o);
cleanup_2:
   SLang_free_slstring (group_name);   
cleanup_3:
   SLang_free_slstring (key);
}

static void sl_g_key_file_get_boolean_list (void)
{
   GKeyFile *key_file;
   Slirp_Opaque *key_file_o = NULL;
   SLang_Array_Type *at = NULL;
   gboolean *retval;
   gchar *group_name, *key;
   gsize length;
   GError *error = NULL;
   
   if (slgtk_usage_err (3, "[int] = g_key_file_get_boolean_list (GKeyFile, string, string)"))
     return;
   
   if (-1 == SLang_pop_string ((char**) &key))
     return;
   if (-1 == SLang_pop_string ((char**) &group_name))
     goto cleanup_3;
   if (-1 == SLang_pop_opaque (GKeyFile_Type, (void**) &key_file, &key_file_o))
     goto cleanup_2;

   retval = g_key_file_get_boolean_list (key_file, group_name, key, &length, &error);
   if (error != NULL)
     throw_gerror (error);
   
   at = SLang_create_array (SLANG_INT_TYPE, 0, retval, (SLindex_Type *) &length, 1);
   if (at == NULL)
     goto cleanup;
   
   (void) SLang_push_array (at, 0);
   
cleanup:
   g_free (retval);
   SLang_free_opaque (key_file_o);
cleanup_2:
   SLang_free_slstring (group_name);   
cleanup_3:
   SLang_free_slstring (key);
}

static void sl_gpointer_set_double (void)
{
   double val;
   gpointer ptr;
   Slirp_Opaque* ptr_o = NULL;

   if (-1 == SLang_pop_double (&val))
     return;
   if (-1 == SLang_pop_opaque(GtkOpaque_Type, (void**)&ptr, &ptr_o))
     return;

   *((double*) ptr) = val;

   SLang_free_opaque (ptr_o);
}

static void sl_g_object_type (Slirp_Opaque *o)
{   
   unsigned long type = (unsigned long) G_OBJECT_TYPE (o->instance);
   (void) SLang_push_ulong (type);
}

static void sl_g_object_type_name (Slirp_Opaque *o)
{   
   char *name = (char *) G_OBJECT_TYPE_NAME (o->instance);
   (void) SLang_push_string (name);
}

#define DUMMY_TYPE 255

static SLang_Intrin_Fun_Type Glib_Funcs [] =
{
   MAKE_INTRINSIC_0("g_convert", sl_g_convert, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_convert_with_fallback", sl_g_convert_with_fallback, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_convert_with_iconv", sl_g_convert_with_iconv, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_filename_from_utf8", sl_g_filename_from_utf8, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_filename_to_utf8", sl_g_filename_to_utf8, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_get_charset", sl_g_get_charset, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_get_filename_charsets", sl_g_get_filename_charsets, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_locale_from_utf8", sl_g_locale_from_utf8, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_locale_to_utf8", sl_g_locale_to_utf8, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_unichar_to_utf8", sl_g_unichar_to_utf8, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ((char*)"g_build_filename", sl_g_build_filename, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ((char*)"g_build_path", sl_g_build_path, SLANG_VOID_TYPE),
   /* MAKE_INTRINSIC_0 ("g_get_current_time", sl_g_get_current_time, SLANG_VOID_TYPE), */
   /* MAKE_INTRINSIC_0 ("g_time_val_add", sl_g_time_val_add, SLANG_VOID_TYPE), */
   /* MAKE_INTRINSIC_0 ("g_time_val_from_iso8601", sl_g_time_val_from_iso8601, SLANG_VOID_TYPE), */
   MAKE_INTRINSIC_0 ("gpointer_set_double", sl_gpointer_set_double, SLANG_VOID_TYPE),
   /* MAKE_INTRINSIC_0("g_source_get_current_time", sl_g_source_get_current_time, SLANG_VOID_TYPE), */
   SLANG_END_INTRIN_FUN_TABLE
};

static SLang_Intrin_Fun_Type Glib_GObject_Funcs[] =
{
   MAKE_INTRINSIC_0("g_idle_add", sl_g_idle_add, SLANG_UINT_TYPE),
   MAKE_INTRINSIC_0("g_idle_add_priority", sl_g_idle_add_priority, SLANG_UINT_TYPE),
   MAKE_INTRINSIC_0("g_object_get", sl_g_object_get, SLANG_VOID_TYPE),   
   MAKE_INTRINSIC_2("g_object_get_data", sl_g_object_get_data,SLANG_VOID_TYPE,DUMMY_TYPE,SLANG_STRING_TYPE),
   MAKE_INTRINSIC_0("g_object_get_property", sl_g_object_get_property, SLANG_VOID_TYPE),   
   MAKE_INTRINSIC_0("g_object_set", sl_g_object_set, SLANG_VOID_TYPE),   
   MAKE_INTRINSIC_0("g_object_set_data", sl_g_object_set_data,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_object_set_property", sl_g_object_set_property, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_param_spec_get_qdata", sl_g_param_spec_get_qdata,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_param_spec_set_qdata", sl_g_param_spec_set_qdata,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_param_spec_steal_qdata", sl_g_param_spec_steal_qdata,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_signal_connect", sl_g_signal_connect,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_signal_connect_after", sl_g_signal_connect_after,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_signal_connect_swapped", sl_g_signal_connect_swapped,SLANG_VOID_TYPE),
   MAKE_INTRINSIC_2("g_signal_emit_by_name", sl_g_signal_emit_by_name,SLANG_VOID_TYPE,DUMMY_TYPE,SLANG_STRING_TYPE),
   MAKE_INTRINSIC_0("g_timeout_add", sl_g_timeout_add, SLANG_UINT_TYPE),
   MAKE_INTRINSIC_0("g_timeout_add_priority", sl_g_timeout_add_priority, SLANG_UINT_TYPE),
   MAKE_INTRINSIC_0("g_timeout_add_seconds", sl_g_timeout_add_seconds, SLANG_UINT_TYPE),
   MAKE_INTRINSIC_0("g_timeout_add_seconds_priority", sl_g_timeout_add_seconds_priority, SLANG_UINT_TYPE),
   MAKE_INTRINSIC_0("g_input_stream_read", sl_g_input_stream_read, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_input_stream_read_bytes", sl_g_input_stream_read_bytes, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_action_map_add_action_entries", sl_g_action_map_add_action_entries, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_1("g_object_type", sl_g_object_type, SLANG_VOID_TYPE, DUMMY_TYPE),
   MAKE_INTRINSIC_1("g_object_type_name", sl_g_object_type_name, SLANG_VOID_TYPE, DUMMY_TYPE),
   /* MAKE_INTRINSIC_0("", sl_, SLANG_VOID_TYPE), */
  SLANG_END_INTRIN_FUN_TABLE
};

static SLang_Intrin_Fun_Type Glib_GtkOpaque_Funcs[] =
{
   MAKE_INTRINSIC_0("g_error_matches", sl_g_error_matches, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ((char*)"g_date_strftime", sl_g_date_strftime, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ("g_date_to_struct_tm", sl_g_date_to_struct_tm, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_key_file_get_integer_list", sl_g_key_file_get_integer_list, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_key_file_get_double_list", sl_g_key_file_get_double_list, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("g_key_file_get_boolean_list", sl_g_key_file_get_boolean_list, SLANG_VOID_TYPE),
   SLANG_END_INTRIN_FUN_TABLE
};
/* }}} */

/* Intrinsic variables {{{ */
static unsigned long uldummy;

static SLang_Intrin_Var_Type GType_Intrin_Vars [] =
{
  MAKE_VARIABLE("G_TYPE_PARAM_CHAR",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_UCHAR",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_BOOLEAN",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_INT",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_UINT",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_LONG",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_ULONG",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_INT64",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_UINT64",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_UNICHAR",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_ENUM",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_FLAGS",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_FLOAT",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_DOUBLE",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_STRING",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_PARAM",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_BOXED",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_POINTER",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_VALUE_ARRAY",&uldummy,SLANG_UINT_TYPE,1),
  MAKE_VARIABLE("G_TYPE_PARAM_OBJECT",&uldummy,SLANG_UINT_TYPE,1),
  SLANG_END_INTRIN_VAR_TABLE
};

static SLang_Intrin_Var_Type Glib_Intrin_Vars [] =
{
   MAKE_VARIABLE("_glib_version", &_glib_version,SLANG_UINT_TYPE,1),
   SLANG_END_INTRIN_VAR_TABLE
};

/* }}} */

static int init_sl_glib(SLang_NameSpace_Type *ns)
{
   int i = -1;
   slgtk_patch_ftable (Glib_GObject_Funcs, DUMMY_TYPE, GObject_Type);
   slgtk_patch_ftable (Glib_GtkOpaque_Funcs, DUMMY_TYPE, GtkOpaque_Type);

   while (GType_Intrin_Vars[++i].name != NULL)
     GType_Intrin_Vars[i].addr = &g_param_spec_types[i];

   if (-1 == SLns_add_intrin_var_table (ns, GType_Intrin_Vars, NULL))
	return -1;

   if (-1 == SLns_add_intrin_var_table (ns, Glib_Intrin_Vars, NULL))
     return -1;

   if (-1 == SLns_add_intrin_fun_table (ns, Glib_Funcs, "__GLIB__"))
	return -1;
   
   if (-1 == SLns_add_intrin_fun_table (ns, Glib_GObject_Funcs, NULL))
	return -1;

   return SLns_add_intrin_fun_table (ns, Glib_GtkOpaque_Funcs, NULL);
}
