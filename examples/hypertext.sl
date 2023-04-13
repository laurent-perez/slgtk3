% Text View/Hypertext
%
% Usually, tags modify the appearance of text in the view, e.g. making it
% bold or colored or underlined. But tags are not restricted to appearance.
% They can also affect the behavior of mouse and key presses, as this demo
% shows.
%


% Inserts a piece of text into the buffer, giving it the usual
% appearance of a hyperlink in a web browser: blue and underlined.
% Additionally, attaches some data on the tag, to make it recognizable
% as a link.

define insert_link (buffer, iter, text, page)
{
   variable tag;

   tag = gtk_text_buffer_create_tag (buffer, NULL,
				     "foreground", "blue",
				     "underline", PANGO_UNDERLINE_SINGLE);
   g_object_set_data (tag, "page", page);
   gtk_text_buffer_insert_with_tags (buffer, iter, text, -1, tag);
}

% Fills the buffer with text and interspersed links. In any real
% hypertext app, this method would parse a file to identify the links.

define show_page (buffer, page)
{
   variable iter;

   gtk_text_buffer_set_text (buffer, "");
   iter = gtk_text_buffer_get_iter_at_offset (buffer, 0);
   if (page == 1)
     {
	gtk_text_buffer_insert (buffer, iter, "Some text to show that simple ", -1);
	insert_link (buffer, iter, "hyper text", 3);
	gtk_text_buffer_insert (buffer, iter, " can easily be realized with ", -1);
	insert_link (buffer, iter, "tags", 2);
	gtk_text_buffer_insert (buffer, iter, ".", -1);
     }
   else if (page == 2)
     {
	gtk_text_buffer_insert (buffer, iter,
				"A tag is an attribute that can be applied to some range of text. " +
				"For example, a tag might be called \"bold\" and make the text inside" +
				"the tag bold. However, the tag concept is more general than that;" +
				"tags don't have to affect appearance. They can instead affect the " +
				"behavior of mouse and key presses, \"lock\" a range of text so the " +
				"user can't edit it, or countless other things.\n", -1);
	insert_link (buffer, iter, "Go back", 1);
     }
   else if (page == 3)
     {
	variable tag;
	
	tag = gtk_text_buffer_create_tag (buffer, NULL,
					  "weight", PANGO_WEIGHT_BOLD);
	gtk_text_buffer_insert_with_tags (buffer, iter, "hypertext:\n", -1, tag);
	gtk_text_buffer_insert (buffer, iter,
				"machine-readable text that is not sequential but is organized " +
				"so that related items of information are connected.\n", -1);
	insert_link (buffer, iter, "Go back", 1);
     }
}

% Looks at all tags covering the position of iter in the text view,
% and if one of them is a link, follow it by showing the page identified
% by the data attached to it.

define follow_if_link (text_view, iter)
{
   variable tags, tag, page;

   tags = gtk_text_iter_get_tags (iter);
   foreach tag (tags)
     {
	page = g_object_get_data (tag, "page");

	if (page != 0)
	  {
	     show_page (gtk_text_view_get_buffer (text_view), page);
	     break;
	  }
     }
}

% Links can be activated by pressing Enter.

define key_press_event (text_view, event)
{
   variable iter, buffer;

   switch (gdk_event_get_keyval (event))
     {
      case GDK_KEY_Return:
      case GDK_KEY_KP_Enter:
        buffer = gtk_text_view_get_buffer (text_view);
        iter = gtk_text_buffer_get_iter_at_mark (buffer,
						 gtk_text_buffer_get_insert (buffer));
        follow_if_link (text_view, iter);
     }

  return FALSE;
}

% Links can also be activated by clicking or tapping.

