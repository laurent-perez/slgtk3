% Icon View/Icon View Basics
%
% The GtkIconView widget is used to display and manipulate icons.
% It uses a GtkTreeModel for data storage, so the list store
% example might be helpful.
%

variable FOLDER_NAME = "images/gnome-fs-directory.png";
variable FILE_NAME = "images/gnome-fs-regular.png";
variable COL_PATH = 0, COL_DISPLAY_NAME = 1, COL_PIXBUF = 2, COL_IS_DIRECTORY = 3;
variable file_pixbuf = NULL, folder_pixbuf, parent, up_button;


% Loads the images for the demo and returns whether the operation succeeded
define load_pixbufs ()
{
   if (file_pixbuf != NULL)
     return; % already loaded earlier

   file_pixbuf = gdk_pixbuf_new_from_file (FILE_NAME);
   folder_pixbuf = gdk_pixbuf_new_from_file (FOLDER_NAME);
}

define fill_store (store)
{
   variable dir, name, iter, path, display_name, is_dir, st;
   
   % First clear the store
   gtk_list_store_clear (store);

   % glib version : bug with "g_dir_read_name"
   % Now go through the directory and extract all the file information
   % dir = g_dir_open (parent, 0);
   % if (dir == NULL)
   %   return;

   % name = g_dir_read_name (dir);
   % while (name != NULL)
   %   {	
	% We ignore hidden files that start with a '.'
	% if (name [0] != '.')
	%   {
	%      path = g_build_filename ([parent, name]);
	%      is_dir = g_file_test (path, G_FILE_TEST_IS_DIR);
	%      display_name = g_filename_to_utf8 (name);
       	%      () = gtk_list_store_append (store,
       	% 				 COL_PATH, path,
       	% 				 COL_DISPLAY_NAME, display_name,
       	% 				 COL_IS_DIRECTORY, is_dir,
       	% 				 COL_PIXBUF, is_dir ? folder_pixbuf : file_pixbuf);
       	%   }
	% name = g_dir_read_name (dir);
     % }
   % g_dir_close (dir);
	
   % slang version   
   dir = listdir (parent);
   foreach name (dir)
    {
       if (name [0] == '.')
   	 continue;
       path = parent + "/" + name;
       st = stat_file (path);
       is_dir = stat_is ("dir", st.st_mode);
       () = gtk_list_store_append (store,
   				   COL_PATH, path,
   				   COL_DISPLAY_NAME, name,
   				   COL_IS_DIRECTORY, is_dir,
   				   COL_PIXBUF, is_dir ? folder_pixbuf : file_pixbuf);
    }   
}

define sort_func (model, a, b)
{
   variable is_dir_a, is_dir_b, name_a, name_b, ret = 1, valid_a, valid_b;

   % We need this function because we want to sort folders before files.

   valid_a = gtk_list_store_iter_is_valid (model, a);
   is_dir_a = gtk_tree_model_get_value (model, a, COL_IS_DIRECTORY);
   name_a = gtk_tree_model_get_value (model, a, COL_DISPLAY_NAME);

   valid_b = gtk_list_store_iter_is_valid (model, b);
   is_dir_b = gtk_tree_model_get_value (model, b, COL_IS_DIRECTORY);
   name_b = gtk_tree_model_get_value (model, b, COL_DISPLAY_NAME);
   
   if ((not is_dir_a) && is_dir_b)
     ret = 1;
   else if (is_dir_a && (not is_dir_b))
     ret = -1;
   else
     % ret = g_utf8_collate (name_a, name_b);
     ret = (name_a == name_b);
     % ret = strcmp (name_a, name_b);

   return ret;
}

define create_store ()
{
   variable store;

   store = gtk_list_store_new ([G_TYPE_STRING, G_TYPE_STRING, GDK_TYPE_PIXBUF, G_TYPE_BOOLEAN]);

   % Set sort column and function
   gtk_tree_sortable_set_default_sort_func (store, &sort_func);
   gtk_tree_sortable_set_sort_column_id (store,
   					 GTK_TREE_SORTABLE_DEFAULT_SORT_COLUMN_ID,
   					 GTK_SORT_ASCENDING);
   return store;
}

