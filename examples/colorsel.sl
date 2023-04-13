% Color Chooser
%
% A GtkColorChooser lets the user choose a color. There are several
% implementations of the GtkColorChooser interface in GTK+. The
% GtkColorChooserDialog is a prebuilt dialog containing a
% GtkColorChooserWidget.
%

try
{
   require ("cairo");
}
catch ImportError:
{
   exit (1);
}

variable color = @GdkRGBA, window;

define draw_callback (widget, cr)
{
   gdk_cairo_set_source_rgba (cr, color);
   cairo_paint (cr);

   return TRUE;
}

define response_cb (dialog, response_id)
{
   if (response_id == GTK_RESPONSE_OK)
     color = gtk_color_chooser_get_rgba (dialog);
   
   gtk_widget_destroy (dialog);
}

define change_color_callback (button)
{
   variable dialog;
   
   dialog = gtk_color_chooser_dialog_new ("Changing color", window);
   gtk_window_set_modal (dialog, TRUE);
   gtk_color_chooser_set_rgba (dialog, color);
   () = g_signal_connect (dialog, "response", &response_cb);

   gtk_widget_show (dialog);
}

define create_colorsel (do_widget)
{
   variable frame, da, vbox, button;
   
   color.red = 0;
   color.blue = 1;
   color.green = 0;
   color.alpha = 1;
   
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Color Chooser");

   gtk_container_set_border_width (window, 8);

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 8);
   gtk_container_set_border_width (vbox, 8);
   gtk_container_add (window, vbox);
   
   % Create the color swatch area
       
   frame = gtk_frame_new (NULL);
   gtk_frame_set_shadow_type (frame, GTK_SHADOW_IN);
   gtk_box_pack_start (vbox, frame, TRUE, TRUE, 0);

   da = gtk_drawing_area_new ();
   () = g_signal_connect (da, "draw", &draw_callback);

   % set a minimum size
   gtk_widget_set_size_request (da, 200, 200);

   gtk_container_add (frame, da);
	
   button = gtk_button_new_with_mnemonic ("_Change the above color");
   gtk_widget_set_halign (button, GTK_ALIGN_END);
   gtk_widget_set_valign (button, GTK_ALIGN_CENTER);
   
   gtk_box_pack_start (vbox, button, FALSE, FALSE, 0);
   
   () = g_signal_connect (button, "clicked", &change_color_callback);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);

   return window;
}
