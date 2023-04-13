% Expander
%
% GtkExpander allows to provide additional content that is initially hidden.
% This is also known as "disclosure triangle".
%
% This example also shows how to make the window resizable only if the expander
% is expanded.
%

define response_cb (window, response_id)
{
   gtk_widget_destroy (window);
}

define expander_cb (expander, pspec, dialog)
{
   gtk_window_set_resizable (dialog, gtk_expander_get_expanded (expander));
}

define do_not_expand (child)
{
   % gtk_container_child_set (gtk_widget_get_parent (child), child,
			    % "expand", FALSE, "fill", FALSE);
   gtk_container_child_set_property (gtk_widget_get_parent (child), child,
				     "expand", FALSE);
   gtk_container_child_set_property (gtk_widget_get_parent (child), child,
   				     "fill", FALSE);
}

define create_expander (do_widget)
{
   variable window, toplevel, area, box, expander, sw, tv, buffer;

   window = gtk_message_dialog_new_with_markup (NULL,
						0,
						GTK_MESSAGE_ERROR,
						GTK_BUTTONS_CLOSE,
						"<big><b>Something went wrong</b></big>");
   gtk_message_dialog_format_secondary_text (window,
					     "Here are some more details but not the full story.");

   area = gtk_message_dialog_get_message_area (window);
   box = gtk_widget_get_parent (area);
   % gtk_container_child_set (gtk_widget_get_parent (box), box,
   % "expand", TRUE, "fill", TRUE);
   gtk_container_child_set_property (gtk_widget_get_parent (box), box,
				     "expand", TRUE);
   gtk_container_child_set_property (gtk_widget_get_parent (box), box,
				     "fill", TRUE);
   
   gtk_container_foreach (area, &do_not_expand);
   
   expander = gtk_expander_new ("Details:");
   sw = gtk_scrolled_window_new (NULL, NULL);
   gtk_scrolled_window_set_min_content_height (sw, 100);
   gtk_scrolled_window_set_shadow_type (sw, GTK_SHADOW_IN);
   gtk_scrolled_window_set_policy (sw, GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC);
   
   tv = gtk_text_view_new ();
   buffer = gtk_text_view_get_buffer (tv);
   gtk_text_view_set_editable (tv, FALSE);
   gtk_text_view_set_wrap_mode (tv, GTK_WRAP_WORD);
   gtk_text_buffer_set_text (buffer,
			     `Finally, the full story with all details.
And all the inside information, including
error codes, etc etc. Pages of information,
you might have to scroll down to read it all,
or even resize the window - it works !\n
A second paragraph will contain even more
innuendo, just to make you scroll down or
resize the window. Do it already !`);

   gtk_container_add (sw, tv);
   gtk_container_add (expander, sw);
   gtk_box_pack_end (area, expander, TRUE, TRUE, 0);
   gtk_widget_show_all (expander);
   
   () = g_signal_connect (expander, "notify::expanded", &expander_cb, window);
   () = g_signal_connect (window, "response", &response_cb);
   
   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
