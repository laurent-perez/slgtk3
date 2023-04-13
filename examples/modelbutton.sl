% Model Button
%
% GtkModelButton is a button widget that is designed to be used with
% a GAction as model. The button will adjust its appearance according
% to the kind of action it is connected to.
%
% It is also possible to use GtkModelButton without a GAction. In this
% case, you should set the "role" attribute yourself, and connect to the
% "clicked" signal as you would for any other button.
%
% A common use of GtkModelButton is to implement menu-like content
% in popovers.
%

define tool_clicked (button, data)
{
   variable active;

   active = g_object_get_property (button, "active");
   g_object_set (button, "active", not active);
}

define create_modelbutton (do_widget)
{
   variable window, builder, actions;
   variable win_entries = GActionEntry [4];
   set_struct_fields (win_entries [0], "color", NULL, "s", "'red'", NULL);
   set_struct_fields (win_entries [1], "chocolate", NULL, NULL, "true", NULL);
   set_struct_fields (win_entries [2], "vanilla", NULL, NULL, "false", NULL);
   set_struct_fields (win_entries [3], "sprinkles", NULL, NULL, NULL, NULL);
   
#ifeval (_gtk3_version > 31000)
   % builder = gtk_builder_new_from_file ("modelbutton.ui");
   builder = gtk_builder_new_from_resource ("/modelbutton/modelbutton.ui");
#else
     {	
	builder = gtk_builder_new ();
	try (err)
	  () = gtk_builder_add_from_file (builder, "modelbutton.ui");
	catch ApplicationError:
	  message (err.object.message);
     }   
#endif
   gtk_builder_add_callback_symbol (builder, "tool_clicked", &tool_clicked);
   gtk_builder_connect_signals (builder, );

   window = gtk_builder_get_object (builder, "window1");
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   
   actions = g_simple_action_group_new ();

   g_action_map_add_action_entries (actions, win_entries);
   
#ifeval (_gtk3_version > 30600)
   gtk_widget_insert_action_group (window, "win", actions);
#endif   

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);   
   
   return window;
}
