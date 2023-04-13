% Size Groups
%
% GtkSizeGroup provides a mechanism for grouping a number of
% widgets together so they all request the same amount of space.
% This is typically useful when you want a column of widgets to
% have the same size, but you can't use a GtkTable widget.
%
% Note that size groups only affect the amount of space requested,
% not the size that the widgets finally receive. If you want the
% widgets in a GtkSizeGroup to actually be the same size, you need
% to pack them in such a way that they get the size they request
% and not more. For example, if you are packing your widgets
% into a table, you would not include the GTK_FILL flag.
%


% Convenience function to create a combo box holding a number of strings

define create_combo_box (strings)
{
   variable combo_box, str;

   combo_box = gtk_combo_box_text_new ();

   foreach str (strings)
     gtk_combo_box_text_append_text (combo_box, str);

   gtk_combo_box_set_active (combo_box, 0);

   return combo_box;
}

define add_row (table, row, size_group, label_text, options)
{
   variable combo_box, label;

   label = gtk_label_new_with_mnemonic (label_text);
   gtk_widget_set_halign (label, GTK_ALIGN_START);
   gtk_widget_set_valign (label, GTK_ALIGN_BASELINE);
   gtk_widget_set_hexpand (label, TRUE);
   gtk_grid_attach (table, label, 0, row, 1, 1);

   combo_box = create_combo_box (options);
   gtk_label_set_mnemonic_widget (label, combo_box);
   gtk_widget_set_halign (combo_box, GTK_ALIGN_END);
   gtk_widget_set_valign (combo_box, GTK_ALIGN_BASELINE);
   gtk_size_group_add_widget (size_group, combo_box);
   gtk_grid_attach (table, combo_box, 1, row, 1, 1);
}

define toggle_grouping (check_button, size_group)
{
   variable new_mode;

   % GTK_SIZE_GROUP_NONE is not generally useful, but is useful
   % here to show the effect of GTK_SIZE_GROUP_HORIZONTAL by
   % contrast.

   if (gtk_toggle_button_get_active (check_button))
     new_mode = GTK_SIZE_GROUP_HORIZONTAL;
   else
     new_mode = GTK_SIZE_GROUP_NONE;

   gtk_size_group_set_mode (size_group, new_mode);
}

define create_sizegroup (do_widget)
{
   variable window, table, frame, vbox, check_button, size_group;
   variable color_options = ["Red", "Green", "Blue"];
   variable dash_options = ["Solid", "Dashed", "Dotted"];
   variable end_options = ["Square", "Round", "Double Arrow"];

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Size Groups");
   gtk_window_set_resizable (window, FALSE);

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);
   gtk_container_add ( window, vbox);
   gtk_container_set_border_width ( vbox, 5);
   
   size_group = gtk_size_group_new (GTK_SIZE_GROUP_HORIZONTAL);
   g_object_set_data (window, "size-group", size_group);
   
   % Create one frame holding color options
   frame = gtk_frame_new ("Color Options");
   gtk_box_pack_start (vbox, frame, TRUE, TRUE, 0);

   table = gtk_grid_new ();
   gtk_container_set_border_width (table, 5);
   gtk_grid_set_row_spacing (table, 5);
   gtk_grid_set_column_spacing (table, 10);
   gtk_container_add (frame, table);
   
   add_row (table, 0, size_group, "_Foreground", color_options);
   add_row (table, 1, size_group, "_Background", color_options);
   
   % And another frame holding line style options
   frame = gtk_frame_new ("Line Options");
   gtk_box_pack_start (vbox, frame, FALSE, FALSE, 0);

   table = gtk_grid_new ();
   gtk_container_set_border_width (table, 5);
   gtk_grid_set_row_spacing (table, 5);
   gtk_grid_set_column_spacing (table, 10);
   gtk_container_add (frame, table);
   
   add_row (table, 0, size_group, "_Dashing", dash_options);
   add_row (table, 1, size_group, "_Line ends", end_options);
   
   % And a check button to turn grouping on and off
   check_button = gtk_check_button_new_with_mnemonic ("_Enable grouping");
   gtk_box_pack_start (vbox, check_button, FALSE, FALSE, 0);
   
   gtk_toggle_button_set_active (check_button, TRUE);
   () = g_signal_connect (check_button, "toggled", &toggle_grouping, size_group);

   if (not gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
