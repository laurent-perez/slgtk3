% Entry/Search Entry
%
% GtkEntry allows to display icons and progress information.
% This demo shows how to use these features in a search entry.
%


variable window = NULL;
variable menu = NULL;
variable notebook = NULL;
variable search_progress_id = 0;
variable finish_search_id = 0;

define show_find_button ()
{
   gtk_notebook_set_current_page (notebook, 0);
}

define show_cancel_button ()
{
   gtk_notebook_set_current_page (notebook, 1);
}

define search_progress (data)
{
   gtk_entry_progress_pulse (data);
   return G_SOURCE_CONTINUE;
}

define search_progress_done (entry)
{
   gtk_entry_set_progress_fraction (entry, 0.0);
}

define finish_search (button)
{
   show_find_button ();
   if (search_progress_id)
    {
       g_source_remove (search_progress_id);
       search_progress_id = 0;
    }
   return G_SOURCE_REMOVE;
}

define start_search_feedback (data)
{
   % search_progress_id = g_timeout_add_full (G_PRIORITY_DEFAULT, 100,
   % 					    &search_progress, data,
   % 					    search_progress_done);
   search_progress_id = g_timeout_add (100, &search_progress, data);

   return G_SOURCE_REMOVE;
}

define start_search (button, entry)
{
   show_cancel_button ();
   search_progress_id = g_timeout_add_seconds (1, &start_search_feedback, entry);
   finish_search_id = g_timeout_add_seconds (15, &finish_search, button);
}

define stop_search (button)
{
   if (finish_search_id)
     {
	g_source_remove (finish_search_id);
	finish_search_id = 0;
     }
   finish_search (button);
}

define clear_entry (entry)
{
   gtk_entry_set_text (entry, "");
}

define search_by_name (item, entry)
{
   gtk_entry_set_icon_tooltip_text (entry,
				    GTK_ENTRY_ICON_PRIMARY,
				    "Search by name\nClick here to change the search type");
   gtk_entry_set_placeholder_text (entry, "name");
}

define search_by_description (item, entry)
{
   gtk_entry_set_icon_tooltip_text (entry,
				    GTK_ENTRY_ICON_PRIMARY,
				    "Search by description\nClick here to change the search type");
   gtk_entry_set_placeholder_text (entry, "description");
}

define search_by_file (item, entry)
{
  gtk_entry_set_icon_tooltip_text (entry,
                                   GTK_ENTRY_ICON_PRIMARY,
                                   "Search by file name\nClick here to change the search type");
  gtk_entry_set_placeholder_text (entry, "file name");
}

define create_search_menu (entry)
{
   variable menu, item;

   menu = gtk_menu_new ();
   
   item = gtk_menu_item_new_with_mnemonic ("Search by _name");
   () = g_signal_connect (item, "activate", &search_by_name, entry);
   gtk_menu_shell_append (menu, item);

   item = gtk_menu_item_new_with_mnemonic ("Search by _description");
   () = g_signal_connect (item, "activate", &search_by_description, entry);
   gtk_menu_shell_append (menu, item);

   item = gtk_menu_item_new_with_mnemonic ("Search by _file name");
   () = g_signal_connect (item, "activate", &search_by_file, entry);
   gtk_menu_shell_append (menu, item);

   gtk_widget_show_all (menu);

   return menu;
}

define icon_press_cb (entry, position, event)
{
#ifeval (_gtk3_version > 32200)      
   if (position == GTK_ENTRY_ICON_PRIMARY)
     gtk_menu_popup_at_pointer (menu, event);
#endif
}

define activate_cb (entry, button)
{
   if (search_progress_id != 0)
     return;
   
   start_search (button, entry);
}

define search_entry_destroyed (widget)
{
   if (finish_search_id != 0)
     {
	g_source_remove (finish_search_id);
	finish_search_id = 0;
     }

   if (search_progress_id != 0)
     {
	g_source_remove (search_progress_id);
	search_progress_id = 0;
     }
}

define entry_populate_popup (entry, menu)
{
   variable item, search_menu, has_text;

   has_text = gtk_entry_get_text_length (entry) > 0;

   item = gtk_separator_menu_item_new ();
   gtk_widget_show (item);
   gtk_menu_shell_append (menu, item);

   item = gtk_menu_item_new_with_mnemonic ("C_lear");
   gtk_widget_show (item);
   () = g_signal_connect_swapped (item, "activate", &clear_entry, entry);
   gtk_menu_shell_append (menu, item);
   gtk_widget_set_sensitive (item, has_text);

   search_menu = create_search_menu (entry);
   item = gtk_menu_item_new_with_label ("Search by");
   gtk_widget_show (item);
   gtk_menu_item_set_submenu (item, search_menu);
   gtk_menu_shell_append (menu, item);
}

define create_search_entry (do_widget)
{
   variable window, vbox, hbox, label, entry, find_button, cancel_button;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Search Entry");
   gtk_window_set_resizable (window, FALSE);
   () = g_signal_connect (window, "destroy", &search_entry_destroyed, window);

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);
   gtk_container_add (window, vbox);
   gtk_container_set_border_width ( vbox, 5);

   label = gtk_label_new (NULL);
   gtk_label_set_markup (label, "Search entry demo");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 10);
   gtk_box_pack_start (vbox, hbox, TRUE, TRUE, 0);
   gtk_container_set_border_width ( hbox, 0);

   % Create our entry
   entry = gtk_search_entry_new ();
   gtk_box_pack_start (hbox, entry, FALSE, FALSE, 0);

   % Create the find and cancel buttons
   notebook = gtk_notebook_new ();
   gtk_notebook_set_show_tabs (notebook, FALSE);
   gtk_notebook_set_show_border (notebook, FALSE);
   gtk_box_pack_start (hbox, notebook, FALSE, FALSE, 0);

   find_button = gtk_button_new_with_label ("Find");
   () = g_signal_connect (find_button, "clicked", &start_search, entry);
   gtk_notebook_append_page (notebook, find_button, );
   gtk_widget_show (find_button);

   cancel_button = gtk_button_new_with_label ("Cancel");
   () = g_signal_connect (cancel_button, "clicked", &stop_search);
   gtk_notebook_append_page (notebook, cancel_button, );
   gtk_widget_show (cancel_button);

   % Set up the search icon
   search_by_name (NULL, entry);

   % Set up the clear icon
   () = g_signal_connect (entry, "icon-press", &icon_press_cb);
   () = g_signal_connect (entry, "activate", &activate_cb);

   % Create the menu
   menu = create_search_menu (entry);
   gtk_menu_attach_to_widget (menu, entry);

   % add accessible alternatives for icon functionality
   g_object_set (entry, "populate-all", TRUE);
   () = g_signal_connect (entry, "populate-popup", &entry_populate_popup);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     {
	gtk_widget_destroy (menu);
	gtk_widget_destroy (window);
    }   
   return window;
}
