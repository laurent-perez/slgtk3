% Pickers
%
% These widgets are mainly intended for use in preference dialogs.
% They allow to select colors, fonts, files, directories and applications.
%

define create_pickers (do_widget)
{
   variable window, table, label, picker;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Pickers");
	
   gtk_container_set_border_width (window, 10);

   table = gtk_grid_new ();
   gtk_grid_set_row_spacing (table, 3);
   gtk_grid_set_column_spacing (table, 10);
   gtk_container_add (window, table);
   
   gtk_container_set_border_width (table, 10);
   
   label = gtk_label_new ("Color:");
   gtk_widget_set_halign (label, GTK_ALIGN_START);
   gtk_widget_set_valign (label, GTK_ALIGN_CENTER);
   gtk_widget_set_hexpand (label, TRUE);
   picker = gtk_color_button_new ();
   gtk_grid_attach (table, label, 0, 0, 1, 1);
   gtk_grid_attach (table, picker, 1, 0, 1, 1);

   label = gtk_label_new ("Font:");
   gtk_widget_set_halign (label, GTK_ALIGN_START);
   gtk_widget_set_valign (label, GTK_ALIGN_CENTER);
   gtk_widget_set_hexpand (label, TRUE);
   picker = gtk_font_button_new ();
   gtk_grid_attach (table, label, 0, 1, 1, 1);
   gtk_grid_attach (table, picker, 1, 1, 1, 1);

   label = gtk_label_new ("File:");
   gtk_widget_set_halign (label, GTK_ALIGN_START);
   gtk_widget_set_valign (label, GTK_ALIGN_CENTER);
   gtk_widget_set_hexpand (label, TRUE);
   picker = gtk_file_chooser_button_new ("Pick a File", GTK_FILE_CHOOSER_ACTION_OPEN);
   gtk_file_chooser_set_local_only (picker, FALSE);
   gtk_grid_attach (table, label, 0, 2, 1, 1);
   gtk_grid_attach (table, picker, 1, 2, 1, 1);
   
   label = gtk_label_new ("Folder:");
   gtk_widget_set_halign (label, GTK_ALIGN_START);
   gtk_widget_set_valign (label, GTK_ALIGN_CENTER);
   picker = gtk_file_chooser_button_new ("Pick a Folder", GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER);
   gtk_grid_attach (table, label, 0, 3, 1, 1);
   gtk_grid_attach (table, picker, 1, 3, 1, 1);
   
   label = gtk_label_new ("Mail:");
   gtk_widget_set_halign (label, GTK_ALIGN_START);
   gtk_widget_set_valign (label, GTK_ALIGN_CENTER);
   gtk_widget_set_hexpand (label, TRUE);
   picker = gtk_app_chooser_button_new ("x-scheme-handler/mailto");
   gtk_app_chooser_button_set_show_dialog_item (picker, TRUE);
   gtk_grid_attach (table, label, 0, 4, 1, 1);
   gtk_grid_attach (table, picker, 1, 4, 1, 1);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
