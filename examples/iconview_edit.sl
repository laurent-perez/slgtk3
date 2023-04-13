% Icon View/Editing and Drag-and-Drop
%
% The GtkIconView widget supports Editing and Drag-and-Drop.
% This example also demonstrates using the generic GtkCellLayout
% interface to set up cell renderers in an icon view.
%

variable COL_TEXT = 0;

define fill_store (store)
{
   variable text = [ "Red", "Green", "Blue", "Yellow" ], iter, i;

   % First clear the store
   gtk_list_store_clear (store);

   for (i = 0 ; i < 4 ; i ++)
     {
	iter = gtk_list_store_append (store);
	gtk_list_store_set (store, iter, COL_TEXT, text [i]);
     }
}

define create_store ()
{
   variable store = gtk_list_store_new ([G_TYPE_STRING]);

   return store;
}

define set_cell_color (cell_layout, cell, tree_model, iter)
{
   variable text, pixel = 0, pixbuf, color;

   text = gtk_tree_model_get (tree_model, iter, COL_TEXT);
   if (text == NULL)
     return;

   color = gdk_rgba_parse (text);
   if (color != NULL)	
    pixel = nint (color.red * 255) << 24 | nint (color.green * 255) << 16 |
     nint (color.blue * 255) << 8 | nint (color.alpha * 255);

   pixbuf = gdk_pixbuf_new (GDK_COLORSPACE_RGB, TRUE, 8, 24, 24);
   gdk_pixbuf_fill (pixbuf, pixel);

   g_object_set (cell, "pixbuf", pixbuf);

   g_object_unref (pixbuf);
}

define edited (cell, path_string, text, data)
{
   variable model, iter, path;

   model = gtk_icon_view_get_model (data);
   path = gtk_tree_path_new_from_string (path_string);

   iter = gtk_tree_model_get_iter (model, path);
   gtk_list_store_set (model, iter, COL_TEXT, text);

   % gtk_tree_path_free (path);
}

define create_iconview_edit (do_widget)
{
   variable window, icon_view, store, renderer;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);	
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Editing and Drag-and-Drop");

   store = create_store ();
   fill_store (store);

   icon_view = gtk_icon_view_new_with_model (store);
   % g_object_unref (store);

   gtk_icon_view_set_selection_mode (icon_view, GTK_SELECTION_SINGLE);
   gtk_icon_view_set_item_orientation (icon_view, GTK_ORIENTATION_HORIZONTAL);
   gtk_icon_view_set_columns (icon_view, 2);
   gtk_icon_view_set_reorderable (icon_view, TRUE);
   
   renderer = gtk_cell_renderer_pixbuf_new ();
   gtk_cell_layout_pack_start (icon_view, renderer, TRUE);
   () = gtk_cell_layout_set_cell_data_func (icon_view, renderer, &set_cell_color);

   renderer = gtk_cell_renderer_text_new ();
   gtk_cell_layout_pack_start (icon_view, renderer, TRUE);
   g_object_set (renderer, "editable", TRUE);
   () = g_signal_connect (renderer, "edited", &edited, icon_view);
   gtk_cell_layout_set_attributes (icon_view, renderer, "text", COL_TEXT);

   gtk_container_add (window, icon_view);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
