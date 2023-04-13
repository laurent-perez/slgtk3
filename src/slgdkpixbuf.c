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
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

static const unsigned int _gdk_pixbuf_version = 10000 * GDK_PIXBUF_MAJOR +
  100 * GDK_PIXBUF_MINOR + GDK_PIXBUF_MICRO;

/* Wrappers and support functions {{{ */

/* Wrapper for gdk_pixbuf_new_from_data() and gdk_pixbuf_save(), as
 * well as support routines in module.c, contributed by John E. Davis
 * (davis@space.mit.edu) */

static int pop_image_array (SLang_Array_Type **ap,  /* {{{ */
			    unsigned int *width, unsigned int *height,
			    unsigned int *stride,
			    int *is_alpha, int *is_grayscale)
{
   SLang_Array_Type *at;
   
   *ap = NULL;
   if (-1 == SLang_pop_array_of_type (&at, SLANG_UCHAR_TYPE))
     return -1;

   if (at->num_elements == 0)
     {
	SLang_verror (SL_INVALID_PARM, "Empty image-array not supported");
	SLang_free_array (at);
	return -1;
     }

   *ap = at;
   *is_grayscale = 1;
   *is_alpha = 0;
   switch (at->num_dims)
     {
      case 1:
	*height = at->dims[0];
	*stride = *width = 1;
	return 0;
	
      case 2:
	*height = at->dims[0];
	*stride = *width = at->dims[1];
	return 0;
	
      case 3:
	switch (at->dims[2])
	  {
	   case 1:
	     *height = at->dims[0];
	     *stride = *width = at->dims[1];
	     return 0;

	   case 3:
	     *is_grayscale = 0;
	     *height = at->dims[0];
	     *width = at->dims[1];
	     *stride = 3 * (*width);
	     return 0;
	     
	   case 4:
	     *is_grayscale = 0;
	     *is_alpha = 1;
	     *height = at->dims[0];
	     *width = at->dims[1];
	     *stride = 4 * (*width);
	     return 0;
	  }
	break;
     }
   
   *ap = NULL;
   SLang_free_array (at);
   SLang_verror (SL_INVALID_PARM, "Still images should be 1D, 2D, or RGB(A)");
   return -1;
}  /* }}} */

static int pop_color_image (SLang_Array_Type **ap,  /* {{{ */
			    unsigned int *width, unsigned int *height,
			    unsigned int *stride,
			    int *is_alpha)
{
   int is_grayscale;
   SLang_Array_Type *at;

   if (-1 == pop_image_array (&at, width, height, stride, 
	    				is_alpha, &is_grayscale))
     return -1;
   
   if (is_grayscale)
     {
	SLang_verror (SL_INVALID_PARM, 
	      		"Expecting a color image, found a grayscale one");
	SLang_free_array (at);
	return -1;
     }
   *ap = at;
   return 0;
}  /* }}} */

#if 0
static int pop_grayscale_image (SLang_Array_Type **ap, /* {{{ */
				unsigned int *width, unsigned int *height,
				unsigned int *stride)
{
   int is_grayscale, is_alpha;
   SLang_Array_Type *at;

   if (-1 == pop_image_array (&at, width, height, stride, 
	    					&is_alpha, &is_grayscale))
     return -1;
   
   if (is_grayscale == 0)
     {
	SLang_verror (SL_INVALID_PARM, 
	      		"Expecting a grayscale image, found a color one");
	SLang_free_array (at);
	return -1;
     }
   *ap = at;
   return 0;
} /* }}} */
#endif

static void destroy_pixbuf_data_array (guchar *pixels, gpointer data_array)
{
   SLang_Array_Type *at = (SLang_Array_Type *)data_array;
   SLang_free_array (at);
   (void) pixels;
}

