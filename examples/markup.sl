% Text View/Markup
%
% GtkTextBuffer lets you define your own tags that can influence
% text formatting in a variety of ways. In this example, we show
% that GtkTextBuffer can load Pango markup and automatically generate
% suitable tags.


variable stack, view, view2;

define source_toggled (button)
{
   variable markup, buffer, start, end;

   if (gtk_toggle_button_get_active (button))
     gtk_stack_set_visible_child_name (stack, "source");
   else
     {
	buffer = gtk_text_view_get_buffer (view2);
	(start, end) = gtk_text_buffer_get_bounds (buffer);
	markup = gtk_text_buffer_get_text (buffer, start, end, FALSE);

	buffer = gtk_text_view_get_buffer (view);
	(start, end) = gtk_text_buffer_get_bounds (buffer);
	gtk_text_buffer_delete (buffer, start, end);
	gtk_text_buffer_insert_markup (buffer, start, markup, -1);
	% g_free (markup);

	gtk_stack_set_visible_child_name (stack, "formatted");
     }
}

define create_markup (do_widget)
{
   variable window, fp, lines;
   variable sw, buffer, iter, bytes, markup, header, show_source;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_default_size (window, 450, 450);

   stack = gtk_stack_new ();
   gtk_widget_show (stack);
   gtk_container_add (window, stack);
   
   show_source = gtk_check_button_new_with_label ("Source");
   gtk_widget_set_valign (show_source, GTK_ALIGN_CENTER);
   () = g_signal_connect (show_source, "toggled", &source_toggled);
   
   header = gtk_header_bar_new ();
   gtk_header_bar_set_show_close_button (header, TRUE);
   gtk_header_bar_pack_start (header, show_source);
   gtk_widget_show_all (header);
   gtk_window_set_titlebar (window, header);
   
   gtk_window_set_title (window, "Markup");
	
   view = gtk_text_view_new ();
   gtk_text_view_set_editable (view, FALSE);
   gtk_text_view_set_wrap_mode (view, GTK_WRAP_WORD);
   gtk_text_view_set_left_margin (view, 10);
   gtk_text_view_set_right_margin (view, 10);
   
   sw = gtk_scrolled_window_new (,);
   gtk_scrolled_window_set_policy (sw, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
   gtk_container_add (sw, view);
   gtk_widget_show_all (sw);
   
   gtk_stack_add_named (stack, sw, "formatted");
   
   view2 = gtk_text_view_new ();
   gtk_text_view_set_wrap_mode (view2, GTK_WRAP_WORD);
   gtk_text_view_set_left_margin (view2, 10);
   gtk_text_view_set_right_margin (view2, 10);
   
   sw = gtk_scrolled_window_new (,);
   gtk_scrolled_window_set_policy (sw, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
   gtk_container_add (sw, view2);
   gtk_widget_show_all (sw);
   
   gtk_stack_add_named (stack, sw, "source");
   
   % bytes = g_resources_lookup_data ("/markup/markup.txt", 0, NULL);
   % markup = g_bytes_get_data (bytes, NULL);

   fp = fopen ("markup.txt", "r");
   lines = fgetslines (fp);
   markup = strjoin (lines);
   () = fclose (fp);
   
   buffer = gtk_text_view_get_buffer (view);
   iter = gtk_text_buffer_get_start_iter (buffer);
   gtk_text_buffer_insert_markup (buffer, iter, markup, -1);
   
   buffer = gtk_text_view_get_buffer (view2);
   iter = gtk_text_buffer_get_start_iter (buffer);
   gtk_text_buffer_insert (buffer, iter, markup, -1);
   
   gtk_widget_show (stack);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