define item_activated (icon_view, tree_path, store)
{
   variable path, iter, is_dir;

   iter = gtk_tree_model_get_iter (store, tree_path);
   path = gtk_tree_model_get_value (store, iter, COL_PATH);
   is_dir = gtk_tree_model_get_value (store, iter, COL_IS_DIRECTORY);
   
   ifnot (is_dir)     
     return;

   % Replace parent with path and re-fill the model
   parent = path;

   fill_store (store);

   % Sensitize the up button
   gtk_widget_set_sensitive (up_button, TRUE);
}

define up_clicked (item, store)
{
   variable dir_name;

   dir_name = g_path_get_dirname (parent);

   parent = dir_name;

   fill_store (store);

   % Maybe de-sensitize the up button
   gtk_widget_set_sensitive (up_button, strcmp (parent, "/") != 0);
}

define home_clicked (item, store)
{
   parent = g_get_home_dir ();

   fill_store (store);

   % Sensitize the up button
   gtk_widget_set_sensitive (up_button, TRUE);
}

define close_window (window)
{
   gtk_widget_destroy (window);

   g_object_unref (file_pixbuf);
   file_pixbuf = NULL;

   g_object_unref (folder_pixbuf);
   folder_pixbuf = NULL;
}

define create_iconview (do_widget)
{
   variable window, sw, icon_view, store, vbox, tool_bar, home_button;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_default_size (window, 650, 400);       
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Icon View Basics");

   () = g_signal_connect (window, "destroy", &close_window, window);
   
   load_pixbufs ();
       
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_add (window, vbox);

   tool_bar = gtk_toolbar_new ();
   gtk_box_pack_start (vbox, tool_bar, FALSE, FALSE, 0);
       
   up_button = gtk_tool_button_new (NULL, NULL);
   gtk_tool_button_set_label (up_button, "_Up");
   gtk_tool_button_set_use_underline (up_button, TRUE);
   gtk_tool_button_set_icon_name (up_button, "go-up");
   gtk_tool_item_set_is_important (up_button, TRUE);
   gtk_widget_set_sensitive (up_button, FALSE);
   gtk_toolbar_insert (tool_bar, up_button, -1);

   home_button = gtk_tool_button_new (NULL, NULL);
   gtk_tool_button_set_label (home_button, "_Home");
   gtk_tool_button_set_use_underline (home_button, TRUE);
   gtk_tool_button_set_icon_name (home_button, "go-home");
   gtk_tool_item_set_is_important (home_button, TRUE);
   gtk_toolbar_insert (tool_bar, home_button, -1);

   sw = gtk_scrolled_window_new (NULL, NULL);
   gtk_scrolled_window_set_shadow_type (sw, GTK_SHADOW_ETCHED_IN);
   gtk_scrolled_window_set_policy (sw, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
       
   gtk_box_pack_start (vbox, sw, TRUE, TRUE, 0);

   % Create the store and fill it with the contents of '/'
   parent = "/";
   store = create_store ();
   fill_store (store);
       
   icon_view = gtk_icon_view_new_with_model (store);
   gtk_icon_view_set_selection_mode (icon_view, GTK_SELECTION_MULTIPLE);
   % g_object_unref (store);

   % Connect to the "clicked" signal of the "Up" tool button
   () = g_signal_connect (up_button, "clicked", &up_clicked, store);

   % Connect to the "clicked" signal of the "Home" tool button
   () = g_signal_connect (home_button, "clicked", &home_clicked, store);
       
   % We now set which model columns that correspond to the text
   % and pixbuf of each item
   gtk_icon_view_set_text_column (icon_view, COL_DISPLAY_NAME);
   gtk_icon_view_set_pixbuf_column (icon_view, COL_PIXBUF);

   % Connect to the "item-activated" signal
   () = g_signal_connect (icon_view, "item-activated", &item_activated, store);
       
   gtk_container_add (sw, icon_view);

   gtk_widget_grab_focus (icon_view);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
