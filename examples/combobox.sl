% Combo Boxes
%
% The GtkComboBox widget allows to select one option out of a list.
% The GtkComboBoxEntry additionally allows the user to enter a value
% that is not in the list of options.
%
% How the options are displayed is controlled by cell renderers.
%

define create_icon_store ()
{
   variable icon_names = ["dialog-warning",
			  "process-stop",
			  "document-new",
			  "edit-clear",
			  NULL,
			  "document-open"];

   variable labels = ["Warning",
		      "Stop",
		      "New",
		      "Clear",
		      NULL,
		      "Open"];

   variable i, iter, store;

   store = gtk_list_store_new ([G_TYPE_STRING, G_TYPE_STRING]);

   for (i = 0; i < length (icon_names) ; i ++)
    {
       if (icon_names [i] != NULL)
   	 () = gtk_list_store_append (store, 0, icon_names [i], 1, labels [i]);
       else
   	 () = gtk_list_store_append (store, 0, NULL, 1, "separator");
    }
   return store;
}

% A GtkCellLayoutDataFunc that demonstrates how one can control
% sensitivity of rows. This particular function does nothing
% useful and just makes the second row insensitive.

define set_sensitive (cell_layout, cell, tree_model, iter)
{
   variable path, indices, sensitive;
   
   path = gtk_tree_model_get_path (tree_model, iter);
   indices = gtk_tree_path_get_indices (path);
   sensitive = indices [0] != 1;
   g_object_set (cell, "sensitive", sensitive);
   % gtk_cell_renderer_set_sensitive (cell, sensitive);
}

% A GtkTreeViewRowSeparatorFunc that demonstrates how rows can be
% rendered as separators. This particular function does nothing
% useful and just turns the fourth row into a separator.

define is_separator (model, iter)
{
  variable path, result;

  path = gtk_tree_model_get_path (model, iter);
  result = gtk_tree_path_get_indices (path) [0] == 4;
  % gtk_tree_path_free (path);

  return result;
}

define create_capital_store ()
{
   variable capitals = {
      { "A - B", NULL },
      { NULL, "Albany" },
      { NULL, "Annapolis" },
      { NULL, "Atlanta" },
      { NULL, "Augusta" },
      { NULL, "Austin" },
      { NULL, "Baton Rouge" },
      { NULL, "Bismarck" },
      { NULL, "Boise" },
      { NULL, "Boston" },
      { "C - D", NULL },
      { NULL, "Carson City" },
      { NULL, "Charleston" },
      { NULL, "Cheyenne" },
      { NULL, "Columbia" },
      { NULL, "Columbus" },
      { NULL, "Concord" },
      { NULL, "Denver" },
      { NULL, "Des Moines" },
      { NULL, "Dover" },
      { "E - J", NULL },
      { NULL, "Frankfort" },
      { NULL, "Harrisburg" },
      { NULL, "Hartford" },
      { NULL, "Helena" },
      { NULL, "Honolulu" },
      { NULL, "Indianapolis" },
      { NULL, "Jackson" },
      { NULL, "Jefferson City" },
      { NULL, "Juneau" },
      { "K - O", NULL},
      { NULL, "Lansing" },
      { NULL, "Lincoln" },
      { NULL, "Little Rock" },
      { NULL, "Madison" },
      { NULL, "Montgomery" },
      { NULL, "Montpelier" },
      { NULL, "Nashville" },
      { NULL, "Oklahoma City" },
      { NULL, "Olympia" },
      { NULL, "P - S" },
      { NULL, "Phoenix" },
      { NULL, "Pierre" },
      { NULL, "Providence" },
      { NULL, "Raleigh" },
      { NULL, "Richmond" },
      { NULL, "Sacramento" },
      { NULL, "Salem" },
      { NULL, "Salt Lake City" },
      { NULL, "Santa Fe" },
      { NULL, "Springfield" },
      { NULL, "St. Paul" },
      { "P - S", NULL },
      { "T - Z", NULL },
      { NULL, "Tallahassee" },
      { NULL, "Topeka" },
      { NULL, "Trenton" },
   };
   
   variable store, capital, iter = NULL;
   
   store = gtk_tree_store_new ([G_TYPE_STRING]);
   
   foreach capital (capitals)
     {
   	if (capital [1] == NULL)
   	  iter = gtk_tree_store_append (store,, 0, capital [0]);
   	else
   	  () = gtk_tree_store_append (store, iter, 0, capital [1]);
     }
   
  return store;
}

