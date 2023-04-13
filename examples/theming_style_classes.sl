% Theming/Style Classes
%
% GTK+ uses CSS for theming. Style classes can be associated
% with widgets to inform the theme about intended rendering.
%
% This demo shows some common examples where theming features
% of GTK+ are used for certain effects: primary toolbars,
% inline toolbars and linked buttons.
%

define create_theming_style_classes (do_widget)
{
   variable window, grid, builder;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Style Classes");
   gtk_window_set_resizable (window, FALSE);
   gtk_container_set_border_width (window, 12);

   builder = gtk_builder_new_from_resource ("/theming_style_classes/theming.ui");

   grid = gtk_builder_get_object (builder, "grid");
   gtk_widget_show_all (grid);
   gtk_container_add (window, grid);
   g_object_unref (builder);

  ifnot (gtk_widget_get_visible (window))
    gtk_widget_show (window);
  else
    gtk_widget_destroy (window);

  return window;
}
