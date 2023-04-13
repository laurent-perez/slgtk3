% Drawing Area
%
% GtkDrawingArea is a blank area where you can draw custom displays
% of various kinds.
%
% This demo has two drawing areas. The checkerboard area shows
% how you can just draw something; all you have to do is write
% a signal handler for expose_event, as shown here.
%
% The "scribble" area is a bit more advanced, and shows how to handle
% events such as button presses and mouse motion. Click the mouse
% and drag in the scribble area to draw squiggles. Resize the window
% to clear the area.
%

try
{
   require ("cairo");
}
catch ImportError:
{
   exit (1);
}

% Pixmap for scribble area, to store current scribbles */
variable surface = NULL;
variable cr;

% Create a new surface of the appropriate size to store our scribbles */

define scribble_configure_event (widget, event)
{
  variable allocation, cr;

  if (surface != NULL)
     cairo_surface_destroy (surface);

   allocation = gtk_widget_get_allocation (widget);
   surface = gdk_window_create_similar_surface (gtk_widget_get_window (widget),
						CAIRO_CONTENT_COLOR,
						allocation.width,
						allocation.height);

  % Initialize the surface to white */
  cr = cairo_create (surface);

  cairo_set_source_rgb (cr, 1, 1, 1);
  cairo_paint (cr);

  cairo_destroy (cr);

  % We've handled the configure event, no need for further processing. */
  return TRUE;
}

% Redraw the screen from the surface */

define scribble_draw (widget, cr)
{
  cairo_set_source_surface (cr, surface, 0, 0);
  cairo_paint (cr);

  return FALSE;
}

% Draw a rectangle on the screen */
define draw_brush (widget, x, y)
{
  variable cr, update_rect = @GdkRectangle;

  update_rect.x = x - 3;
  update_rect.y = y - 3;
  update_rect.width = 6;
  update_rect.height = 6;

  % Path to the surface, where we store our state */
  cr = cairo_create (surface);

  gdk_cairo_rectangle (cr, update_rect);
  cairo_fill (cr);

  cairo_destroy (cr);

  % Now invalidate the affected region of the drawing area. */
  gdk_window_invalidate_rect (gtk_widget_get_window (widget),
                              update_rect,
                              FALSE);
}

define scribble_button_press_event (widget, event)
{
   variable x, y;
   
   if (surface == NULL)
     return FALSE; % paranoia check, in case we haven't gotten a configure event

   if (gdk_event_get_button (event) == GDK_BUTTON_PRIMARY)
     {
	(x, y) = gdk_event_get_coords (event);
	draw_brush (widget, typecast (x, Int_Type), typecast (y, Int_Type));
     }
   
   % We've handled the event, stop processing
   return TRUE;
}

define scribble_motion_notify_event (widget, event)
{
   variable x, y, state;

   % paranoia check, in case we haven't gotten a configure event
   if (surface == NULL)
     return FALSE;

   % This call is very important; it requests the next motion event.
   % If you don't call gdk_window_get_pointer() you'll only get
   % a single motion event. The reason is that we specified
   % GDK_POINTER_MOTION_HINT_MASK to gtk_widget_set_events().
   % If we hadn't specified that, we could just use event->x, event->y
   % as the pointer location. But we'd also get deluged in events.
   % By requesting the next event as we handle the current one,
   % we adefine getting a huge number of events faster than we
   % can cope.

   % gdk_window_get_pointer has been deprecated
   (, x, y, state) = gdk_window_get_device_position (gdk_event_get_window (event),
						     gdk_event_get_device (event));

   if (state & GDK_BUTTON1_MASK)
     draw_brush (widget, x, y);

   % We've handled it, stop processing */
   return TRUE;
}

define checkerboard_draw (da, cr)
{
   variable i, j, xcount, ycount, width, height;
   variable CHECK_SIZE = 10;
   variable SPACING = 2;

   % At the start of a draw handler, a clip region has been set on
   % the Cairo context, and the contents have been cleared to the
   % widget's background color. The docs for
   % gdk_window_begin_paint_region() give more details on how this
   % works.

   xcount = 0;
   width = gtk_widget_get_allocated_width (da);
   height = gtk_widget_get_allocated_height (da);
   i = SPACING;
   while (i < width)
     {
	j = SPACING;
	ycount = xcount mod 2; % start with even/odd depending on row
	while (j < height)
	  {
	     if (ycount mod 2)
	       cairo_set_source_rgb (cr, 0.45777, 0, 0.45777);
	     else
	       cairo_set_source_rgb (cr, 1, 1, 1);

	     % If we're outside the clip, this will do nothing.

	     cairo_rectangle (cr, i, j, CHECK_SIZE, CHECK_SIZE);
	     cairo_fill (cr);
	     
	     j += CHECK_SIZE + SPACING;
	     ++ycount;
	  }
	
	i += CHECK_SIZE + SPACING;
	++ xcount;
     }

   % return TRUE because we've handled this event, so no
   % further processing is required.

   return TRUE;
}

define close_window ()
{
   if (surface != NULL)
     cairo_surface_destroy (surface);
   surface = NULL;
}

define create_drawingarea (do_widget)
{
   variable window, frame;
   variable vbox;
   variable da;
   variable label;
   
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Drawing Area");
   
   () = g_signal_connect (window, "destroy", &close_window);
   
   gtk_container_set_border_width (window, 8);
   
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 8);
   gtk_container_set_border_width (vbox, 8);
   gtk_container_add (window, vbox);
	
   % Create the checkerboard area

   label = gtk_label_new ("");
   gtk_label_set_markup (label, "<u>Checkerboard pattern</u>");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);
   
   frame = gtk_frame_new (NULL);
   gtk_frame_set_shadow_type (frame, GTK_SHADOW_IN);
   gtk_box_pack_start (vbox, frame, TRUE, TRUE, 0);
   
   da = gtk_drawing_area_new ();
   % set a minimum size
   gtk_widget_set_size_request (da, 100, 100);
   
   gtk_container_add (frame, da);
   
   () = g_signal_connect (da, "draw", &checkerboard_draw);

   % Create the scribble area
   
   label = gtk_label_new ("");
   gtk_label_set_markup (label, "<u>Scribble area</u>");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);
   
   frame = gtk_frame_new (NULL);
   gtk_frame_set_shadow_type (frame, GTK_SHADOW_IN);
   gtk_box_pack_start (vbox, frame, TRUE, TRUE, 0);
   
   da = gtk_drawing_area_new ();
   % set a minimum size
   gtk_widget_set_size_request (da, 100, 100);
   
   gtk_container_add (frame, da);
   
   % Signals used to handle backing surface
   
   () = g_signal_connect (da, "draw", &scribble_draw);
   () = g_signal_connect (da, "configure-event", &scribble_configure_event);
   
   % Event signals
   
   () = g_signal_connect (da, "motion-notify-event", &scribble_motion_notify_event);
   () = g_signal_connect (da, "button-press-event", &scribble_button_press_event);
   
   
   % Ask to receive events the drawing area doesn't normally
   % subscribe to
   
   gtk_widget_set_events (da, gtk_widget_get_events (da)
			  | GDK_LEAVE_NOTIFY_MASK
			  | GDK_BUTTON_PRESS_MASK
			  | GDK_POINTER_MOTION_MASK
			  | GDK_POINTER_MOTION_HINT_MASK);
   
   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
