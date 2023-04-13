% Spinner
%
% GtkSpinner allows to show that background activity is on-going.

variable spinner_sensitive = NULL;
variable spinner_unsensitive = NULL;

define on_play_clicked (button, data)
{
   gtk_spinner_start (spinner_sensitive);
   gtk_spinner_start (spinner_unsensitive);
}

define on_stop_clicked (button, data)
{
   gtk_spinner_stop (spinner_sensitive);
   gtk_spinner_stop (spinner_unsensitive);
}

define create_spinner (do_widget)
{
   variable window, content_area, vbox, hbox, button, spinner;

   window = gtk_dialog_new_with_buttons ("Spinner", NULL, 0,
					 ["Close"], [GTK_RESPONSE_NONE]);
   gtk_window_set_resizable (window, FALSE);

   () = g_signal_connect (window, "response", &gtk_widget_destroy, window);
   
   content_area = gtk_dialog_get_content_area (window);

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);
   gtk_box_pack_start (content_area, vbox, TRUE, TRUE, 0);
   gtk_container_set_border_width (vbox, 5);
   
   % Sensitive
   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 5);
   spinner = gtk_spinner_new ();
   gtk_container_add (hbox, spinner);
   gtk_container_add (hbox, gtk_entry_new ());
   gtk_container_add (vbox, hbox);
   spinner_sensitive = spinner;
   
   % Disabled
   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 5);
   spinner = gtk_spinner_new ();
   gtk_container_add (hbox, spinner);
   gtk_container_add (hbox, gtk_entry_new ());
   gtk_container_add (vbox, hbox);
   spinner_unsensitive = spinner;
   gtk_widget_set_sensitive (hbox, FALSE);
   
   button = gtk_button_new_with_label ("Play");
   g_signal_connect (button, "clicked", &on_play_clicked, spinner);
   gtk_container_add (vbox, button);
   
   button = gtk_button_new_with_label ("Stop");
   g_signal_connect (button, "clicked", &on_stop_clicked, spinner);
   gtk_container_add (vbox, button);
   
   % Start by default to test for:
   % https://bugzilla.gnome.org/show_bug.cgi?id=598496
   on_play_clicked (NULL, NULL);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
