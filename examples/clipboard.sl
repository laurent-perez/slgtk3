% Clipboard
%
% GtkClipboard is used for clipboard handling. This demo shows how to
% copy and paste text to and from the clipboard.
%
% It also shows how to transfer images via the clipboard or via
% drag-and-drop, and how to make clipboard contents persist after
% the application exits. Clipboard persistence requires a clipboard
% manager to run.
%

variable GDK_SELECTION_CLIPBOARD = _gdk_make_atom (69);

define copy_button_clicked (button, entry)
{
   variable clipboard;
   
   % Get the clipboard object
   clipboard = gtk_widget_get_clipboard (entry, GDK_SELECTION_CLIPBOARD);

   % Set clipboard text
   gtk_clipboard_set_text (clipboard, gtk_entry_get_text (entry), -1);
}

define paste_received (clipboard, text, entry)
{
   % Set the entry text
   if (text != NULL)
     gtk_entry_set_text (entry, text);
}

define paste_button_clicked (button, entry)
{
   variable clipboard;
   
   % Get the clipboard object
   clipboard = gtk_widget_get_clipboard (entry, GDK_SELECTION_CLIPBOARD);

   % Request the contents of the clipboard, contents_received will be
   % called when we do get the contents.
   gtk_clipboard_request_text (clipboard, &paste_received, entry);
}

define get_image_pixbuf (image)
{
   variable size, icon_name, icon_theme, width;

   width = 20;
   switch (gtk_image_get_storage_type (image))
     { case GTK_IMAGE_PIXBUF:
  	return g_object_ref (gtk_image_get_pixbuf (image));
     }   
     { case GTK_IMAGE_ICON_NAME:
	(icon_name, size) = gtk_image_get_icon_name (image);
  	icon_theme = gtk_icon_theme_get_for_screen (gtk_widget_get_screen (image));
  	(width, ) = gtk_icon_size_lookup (size);
  	return gtk_icon_theme_load_icon (icon_theme, icon_name, width,
					 GTK_ICON_LOOKUP_GENERIC_FALLBACK);
     }   
     { vmessage ("Image storage type %d not handled",
		 gtk_image_get_storage_type (image));
	return NULL;
     }
}

define drag_begin (widget, context, data)
{
   variable pixbuf;

   pixbuf = get_image_pixbuf (data);
   gtk_drag_set_icon_pixbuf (context, pixbuf, -2, -2);
   % g_object_unref (pixbuf);
}

define drag_data_get (widget, context, selection_data, info, time, data)
{
   variable pixbuf;

   pixbuf = get_image_pixbuf (data);
   gtk_selection_data_set_pixbuf (selection_data, pixbuf);
   % g_object_unref (pixbuf);
}

define drag_data_received (widget, context, x, y, selection_data, info, time, data)
{
   variable pixbuf;

   if (gtk_selection_data_get_length (selection_data) > 0)
     {
	pixbuf = gtk_selection_data_get_pixbuf (selection_data);
	gtk_image_set_from_pixbuf (data, pixbuf);
	% g_object_unref (pixbuf);
     }
}

define copy_image (item, data)
{
   variable clipboard, pixbuf;

   clipboard = gtk_clipboard_get (GDK_SELECTION_CLIPBOARD);
   pixbuf = get_image_pixbuf (data);

   gtk_clipboard_set_image (clipboard, pixbuf);
   % g_object_unref (pixbuf);
}

define paste_image (item, data)
{
   variable clipboard, pixbuf;

   clipboard = gtk_clipboard_get (GDK_SELECTION_CLIPBOARD);
   pixbuf = gtk_clipboard_wait_for_image (clipboard);

   if (pixbuf != NULL)
     {
	gtk_image_set_from_pixbuf (data, pixbuf);
	% g_object_unref (pixbuf);
     }
}

define button_press (widget, event, data)
{
   variable menu, item, button;
   
   if (gdk_event_get_button (event) != GDK_BUTTON_SECONDARY)
     return FALSE;

   menu = gtk_menu_new ();

   item = gtk_menu_item_new_with_mnemonic ("_Copy");
   () = g_signal_connect (item, "activate", &copy_image, data);
   gtk_widget_show (item);
   gtk_menu_shell_append (menu, item);

   item = gtk_menu_item_new_with_mnemonic ("_Paste");
   () = g_signal_connect (item, "activate", &paste_image, data);
   gtk_widget_show (item);
   gtk_menu_shell_append (menu, item);
   
   gtk_menu_popup_at_pointer (menu, event);

   return TRUE;
}

