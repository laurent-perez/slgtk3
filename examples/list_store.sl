% Tree View/List Store
%
% The GtkListStore is used to store data in list form, to be used
% later on by a GtkTreeView to display it. This demo builds a
% simple GtkListStore and displays it.

variable timeout = 0;

typedef struct
{
   fixed, number, severity, description
} Bug;

variable COLUMN_FIXED = 0;
variable COLUMN_NUMBER = 1;
variable COLUMN_SEVERITY = 2;
variable COLUMN_DESCRIPTION = 3;
variable COLUMN_PULSE = 4;
variable COLUMN_ICON = 5;
variable COLUMN_ACTIVE = 6;
variable COLUMN_SENSITIVE = 7;
variable NUM_COLUMNS = 8;

variable data = Bug [14];

set_struct_fields (data [0], FALSE, 60482, "Normal",     "scrollable notebooks and hidden tabs");
set_struct_fields (data [1], FALSE, 60620, "Critical",   "gdk_window_clear_area (gdkwindow-win32.c) is not thread-safe");
set_struct_fields (data [2], FALSE, 50214, "Major",      "Xft support does not clean up correctly");
set_struct_fields (data [3], TRUE,  52877, "Major",      "GtkFileSelection needs a refresh method. ");
set_struct_fields (data [4], FALSE, 56070, "Normal",     "Can't click button after setting in sensitive");
set_struct_fields (data [5], TRUE,  56355, "Normal",     "GtkLabel - Not all changes propagate correctly");
set_struct_fields (data [6], FALSE, 50055, "Normal",     "Rework width/height computations for TreeView");
set_struct_fields (data [7], FALSE, 58278, "Normal",     "gtk_dialog_set_response_sensitive () doesn't work");
set_struct_fields (data [8], FALSE, 55767, "Normal",     "Getters for all setters");
set_struct_fields (data [9], FALSE, 56925, "Normal",     "Gtkcalender size");
set_struct_fields (data [10], FALSE, 56221, "Normal",     "Selectable label needs right-click copy menu");
set_struct_fields (data [11], TRUE,  50939, "Normal",     "Add shift clicking to GtkTextView");
set_struct_fields (data [12], FALSE, 6112,  "Enhancement","netscape-like collapsable toolbars");
set_struct_fields (data [13], FALSE, 1,     "Normal",     "First bug :=)");

define spinner_timeout (model)
{
   variable iter, pulse;

   if (model == NULL)
     return G_SOURCE_REMOVE;

   iter = gtk_tree_model_get_iter_first (model);
   % pulse = gtk_tree_model_get (model, iter, COLUMN_PULSE);
   pulse = gtk_tree_model_get_value (model, iter, COLUMN_PULSE);
   if (pulse == 0xffffffff)
     pulse = 0;
   else
     pulse ++;

   gtk_list_store_set (model, iter,
		       COLUMN_PULSE, pulse,
		       COLUMN_ACTIVE, TRUE);

   return G_SOURCE_CONTINUE;
}

define create_model ()
{
   variable i = 0, store, iter, icon_name, sensitive;

   % create list store
   store = gtk_list_store_new ([G_TYPE_BOOLEAN,
				G_TYPE_UINT,
				G_TYPE_STRING,
				G_TYPE_STRING,
				G_TYPE_UINT,
				G_TYPE_STRING,
				G_TYPE_BOOLEAN,
				G_TYPE_BOOLEAN]);

   % add data to the list store
   for (i = 0 ; i < length (data) ; i ++)
     {
	if (i == 1 || i == 3)
	  icon_name = "battery-caution-charging-symbolic";
	else
	  icon_name = NULL;
	if (i == 3)
	  sensitive = FALSE;
	else
	  sensitive = TRUE;
	iter = gtk_list_store_append (store);
	gtk_list_store_set (store, iter,
			    COLUMN_FIXED, data [i].fixed,
			    COLUMN_NUMBER, data [i].number,
			    COLUMN_SEVERITY, data [i].severity,
			    COLUMN_DESCRIPTION, data [i].description,
			    COLUMN_PULSE, 0,
			    COLUMN_ICON, icon_name,
			    COLUMN_ACTIVE, FALSE,
			    COLUMN_SENSITIVE, sensitive);
     }

   return store;
}

define fixed_toggled (cell, path_str, model)
{
   variable iter, path, fixed;
   
   path = gtk_tree_path_new_from_string (path_str);

   % get toggled iter
   iter = gtk_tree_model_get_iter (model, path);
   % fixed = gtk_tree_model_get (model, iter, COLUMN_FIXED);
   fixed = gtk_tree_model_get_value (model, iter, COLUMN_FIXED);

   % do something with the value
   fixed = not fixed;

   % set new value
   gtk_list_store_set (model, iter, COLUMN_FIXED, fixed);

   % clean up
   % gtk_tree_path_free (path);
}

