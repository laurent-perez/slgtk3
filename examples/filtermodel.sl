% Tree View/Filter Model
%
% This example demonstrates how GtkTreeModelFilter can be used not
% just to show a subset of the rows, but also to compute columns
% that are not actually present in the underlying model.
%


variable WIDTH_COLUMN = 0;
variable HEIGHT_COLUMN = 1;
variable AREA_COLUMN = 2;
variable SQUARE_COLUMN = 3;

define format_number (col, cell, model, iter, data)
{
   variable num, text;

   num = gtk_tree_model_get_value (model, iter, data);
   g_object_set (cell, "text", string (num));
}

define filter_modify_func (model, iter, value, column)
{
   variable width, height, filter_model, child_model, child_iter;

   filter_model = model;
   child_model = gtk_tree_model_filter_get_model (filter_model);
   child_iter = gtk_tree_model_filter_convert_iter_to_child_iter (filter_model, iter);

   (width, height) = gtk_tree_model_get (child_model, child_iter,
					 WIDTH_COLUMN, HEIGHT_COLUMN);
   % width = gtk_tree_model_get_value (child_model, child_iter, WIDTH_COLUMN);
   % height = gtk_tree_model_get_value (child_model, child_iter, HEIGHT_COLUMN);
   % width = gtk_tree_model_get (child_model, child_iter, WIDTH_COLUMN);
   % height = gtk_tree_model_get (child_model, child_iter, HEIGHT_COLUMN);
          
   switch (column)
     { case WIDTH_COLUMN: g_value_set_int (value, width); }
     { case HEIGHT_COLUMN: g_value_set_int (value, height); }
     { case AREA_COLUMN: g_value_set_int (value, width * height); }
     { case SQUARE_COLUMN: g_value_set_boolean (value, width == height); }
}

define visible_func (model, iter)
{
   variable width;

   width = gtk_tree_model_get (model, iter, WIDTH_COLUMN);

   return width < 10;
}

define cell_edited (cell, path_string, new_text, store)
{
   variable val, path, iter, column;

   path = gtk_tree_path_new_from_string (path_string);
   iter = gtk_tree_model_get_iter (store, path);
   % gtk_tree_path_free (path);
   
   column = g_object_get_data (cell, "column");

   val = atoi (new_text);

   gtk_list_store_set (store, iter, column, val);
}

define create_filtermodel (do_widget)
{
   variable window, tree, store, model, column, cell, builder;
   variable types = Int_Type [4];

   builder = gtk_builder_new_from_resource ("/filtermodel/filtermodel.ui");
   gtk_builder_connect_signals (builder);
   window = gtk_builder_get_object (builder, "window1");
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));

   store = gtk_builder_get_object (builder, "liststore1");
       
   column = gtk_builder_get_object (builder, "treeviewcolumn1");
   cell = gtk_builder_get_object (builder, "cellrenderertext1");
   gtk_tree_view_column_set_cell_data_func (column, cell,
   					    &format_number, WIDTH_COLUMN);

   g_object_set_data (cell, "column", WIDTH_COLUMN);
   () = g_signal_connect (cell, "edited", &cell_edited, store);

   column = gtk_builder_get_object (builder, "treeviewcolumn2");
   cell = gtk_builder_get_object (builder, "cellrenderertext2");
   gtk_tree_view_column_set_cell_data_func (column, cell,
   					    &format_number, HEIGHT_COLUMN);
   
   g_object_set_data (cell, "column", HEIGHT_COLUMN);
   () = g_signal_connect (cell, "edited", &cell_edited, store);

   column = gtk_builder_get_object (builder, "treeviewcolumn3");
   cell = gtk_builder_get_object (builder, "cellrenderertext3");
   gtk_tree_view_column_set_cell_data_func (column, cell,
					    &format_number, WIDTH_COLUMN);

   column = gtk_builder_get_object (builder, "treeviewcolumn4");
   cell = gtk_builder_get_object (builder, "cellrenderertext4");
   gtk_tree_view_column_set_cell_data_func (column, cell,
   					    &format_number, HEIGHT_COLUMN);

   column = gtk_builder_get_object (builder, "treeviewcolumn5");
   cell = gtk_builder_get_object (builder, "cellrenderertext5");
   gtk_tree_view_column_set_cell_data_func (column, cell,
   					    &format_number, AREA_COLUMN);

   column = gtk_builder_get_object (builder, "treeviewcolumn6");
   cell = gtk_builder_get_object (builder, "cellrendererpixbuf1");
   gtk_tree_view_column_add_attribute (column, cell, "visible", SQUARE_COLUMN);
 
   tree = gtk_builder_get_object (builder, "treeview2");

   types [WIDTH_COLUMN] = G_TYPE_INT;
   types [HEIGHT_COLUMN] = G_TYPE_INT;
   types [AREA_COLUMN] = G_TYPE_INT;
   types [SQUARE_COLUMN] = G_TYPE_BOOLEAN;
   
   model = gtk_tree_model_filter_new (store, NULL);
   gtk_tree_model_filter_set_modify_func (model, types,
                                          &filter_modify_func);

   gtk_tree_view_set_model (tree, model);

   column = gtk_builder_get_object (builder, "treeviewcolumn7");
   cell = gtk_builder_get_object (builder, "cellrenderertext6");
   gtk_tree_view_column_set_cell_data_func (column, cell,
   					    &format_number, WIDTH_COLUMN);

   column = gtk_builder_get_object (builder, "treeviewcolumn8");
   cell = gtk_builder_get_object (builder, "cellrenderertext7");
   gtk_tree_view_column_set_cell_data_func (column, cell,
					    &format_number, HEIGHT_COLUMN);

   tree = gtk_builder_get_object (builder, "treeview3");

   model = gtk_tree_model_filter_new (store,);
   gtk_tree_model_filter_set_visible_func (model, &visible_func);
   gtk_tree_view_set_model (tree, model);

   % g_object_unref (builder);
   
   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
