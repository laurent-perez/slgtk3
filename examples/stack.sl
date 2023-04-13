% Stack
%
% GtkStack is a container that shows a single child at a time,
% with nice transitions when the visible child changes.
%
% GtkStackSwitcher adds buttons to control which child is visible.
%


define create_stack (do_widget)
{
  variable window, builder;

   builder = gtk_builder_new_from_resource ("/stack/stack.ui");
   gtk_builder_connect_signals (builder, );
   window = (gtk_builder_get_object (builder, "window1"));
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   % () = g_signal_connect (window, "destroy", &gtk_widget_destroyed, &window);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