define add_columns (treeview)
{
   variable renderer, column, model;

   model = gtk_tree_view_get_model (treeview);

   % column for fixed toggles
   renderer = gtk_cell_renderer_toggle_new ();
   () = g_signal_connect (renderer, "toggled", &fixed_toggled, model);

   column = gtk_tree_view_column_new_with_attributes ("Fixed?", renderer,
						      "active", COLUMN_FIXED);

   % set this column to a fixed sizing (of 50 pixels)
   gtk_tree_view_column_set_sizing (column, GTK_TREE_VIEW_COLUMN_FIXED);
   gtk_tree_view_column_set_fixed_width (column, 50);
   gtk_tree_view_append_column (treeview, column);
   
   % column for bug numbers
   renderer = gtk_cell_renderer_text_new ();
   column = gtk_tree_view_column_new_with_attributes ("Bug number", renderer,
						      "text", COLUMN_NUMBER);
   gtk_tree_view_column_set_sort_column_id (column, COLUMN_NUMBER);
   gtk_tree_view_append_column (treeview, column);

   % column for severities
   renderer = gtk_cell_renderer_text_new ();
   column = gtk_tree_view_column_new_with_attributes ("Severity", renderer,
						      "text", COLUMN_SEVERITY);
   gtk_tree_view_column_set_sort_column_id (column, COLUMN_SEVERITY);
   gtk_tree_view_append_column (treeview, column);

   % column for description
   renderer = gtk_cell_renderer_text_new ();
   column = gtk_tree_view_column_new_with_attributes ("Description", renderer,
						      "text", COLUMN_DESCRIPTION);
   gtk_tree_view_column_set_sort_column_id (column, COLUMN_DESCRIPTION);
   gtk_tree_view_append_column (treeview, column);
   
   % column for spinner
   renderer = gtk_cell_renderer_spinner_new ();
   column = gtk_tree_view_column_new_with_attributes ("Spinning", renderer,
						      "pulse", COLUMN_PULSE,
						      "active", COLUMN_ACTIVE);
   gtk_tree_view_column_set_sort_column_id (column, COLUMN_PULSE);
   gtk_tree_view_append_column (treeview, column);
   
   % column for symbolic icon
   renderer = gtk_cell_renderer_pixbuf_new ();
   column = gtk_tree_view_column_new_with_attributes ("Symbolic icon", renderer,
						      "icon-name", COLUMN_ICON,
						      "sensitive", COLUMN_SENSITIVE);
   gtk_tree_view_column_set_sort_column_id (column, COLUMN_ICON);
   gtk_tree_view_append_column (treeview, column);
}

define window_closed (widget, event)
{
   if (timeout != 0)
     {
	g_source_remove (timeout);
	timeout = 0;
     }
   return FALSE;
}

define create_list_store (do_widget)
{
   variable window, vbox, label, sw, treeview, model;
   
   % create window, etc
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "List Store");

   gtk_container_set_border_width (window, 8);

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 8);
   gtk_container_add (window, vbox);

   label = gtk_label_new ("This is the bug list (note: not based on real data, it would be nice to have a nice ODBC interface to bugzilla or so, though).");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

   sw = gtk_scrolled_window_new (,);
   gtk_scrolled_window_set_shadow_type (sw, GTK_SHADOW_ETCHED_IN);
   gtk_scrolled_window_set_policy (sw, GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC);
   gtk_box_pack_start (vbox, sw, TRUE, TRUE, 0);

   % create tree model
   model = create_model ();
   
   % create tree view
   treeview = gtk_tree_view_new_with_model (model);
   gtk_tree_view_set_search_column (treeview, COLUMN_DESCRIPTION);
   
   g_object_unref (model);

   gtk_container_add (sw, treeview);

   % add columns to the tree view
   add_columns (treeview);

   % finish & show
   gtk_window_set_default_size (window, 280, 250);
   () = g_signal_connect (window, "delete-event", &window_closed);

   ifnot (gtk_widget_get_visible (window))
    {
       gtk_widget_show_all (window);
       if (timeout == 0)
	 {
	    % FIXME this should use the animation-duration instead
	    timeout = g_timeout_add (80, &spinner_timeout, model);
	 }
    }
   else
     {
	gtk_widget_destroy (window);
	if (timeout != 0)
	  {
	     g_source_remove (timeout);
	     timeout = 0;
	  }
    }
   
   return window;
}
