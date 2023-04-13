% Pango/Rotated Text
%
% This demo shows how to use PangoCairo to draw rotated and transformed
% text.  The right pane shows a rotated GtkLabel widget.
%
% In both cases, a custom PangoCairo shape renderer is installed to draw
% a red heart using cairo drawing operations instead of the Unicode heart
% character.
%

try
{
   require ("cairo");
}
catch ImportError:
{
   exit (1);
}

variable RADIUS = 150;
variable N_WORDS = 5;
variable FONT = "Serif 18";
variable HEART = "♥", text = "I ♥ GTK+";

define fancy_shape_renderer (cr, attr, do_path)
{
   variable x, y, ink_rect, data;
   
   (x, y) = cairo_get_current_point (cr);
   cairo_translate (cr, x, y);

   (ink_rect,) = pango_get_attr_shape_rect (attr);
   cairo_scale (cr, ink_rect.width / PANGO_SCALE, ink_rect.height / PANGO_SCALE);

   data = pango_attr_shape_get_data (attr);
   switch (data)
     { case 0x2665:
	% U+2665 BLACK HEART SUIT
        cairo_move_to (cr, .5, .0);
        cairo_line_to (cr, .9, -.4);
        cairo_curve_to (cr, 1.1, -.8, .5, -.9, .5, -.5);
        cairo_curve_to (cr, .5, -.9, -.1, -.8, .1, -.4);
        cairo_close_path (cr);
     }

   if (not do_path)
     {
   	cairo_set_source_rgb (cr, 1., 0., 0.);
   	cairo_fill (cr);
     }
}

define create_fancy_attr_list_for_layout (layout)
{
   variable attrs, metrics, ascent, ink_rect, logical_rect, p, attr, start_index;

   % Get font metrics and prepare fancy shape size
   metrics = pango_context_get_metrics (pango_layout_get_context (layout),
					pango_layout_get_font_description (layout), );
   ascent = pango_font_metrics_get_ascent (metrics);
   logical_rect = @PangoRectangle;
   logical_rect.x = 0;
   logical_rect.width = ascent;
   logical_rect.y = -ascent;
   logical_rect.height = ascent;
   ink_rect = @logical_rect;
   % pango_font_metrics_unref (metrics);

   % Set fancy shape attributes for all hearts
   attrs = pango_attr_list_new ();
   p = is_substr (text, HEART) - 1;
   attr = pango_attr_shape_new_with_data (ink_rect,
					  logical_rect,
					  g_utf8_get_char (HEART));

   pango_attr_set_index (attr, p, p + strbytelen (HEART));

   pango_attr_list_insert (attrs, attr);

   return attrs;
}

define rotated_text_draw (widget, cr)
{
   variable context, layout, desc, pattern, attrs, device_radius, width, height, i;
   
   % Create a cairo context and set up a transformation matrix so that the user
   % space coordinates for the centered square where we draw are [-RADIUS, RADIUS],
   % [-RADIUS, RADIUS].
   % We first center, then change the scale.
   width = gtk_widget_get_allocated_width (widget);
   height = gtk_widget_get_allocated_height (widget);
   device_radius = _min (width, height) / 2.;
   cairo_translate (cr,
		    device_radius + (width - 2 * device_radius) / 2,
		    device_radius + (height - 2 * device_radius) / 2);
   cairo_scale (cr, device_radius / RADIUS, device_radius / RADIUS);

   % Create a subtle gradient source and use it.
   pattern = cairo_pattern_create_linear (-RADIUS, -RADIUS, RADIUS, RADIUS);
   cairo_pattern_add_color_stop_rgb (pattern, 0., .5, .0, .0);
   cairo_pattern_add_color_stop_rgb (pattern, 1., .0, .0, .5);
   cairo_set_source (cr, pattern);

   % Create a PangoContext and set up our shape renderer
   context = gtk_widget_create_pango_context (widget);
   pango_cairo_context_set_shape_renderer (context, &fancy_shape_renderer);

   % Create a PangoLayout, set the text, font, and attributes
   layout = pango_layout_new (context);
   pango_layout_set_text (layout, text);
   desc = pango_font_description_from_string (FONT);
   pango_layout_set_font_description (layout, desc);

   attrs = create_fancy_attr_list_for_layout (layout);
   pango_layout_set_attributes (layout, attrs);
   pango_attr_list_unref (attrs);

   % Draw the layout N_WORDS times in a circle
   for (i = 0 ; i < N_WORDS ; i ++)
    {
       % Inform Pango to re-layout the text with the new transformation matrix
       pango_cairo_update_layout (cr, layout);
       (width, height) = pango_layout_get_pixel_size (layout);
       cairo_move_to (cr, - width / 2, - RADIUS * .9);
       pango_cairo_show_layout (cr, layout);

       % Rotate for the next turn
       cairo_rotate (cr, PI*2 / N_WORDS);
    }

   % free the objects we created
   pango_font_description_free (desc);
   g_object_unref (layout);
   g_object_unref (context);
   cairo_pattern_destroy (pattern);
   
   return FALSE;
}

define create_rotated_text (do_widget)
{
   variable window, box, drawing_area, label, layout, attrs;
   
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Rotated Text");
   gtk_window_set_default_size (window, 4 * RADIUS, 2 * RADIUS);

   box = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 0);
   gtk_box_set_homogeneous (box, TRUE);
   gtk_container_add (window, box);
   
   % Add a drawing area
   drawing_area = gtk_drawing_area_new ();
   gtk_container_add (box, drawing_area);
   gtk_style_context_add_class (gtk_widget_get_style_context (drawing_area),
				GTK_STYLE_CLASS_VIEW);

   () = g_signal_connect (drawing_area, "draw", &rotated_text_draw);

   % And a label
   label = gtk_label_new (text);
   gtk_container_add (box, label);

   gtk_label_set_angle (label, 45);
   
   % Set up fancy stuff on the label
   layout = gtk_label_get_layout (label);
   pango_cairo_context_set_shape_renderer (pango_layout_get_context (layout),
   					   &fancy_shape_renderer);
   attrs = create_fancy_attr_list_for_layout (layout);
   gtk_label_set_attributes (label, attrs);
   % pango_attr_list_unref (attrs);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);

   return window;
}
