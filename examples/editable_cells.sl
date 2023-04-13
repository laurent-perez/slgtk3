% Tree View/Editable Cells
%
% This demo demonstrates the use of editable cells in a GtkTreeView. If
% you're new to the GtkTreeView widgets and associates, look into
% the GtkListStore example first. It also shows how to use the
% GtkCellRenderer::editing-started signal to do custom setup of the
% editable widget.
%
% The cell renderers used in this demo are GtkCellRendererText,
% GtkCellRendererCombo and GtkCellRendererProgress.

variable product = {"bottles of coke", "packages of noodles",
   "packages of chocolate chip cookies",
   "can vanilla ice cream", "eggs"};
variable number = {3, 5, 2, 1, 6};
variable yummy = {20, 50, 90, 60, 10};

define create_items_model ()
{
   variable i, model;

   % create list store
   % model = gtk_list_store_new ([G_TYPE_INT, G_TYPE_STRING, G_TYPE_INT, G_TYPE_BOOLEAN]);
   model = gtk_list_store_new ([G_TYPE_INT, G_TYPE_STRING, G_TYPE_INT]);

   % add items
   for (i = 0 ; i < length (product) ; i ++)
     () = gtk_list_store_append (model, 0, number [i], 1, product [i], 2, yummy [i]);

  return model;
}

define create_numbers_model ()
{
   variable i, N_NUMBERS = 10, model;

   % create list store
   % model = gtk_list_store_new ([G_TYPE_STRING, G_TYPE_INT]);
   model = gtk_list_store_new ([G_TYPE_STRING]);
   
   % add numbers
   for (i = 0 ; i < N_NUMBERS ; i ++)
     gtk_list_store_append (model, 0, string (i));

   return model;
}

define add_item (button, treeview)
{
   variable model, iter, path, current, column, selection;

   list_append (product, "Description here");
   list_append (number, 0);
   list_append (yummy, 50);

   % Insert a new row below the current one
   (path, ) = gtk_tree_view_get_cursor (treeview);
   model = gtk_tree_view_get_model (treeview);
   if (path != NULL)
     {	
	current = gtk_tree_model_get_iter (model, path);  
	% gtk_tree_path_free (path);
	iter = gtk_list_store_insert_after (model, current);
     }
   else
     {
	iter = gtk_list_store_insert (model, -1);
     }
   
   % Set the data for the new row
   gtk_list_store_set (model, current,
   		       0, number [-1],
   		       1, product [-1],
   		       2, yummy [-1]);
   
   % Move focus to the new row
   path = gtk_tree_model_get_path (model, iter);
   column = gtk_tree_view_get_column (treeview, 0);
   gtk_tree_view_set_cursor (treeview, path, column, FALSE);   
   % gtk_tree_path_free (path);
}

define remove_item (widget, treeview)
{
   variable iter, model, selection, path, i;

   model = gtk_tree_view_get_model (treeview);
   selection = gtk_tree_view_get_selection (treeview);
   iter = gtk_tree_iter_new ();
   if (gtk_tree_selection_get_selected (selection,, iter))
     {	
	path = gtk_tree_model_get_path (model, iter);
	i = gtk_tree_path_get_indices (path) [0];
	list_delete (product, i);
	list_delete (number, i);
	list_delete (yummy, i);   
	gtk_list_store_remove (model, iter);
	% gtk_tree_path_free (path);
     }
}

define separator_row (model, iter)
{
  variable path, idx;

  path = gtk_tree_model_get_path (model, iter);
  idx = gtk_tree_path_get_indices (path) [0];
  % gtk_tree_path_free (path);

  return idx == 5;
}

define editing_started (cell, editable, path)
{
   % gtk_combo_box_set_row_separator_func (editable, &separator_row, NULL, NULL);
}