define event_after (text_view, ev)
{
   variable start, end, iter, buffer, ex, ey, x, y, event, over_text;

  if (gdk_event_get_event_type (ev) == GDK_BUTTON_RELEASE)
     {
	if (gdk_event_get_button (ev) != GDK_BUTTON_PRIMARY)
	  return FALSE;

	(ex, ey) = gdk_event_get_coords (ev);
     }
   else if (gdk_event_get_event_type (ev) == GDK_TOUCH_END)
    {
       (ex, ey) = gdk_event_get_coords (ev);
    }
   else
    return FALSE;

   buffer = gtk_text_view_get_buffer (text_view);
   
   % we shouldn't follow a link if the user has selected something
   (start, end) = gtk_text_buffer_get_selection_bounds (buffer);
   if (gtk_text_iter_get_offset (start) != gtk_text_iter_get_offset (end))
     return FALSE;

   (x, y) = gtk_text_view_window_to_buffer_coords (text_view,
						   GTK_TEXT_WINDOW_WIDGET,
						   nint (ex), nint (ey));

   (over_text, iter) = gtk_text_view_get_iter_at_location (text_view, x, y);
   if (over_text)
     follow_if_link (text_view, iter);

  return TRUE;
}

variable hovering_over_link = FALSE;
variable hand_cursor = NULL;
variable regular_cursor = NULL;

% Looks at all tags covering the position (x, y) in the text view,
% and if one of them is a link, change the cursor to the "hands" cursor
% typically used by web browsers.

define set_cursor_if_appropriate (text_view, x, y)
{
   variable tags, tag, iter, hovering = FALSE, over_text, page;

   (over_text, iter) = gtk_text_view_get_iter_at_location (text_view, x, y);
   if (over_text)
     {
	tags = gtk_text_iter_get_tags (iter);
	foreach tag (tags)
	  {
	     page = g_object_get_data (tag, "page");
	     if (page != 0)
	       {
	     	  hovering = TRUE;
	     	  break;
	       }
	  }
     }
   
   if (hovering != hovering_over_link)
     {
	hovering_over_link = hovering;

	if (hovering_over_link)
	  gdk_window_set_cursor (gtk_text_view_get_window (text_view, GTK_TEXT_WINDOW_TEXT), hand_cursor);
	else
	  gdk_window_set_cursor (gtk_text_view_get_window (text_view, GTK_TEXT_WINDOW_TEXT), regular_cursor);
     }
}

% Update the cursor image if the pointer moved.

define motion_notify_event (text_view, event)
{
   variable x, y, ex, ey;

   (ex, ey) = gdk_event_get_coords (event);
   (x, y) = gtk_text_view_window_to_buffer_coords (text_view,
						   GTK_TEXT_WINDOW_WIDGET,
						   nint (ex), nint (ey));
   
   set_cursor_if_appropriate (text_view, x, y);
   
   return FALSE;
}

define create_hypertext (do_widget)
{
   variable window, view, sw, buffer, display;

   display = gtk_widget_get_display (do_widget);
   hand_cursor = gdk_cursor_new_from_name (display, "pointer");
   regular_cursor = gdk_cursor_new_from_name (display, "text");
   
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_title (window, "Hypertext");
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_default_size (window, 450, 450);
   
   gtk_container_set_border_width (window, 0);

   view = gtk_text_view_new ();
   gtk_text_view_set_wrap_mode (view, GTK_WRAP_WORD);
   gtk_text_view_set_left_margin (view, 20);
   gtk_text_view_set_right_margin (view, 20);
   () = g_signal_connect (view, "key-press-event", &key_press_event);
   () = g_signal_connect (view, "event-after", &event_after);
   () = g_signal_connect (view, "motion-notify-event", &motion_notify_event);
   
   buffer = gtk_text_view_get_buffer (view);
   
   sw = gtk_scrolled_window_new (NULL, NULL);
   gtk_scrolled_window_set_policy (sw, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
   gtk_container_add (window, sw);
   gtk_container_add (sw, view);
   
   show_page (buffer, 1);
   
   gtk_widget_show_all (sw);

   if (not gtk_widget_get_visible (window))
     gtk_widget_show (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
