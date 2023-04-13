% Tree View/Tree Store
%
% The GtkTreeStore is used to store data in tree form, to be
% used later on by a GtkTreeView to display it. This demo builds
% a simple GtkTreeStore and displays it. If you're new to the
% GtkTreeView widgets and associates, look into the GtkListStore
% example first.


% TreeItem structure
typedef struct
{
   label, alex, havoc, tim, owen, dave,
   world_holiday, % shared by the European hackers
   children
} TreeItem;

% columns
variable HOLIDAY_NAME_COLUMN = 0;
variable ALEX_COLUMN = 1;
variable HAVOC_COLUMN = 2;
variable TIM_COLUMN = 3;
variable OWEN_COLUMN = 4;
variable DAVE_COLUMN = 5;
variable VISIBLE_COLUMN = 6;
variable WORLD_COLUMN = 7;
variable NUM_COLUMNS = 8;

% tree data
variable january = TreeItem [3];
set_struct_fields (january [0], "New Years Day", TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, NULL);
set_struct_fields (january [1], "Presidential Inauguration", FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, NULL);
set_struct_fields (january [2], "Martin Luther King Jr. day", FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, NULL);

variable february = TreeItem [3];
set_struct_fields (february [0],  "Presidents' Day", FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, NULL);
set_struct_fields (february [1],  "Groundhog Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (february [2],  "Valentine's Day", FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, NULL);

variable march = TreeItem [2];
set_struct_fields (march [0],  "National Tree Planting Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (march [1],  "St Patrick's Day", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, NULL);

variable april = TreeItem [4];
set_struct_fields (april [0],  "April Fools' Day", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, NULL);
set_struct_fields (april [1],  "Army Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (april [2],  "Earth Day", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, NULL);
set_struct_fields (april [3],  "Administrative Professionals' Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);

variable may = TreeItem [5];
set_struct_fields (may [0],  "Nurses' Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (may [1],  "National Day of Prayer", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (may [2],  "Mothers' Day", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, NULL);
set_struct_fields (may [3],  "Armed Forces Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (may [4],  "Memorial Day", TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, NULL);

variable june = TreeItem [3];
set_struct_fields (june [0],  "June Fathers' Day", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, NULL);
set_struct_fields (june [1],  "Juneteenth (Liberation of Slaves)", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (june [2],  "Flag Day", FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, NULL);

variable july = TreeItem [2];
set_struct_fields (july [0],  "Parents' Day", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, NULL);
set_struct_fields (july [1],  "Independence Day", FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, NULL);

variable august = TreeItem [3];
set_struct_fields (august [0],  "Air Force Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (august [1],  "Coast Guard Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (august [2],  "Friendship Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);

variable september = TreeItem [3];
set_struct_fields (september [0],  "Grandparents' Day", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, NULL);
set_struct_fields (september [1],  "Citizenship Day or Constitution Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (september [2],  "Labor Day", TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, NULL);

variable october = TreeItem [7];
set_struct_fields (october [0],  "National Children's Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (october [1],  "Bosses' Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (october [2],  "Sweetest Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (october [3],  "Mother-in-Law's Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (october [4],  "Navy Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (october [5],  "Columbus Day", FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, NULL);
set_struct_fields (october [6],  "Halloween", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, NULL);

variable november = TreeItem [3];
set_struct_fields (november [0],  "Marine Corps Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (november [1],  "Veterans' Day", TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, NULL);
set_struct_fields (november [2],  "Thanksgiving", FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, NULL);

variable december = TreeItem [3];
set_struct_fields (december [0],  "Pearl Harbor Remembrance Day", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);
set_struct_fields (december [1],  "Christmas", TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, NULL);
set_struct_fields (december [2],  "Kwanzaa", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, NULL);

variable toplevel = TreeItem [12];
set_struct_fields (toplevel [0], "January", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, january);
set_struct_fields (toplevel [1], "February", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, february);
set_struct_fields (toplevel [2], "March", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, march);
set_struct_fields (toplevel [3], "April", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, april);
set_struct_fields (toplevel [4], "May", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, may);
set_struct_fields (toplevel [5], "June", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, june);
set_struct_fields (toplevel [6], "July", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, july);
set_struct_fields (toplevel [7], "August", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, august);
set_struct_fields (toplevel [8], "September", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, september);
set_struct_fields (toplevel [9], "October", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, october);
set_struct_fields (toplevel [10], "November", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, november);
set_struct_fields (toplevel [11], "December", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, december);

define create_model ()
{
   variable model, iter, month;

   % create tree store
   model = gtk_tree_store_new ([G_TYPE_STRING,
			       G_TYPE_BOOLEAN,
			       G_TYPE_BOOLEAN,
			       G_TYPE_BOOLEAN,
			       G_TYPE_BOOLEAN,
			       G_TYPE_BOOLEAN,
			       G_TYPE_BOOLEAN,
			       G_TYPE_BOOLEAN]);

   % add data to the tree store
   foreach month (toplevel)
    {
       variable holiday;

       iter = gtk_tree_store_append (model, );
       
       gtk_tree_store_set (model, iter,
			   HOLIDAY_NAME_COLUMN, month.label,
			   ALEX_COLUMN, FALSE,
			   HAVOC_COLUMN, FALSE,
			   TIM_COLUMN, FALSE,
			   OWEN_COLUMN, FALSE,
			   DAVE_COLUMN, FALSE,
			   VISIBLE_COLUMN, FALSE,
			   WORLD_COLUMN, FALSE);
       
       % add children
       foreach holiday (month.children)
	 {
	    variable child_iter;

	    child_iter = gtk_tree_store_append (model, iter);
	    gtk_tree_store_set (model, child_iter,
	    			HOLIDAY_NAME_COLUMN, holiday.label,
	    			ALEX_COLUMN, holiday.alex,
	    			HAVOC_COLUMN, holiday.havoc,
	    			TIM_COLUMN, holiday.tim,
	    			OWEN_COLUMN, holiday.owen,
	    			DAVE_COLUMN, holiday.dave,
	    			VISIBLE_COLUMN, TRUE,
	    			WORLD_COLUMN, holiday.world_holiday);
	 }
    }

   return model;
}

define item_toggled (cell, path_str, model)
{
   variable path = gtk_tree_path_new_from_string (path_str);
   variable iter, toggle_item, column;

   column = g_object_get_data (cell, "column");

   % get toggled iter
   iter = gtk_tree_model_get_iter (model, path);
   toggle_item = gtk_tree_model_get (model, iter, column);

   % do something with the value
   toggle_item = not toggle_item;

   % set new value
   gtk_tree_store_set (model, iter, column, toggle_item);

   % clean up
   % gtk_tree_path_free (path);
}

define add_columns (treeview)
{
   variable col_offset, renderer, column;
   variable model = gtk_tree_view_get_model (treeview);

   % column for holiday names
   renderer = gtk_cell_renderer_text_new ();
   g_object_set (renderer, "xalign", 0.0);

   col_offset = gtk_tree_view_insert_column_with_attributes (treeview,
							     -1, "Holiday",
							     renderer, "text",
							     HOLIDAY_NAME_COLUMN);
   column = gtk_tree_view_get_column (treeview, col_offset - 1);
   gtk_tree_view_column_set_clickable (column, TRUE);

   % alex column
   renderer = gtk_cell_renderer_toggle_new ();
   g_object_set (renderer, "xalign", 0.0);
   g_object_set_data (renderer, "column", ALEX_COLUMN);

   () = g_signal_connect (renderer, "toggled", &item_toggled, model);

   col_offset = gtk_tree_view_insert_column_with_attributes (treeview,
							     -1, "Alex",
							     renderer,
							     "active",
							     ALEX_COLUMN,
							     "visible",
							     VISIBLE_COLUMN,
							     "activatable",
							     WORLD_COLUMN);

   column = gtk_tree_view_get_column (treeview, col_offset - 1);
   gtk_tree_view_column_set_sizing (column, GTK_TREE_VIEW_COLUMN_FIXED);
   gtk_tree_view_column_set_clickable (column, TRUE);

   % havoc column
   renderer = gtk_cell_renderer_toggle_new ();
   g_object_set (renderer, "xalign", 0.0);
   g_object_set_data (renderer, "column", HAVOC_COLUMN);

   () = g_signal_connect (renderer, "toggled", &item_toggled, model);

   col_offset = gtk_tree_view_insert_column_with_attributes (treeview,
							     -1, "Havoc",
							     renderer,
							     "active",
							     HAVOC_COLUMN,
							     "visible",
							     VISIBLE_COLUMN);
   
   column = gtk_tree_view_get_column (treeview, col_offset - 1);
   gtk_tree_view_column_set_sizing (column, GTK_TREE_VIEW_COLUMN_FIXED);
   gtk_tree_view_column_set_clickable (column, TRUE);

   % tim column
   renderer = gtk_cell_renderer_toggle_new ();
   g_object_set (renderer, "xalign", 0.0);
   g_object_set_data (renderer, "column", TIM_COLUMN);

   () = g_signal_connect (renderer, "toggled", &item_toggled, model);

   col_offset = gtk_tree_view_insert_column_with_attributes (treeview,
							     -1, "Tim",
							     renderer,
							     "active",
							     TIM_COLUMN,
							     "visible",
							     VISIBLE_COLUMN,
							     "activatable",
							     WORLD_COLUMN);

   column = gtk_tree_view_get_column (treeview, col_offset - 1);
   gtk_tree_view_column_set_sizing (column, GTK_TREE_VIEW_COLUMN_FIXED);
   gtk_tree_view_column_set_clickable (column, TRUE);

   % owen column
   renderer = gtk_cell_renderer_toggle_new ();
   g_object_set (renderer, "xalign", 0.0);
   g_object_set_data (renderer, "column", OWEN_COLUMN);

   () = g_signal_connect (renderer, "toggled", &item_toggled, model);
   
   col_offset = gtk_tree_view_insert_column_with_attributes (treeview,
							     -1, "Owen",
							     renderer,
							     "active",
							     OWEN_COLUMN,
							     "visible",
							     VISIBLE_COLUMN);

   column = gtk_tree_view_get_column (treeview, col_offset - 1);
   gtk_tree_view_column_set_sizing (column, GTK_TREE_VIEW_COLUMN_FIXED);
   gtk_tree_view_column_set_clickable (column, TRUE);
   
   % dave column
   renderer = gtk_cell_renderer_toggle_new ();
   g_object_set (renderer, "xalign", 0.0);
   g_object_set_data (renderer, "column", DAVE_COLUMN);

   () = g_signal_connect (renderer, "toggled", &item_toggled, model);

   col_offset = gtk_tree_view_insert_column_with_attributes (treeview,
							     -1, "Dave",
							     renderer,
                                                            "active",
							     DAVE_COLUMN,
							     "visible",
                                                            VISIBLE_COLUMN);

   column = gtk_tree_view_get_column (treeview, col_offset - 1);
   gtk_tree_view_column_set_sizing (column, GTK_TREE_VIEW_COLUMN_FIXED);
   gtk_tree_view_column_set_clickable (column, TRUE);
}

define create_tree_store (do_widget)
{
   variable window, vbox, sw, treeview, model;

   % create window, etc
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Tree Store");

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 8);
   gtk_container_set_border_width (vbox, 8);
   gtk_container_add (window, vbox);

   gtk_box_pack_start (vbox,
		       gtk_label_new ("Jonathan's Holiday Card Planning Sheet"),
		       FALSE, FALSE, 0);

   sw = gtk_scrolled_window_new (,);
   gtk_scrolled_window_set_shadow_type (sw, GTK_SHADOW_ETCHED_IN);
   gtk_scrolled_window_set_policy (sw, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
   gtk_box_pack_start (vbox, sw, TRUE, TRUE, 0);

   % create model
   model = create_model ();

   % create tree view
   treeview = gtk_tree_view_new_with_model (model);
   g_object_unref (model);
   gtk_tree_selection_set_mode (gtk_tree_view_get_selection (treeview),
				GTK_SELECTION_MULTIPLE);
   
   add_columns (treeview);

   gtk_container_add (sw, treeview);

   % expand all rows after the treeview widget has been realized
   () = g_signal_connect (treeview, "realize", &gtk_tree_view_expand_all);
   gtk_window_set_default_size (window, 650, 400);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
