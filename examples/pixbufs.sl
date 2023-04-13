% Pixbufs
%
% A GdkPixbuf represents an image, normally in RGB or RGBA format.
% Pixbufs are normally used to load files from disk and perform
% image scaling.
%
% This demo is not all that educational, but looks cool. It was written
% by Extreme Pixbuf Hacker Federico Mena Quintero. It also shows
% off how to use GtkDrawingArea to do a simple animation.
%
% Look at the Image demo for additional pixbuf usage examples.
%
%

try
{
   require ("cairo");
}
catch ImportError:
{
   exit (1);
}

variable BACKGROUND_NAME = "/pixbufs/background.jpg";
variable image_names = ["/pixbufs/apple-red.png",
			"/pixbufs/gnome-applets.png",
			"/pixbufs/gnome-calendar.png",
			"/pixbufs/gnome-foot.png",
			"/pixbufs/gnome-gmush.png",
			"/pixbufs/gnome-gimp.png",
			"/pixbufs/gnome-gsame.png",
			"/pixbufs/gnu-keys.png"
		       ];

variable N_IMAGES = length (image_names);

% Current frame
variable frame;
% Background image
variable background = FALSE;

variable back_width, back_height;

% Images
variable images = GdkPixbuf_Type [N_IMAGES];

% Widgets
variable da;

% Loads the images for the demo and returns whether the operation succeeded
define load_pixbufs ()
{
   variable i, err;

   if (background)
     return TRUE; % already loaded earlier

   try (err)
   background = gdk_pixbuf_new_from_resource (BACKGROUND_NAME);
   %   background = gdk_pixbuf_new_from_file (BACKGROUND_NAME);
   catch AnyError:
     return err;

   back_width = gdk_pixbuf_get_width (background);
   back_height = gdk_pixbuf_get_height (background);

   for (i = 0 ; i < N_IMAGES ; i ++)
     {
	try (err)
	  images [i] = gdk_pixbuf_new_from_resource (image_names [i]);	
	  % images [i] = gdk_pixbuf_new_from_file (image_names [i]);
	catch AnyError:
	  return err;
     }
   
   return TRUE;
}

% Expose callback for the drawing area
define draw_cb (widget, cr)
{
   gdk_cairo_set_source_pixbuf (cr, frame, 0, 0);
   cairo_paint (cr);

   return TRUE;
}

variable CYCLE_TIME = 3000000; % 3 seconds

variable start_time = 0;

% Handler to regenerate the frame
define on_tick (widget, frame_clock)
{
   variable current_time, i, f, xmid, ymid, radius;
   variable ang, xpos, ypos, iw, ih, r, dest, k;
   variable r1 = @GdkRectangle, r2 = @GdkRectangle;
   
   gdk_pixbuf_copy_area (background, 0, 0, back_width, back_height, frame, 0, 0);
   
   if (start_time == 0)
     {	
#ifeval (_gtk3_version >= 30800)
	start_time = gdk_frame_clock_get_frame_time (frame_clock);   
#else
	start_time = g_get_monotonic_time ();
#endif
     }
#ifeval (_gtk3_version >= 30800)
   current_time = gdk_frame_clock_get_frame_time (frame_clock);
#else
   current_time = g_get_monotonic_time ();
#endif
   
   f = ((current_time - start_time) mod CYCLE_TIME) / (CYCLE_TIME * 1.0);
   
   xmid = back_width / 2.0;
   ymid = back_height / 2.0;

   radius = _min (xmid, ymid) / 2.0;

   for (i = 0; i < N_IMAGES; i ++)
     {
	ang = 2.0 * PI * i / N_IMAGES - f * 2.0 * PI;

	iw = gdk_pixbuf_get_width (images [i]);
	ih = gdk_pixbuf_get_height (images [i]);

	r = radius + (radius / 3.0) * sin (f * 2.0 * PI);

	xpos = floor (xmid + r * cos (ang) - iw / 2.0 + 0.5);
	ypos = floor (ymid + r * sin (ang) - ih / 2.0 + 0.5);

	k = (i & 1) ? sin (f * 2.0 * PI) : cos (f * 2.0 * PI);
	k = 2.0 * k * k;
	k = _max (0.25, k);

	r1.x = int (xpos);
	r1.y = int (ypos);
	r1.width = int (iw * k);
	r1.height = int (ih * k);

	r2.x = 0;
	r2.y = 0;
	r2.width = back_width;
	r2.height = back_height;

	dest = gdk_rectangle_intersect (r1, r2);
	if (dest != NULL)
	  gdk_pixbuf_composite (images [i], frame,
				dest.x, dest.y, dest.width, dest.height,
				xpos, ypos, k, k,
				GDK_INTERP_NEAREST,
				((i & 1)
				  ? int (_max (127, int (abs (255 * sin (f * 2.0 * PI)))))
				  : int (_max (127, int (abs (255 * cos (f * 2.0 * PI)))))));
     }

   gtk_widget_queue_draw (da);

   return G_SOURCE_CONTINUE;
   % return TRUE;
}

define create_pixbufs (do_widget)
{
   variable window, err;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Pixbufs");
   gtk_window_set_resizable (window, FALSE);

   err = load_pixbufs ();
   if (typeof (err) == Struct_Type)
     {
	variable dialog;
	
	dialog = gtk_message_dialog_new (window,
					 GTK_DIALOG_DESTROY_WITH_PARENT,
					 GTK_MESSAGE_ERROR,
					 GTK_BUTTONS_CLOSE,
					 "Failed to load an image : " + err.object.message);
	
	() = g_signal_connect (dialog, "response", &gtk_widget_destroy);
	
	gtk_widget_show (dialog);
     }
   else
     {
	gtk_widget_set_size_request (window, back_width, back_height);
	
	frame = gdk_pixbuf_new (GDK_COLORSPACE_RGB, FALSE, 8, back_width, back_height);
	
	da = gtk_drawing_area_new ();
	
	() = g_signal_connect (da, "draw", &draw_cb);
	
	gtk_container_add (window, da);
	
#ifeval (_gtk3_version >= 30800)
	() = gtk_widget_add_tick_callback (da, &on_tick);
#else
	() = g_idle_add (&on_tick, da, NULL);
#endif
     }

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     {
	gtk_widget_destroy (window);
	g_object_unref (frame);
     }
   
   return window;
}
