import ("gtk3");

% variable _current_namespace = current_namespace();
% #ifnexists gtk_main
% import("gtk3", _current_namespace);
% #endif

variable GDK_TYPE_PIXBUF = gdk_pixbuf_get_type ();
variable GTK_TYPE_WIDGET = gtk_widget_get_type ();

typedef struct
{
   name, activate, parameter_type, state, change_state
} GActionEntry;

% deprecated
typedef struct
{
   tv_sec, tv_usec
} GTimeVal;

% deprecated
typedef struct
{
   red, green, blue, pixel
} GdkColor;

typedef struct
{
   min_width, min_height, max_width, max_height, base_width, base_height,
   width_inc, height_inc, min_aspect, max_aspect, win_gravity
} GdkGeometry;

typedef struct
{
   keycode, group, level
} GdkKeymapKey;

typedef struct
{
   x, y
} GdkPoint;

typedef struct
{
   red, green, blue, alpha
} GdkRGBA;

typedef struct
{
   x, y, width, height
} GdkRectangle;

typedef struct
{
   left, right, top, bottom
} GtkBorder;

typedef struct
{
   start, end
} GtkPageRange;

typedef struct
{
   width, height
} GtkRequisition;

typedef struct
{
   x, y, width, height
} GdkAllocation;

typedef struct
{
   x, y, width, height
} PangoRectangle;

define gdk_point_new (x, y)
{
   variable p = @GdkPoint;
   
   p.x = x;
   p.y = y;
   
   return p;
}

define gdk_rectangle_new (x, y, w, h)
{
   variable r = @GdkRectangle;
   
   r.x = x;
   r.y = y;
   r.width = w;
   r.height = h;
   
   return r;
}

define gdk_rgba_new (r, g, b, a)
{
   variable color = @GdkRGBA;
   
   color.r = r;
   color.g = g;
   color.b = b;
   color.a = a;
   
   return color;
}

% this function is the s-lang conterpart of GTK_IS_CONTAINER macro in C
define gtk_is_container (widget)
{
   return g_type_check_instance_is_a (widget, gtk_container_get_type ());
}

% I'm too lazy to add functions for all those GTK_IS_XXX macros
% they should be rarely needed anyway, so this generic one will do the job
% gtk_is (widget, "container") does the same as gtk_is_container (widget) above
define gtk_is (widget, type)
{
   variable fname = "gtk_" + type + "_get_type";      
   
   return g_type_check_instance_is_a (widget, @__get_reference (fname));
}

provide ("gtk3");
