% Entry/Delayed Search Entry
%
% GtkSearchEntry sets up GtkEntries ready for search. Search entries
% have their "changed" signal delayed and should be used
% when the searched operation is slow such as loads of entries
% to search, or online searches.
%


define search_changed_cb (entry, result_label)
{
   variable text;
   
   text = gtk_entry_get_text (entry);
   g_message ("search changed: " + text);
   gtk_label_set_text (result_label, text);
}

define changed_cb (editable)
{
   variable text;
   
   text = gtk_entry_get_text (editable);
}

define window_key_press_event_cb (widget, event, bar)
{
   return gtk_search_bar_handle_event (bar, event);
}

define  search_changed (entry, label)
{
   gtk_label_set_text (label, "search-changed");
}

define next_match (entry, label)
{
   gtk_label_set_text (label, "next-match");
}

define previous_match (entry, label)
{
   gtk_label_set_text (label, "previous-match");
}

define stop_search (entry, label)
{
   gtk_label_set_text (label, "stop-search");
}

define create_search_entry_delayed (do_widget)
{
   variable vbox, hbox, label, entry, container, searchbar, button;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_title (window, "Delayed Search Entry");
   gtk_window_set_transient_for (window, do_widget);
   gtk_window_set_resizable (window, TRUE);
   gtk_widget_set_size_request (window, 200, -1);

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_add (window, vbox);
   gtk_container_set_border_width (vbox, 0);

   entry = gtk_search_entry_new ();
   container = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 10);
   gtk_widget_set_halign (container, GTK_ALIGN_CENTER);
   gtk_box_pack_start (container, entry, FALSE, FALSE, 0);
   searchbar = gtk_search_bar_new ();
   gtk_search_bar_connect_entry (searchbar, entry);
   gtk_search_bar_set_show_close_button (searchbar, FALSE);
   gtk_container_add (searchbar, container);
   gtk_box_pack_start (vbox, searchbar, FALSE, FALSE, 0);
   
   % Hook the search bar to key presses
   () = g_signal_connect (window, "key-press-event", &window_key_press_event_cb, searchbar);

   % Help
   label = gtk_label_new ("Start Typing to search");
   gtk_box_pack_start (vbox, label, TRUE, TRUE, 0);
   
   % Toggle button
   button = gtk_toggle_button_new_with_label ("Search");
   g_object_bind_property (button,
			   "active", searchbar,
			   "search-mode-enabled", G_BINDING_BIDIRECTIONAL);
   gtk_box_pack_start (vbox, button, TRUE, TRUE, 0);
   
   % Result
   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 10);
   gtk_box_pack_start (vbox, hbox, TRUE, TRUE, 0);
   gtk_container_set_border_width ( hbox, 0);
   
   label = gtk_label_new ("Result:");
   gtk_label_set_xalign (label, 0.0);
   gtk_widget_set_margin_start (label, 6);
   gtk_box_pack_start (hbox, label, TRUE, TRUE, 0);
   
   label = gtk_label_new ("");
   gtk_box_pack_start (hbox, label, TRUE, TRUE, 0);

   () = g_signal_connect (entry, "search-changed", &search_changed_cb, label);
   () = g_signal_connect (entry, "changed", &changed_cb);

   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 10);
   gtk_box_pack_start (vbox, hbox, TRUE, TRUE, 0);
   gtk_container_set_border_width (hbox, 0);
   
   label = gtk_label_new ("Signal:");
   gtk_label_set_xalign (label, 0.0);
   gtk_widget_set_margin_start (label, 6);
   gtk_box_pack_start (hbox, label, TRUE, TRUE, 0);
   
   label = gtk_label_new ("");
   gtk_box_pack_start (hbox, label, TRUE, TRUE, 0);
   
   () = g_signal_connect (entry, "search-changed", &search_changed, label);
   () = g_signal_connect (entry, "next-match", &next_match, label);
   () = g_signal_connect (entry, "previous-match", &previous_match, label);
   () = g_signal_connect (entry, "stop-search", &stop_search, label);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
