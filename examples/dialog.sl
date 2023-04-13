% Dialogs and Message Boxes
%
% Dialog widgets are used to pop up a transient window for user feedback.
%

variable window, entry1, entry2;
variable i = 1;

define message_dialog_clicked (button)
{
  variable dialog;  

  dialog = gtk_message_dialog_new (window,
                                   GTK_DIALOG_MODAL | GTK_DIALOG_DESTROY_WITH_PARENT,
                                   GTK_MESSAGE_INFO,
                                   GTK_BUTTONS_OK_CANCEL,
                                   "This message box has been popped up the following number of times:");
  gtk_message_dialog_format_secondary_text (dialog, string (i));
  gtk_dialog_run (dialog);
  gtk_widget_destroy (dialog);
  i ++;
}

define interactive_dialog_clicked (button)
{
  variable content_area;
  variable dialog;
  variable hbox;
  variable image;
  variable table;
  variable local_entry1;
  variable local_entry2;
  variable label;
  variable response;

  dialog = gtk_dialog_new_with_buttons ("Interactive Dialog",
                                        window,
                                        GTK_DIALOG_MODAL| GTK_DIALOG_DESTROY_WITH_PARENT,
                                        ["_OK", "_Cancel"],
                                        [GTK_RESPONSE_OK, GTK_RESPONSE_CANCEL]);

  content_area = gtk_dialog_get_content_area (dialog);

  hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 8);
  gtk_container_set_border_width (hbox, 8);
  gtk_box_pack_start (content_area, hbox, FALSE, FALSE, 0);

  image = gtk_image_new_from_icon_name ("dialog-question", GTK_ICON_SIZE_DIALOG);
  gtk_box_pack_start (hbox, image, FALSE, FALSE, 0);

  table = gtk_grid_new ();
  gtk_grid_set_row_spacing (table, 4);
  gtk_grid_set_column_spacing (table, 4);
  gtk_box_pack_start (hbox, table, TRUE, TRUE, 0);
  label = gtk_label_new_with_mnemonic ("_Entry 1");
  gtk_grid_attach (table, label, 0, 0, 1, 1);
  local_entry1 = gtk_entry_new ();
  gtk_entry_set_text (local_entry1, gtk_entry_get_text (entry1));
  gtk_grid_attach (table, local_entry1, 1, 0, 1, 1);
  gtk_label_set_mnemonic_widget (label, local_entry1);

  label = gtk_label_new_with_mnemonic ("E_ntry 2");
  gtk_grid_attach (table, label, 0, 1, 1, 1);

  local_entry2 = gtk_entry_new ();
   gtk_entry_set_text (local_entry2, gtk_entry_get_text (entry2));
   gtk_grid_attach (table, local_entry2, 1, 1, 1, 1);
   gtk_label_set_mnemonic_widget (label, local_entry2);

  gtk_widget_show_all (hbox);
  response = gtk_dialog_run (dialog);

   if (response == GTK_RESPONSE_OK)
    {
       gtk_entry_set_text (entry1, gtk_entry_get_text (local_entry1));
       gtk_entry_set_text (entry2, gtk_entry_get_text (local_entry2));
    }

  gtk_widget_destroy (dialog);
}

define create_dialog (do_widget)
{
   variable frame;
   variable vbox;
   variable vbox2;
   variable hbox;
   variable button;
   variable table;
   variable label;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Dialogs and Message Boxes");

   gtk_container_set_border_width (window, 8);
   
   frame = gtk_frame_new ("Dialogs");
   gtk_container_add (window, frame);
   
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 8);
   gtk_container_set_border_width ( vbox, 8);
   gtk_container_add (frame, vbox);

   % Standard message dialog
   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 8);
   gtk_box_pack_start (vbox, hbox, FALSE, FALSE, 0);
   button = gtk_button_new_with_mnemonic ("_Message Dialog");
   () = g_signal_connect (button, "clicked", &message_dialog_clicked);
   gtk_box_pack_start (hbox, button, FALSE, FALSE, 0);

   gtk_box_pack_start (vbox, gtk_separator_new (GTK_ORIENTATION_HORIZONTAL),
		       FALSE, FALSE, 0);

   % Interactive dialog
   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 8);
   gtk_box_pack_start (vbox, hbox, FALSE, FALSE, 0);
   vbox2 = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);

   button = gtk_button_new_with_mnemonic ("_Interactive Dialog");
   () = g_signal_connect (button, "clicked", &interactive_dialog_clicked);
   gtk_box_pack_start (hbox, vbox2, FALSE, FALSE, 0);
   gtk_box_pack_start ((vbox2), button, FALSE, FALSE, 0);

   table = gtk_grid_new ();
   gtk_grid_set_row_spacing (table, 4);
   gtk_grid_set_column_spacing (table, 4);
   gtk_box_pack_start (hbox, table, FALSE, FALSE, 0);

   label = gtk_label_new_with_mnemonic ("_Entry 1");
   gtk_grid_attach (table, label, 0, 0, 1, 1);

   entry1 = gtk_entry_new ();
   gtk_grid_attach (table, entry1, 1, 0, 1, 1);
   gtk_label_set_mnemonic_widget (label, entry1);
   
   label = gtk_label_new_with_mnemonic ("_Entry 2");
   gtk_grid_attach (table, label, 0, 1, 1, 1);

   entry2 = gtk_entry_new ();
   gtk_grid_attach (table, entry2, 1, 1, 1, 1);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);

   return window;
}
