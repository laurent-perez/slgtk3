% Theming/Animated Backgrounds
%
% This demo is done in honour of the Pixbufs demo further down.
% It is done exclusively with CSS as the background of the window.
%

define show_parsing_error (provider, section, error, buffer)
{
   variable start, end, tag_name;

   start = gtk_text_buffer_get_iter_at_line_index (buffer,
						   gtk_css_section_get_start_line (section),
						   gtk_css_section_get_start_position (section));
   end = gtk_text_buffer_get_iter_at_line_index (buffer,
						 gtk_css_section_get_end_line (section),
						 gtk_css_section_get_end_position (section));

   
   % if (g_error_matches (error, GTK_CSS_PROVIDER_ERROR, GTK_CSS_PROVIDER_ERROR_DEPRECATED))
   if (g_error_matches (error, gtk_css_provider_error_quark (), GTK_CSS_PROVIDER_ERROR_DEPRECATED))
     tag_name = "warning";
   else
     tag_name = "error";

   gtk_text_buffer_apply_tag_by_name (buffer, tag_name, start, end);
}

define css_text_changed (buffer, provider)
{
   variable start, end, text, err;

   start = gtk_text_buffer_get_start_iter (buffer);
   end = gtk_text_buffer_get_end_iter (buffer);
   gtk_text_buffer_remove_all_tags (buffer, start, end);

   text = gtk_text_buffer_get_text (buffer, start, end, FALSE);

   try (err)
     () = gtk_css_provider_load_from_data (provider, text, -1);
   catch ApplicationError:
     message (err.object.message);

   gtk_style_context_reset_widgets (gdk_screen_get_default ());
}

define apply_css ();

define apply_css (widget, provider)
{
   gtk_style_context_add_provider (gtk_widget_get_style_context (widget), provider, 0xffffffff);
   
   if (g_type_check_instance_is_a (widget, gtk_container_get_type ()))
     gtk_container_forall (widget, &apply_css, provider);
}

define create_css_pixbufs (do_widget)
{
   variable window, paned, container, child, provider, text, bytes, fp, lines;
	
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_title (window, "Animated Backgrounds");
   gtk_window_set_transient_for (window, (do_widget));
   gtk_window_set_default_size (window, 400, 300);

   paned = gtk_paned_new (GTK_ORIENTATION_VERTICAL);
   gtk_container_add (window, paned);
	
   % Need a filler so we get a handle
   child = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_add (paned, child);

   text = gtk_text_buffer_new (NULL);
   gtk_text_buffer_create_tag (text,
			       "warning",
			       "underline", PANGO_UNDERLINE_SINGLE);
   gtk_text_buffer_create_tag (text,
			       "error",
			       "underline", PANGO_UNDERLINE_ERROR);
   
   provider = gtk_css_provider_new ();
   
   container = gtk_scrolled_window_new (,);
   gtk_container_add (paned, container);
   child = gtk_text_view_new_with_buffer (text);
   gtk_container_add (container, child);
   () = g_signal_connect (text, "changed", &css_text_changed, provider);
   
   % bytes = g_resources_lookup_data ("/css_pixbufs/css_pixbufs.css", 0);
   fp = fopen ("css/css_pixbufs.css", "r");
   lines = fgetslines (fp);
   bytes = strjoin (lines);
   () = fclose (fp);
   
   gtk_text_buffer_set_text (text, bytes);
   
   () = g_signal_connect (provider, "parsing-error", &show_parsing_error, gtk_text_view_get_buffer (child));
   
   apply_css (window, provider);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