define is_capital_sensitive (cell_layout, cell, tree_model, iter)
{
   variable sensitive;
   
   sensitive = not gtk_tree_model_iter_has_child (tree_model, iter);
   % gtk_cell_renderer_set_sensitive (cell, sensitive);   
   g_object_set (cell, "sensitive", sensitive);
}

define fill_combo_entry (combo)
{
  gtk_combo_box_text_append_text (combo, "One");
  gtk_combo_box_text_append_text (combo, "Two");
  gtk_combo_box_text_append_text (combo, "2\302\275");
  gtk_combo_box_text_append_text (combo, "Three");
}

define create_combobox (do_widget)
{
   variable window;
   variable vbox, frame, box, combo, entry;
   variable model, renderer, path, iter;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Combo Boxes");
   
   gtk_container_set_border_width (window, 10);
   
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 2);
   gtk_container_add (window, vbox);
   
   % A combobox demonstrating cell renderers, separators and insensitive rows

   frame = gtk_frame_new ("Items with icons");
   gtk_box_pack_start (vbox, frame, FALSE, FALSE, 0);

   box = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_set_border_width (box, 5);
   gtk_container_add (frame, box);

   model = create_icon_store ();
   combo = gtk_combo_box_new_with_model (model);
   % g_object_unref (model);
   gtk_container_add (box, combo);

   renderer = gtk_cell_renderer_pixbuf_new ();
   gtk_cell_layout_pack_start (combo, renderer, FALSE);
   gtk_cell_layout_set_attributes (combo, renderer, "icon-name", 0);   

   gtk_cell_layout_set_cell_data_func (combo, renderer, &set_sensitive);
   
   renderer = gtk_cell_renderer_text_new ();
   gtk_cell_layout_pack_start (combo, renderer, TRUE);
   gtk_cell_layout_set_attributes (combo, renderer, "text", 1);

   gtk_cell_layout_set_cell_data_func (combo, renderer, &set_sensitive);
   
   gtk_combo_box_set_row_separator_func (combo, &is_separator);

   gtk_combo_box_set_active (combo, 0);
   
   % A combobox demonstrating trees.
   
   frame = gtk_frame_new ("Where are we ?");
   gtk_box_pack_start (vbox, frame, FALSE, FALSE, 0);

   box = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_set_border_width (box, 5);
   gtk_container_add (frame, box);

   model = create_capital_store ();
   combo = gtk_combo_box_new_with_model (model);
   % g_object_unref (model);
   gtk_container_add (box, combo);
   
   renderer = gtk_cell_renderer_text_new ();
   gtk_cell_layout_pack_start (combo, renderer, TRUE);
   gtk_cell_layout_set_attributes (combo, renderer, "text", 0);
   gtk_cell_layout_set_cell_data_func (combo, renderer, &is_capital_sensitive);

#ifeval (_gtk3_version >= 31200)
   path = gtk_tree_path_new_from_indices ([0, 8]);
#else
   path = gtk_tree_path_new_from_indices ([0, 8, -1]);
#endif

   iter = gtk_tree_model_get_iter (model, path);
   if (iter != NULL)
     gtk_combo_box_set_active_iter (combo, iter);

   % A GtkComboBoxEntry with validation */
   frame = gtk_frame_new ("Editable");
   gtk_box_pack_start (vbox, frame, FALSE, FALSE, 0);

   box = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_set_border_width (box, 5);
   gtk_container_add (frame, box);
   
   combo = gtk_combo_box_text_new_with_entry ();
   fill_combo_entry (combo);
   gtk_container_add (box, combo);
   
   % A combobox with string IDs */
   frame = gtk_frame_new ("String IDs");
   gtk_box_pack_start (vbox, frame, FALSE, FALSE, 0);
   
   box = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_set_border_width (box, 5);
   gtk_container_add (frame, box);
   
   combo = gtk_combo_box_text_new ();
   gtk_combo_box_text_append (combo, "never", "Not visible");
   gtk_combo_box_text_append (combo, "when-active", "Visible when active");
   gtk_combo_box_text_append (combo, "always", "Always visible");
   gtk_container_add (box, combo);
   
   entry = gtk_entry_new ();
   g_object_bind_property (combo, "active-id", entry, "text", G_BINDING_BIDIRECTIONAL);
   gtk_container_add (box, entry);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
