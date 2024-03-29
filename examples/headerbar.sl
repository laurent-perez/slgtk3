% Header Bar
%
% GtkHeaderBar is a container that is suitable for implementing
% window titlebars. One of its features is that it can position
% a title (and optional subtitle) centered with regard to the
% full width, regardless of variable-width content at the left
% or right.
%
% It is commonly used with gtk_window_set_titlebar()
%

define create_headerbar (do_widget)
{
  variable window, header, button, box, image, icon;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_default_size (window, 600, 400);
       
   header = gtk_header_bar_new ();
   gtk_header_bar_set_show_close_button (header, TRUE);
   gtk_header_bar_set_title (header, "Welcome to Facebook - Log in, sign up or learn more");
   gtk_header_bar_set_has_subtitle (header, FALSE);
       
   button = gtk_button_new ();
   icon = g_themed_icon_new ("mail-send-receive-symbolic");
   image = gtk_image_new_from_gicon (icon, GTK_ICON_SIZE_BUTTON);
   g_object_unref (icon);
   gtk_container_add (button, image);
   gtk_header_bar_pack_end (header, button);

   box = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 0);
   gtk_style_context_add_class (gtk_widget_get_style_context (box), "linked");
   button = gtk_button_new ();
   gtk_container_add (button, gtk_image_new_from_icon_name ("pan-start-symbolic", GTK_ICON_SIZE_BUTTON));
   gtk_container_add (box, button);
   button = gtk_button_new ();
   gtk_container_add (button, gtk_image_new_from_icon_name ("pan-end-symbolic", GTK_ICON_SIZE_BUTTON));
   gtk_container_add (box, button);

   gtk_header_bar_pack_start (header, box);

   gtk_window_set_titlebar (window, header);

   gtk_container_add (window, gtk_text_view_new ());

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
