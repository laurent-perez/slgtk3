% Revealer
%
% GtkRevealer is a container that animates showing and hiding
% of its sole child with nice transitions.
%


static variable count = 0;
static variable timeout = 0;
variable builder;

define change_direction (revealer)
{
   vmessage ("revealer : %S", revealer);
   if (gtk_widget_get_mapped (revealer))
     {
	variable revealed;

	revealed = gtk_revealer_get_child_revealed (revealer);
	gtk_revealer_set_reveal_child (revealer, not revealed);
     }
}

define reveal_one (window)
{
   variable name, revealer;

   % builder = g_object_get_data (window, "builder");
   name = "revealer" + string (count);
   revealer = gtk_builder_get_object (builder, name);

   gtk_revealer_set_reveal_child (revealer, TRUE);

   % () = g_signal_connect (revealer, "notify::child-revealed", &change_direction);
   () = g_signal_connect (revealer, "notify::realized", &change_direction);

   count ++;
   if (count >= 9)
     {
	timeout = 0;
	return FALSE;
     }
   else
     return TRUE;
}

define on_destroy ()
{
   if (timeout != 0)
     {
	g_source_remove (timeout);
	timeout = 0;
     }
}

define create_revealer (do_widget)
{
   variable window;

   builder = gtk_builder_new_from_resource ("/revealer/revealer.ui");
   % builder = gtk_builder_new_from_file ("revealer.ui");
   gtk_builder_connect_signals (builder, );
   window = gtk_builder_get_object (builder, "window");
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   () = g_signal_connect (window, "destroy", &on_destroy);
   % g_object_set_data_full (window, "builder", builder, g_object_unref);

   ifnot (gtk_widget_get_visible (window))
    {
       count = 0;
       timeout = g_timeout_add (690, &reveal_one, window);
       gtk_widget_show_all (window);
    }
   else
     {
	gtk_widget_destroy (window);
     }
  return window;
}