static void sl_gdk_pixbuf_new_from_data (void)  /* {{{ */
{
   GdkPixbuf* rtn;
   SLang_Array_Type *at;
   int is_alpha;
   unsigned int width, height, stride;
   
   if (SLang_Num_Function_Args == 0) 
     {
	SLang_verror (SL_USAGE_ERROR,
		"Usage: GdkPixbuf = gdk_pixbuf_new_from_data(image-array)");
	return;
     }

   if (-1 == pop_color_image (&at, &width, &height, &stride, &is_alpha))
     return;

   /* Note: the returned pixbuf has a reference to the array */
   rtn = gdk_pixbuf_new_from_data ((const guchar *) at->data,
				   GDK_COLORSPACE_RGB,
				   is_alpha,
				   8,
				   width,
				   height,
				   stride,
				   destroy_pixbuf_data_array, (gpointer)at);

   if (rtn == NULL)
     {
	SLang_free_array (at);
	return;
     }

   if (-1 == SLang_push_opaque(GdkPixbuf_Type, rtn, 0))
     g_object_unref (rtn);
}  /* }}} */

static void sl_gdk_pixbuf_save (void)  /* {{{ */
{
   unsigned int nopts;
   char **keys, **vals;
   char *type, *file;
   GdkPixbuf *pixbuf;
   Slirp_Opaque *pixbuf_o = NULL;
   GError *error = NULL;

   if (SLang_Num_Function_Args < 3)
     {
	SLang_verror (SL_USAGE_ERROR,
	"Usage: gdk_pixbuf_save (pixbuf, file, type [,\"key=val\",...])");
	return;
     }
   
   nopts = (unsigned int) (SLang_Num_Function_Args - 3);

   if (-1 == slgtk_pop_key_val_pairs (nopts, &keys, &vals))
     return;

   type = NULL;
   file = NULL;

   if ((-1 == SLang_pop_slstring (&type))
       || (-1 == SLang_pop_slstring (&file))
       || (-1 == SLang_pop_opaque (GdkPixbuf_Type, (void**)&pixbuf, &pixbuf_o)))
     goto free_and_return;

   if (FALSE == gdk_pixbuf_savev (pixbuf,
				  (const char *)file,
				  (const char *)type,
				  keys, vals,
				  &error))

     SLang_verror (SL_INTRINSIC_ERROR, "gdk_pixbuf_save: %s",
			(error != NULL) ? error->message : "Unknown Error");

   /* drop */
   free_and_return:
   slgtk_free_malloced_string_array (keys, nopts);
   slgtk_free_malloced_string_array (vals, nopts);
   SLang_free_slstring (type);
   SLang_free_slstring (file);
   SLang_free_opaque(pixbuf_o);
}  /* }}} */

static void sl_gdk_pixbuf_get_pixels (void) /*{{{*/
{
   const GdkPixbuf *pb;
   gint stride, bpp, dims[3];
   guchar *pixels;
   guint npixels, copy_size;
   guchar *copy = NULL;
   Slirp_Opaque* pb_o = NULL;
   SLang_Array_Type *at = NULL;

   if (slgtk_usage_err(1, "UChar_Type[h,w] = gdk_pixbuf_get_pixels(GdkPixbuf_Type)")
		|| SLang_pop_opaque(GdkPixbuf_Type, (void**)&pb, &pb_o) == -1)
	return;

   dims[0] = gdk_pixbuf_get_height(pb);
   dims[1] = gdk_pixbuf_get_width(pb);
   dims[2] = gdk_pixbuf_get_n_channels(pb);

   copy_size =  dims[0]*dims[1]*dims[2];
   if ( (copy = (guchar *)SLmalloc(copy_size)) == NULL)
	goto done;

   /* See GdkPixbuf docs for this calculation: the number of pixels
      in the pixbuf is not necessarily rowstride*height because the
      last row may not be as wide as full rowstride */

   pixels  = gdk_pixbuf_get_pixels(pb);
   stride  = gdk_pixbuf_get_rowstride(pb);
   bpp     = gdk_pixbuf_get_bits_per_sample(pb);
   npixels = (dims[0] - 1) * stride + (dims[1] * ((dims[2] * bpp + 7) / 8));

   memcpy(copy, pixels, npixels);
   if (npixels < copy_size)
	memset(copy + npixels, 0, copy_size - npixels);
   
   if ((at = SLang_create_array (SLANG_UCHAR_TYPE, 0, copy, dims, 3)) == NULL)
	goto done;

   (void) SLang_push_array(at, 1);

   done:
   if (at == NULL)
	SLfree((char*)copy);
   SLang_free_opaque(pb_o);

}  /* }}} */

