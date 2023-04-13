/* -*- mode: C; mode: fold; -*- */

/* This file is part of
 *
 * 	SLgtk3 : S-Lang bindings for GTK3 widget set
 *
 * Copyright (C) 2020 Laurent Perez <laurent.perez@unicaen.fr>
 * 
 * SLgtk3 is based on SLgtk : S-Lang bindings for GTK2
 * Large parts of SLgtk3 code have been borrowed to SLgtk
 *
 * Copyright (C) 2003-2010 Massachusetts Institute of Technology 
 * Copyright (C) 2002 Michael S. Noble <mnoble@space.mit.edu> */

#include <slang.h>
#include "config.h"

#include <glib-object.h>

#define SIZEOF_POINTER SIZEOF_CHAR_P
#define MODULE_NAME "SLgtk3"

extern int slgtk3_debug;

extern void slgtk_error_terminate_main_loop	(char* msg);

extern GClosure* slgtk_closure_new (SLang_Name_Type *function,
				    SLang_Any_Type **args,
				    unsigned int nargs,
				    SLang_Any_Type *swap_data);

void throw_gerror (GError *gerr);

extern int slgtk_pop_g_value (GValue *val);
extern int slgtk_push_g_value (const GValue *val);
extern int slgtk_push_boxed (const GValue *val);
extern int slgtk_usage_err (int expected_nargs, const char *usage_str);
extern void slgtk_free_malloced_string_array (char **strs, unsigned int n);
extern int slgtk_pop_key_val_pairs (unsigned int n, char ***keysp, char ***valsp);
extern int slgtk_extract_slang_args (unsigned int nargs, SLang_Any_Type ***pargs);
extern void slgtk_free_slang_args (unsigned int nargs, SLang_Any_Type **pargs);
extern void slgtk_patch_ftable (SLang_Intrin_Fun_Type *func_array, SLtype dummy_id, SLtype actual_id);

extern SLang_CStruct_Field_Type GFlagsValue_Layout [];
extern SLang_CStruct_Field_Type GdkKeymapKey_Layout [];
extern SLang_CStruct_Field_Type GdkColor_Layout [];
extern SLang_CStruct_Field_Type GdkGeometry_Layout [];
extern SLang_CStruct_Field_Type GdkRectangle_Layout [];
extern SLang_CStruct_Field_Type GdkPoint_Layout [];
extern SLang_CStruct_Field_Type *GtkAllocation_Layout;
extern SLang_CStruct_Field_Type	GError_Layout [];
extern SLang_CStruct_Field_Type	GTimeVal_Layout [];
extern SLang_CStruct_Field_Type GdkRGBA_Layout [];
extern SLang_CStruct_Field_Type PangoColor_Layout [];

#define DUMMY_TYPE 255

#if 0
#define O 		255

#define I               SLANG_INT_TYPE
#define UI              SLANG_UINT_TYPE
#define UL              SLANG_ULONG_TYPE
#define UC              SLANG_UCHAR_TYPE
#define S               SLANG_STRING_TYPE
#define F               SLANG_FLOAT_TYPE
#define D               SLANG_DOUBLE_TYPE
#define R               SLANG_REF_TYPE
#endif

#define BEGIN_DECLS
#define END_DECLS
