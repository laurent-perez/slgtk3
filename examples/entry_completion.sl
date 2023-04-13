% Entry/Entry Completion
%
% GtkEntryCompletion provides a mechanism for adding support for
% completion in GtkEntry.
%
%


% Creates a tree model containing the completions

define create_completion_model ()
{
  variable store, iter;

  store = gtk_list_store_new ([G_TYPE_STRING]);

  % Append one word
  iter = gtk_list_store_append (store);
  gtk_list_store_set (store, iter, 0, "GNOME");

  % Append another word
  iter = gtk_list_store_append (store);
  gtk_list_store_set (store, iter, 0, "total");

  % And another word
  iter = gtk_list_store_append (store);
  gtk_list_store_set (store, iter, 0, "totally");

  return store;
}

define create_entry_completion (do_widget)
{
  variable window, vbox, label, entry, completion, completion_model;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Entry Completion");
   gtk_window_set_resizable (window, FALSE);

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);
   gtk_container_add (window, vbox);
   gtk_container_set_border_width ( vbox, 5);
   
   label = gtk_label_new (NULL);
   gtk_label_set_markup (label, "Completion demo, try writing <b>total</b> or <b>gnome</b> for example.");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);
   
   % Create our entry
   entry = gtk_entry_new ();
   gtk_box_pack_start (vbox, entry, FALSE, FALSE, 0);

   % Create the completion object
   completion = gtk_entry_completion_new ();
   
   % Assign the completion to the entry
   gtk_entry_set_completion (entry, completion);
   g_object_unref (completion);

   % Create a tree model and use it as the completion model
   completion_model = create_completion_model ();
   gtk_entry_completion_set_model (completion, completion_model);
   g_object_unref (completion_model);

   % Use model column 0 as the text column
   gtk_entry_completion_set_text_column (completion, 0);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);

   return window;
}
