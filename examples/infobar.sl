% Info Bars
%
% Info bar widgets are used to report important messages to the user.
%

define on_dialog_response (dialog, response_id)
{
   gtk_widget_destroy (dialog);
}

define on_bar_response (info_bar, response_id, data)
{
  variable dialog, window;

   if (response_id == GTK_RESPONSE_CLOSE)
     {
	gtk_widget_hide (info_bar);
	return;
    }

   window = gtk_widget_get_toplevel (info_bar);
   dialog = gtk_message_dialog_new (window,
				    GTK_DIALOG_MODAL | GTK_DIALOG_DESTROY_WITH_PARENT,
				    GTK_MESSAGE_INFO,
				    GTK_BUTTONS_OK,
				    "You clicked a button on an info bar");
   gtk_message_dialog_format_secondary_text (dialog, "Your response has id " + string (response_id));
   
   () = g_signal_connect (dialog, "response", &on_dialog_response);

   gtk_widget_show_all (dialog);
}

define create_infobar (do_widget)
{
  variable window, frame, bar, vbox, vbox2, label, actions, button;

   actions = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 0);
   
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Info Bars");

   gtk_container_set_border_width (window, 8);
	
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_add (window, vbox);

   bar = gtk_info_bar_new ();
   gtk_box_pack_start (vbox, bar, FALSE, FALSE, 0);
   gtk_info_bar_set_message_type (bar, GTK_MESSAGE_INFO);
   label = gtk_label_new ("This is an info bar with message type GTK_MESSAGE_INFO");
   gtk_label_set_line_wrap (label, TRUE);
#ifeval (_gtk3_version >= 31600)
   gtk_label_set_xalign (label, 0);
#endif
   gtk_box_pack_start (gtk_info_bar_get_content_area (bar), label, FALSE, FALSE, 0);

   button = gtk_toggle_button_new_with_label ("Message");
   g_object_bind_property (button, "active", bar, "visible", G_BINDING_BIDIRECTIONAL);
   gtk_container_add (actions, button);

   bar = gtk_info_bar_new ();
   gtk_box_pack_start (vbox, bar, FALSE, FALSE, 0);
   gtk_info_bar_set_message_type (bar, GTK_MESSAGE_WARNING);
   label = gtk_label_new ("This is an info bar with message type GTK_MESSAGE_WARNING");
   gtk_label_set_line_wrap (label, TRUE);
#ifeval (_gtk3_version >= 31600)
   gtk_label_set_xalign (label, 0);
#endif
   gtk_box_pack_start (gtk_info_bar_get_content_area (bar), label, FALSE, FALSE, 0);
   
   button = gtk_toggle_button_new_with_label ("Warning");
   g_object_bind_property (button, "active", bar, "visible", G_BINDING_BIDIRECTIONAL);
   gtk_container_add (actions, button);

   bar = gtk_info_bar_new_with_buttons (["_OK"], [GTK_RESPONSE_OK]);
#ifeval (_gtk3_version >= 31000)
   gtk_info_bar_set_show_close_button (bar, TRUE);
#endif
   () = g_signal_connect (bar, "response", &on_bar_response, window);
   gtk_box_pack_start (vbox, bar, FALSE, FALSE, 0);
   gtk_info_bar_set_message_type (bar, GTK_MESSAGE_QUESTION);
   label = gtk_label_new ("This is an info bar with message type GTK_MESSAGE_QUESTION");
   gtk_label_set_line_wrap (label, TRUE);
#ifeval (_gtk3_version >= 31600)
   gtk_label_set_xalign (label, 0);
#endif
   gtk_box_pack_start (gtk_info_bar_get_content_area (bar), label, FALSE, FALSE, 0);
   
   button = gtk_toggle_button_new_with_label ("Question");
   g_object_bind_property (button, "active", bar, "visible", G_BINDING_BIDIRECTIONAL);
   gtk_container_add (actions, button);

   bar = gtk_info_bar_new ();
   gtk_box_pack_start (vbox, bar, FALSE, FALSE, 0);
   gtk_info_bar_set_message_type (bar, GTK_MESSAGE_ERROR);
   label = gtk_label_new ("This is an info bar with message type GTK_MESSAGE_ERROR");
   gtk_label_set_line_wrap (label, TRUE);
#ifeval (_gtk3_version >= 31600)
   gtk_label_set_xalign (label, 0);
#endif
   gtk_box_pack_start (gtk_info_bar_get_content_area (bar), label, FALSE, FALSE, 0);
   
   button = gtk_toggle_button_new_with_label ("Error");
   g_object_bind_property (button, "active", bar, "visible", G_BINDING_BIDIRECTIONAL);
   gtk_container_add (actions, button);

   bar = gtk_info_bar_new ();
   gtk_box_pack_start (vbox, bar, FALSE, FALSE, 0);
   gtk_info_bar_set_message_type (bar, GTK_MESSAGE_OTHER);
   label = gtk_label_new ("This is an info bar with message type GTK_MESSAGE_OTHER");
   gtk_label_set_line_wrap (label, TRUE);
#ifeval (_gtk3_version >= 31600)
   gtk_label_set_xalign (label, 0);
#endif
   gtk_box_pack_start (gtk_info_bar_get_content_area (bar), label, FALSE, FALSE, 0);
   
   button = gtk_toggle_button_new_with_label ("Other");
   g_object_bind_property (button, "active", bar, "visible", G_BINDING_BIDIRECTIONAL);
   gtk_container_add (actions, button);
   
   frame = gtk_frame_new ("Info bars");
   gtk_box_pack_start (vbox, frame, FALSE, FALSE, 8);
	
   vbox2 = gtk_box_new (GTK_ORIENTATION_VERTICAL, 8);
   gtk_container_set_border_width (vbox2, 8);
   gtk_container_add (frame, vbox2);
   
   % Standard message dialog
   label = gtk_label_new ("An example of different info bars");
   gtk_box_pack_start (vbox2, label, FALSE, FALSE, 0);

   gtk_widget_show_all (actions);
   gtk_box_pack_start (vbox2, actions, FALSE, FALSE, 0);
   
   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);

   return window;
}
