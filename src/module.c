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

#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <gtk/gtk.h>
#include "module.h"

SLang_CStruct_Field_Type GError_Layout [] =
{
  MAKE_CSTRUCT_FIELD(GError,domain,"domain",SLANG_INT_TYPE,0),
  MAKE_CSTRUCT_FIELD(GError,code,"code",SLANG_INT_TYPE,0),
  MAKE_CSTRUCT_FIELD(GError,message,"message",SLANG_STRING_TYPE,0),
  SLANG_END_CSTRUCT_TABLE
};

int slgtk_usage_err(int expected_nargs, const char *usage_str)
{
   if (SLang_Num_Function_Args < expected_nargs) {
	int npop = SLstack_depth();
	if (npop > SLang_Num_Function_Args) npop = SLang_Num_Function_Args;
	SLdo_pop_n(npop);
	SLang_verror(SL_USAGE_ERROR, "Usage: %s", usage_str);
	return -1;
   }
   return 0;
}

void throw_gerror (GError *gerr)  /* {{{ */
{
   SLang_Struct_Type *s = NULL;

   if (gerr == NULL)
     return;

   if (SLang_push_cstruct (gerr, GError_Layout) != 0
       || SLang_pop_struct(&s) != 0)
     return;

   SLerr_throw(SL_Application_Error,
	       "SLgtk error: look in exeption.object for GError",
	       SLANG_STRUCT_TYPE, &s);
}  /* }}} */

void slgtk_error_terminate_main_loop(char* cause)
{
   GtkWidget *focus;
   GList *windows;
   const char* problem =
	"SLgtk Error: unrecoverable S-Lang error, quitting main loop\n";
   static unsigned char previously_reported;

   /* This routine s/b called when SLgtk detects a fatal S-Lang error,  */
   /* to bring down GUI windows and ensure the app does not hang.  Note */
   /* that this DOES NOT MEAN the app MUST exit, since gtk_main() calls */
   /* can be nested. */

   if (cause == NULL)
      cause = "unknown";

   if (gtk_main_level() == 0) {
	if (previously_reported == 0)
	   SLang_verror(SLang_get_error(), "%s", (char*)problem);
	previously_reported++;
	return;
   }

   fprintf(stderr, "%s\n", problem);
   fprintf(stderr,"Cause: %s\n",cause);
   fflush (stderr);

   SLang_restart(0);
   SLang_set_error(0);
   previously_reported = 0;

   windows = gtk_window_list_toplevels();
   /* !!! Unclear if g_list_foreach (windows,(GFunc)g_object_ref,NULL) */
   /* is needed here (as advocated by docs) since we should be exiting */

   while (windows) {
      focus = gtk_window_get_focus(GTK_WINDOW(windows->data));
      if (focus != NULL) /* && GTK_WIDGET_HAS_FOCUS(focus)) { */
	/* gtk_object_destroy(GTK_OBJECT(windows->data)); */
	break;
      windows = windows->next;
   }

   g_list_free(windows);
   if (gtk_main_level() > 0)
      gtk_main_quit();
}


void slgtk_free_malloced_string_array (char **strs, unsigned int n)
{
   unsigned int i;
   
   if (strs == NULL)
     return;

   for (i = 0; i < n; i++)
     {
	if (strs[i] != NULL)
	  SLfree (strs[i]);
	i++;
     }
   
   SLfree ((char *) strs);
}


int slgtk_pop_key_val_pairs (unsigned int n, char ***keysp, char ***valsp)
{
   char **keys, **vals;
   unsigned int i;
   unsigned int buflen;

   *keysp = *valsp = NULL;

   buflen = (n+1) * sizeof (char *);

   keys = (char **) SLmalloc (buflen);
   if (keys == NULL)
     return -1;

   vals = (char **) SLmalloc (buflen);
   if (vals == NULL)
     return -1;
   
   memset ((char *) keys, 0, buflen);
   memset ((char *) vals, 0, buflen);

   i = n;
   while (i != 0)
     {
	char *keyval;
	char *equals;

	i--;
	if (-1 == SLang_pop_slstring (&keyval))
	  goto return_error;
	
	if (NULL == (equals = strchr (keyval, '=')))
	  equals = keyval + strlen (keyval);
	else 
	if (NULL == (keys[i] = SLmake_nstring (keyval, equals - keyval)))
	  {
	     SLang_free_slstring (keyval);
	     goto return_error;
	  }
	if (*equals) equals++;
	
	if (NULL == (vals[i] = SLmake_string (equals)))
	  {
	     SLang_free_slstring (keyval);
	     goto return_error;
	  }
	
	SLang_free_slstring (keyval);
     }
   
   *keysp = keys;
   *valsp = vals;
   return 0;

   return_error:
   slgtk_free_malloced_string_array (keys, n);
   slgtk_free_malloced_string_array (vals, n);
   return -1;
}

void slgtk_patch_ftable (SLang_Intrin_Fun_Type *f, SLtype dummy, SLtype actual)
{
   while (f->name != NULL) {		/* Reset intrinsic function table */
					/* entries containing types that  */
	unsigned int i, nargs;		/* will be registered @runtime.   */
	SLtype	*args;			/* These types are given dummy    */
					/* SLtype ids @compile time, and  */
	nargs = f->num_args;		/* are then reset here once the   */
	args = f->arg_types;		/* new type has been registered.  */

	for (i = 0; i < nargs; i++) {
	    if (args[i] == dummy)
		args[i] = actual;
	}
	
	if (f->return_type == dummy) f->return_type = actual;
	f++;
   }
}
