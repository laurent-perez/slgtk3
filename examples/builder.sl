% Builder
%
% Demonstrates an interface loaded from a XML description.
%

define quit_activate (action, window)
{
   gtk_widget_destroy (window);
}

define about_activate (action, builder)
{
   variable about_dlg;

   about_dlg = gtk_builder_get_object (builder, "aboutdialog1");
   gtk_dialog_run (about_dlg);
   gtk_widget_hide (about_dlg);
}

define help_activate (action)
{   
   message ("Help not available");
}

define create_builder (do_widget)
{
  variable window, toolbar, item, builder, actions, accel_group, act, err;
   
#ifeval (_gtk3_version > 31000)
   builder = gtk_builder_new_from_file ("ui/demo.ui");
#else
     {	
	builder = gtk_builder_new ();
	try (err)
	  () = gtk_builder_add_from_file (builder, "ui/demo.ui");
	catch ApplicationError:
	  message (err.object.message);
     }   
#endif
   window = gtk_builder_get_object (builder, "window1");
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   toolbar = gtk_builder_get_object (builder, "toolbar1");
   gtk_style_context_add_class (gtk_widget_get_style_context (toolbar),
				"primary-toolbar");

   actions = g_simple_action_group_new ();

   act = g_simple_action_new ("about", NULL);
   () = g_signal_connect (act, "activate", &about_activate, builder);
   g_action_map_add_action (actions, act);
   act = g_simple_action_new ("help", NULL);
   () = g_signal_connect (act, "activate", &help_activate);
   g_action_map_add_action (actions, act);
   act = g_simple_action_new ("quit", NULL);
   () = g_signal_connect (act, "activate", &quit_activate, window);
   g_action_map_add_action (actions, act);

#ifeval (_gtk3_version > 30600)
   gtk_widget_insert_action_group (window, "win", actions);
#endif
   accel_group = gtk_accel_group_new ();
   gtk_window_add_accel_group (window, accel_group);

   item = gtk_builder_get_object (builder, "new_item");
   gtk_widget_add_accelerator (item, "activate", accel_group,
			       GDK_KEY_n, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE);

   item = gtk_builder_get_object (builder, "open_item");
   gtk_widget_add_accelerator (item, "activate", accel_group,
			       GDK_KEY_o, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE);

   item = gtk_builder_get_object (builder, "save_item");
   gtk_widget_add_accelerator (item, "activate", accel_group,
			       GDK_KEY_s, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE);

   item = gtk_builder_get_object (builder, "quit_item");
   gtk_widget_add_accelerator (item, "activate", accel_group,
			       GDK_KEY_q, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE);

   item = gtk_builder_get_object (builder, "copy_item");
   gtk_widget_add_accelerator (item, "activate", accel_group,
			       GDK_KEY_c, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE);
   
   item = gtk_builder_get_object (builder, "cut_item");
   gtk_widget_add_accelerator (item, "activate", accel_group,
			       GDK_KEY_x, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE);
   
   item = gtk_builder_get_object (builder, "paste_item");
   gtk_widget_add_accelerator (item, "activate", accel_group,
			       GDK_KEY_v, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE);
   
   item = gtk_builder_get_object (builder, "help_item");
   gtk_widget_add_accelerator (item, "activate", accel_group,
			       GDK_KEY_F1, 0, GTK_ACCEL_VISIBLE);

   item = gtk_builder_get_object (builder, "about_item");
   gtk_widget_add_accelerator (item, "activate", accel_group,
			       GDK_KEY_F7, 0, GTK_ACCEL_VISIBLE);
   
  ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);

  return window;
}