define cell_edited (cell, path_string, txt, model)
{
   variable path, iter, column, i;

   path = gtk_tree_path_new_from_string (path_string);
   iter = gtk_tree_model_get_iter (model, path);
   column = g_object_get_data (cell, "column");
   
   switch (column)
     {
      case 0:
	i = gtk_tree_path_get_indices (path) [0];
	number [i] = atoi (txt);
	gtk_list_store_set (model, iter, column, number [i]);
     }
     {
      case 1:
	i = gtk_tree_path_get_indices (path) [0];
	product [i] = txt;	
	gtk_list_store_set (model, iter, column, product [i]);
     }
   % gtk_tree_path_free (path);
}

define add_columns (treeview, items_model, numbers_model)
{
   variable renderer, retval;

   % number column
   renderer = gtk_cell_renderer_combo_new ();   
   g_object_set (renderer,
                 "model", numbers_model,
                 "text-column", 0,
                 "has-entry", FALSE,
                 "editable", TRUE);

   % g_object_set_property (renderer, "model", numbers_model);
   % g_object_set_property (renderer, "text-column", 1);
   % g_object_set_property (renderer, "has-entry", FALSE);
   % g_object_set_property (renderer, "editable", TRUE);

   () = g_signal_connect (renderer, "edited", &cell_edited, items_model);
   () = g_signal_connect (renderer, "editing-started", &editing_started);
   g_object_set_data (renderer, "column", 0);

   retval = gtk_tree_view_insert_column_with_attributes (treeview, -1,
							 "Number", renderer,
							 "text", 0);

   % product column
   renderer = gtk_cell_renderer_text_new ();
   g_object_set_property (renderer, "editable", TRUE);
   () = g_signal_connect (renderer, "edited", &cell_edited, items_model);
   g_object_set_data (renderer, "column", 1);
   
   retval = gtk_tree_view_insert_column_with_attributes (treeview, -1,
							 "Product", renderer,
							 "text", 1);

   % yummy column
   renderer = gtk_cell_renderer_progress_new ();
   g_object_set_data (renderer, "column", 2);

   retval = gtk_tree_view_insert_column_with_attributes (treeview, -1,
							 "Yummy", renderer,
							 "value", 2);
}

define create_editable_cells (do_widget)
{
   variable window, vbox, hbox, sw, treeview, button, items_model, numbers_model;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Editable Cells");
   gtk_container_set_border_width (window, 5);

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);
   gtk_container_add (window, vbox);

   gtk_box_pack_start (vbox,
		       gtk_label_new ("Shopping list (you can edit the cells !)"),
		       FALSE, FALSE, 0);

   sw = gtk_scrolled_window_new (,);
   gtk_scrolled_window_set_shadow_type (sw, GTK_SHADOW_ETCHED_IN);
   gtk_scrolled_window_set_policy (sw,GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
   gtk_box_pack_start (vbox, sw, TRUE, TRUE, 0);

   % create models
   items_model = create_items_model ();
   numbers_model = create_numbers_model ();

   % create tree view
   treeview = gtk_tree_view_new_with_model (items_model);
   gtk_tree_selection_set_mode (gtk_tree_view_get_selection (treeview),
				GTK_SELECTION_SINGLE);

   add_columns (treeview, items_model, numbers_model);

   % g_object_unref (numbers_model);
   % g_object_unref (items_model);
   
   gtk_container_add (sw, treeview);

   % some buttons
   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 4);
   gtk_box_set_homogeneous (hbox, TRUE);
   gtk_box_pack_start (vbox, hbox, FALSE, FALSE, 0);

   button = gtk_button_new_with_label ("Add item");
   () = g_signal_connect (button, "clicked", &add_item, treeview);
   gtk_box_pack_start (hbox, button, TRUE, TRUE, 0);

   button = gtk_button_new_with_label ("Remove item");
   () = g_signal_connect (button, "clicked", &remove_item, treeview);
   gtk_box_pack_start (hbox, button, TRUE, TRUE, 0);

   gtk_window_set_default_size (window, 600, 300);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