define create_clipboard (do_widget)
{
   variable window, vbox, hbox, label, entry, button, ebox, image, clipboard;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Clipboard");

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_set_border_width (vbox, 8);

   gtk_container_add (window, vbox);

   label = gtk_label_new ("\"Copy\" will copy the text\nin the entry to the clipboard");

   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 4);
   gtk_container_set_border_width (hbox, 8);
   gtk_box_pack_start (vbox, hbox, FALSE, FALSE, 0);

   % Create the first entry
   entry = gtk_entry_new ();
   gtk_box_pack_start (hbox, entry, TRUE, TRUE, 0);

   % Create the button
   button = gtk_button_new_with_mnemonic ("_Copy");
   gtk_box_pack_start (hbox, button, FALSE, FALSE, 0);
   () = g_signal_connect (button, "clicked", &copy_button_clicked, entry);

   label = gtk_label_new ("\"Paste\" will paste the text from the clipboard to the entry");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 4);
   gtk_container_set_border_width (hbox, 8);
   gtk_box_pack_start (vbox, hbox, FALSE, FALSE, 0);

   % Create the second entry
   entry = gtk_entry_new ();
   gtk_box_pack_start (hbox, entry, TRUE, TRUE, 0);

   % Create the button
   button = gtk_button_new_with_mnemonic ("_Paste");
   gtk_box_pack_start (hbox, button, FALSE, FALSE, 0);
   () = g_signal_connect (button, "clicked", &paste_button_clicked, entry);

   label = gtk_label_new ("Images can be transferred via the clipboard, too");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 4);
   gtk_container_set_border_width (hbox, 8);
   gtk_box_pack_start (vbox, hbox, FALSE, FALSE, 0);

   % Create the first image
   image = gtk_image_new_from_icon_name ("dialog-warning", GTK_ICON_SIZE_BUTTON);
   ebox = gtk_event_box_new ();
   gtk_container_add (ebox, image);
   gtk_container_add (hbox, ebox);

   % make ebox a drag source
   gtk_drag_source_set (ebox, GDK_BUTTON1_MASK, , GDK_ACTION_COPY);
   gtk_drag_source_add_image_targets (ebox);
   () = g_signal_connect (ebox, "drag-begin", &drag_begin, image);
   () = g_signal_connect (ebox, "drag-data-get", &drag_data_get, image);

   % accept drops on ebox
   gtk_drag_dest_set (ebox, GTK_DEST_DEFAULT_ALL, , GDK_ACTION_COPY);
   gtk_drag_dest_add_image_targets (ebox);
   () = g_signal_connect (ebox, "drag-data-received", &drag_data_received, image);

   % context menu on ebox
   gtk_widget_set_events (ebox, GDK_BUTTON_PRESS_MASK);
   () = g_signal_connect (ebox, "button-press-event", &button_press, image);

   % Create the second image
   image = gtk_image_new_from_icon_name ("process-stop", GTK_ICON_SIZE_BUTTON);
   ebox = gtk_event_box_new ();
   gtk_container_add (ebox, image);
   gtk_container_add (hbox, ebox);

   % make ebox a drag source
   gtk_drag_source_set (ebox, GDK_BUTTON1_MASK, , GDK_ACTION_COPY);
   gtk_drag_source_add_image_targets (ebox);
   () = g_signal_connect (ebox, "drag-begin", &drag_begin, image);
   () = g_signal_connect (ebox, "drag-data-get", &drag_data_get, image);

   % accept drops on ebox
   gtk_drag_dest_set (ebox, GTK_DEST_DEFAULT_ALL, , GDK_ACTION_COPY);
   gtk_drag_dest_add_image_targets (ebox);
   () = g_signal_connect (ebox, "drag-data-received", &drag_data_received, image);

   % context menu on ebox
   () = g_signal_connect (ebox, "button-press-event", &button_press, image);

   % tell the clipboard manager to make the data persistent
   clipboard = gtk_clipboard_get (GDK_SELECTION_CLIPBOARD);
   gtk_clipboard_set_can_store (clipboard, [NULL]);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
