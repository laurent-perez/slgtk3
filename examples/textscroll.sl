% Text View/Automatic Scrolling
%
% This example demonstrates how to use the gravity of
% GtkTextMarks to keep a text view scrolled to the bottom
% while appending text.
%

variable spaces_end = "",count_end = 0, spaces_bottom = "", count_bottom = 0;

% Scroll to the end of the buffer.
define scroll_to_end (textview)
{
   variable buffer, iter, mark, text;
   
   buffer = gtk_text_view_get_buffer (textview);

   % Get "end" mark. It's located at the end of buffer because
   % of right gravity

   mark = gtk_text_buffer_get_mark (buffer, "end");
   iter = gtk_text_buffer_get_iter_at_mark (buffer, mark);

   % and insert some text at its position, the iter will be
   % revalidated after insertion to poto the end of inserted text

   % spaces = g_strnfill (count++, ' ');
   count_end += 1;
   spaces_end += " ";
   gtk_text_buffer_insert (buffer, iter, "\n", -1);
   gtk_text_buffer_insert (buffer, iter, spaces_end, -1);
   text = sprintf ("Scroll to end scroll to end scroll to end scroll to end %d", count_end);
   gtk_text_buffer_insert (buffer, iter, text, -1);
   
   % Now scroll the end mark onscreen.

   gtk_text_view_scroll_mark_onscreen (textview, mark);

   % Emulate typewriter behavior, shift to the left if we
   % are far enough to the right.

   if (count_end > 150)
     count_end = 0;
   
   return G_SOURCE_CONTINUE;
}

% Scroll to the bottom of the buffer.

define scroll_to_bottom (textview)
{
   variable buffer, iter, mark, text;

   buffer = gtk_text_view_get_buffer (textview);
   
   % Get end iterator */
   iter = gtk_text_buffer_get_end_iter (buffer);

   % and insert some text at it, the iter will be revalidated
   % after insertion to poto the end of inserted text
   count_bottom += 1;
   spaces_bottom += " ";
   gtk_text_buffer_insert (buffer, iter, "\n", -1);
   gtk_text_buffer_insert (buffer, iter, spaces_bottom, -1);
   text = sprintf ("Scroll to bottom scroll to bottom scroll to bottom scroll to bottom %d", count_bottom);
   gtk_text_buffer_insert (buffer, iter, text, -1);

   % Move the iterator to the beginning of line, so we don't scroll
   % in horizontal direction

   gtk_text_iter_set_line_offset (iter, 0);

   % and place the mark at iter. the mark will stay there after we
   % insert some text at the end because it has left gravity.

   mark = gtk_text_buffer_get_mark (buffer, "scroll");
   gtk_text_buffer_move_mark (buffer, mark, iter);

   % Scroll the mark onscreen.

   gtk_text_view_scroll_mark_onscreen (textview, mark);
   
   % Shift text back if we got enough to the right.

   if (count_bottom > 40)
     count_bottom = 0;
   
   return G_SOURCE_CONTINUE;
}

define setup_scroll (textview, to_end)
{
   variable buffer, iter;

   buffer = gtk_text_view_get_buffer (textview);
   iter = gtk_text_buffer_get_end_iter (buffer);

   if (to_end)
     {
	% If we want to scroll to the end, including horizontal scrolling,
	% then we just create a mark with right gravity at the end of the
	% buffer. It will stay at the end unless explicitly moved with
	% gtk_text_buffer_move_mark.

	() = gtk_text_buffer_create_mark (buffer, "end", iter, FALSE);

	% Add scrolling timeout.
	return g_timeout_add (50, &scroll_to_end, textview);
     }
   else
     {
	% If we want to scroll to the bottom, but not scroll horizontally,
	% then an end mark won't do the job. Just create a mark so we can
	% use it with gtk_text_view_scroll_mark_onscreen, we'll position it
	% explicitly when needed. Use left gravity so the mark stays where
	% we put it after inserting new text.

	() = gtk_text_buffer_create_mark (buffer, "scroll", iter, TRUE);

	% Add scrolling timeout.
	return g_timeout_add (100, &scroll_to_bottom, textview);
     }
}

define remove_timeout (window, timeout)
{
   g_source_remove (timeout);
}

define create_text_view (hbox, to_end)
{
   variable swindow, textview, timeout;

   swindow = gtk_scrolled_window_new (,);
   gtk_box_pack_start (hbox, swindow, TRUE, TRUE, 0);
   textview = gtk_text_view_new ();
   gtk_container_add (swindow, textview);

   timeout = setup_scroll (textview, to_end);

   % Remove the timeout in destroy handler, so we don't try to
   % scroll destroyed widget.

   () = g_signal_connect (textview, "destroy", &remove_timeout, timeout);
}

define create_textscroll (do_widget)
{
   variable window, hbox;
	
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_title (window, "Automatic Scrolling");
   gtk_window_set_default_size (window, 600, 400);
	
   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 6);
   gtk_box_set_homogeneous (hbox, TRUE);
   gtk_container_add ( window, hbox);
   
   create_text_view (hbox, TRUE);
   create_text_view (hbox, FALSE);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
