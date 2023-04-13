% Overlay/Interactive Overlay
%
% Shows widgets in static positions over a main widget.
%
% The overlayed widgets can be interactive controls such
% as the entry in this example, or just decorative, like
% the big blue label.
%


define do_number (button, entry)
{
   gtk_entry_set_text (entry, gtk_button_get_label (button));
}

define create_overlay (do_widget)
{
   variable window;
   variable overlay, grid, button, vbox, label, entry, i, j, text;
   
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_default_size (window, 500, 510);
   gtk_window_set_title (window, "Interactive Overlay");

   overlay = gtk_overlay_new ();
   grid = gtk_grid_new ();
   gtk_container_add (overlay, grid);

   entry = gtk_entry_new ();
       
   for (j = 0; j < 5; j ++)
     {
	for (i = 0; i < 5; i ++)
	  {
	     text = sprintf ("%d", 5*j + i);
	     button = gtk_button_new_with_label (text);
	     gtk_widget_set_hexpand (button, TRUE);
	     gtk_widget_set_vexpand (button, TRUE);
	     () = g_signal_connect (button, "clicked", &do_number, entry);
	     gtk_grid_attach (grid, button, i, j, 1, 1);
	  }
     }

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 10);
   gtk_overlay_add_overlay (overlay, vbox);
   gtk_overlay_set_overlay_pass_through (overlay, vbox, TRUE);
   gtk_widget_set_halign (vbox, GTK_ALIGN_CENTER);
   gtk_widget_set_valign (vbox, GTK_ALIGN_CENTER);
   
   label = gtk_label_new ("<span foreground='blue' weight='ultrabold' font='40'>Numbers</span>");
   gtk_label_set_use_markup (label, TRUE);
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 8);
   
   gtk_entry_set_placeholder_text (entry, "Your Lucky Number");
   gtk_box_pack_start (vbox, entry, FALSE, FALSE, 8);
   
   gtk_container_add (window, overlay);
   
   gtk_widget_show_all (overlay);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
