% Text View/Tabs
%
% GtkTextView can position text at fixed positions, using tabs.
%

define create_tabs (do_widget)
{
   variable window, view, sw, buffer, tabs;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_title (window, "Tabs");
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_default_size (window, 450, 450);

   gtk_container_set_border_width (window, 0);
       
   view = gtk_text_view_new ();
   gtk_text_view_set_wrap_mode (view, GTK_WRAP_WORD);
   gtk_text_view_set_left_margin (view, 20);
   gtk_text_view_set_right_margin (view, 20);

   tabs = pango_tab_array_new (3, TRUE);
   pango_tab_array_set_tab (tabs, 0, PANGO_TAB_LEFT, 0);
   pango_tab_array_set_tab (tabs, 1, PANGO_TAB_LEFT, 150);
   pango_tab_array_set_tab (tabs, 2, PANGO_TAB_LEFT, 300);
   gtk_text_view_set_tabs (view, tabs);
   % pango_tab_array_free (tabs);

   buffer = gtk_text_view_get_buffer (view);
   gtk_text_buffer_set_text (buffer, "one\ttwo\tthree\nfour\tfive\tsix\nseven\teight\tnine");
   
   sw = gtk_scrolled_window_new (,);
   gtk_scrolled_window_set_policy (sw, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
   gtk_container_add (window, sw);
   gtk_container_add (sw, view);

   gtk_widget_show_all (sw);
   
   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
