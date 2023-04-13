% Gestures
%
% Perform gestures on touchscreens and other input devices. This
% demo reacts to long presses and swipes from all devices, plus
% multi-touch rotate and zoom gestures.
%

require ("cairo");

variable rotate = NULL;
variable zoom = NULL;
variable swipe_x = 0;
variable swipe_y = 0;
variable long_pressed = FALSE;

define swipe_gesture_swept (gesture, velocity_x, velocity_y, widget)
{
   swipe_x = velocity_x / 10;
   swipe_y = velocity_y / 10;
   gtk_widget_queue_draw (widget);
}

define long_press_gesture_pressed (gesture, gx, gy, widget)
{
   long_pressed = TRUE;
   gtk_widget_queue_draw (widget);
}

define long_press_gesture_end (gesture, sequence, widget)
{
   long_pressed = FALSE;
   gtk_widget_queue_draw (widget);
}

define rotation_angle_changed (gesture, angle, delta, widget)
{
   gtk_widget_queue_draw (widget);
}

define zoom_scale_changed (gesture, scale, widget)
{
   gtk_widget_queue_draw (widget);
}

define drawing_area_draw (widget, cr)
{
   variable allocation;

   allocation = gtk_widget_get_allocation (widget);

   if (swipe_x != 0 || swipe_y != 0)
     {
	cairo_save (cr);
	cairo_set_line_width (cr, 6);
	cairo_move_to (cr, allocation.width / 2, allocation.height / 2);
	cairo_rel_line_to (cr, swipe_x, swipe_y);
	cairo_set_source_rgba (cr, 1, 0, 0, 0.5);
	cairo_stroke (cr);
	cairo_restore (cr);
     }
   
   if (gtk_gesture_is_recognized (rotate) || gtk_gesture_is_recognized (zoom))
     {
	variable pat, matrix, angle, scale;

	matrix = cairo_get_matrix (cr);
	cairo_matrix_translate (matrix, allocation.width / 2, allocation.height / 2);
	cairo_save (cr);

	angle = gtk_gesture_rotate_get_angle_delta (rotate);
	cairo_matrix_rotate (matrix, angle);

	scale = gtk_gesture_zoom_get_scale_delta (zoom);
	cairo_matrix_scale (matrix, scale, scale);

	cairo_set_matrix (cr, matrix);
	cairo_rectangle (cr, -100, -100, 200, 200);

	pat = cairo_pattern_create_linear (-100, 0, 200, 0);
	cairo_pattern_add_color_stop_rgb (pat, 0, 0, 0, 1);
	cairo_pattern_add_color_stop_rgb (pat, 1, 1, 0, 0);
	cairo_set_source (cr, pat);
	cairo_fill (cr);

	cairo_restore (cr);
	
	cairo_pattern_destroy (pat);
     }

   if (long_pressed)
     {
	cairo_save (cr);
	cairo_arc (cr, allocation.width / 2, allocation.height / 2, 50, 0, 2 * PI);
	cairo_set_source_rgba (cr, 0, 1, 0, 0.5);
	cairo_stroke (cr);	
	cairo_restore (cr);
     }

   return TRUE;
}

define create_gestures (do_widget)
{
   variable window, drawing_area, gesture;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_default_size (window, 400, 400);
   gtk_window_set_title (window, "Gestures");
   
   drawing_area = gtk_drawing_area_new ();
   gtk_container_add ( window, drawing_area);
   gtk_widget_add_events (drawing_area,
			  GDK_BUTTON_PRESS_MASK | GDK_BUTTON_RELEASE_MASK |
			  GDK_POINTER_MOTION_MASK | GDK_TOUCH_MASK);

   () = g_signal_connect (drawing_area, "draw", &drawing_area_draw);

   % Swipe
   gesture = gtk_gesture_swipe_new (drawing_area);
   () = g_signal_connect (gesture, "swipe", &swipe_gesture_swept, drawing_area);
   gtk_event_controller_set_propagation_phase (gesture, GTK_PHASE_BUBBLE);
   % g_object_weak_ref (drawing_area, &g_object_unref, gesture);

   % Long press
   gesture = gtk_gesture_long_press_new (drawing_area);
   () = g_signal_connect (gesture, "pressed", &long_press_gesture_pressed, drawing_area);
   () = g_signal_connect (gesture, "end", &long_press_gesture_end, drawing_area);
   gtk_event_controller_set_propagation_phase (gesture, GTK_PHASE_BUBBLE);
   % g_object_weak_ref (drawing_area, &g_object_unref, gesture);

   % Rotate
   rotate = gtk_gesture_rotate_new (drawing_area);
   () = g_signal_connect (rotate, "angle-changed", &rotation_angle_changed, drawing_area);
   gtk_event_controller_set_propagation_phase (rotate, GTK_PHASE_BUBBLE);
   % g_object_weak_ref (drawing_area, &g_object_unref, rotate);

   % Zoom
   zoom = gtk_gesture_zoom_new (drawing_area);
   () = g_signal_connect (zoom, "scale-changed", &zoom_scale_changed, drawing_area);
   gtk_event_controller_set_propagation_phase (zoom, GTK_PHASE_BUBBLE);
   % g_object_weak_ref (drawing_area, &g_object_unref, rotate);
   
   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