static void sl_gdk_pixbuf_get_pixel(void) /*{{{*/
{
   GdkPixbuf *pb = NULL;
   Slirp_Opaque* pb_o = NULL;
   SLang_Array_Type *at = NULL;
   gint  x, y, length = 4;

   /* Returns RGBA for single pixel at zero-based (x,y) in given pixbuf */
   /* Recall that alpha value 255 = 100% opacity, 0 = 100% transparent  */
   if (slgtk_usage_err(3, "UChar_Type[4] = _gdk_pixbuf_get_pixel(GdkPixbuf, x, y)")
	|| SLang_pop_integer(&y) == -1
	|| SLang_pop_integer(&x) == -1
	|| SLang_pop_opaque(GdkPixbuf_Type, (void**)&pb, &pb_o) == -1
	|| !(at = SLang_create_array (SLANG_UCHAR_TYPE, 0, NULL, &length, 1)))
	return;

   {
   gint width   = gdk_pixbuf_get_width(pb);
   gint height  = gdk_pixbuf_get_height(pb);
   gint stride  = gdk_pixbuf_get_rowstride(pb);
   gint nchans  = gdk_pixbuf_get_n_channels(pb);
   guchar *pixels  = gdk_pixbuf_get_pixels(pb);

   if ((x >= 0 && x < width) && (y >= 0 && y < height))
      memcpy(at->data, pixels + (y * stride) + (nchans * x), nchans);
   }

   (void) SLang_push_array(at, 1);
   SLang_free_opaque(pb_o);

}  /* }}} */

static void sl_gdk_pixbuf_loader_write (void)
{   
   gboolean retval;
   GdkPixbufLoader* loader;
   Slirp_Opaque* loader_o = NULL;
   const guchar* buf;
   gsize count = 0;
   GError* error = NULL;
   SLang_BString_Type *bstring = NULL;
   SLstrlen_Type len;
   
   if (slgtk_usage_err (2, "int = gdk_pixbuf_loader_write (GdkPixbufLoader, BString_Type [, int])"))
     return;

   if (SLang_Num_Function_Args == 3)
     {	
	if (-1 == SLang_pop_ulong ((unsigned long*) &count))
	  return;
     }
   if (-1 == SLang_pop_bstring (&bstring))
     return;
   if (-1 == SLang_pop_opaque (GObject_Type, (void**) &loader, &loader_o))
     goto cleanup;

   buf = (guchar *) SLbstring_get_pointer (bstring, &len);
   if (SLang_Num_Function_Args < 3)
     count = (gsize) len;
   else
     {
	if (count > len)
	  count = len;
     }   
   retval = gdk_pixbuf_loader_write (loader, buf, count, &error);

   if (error != NULL)
     throw_gerror (error);
   
   (void) SLang_push_int (retval);
   
   SLang_free_opaque(loader_o);
cleanup:
   SLbstring_free (bstring);
}

/* }}} */


static SLang_Intrin_Fun_Type Intrin_Funcs[] =
{
   MAKE_INTRINSIC_0("gdk_pixbuf_new_from_data", sl_gdk_pixbuf_new_from_data, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gdk_pixbuf_save", sl_gdk_pixbuf_save, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gdk_pixbuf_get_pixels", sl_gdk_pixbuf_get_pixels, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("_gdk_pixbuf_get_pixel", sl_gdk_pixbuf_get_pixel, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0("gdk_pixbuf_loader_write", sl_gdk_pixbuf_loader_write, SLANG_VOID_TYPE),
   /* MAKE_INTRINSIC_0("", sl_ SLANG_VOID_TYPE), */
   SLANG_END_INTRIN_FUN_TABLE
};

static SLang_Intrin_Var_Type Intrin_Vars[] =
{
   MAKE_VARIABLE("_gdk_pixbuf_version", &_gdk_pixbuf_version,SLANG_UINT_TYPE,1),
   SLANG_END_INTRIN_VAR_TABLE
};

static int init_sl_gdkpixbuf(SLang_NameSpace_Type *ns)  /* {{{ */
{
   if (-1 == SLns_add_intrin_var_table (ns, Intrin_Vars, NULL))
     return -1;
   
   return SLns_add_intrin_fun_table (ns, Intrin_Funcs, "__GDKPIXBUF__");
}  /* }}} */
