% Shortcuts Window
%
% GtkShortcutsWindow is a window that provides a help overlay
% for shortcuts and gestures in an application.
%


define show_shortcuts (window, id, view)
{
   variable builder, overlay, path;

   path = sprintf ("/shortcuts/%s.ui", id);
   builder = gtk_builder_new_from_resource (path);
   overlay = gtk_builder_get_object (builder, id);
   gtk_window_set_transient_for (overlay, window);
   g_object_set (overlay, "view-name", view);
   gtk_widget_show (overlay);
   % g_object_unref (builder);
}

define builder_shortcuts (window)
{
   show_shortcuts (window, "shortcuts-builder", NULL);
}

define gedit_shortcuts (window)
{
  show_shortcuts (window, "shortcuts-gedit", NULL);
}

define clocks_shortcuts (window)
{
   show_shortcuts (window, "shortcuts-clocks", NULL);
}

define clocks_shortcuts_stopwatch (window)
{
   show_shortcuts (window, "shortcuts-clocks", "stopwatch");
}

define boxes_shortcuts (window)
{
   show_shortcuts (window, "shortcuts-boxes", NULL);
}

define boxes_shortcuts_wizard (window)
{
   show_shortcuts (window, "shortcuts-boxes", "wizard");
}

define boxes_shortcuts_display (window)
{
   show_shortcuts (window, "shortcuts-boxes", "display");
}

define create_shortcuts (do_widget)
{
  variable window, icons_added = FALSE, builder;

  if (not icons_added)
    {
       icons_added = TRUE;
       gtk_icon_theme_add_resource_path (gtk_icon_theme_get_default (), "/icons");
    }

   builder = gtk_builder_new_from_resource ("/shortcuts/shortcuts.ui");
   % gtk_builder_add_callback_symbol (builder,
   % 				    "builder_shortcuts", &builder_shortcuts);
   % gtk_builder_add_callback_symbol (builder,
   % 				    "gedit_shortcuts", &gedit_shortcuts);
   % gtk_builder_add_callback_symbol (builder,
   % 				    "clocks_shortcuts", &clocks_shortcuts);
   % gtk_builder_add_callback_symbol (builder,
   % 				    "clocks_shortcuts_stopwatch", &clocks_shortcuts_stopwatch);
   % gtk_builder_add_callback_symbol (builder,
   % 				    "boxes_shortcuts", &boxes_shortcuts);
   % gtk_builder_add_callback_symbol (builder,
   % 				    "boxes_shortcuts_wizard", &boxes_shortcuts_wizard);
   % gtk_builder_add_callback_symbol (builder,
   % 				    "boxes_shortcuts_display", &boxes_shortcuts_display);

   gtk_builder_add_callback_symbols (builder,
   				     "builder_shortcuts", &builder_shortcuts,
   				     "gedit_shortcuts", &gedit_shortcuts,
   				     "clocks_shortcuts", &clocks_shortcuts,
   				     "clocks_shortcuts_stopwatch", &clocks_shortcuts_stopwatch,
   				     "boxes_shortcuts", &boxes_shortcuts,
   				     "boxes_shortcuts_wizard", &boxes_shortcuts_wizard,
   				     "boxes_shortcuts_display", &boxes_shortcuts_display);
   
   window = gtk_builder_get_object (builder, "window1");
   gtk_builder_connect_signals (builder, window);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   % g_object_unref (builder);

   if (not gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);

   return window;
}
