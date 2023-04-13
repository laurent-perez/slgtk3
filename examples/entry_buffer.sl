% Entry/Entry Buffer
%
% GtkEntryBuffer provides the text content in a GtkEntry.
% Applications can provide their own buffer implementation,
% e.g. to provide secure handling for passwords in memory.
%

define create_entry_buffer (do_widget)
{
  variable window;
  variable vbox, label, entry, buffer;
   
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   % gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Entry Buffer");
   gtk_window_set_resizable (window, FALSE);

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);
   gtk_container_add (window, vbox);
   gtk_container_set_border_width (vbox, 5);

   label = gtk_label_new (NULL);
   gtk_label_set_markup (label,
			 "Entries share a buffer. Typing in one is reflected in the other.");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

   % Create a buffer
   buffer = gtk_entry_buffer_new ("Hello !");

   % Create our first entry
   entry = gtk_entry_new_with_buffer (buffer);
   gtk_box_pack_start (vbox, entry, FALSE, FALSE, 0);

   % Create the second entry
   entry = gtk_entry_new_with_buffer (buffer);
   gtk_entry_set_visibility (entry, FALSE);
   gtk_box_pack_start (vbox, entry, FALSE, FALSE, 0);
   
   g_object_unref (buffer);
   
   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
