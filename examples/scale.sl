% Scale
%
% GtkScale is a way to select a value from a range.
% Scales can have marks to help pick special values,
% and they can also restrict the values that can be
% chosen.
%

define create_scale (do_widget)
{
   variable window, builder, err;

#ifeval (_gtk3_version > 31000)
   builder = gtk_builder_new_from_resource ("/scale/scale.ui");
   % builder = gtk_builder_new_from_file ("scale.ui");
#else
     {	
	builder = gtk_builder_new ();
	try (err)
	  () = gtk_builder_add_from_file (builder, "scale.ui");
	catch ApplicationError:
	  message (err.object.message);
     }   
#endif
   gtk_builder_connect_signals (builder, );
   window = gtk_builder_get_object (builder, "window1");
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
      
   return window;
}
