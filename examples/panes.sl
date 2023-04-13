% Paned Widgets
%
% The GtkPaned Widget divides its content area into two panes
% with a divider in between that the user can adjust. A separate
% child is placed into each pane. GtkPaned widgets can be split
% horizontally or vertially.
%
% There are a number of options that can be set for each pane.
% This test contains both a horizontal and a vertical GtkPaned
% widget, and allows you to adjust the options for each side of
% each widget.
%


define toggle_resize (widget, child)
{
   variable parent, is_child1, resize, shrink;

   parent = gtk_widget_get_parent (child);

   is_child1 = (child == gtk_paned_get_child1 (parent));
   
   % gtk_container_child_get (parent, child,
   % 			    "resize", &resize,
   % 			    "shrink", &shrink,
   % 			    NULL);
   resize = gtk_container_child_get_property (parent, child, "resize");
   shrink = gtk_container_child_get_property (parent, child, "shrink");
   
   g_object_ref (child);
   gtk_container_remove (parent, child);
   if (is_child1)
     gtk_paned_pack1 (parent, child, not resize, shrink);
   else
     gtk_paned_pack2 (parent, child, not resize, shrink);
   g_object_unref (child);
}

define toggle_shrink (widget, child)
{
   variable parent, is_child1, resize, shrink;

   parent = gtk_widget_get_parent (child);

   is_child1 = (child == gtk_paned_get_child1 (parent));
   
   % gtk_container_child_get (parent, child,
   % 			    "resize", &resize,
   % 			    "shrink", &shrink,
   % 			    NULL);
   resize = gtk_container_child_get_property (parent, child, "resize");
   shrink = gtk_container_child_get_property (parent, child, "shrink");

   g_object_ref (child);
   gtk_container_remove (parent, child);
   if (is_child1)
     gtk_paned_pack1 (parent, child, resize, not shrink);
   else
     gtk_paned_pack2 (parent, child, resize, not shrink);
   g_object_unref (child);
}

define create_pane_options (paned, frame_label, label1, label2)
{
   variable child1, child2, frame, table, label, check_button;

   child1 = gtk_paned_get_child1 (paned);
   child2 = gtk_paned_get_child2 (paned);

   frame = gtk_frame_new (frame_label);
   gtk_container_set_border_width (frame, 4);

   table = gtk_grid_new ();
   gtk_container_add (frame, table);

   label = gtk_label_new (label1);
   gtk_grid_attach (table, label, 0, 0, 1, 1);

   check_button = gtk_check_button_new_with_mnemonic ("_Resize");
   gtk_grid_attach (table, check_button, 0, 1, 1, 1);
   () = g_signal_connect (check_button, "toggled", &toggle_resize, child1);

   check_button = gtk_check_button_new_with_mnemonic ("_Shrink");
   gtk_grid_attach (table, check_button, 0, 2, 1, 1);
   gtk_toggle_button_set_active (check_button, TRUE);
   () = g_signal_connect (check_button, "toggled", &toggle_shrink, child1);

   label = gtk_label_new (label2);
   gtk_grid_attach (table, label, 1, 0, 1, 1);

   check_button = gtk_check_button_new_with_mnemonic ("_Resize");
   gtk_grid_attach (table, check_button, 1, 1, 1, 1);
   gtk_toggle_button_set_active (check_button, TRUE);
   () = g_signal_connect (check_button, "toggled", &toggle_resize, child2);

   check_button = gtk_check_button_new_with_mnemonic ("_Shrink");
   gtk_grid_attach (table, check_button, 1, 2, 1, 1);
   gtk_toggle_button_set_active (check_button, TRUE);
   () =g_signal_connect (check_button, "toggled", &toggle_shrink, child2);

   return frame;
}

define create_panes (do_widget)
{
   variable window, frame, hpaned, vpaned, button, vbox;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));

   gtk_window_set_title (window, "Paned Widgets");
   gtk_container_set_border_width (window, 0);
   
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_add (window, vbox);
   
   vpaned = gtk_paned_new (GTK_ORIENTATION_VERTICAL);
   gtk_box_pack_start (vbox, vpaned, TRUE, TRUE, 0);
   gtk_container_set_border_width (vpaned, 5);
   
   hpaned = gtk_paned_new (GTK_ORIENTATION_HORIZONTAL);
   gtk_paned_add1 (vpaned, hpaned);
   
   frame = gtk_frame_new (NULL);
   gtk_frame_set_shadow_type (frame, GTK_SHADOW_IN);
   gtk_widget_set_size_request (frame, 60, 60);
   gtk_paned_add1 (hpaned, frame);
   
   button = gtk_button_new_with_mnemonic ("_Hi there");
   gtk_container_add (frame, button);
   
   frame = gtk_frame_new (NULL);
   gtk_frame_set_shadow_type (frame, GTK_SHADOW_IN);
   gtk_widget_set_size_request (frame, 80, 60);
   gtk_paned_add2 (hpaned, frame);
   
   frame = gtk_frame_new (NULL);
   gtk_frame_set_shadow_type (frame, GTK_SHADOW_IN);
   gtk_widget_set_size_request (frame, 60, 80);
   gtk_paned_add2 (vpaned, frame);
   
   % Now create toggle buttons to control sizing
   
   gtk_box_pack_start (vbox,
		       create_pane_options (hpaned, "Horizontal", "Left", "Right"),
		       FALSE, FALSE, 0);
   
   gtk_box_pack_start (vbox,
		       create_pane_options (vpaned, "Vertical", "Top", "Bottom"),
		       FALSE, FALSE, 0);
   
   gtk_widget_show_all (vbox);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
