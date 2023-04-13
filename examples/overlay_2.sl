% Overlay/Decorative Overlay
%
% Another example of an overlay with some decorative
% and some interactive controls.
%


variable tag;

define margin_changed (adjustment, text)
{
   variable value;

   value = gtk_adjustment_get_value (adjustment);
   gtk_text_view_set_left_margin (text, int (value));
   gtk_text_view_set_pixels_above_lines (text, int (value));
}

define create_overlay_2 (do_widget)
{
   variable window;
   variable overlay, sw, text, image, scale, buffer, start, end, adjustment;
   
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_default_size (window, 500, 510);
   gtk_window_set_title (window, "Decorative Overlay");

   overlay = gtk_overlay_new ();
   sw = gtk_scrolled_window_new (,);
   gtk_scrolled_window_set_policy (sw, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
   text = gtk_text_view_new ();
   buffer = gtk_text_view_get_buffer (text);

   gtk_text_buffer_set_text (buffer, "Dear diary...");

   tag = gtk_text_buffer_create_tag (buffer, "top-margin",
				     "pixels-above-lines", 0);
   start = gtk_text_buffer_get_start_iter (buffer);
   end = start;
   gtk_text_iter_forward_word_end (end);
   gtk_text_buffer_apply_tag (buffer, tag, start, end);
   
   gtk_container_add (window, overlay);
   gtk_container_add (overlay, sw);
   gtk_container_add (sw, text);
   
   image = gtk_image_new_from_resource ("/overlay2/decor1.png");
   gtk_overlay_add_overlay (overlay, image);
   gtk_overlay_set_overlay_pass_through (overlay, image, TRUE);
   gtk_widget_set_halign (image, GTK_ALIGN_START);
   gtk_widget_set_valign (image, GTK_ALIGN_START);

   image = gtk_image_new_from_resource ("/overlay2/decor2.png");
   gtk_overlay_add_overlay (overlay, image);
   gtk_overlay_set_overlay_pass_through (overlay, image, TRUE);
   gtk_widget_set_halign (image, GTK_ALIGN_END);
   gtk_widget_set_valign (image, GTK_ALIGN_END);

   adjustment = gtk_adjustment_new (0, 0, 100, 1, 1, 0);
   () = g_signal_connect (adjustment, "value-changed", &margin_changed, text);
   
   scale = gtk_scale_new (GTK_ORIENTATION_HORIZONTAL, adjustment);
   gtk_scale_set_draw_value (scale, FALSE);
   gtk_widget_set_size_request (scale, 120, -1);
   gtk_widget_set_margin_start (scale, 20);
   gtk_widget_set_margin_end (scale, 20);
   gtk_widget_set_margin_bottom (scale, 20);
   gtk_overlay_add_overlay (overlay, scale);
   gtk_widget_set_halign (scale, GTK_ALIGN_START);
   gtk_widget_set_valign (scale, GTK_ALIGN_END);
   gtk_widget_set_tooltip_text (scale, "Margin");

   gtk_adjustment_set_value (adjustment, 100);
   
   gtk_widget_show_all (overlay);
   
   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
