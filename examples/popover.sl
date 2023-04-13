% Popovers
%
% A bubble-like window containing contextual information or options.
% GtkPopovers can be attached to any widget, and will be displayed
% within the same window, but on top of all its content.
%

require ("cairo");

define toggle_changed_cb (button, popover)
{
   gtk_widget_set_visible (popover, gtk_toggle_button_get_active (button));
}

define make_popover (parent, child, pos)
{
   variable popover;

   popover = gtk_popover_new (parent);
   gtk_popover_set_position (popover, pos);
   gtk_container_add (popover, child);
   gtk_container_set_border_width (popover, 6);
   gtk_widget_show (child);
   
   return popover;
}

define create_complex_popover (parent, pos)
{
   variable popover, window, content, builder, err;

   builder = gtk_builder_new ();
   try (err)
     () = gtk_builder_add_from_resource (builder, "/popover/popover.ui");
     % () = gtk_builder_add_from_file (builder, "popover.ui");
   catch ApplicationError:
     message (err.object.message);

   window = gtk_builder_get_object (builder, "window");
   content = gtk_bin_get_child (window);
   % g_object_ref (content);
   gtk_container_remove (gtk_widget_get_parent (content), content);
   gtk_widget_destroy (window);
   % g_object_unref (builder);

   popover = make_popover (parent, content, GTK_POS_BOTTOM);
   % g_object_unref (content);

   return popover;
}

define entry_size_allocate_cb (entry, allocation, popover)
{
   variable popover_pos, rect;

   if (gtk_widget_is_visible (popover))
     {
	popover_pos = g_object_get_data (entry, "popover-icon-pos");
	rect = gtk_entry_get_icon_area (entry, popover_pos);
	gtk_popover_set_pointing_to (popover, rect);
    }
}

define entry_icon_press_cb (entry, icon_pos, event, popover)
{
   variable rect;

   rect = gtk_entry_get_icon_area (entry, icon_pos);
   gtk_popover_set_pointing_to (popover, rect);
   gtk_widget_show (popover);
   
   g_object_set_data (entry, "popover-icon-pos", icon_pos);
}

define day_selected_cb (calendar)
{
   variable popover, rect, allocation, event, x, y;

   event = gtk_get_current_event ();

   if (gdk_event_get_event_type (event) != GDK_BUTTON_PRESS)
     return;

   (x, y) = gdk_event_get_coords (event);
   (x, y) = gdk_window_coords_to_parent (gdk_event_get_window (event), x, y);

   allocation = gtk_widget_get_allocation (calendar);
   rect = @cairo_rectangle_int_t;
   rect.x = int (x - allocation.x);
   rect.y = int (y - allocation.y);
   rect.width = 1;
   rect.height = 1;

   popover = make_popover (calendar, gtk_entry_new (), GTK_POS_BOTTOM);
   gtk_popover_set_pointing_to (popover, rect);

   gtk_widget_show (popover);

   % gdk_event_free (event);
}

define create_popover (do_widget)
{
   variable window, popover, box, widget;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   box = gtk_box_new (GTK_ORIENTATION_VERTICAL, 24);
   gtk_container_set_border_width (box, 24);
   gtk_container_add (window, box);
   
   widget = gtk_toggle_button_new_with_label ("Button");
   popover = make_popover (widget,
			     gtk_label_new ("This popover does not grab input"),
			     GTK_POS_TOP);
   gtk_popover_set_modal (popover, FALSE);
   () = g_signal_connect (widget, "toggled", &toggle_changed_cb, popover);
   gtk_container_add (box, widget);
   
   widget = gtk_entry_new ();
   popover = create_complex_popover (widget, GTK_POS_TOP);
   gtk_entry_set_icon_from_icon_name (widget,
				      GTK_ENTRY_ICON_PRIMARY, "edit-find");
   gtk_entry_set_icon_from_icon_name (widget,
				      GTK_ENTRY_ICON_SECONDARY, "edit-clear");
   
   () = g_signal_connect (widget, "icon-press", &entry_icon_press_cb, popover);
   () = g_signal_connect (widget, "size-allocate", &entry_size_allocate_cb, popover);
   gtk_container_add (box, widget);
   
   widget = gtk_calendar_new ();
   () = g_signal_connect (widget, "day-selected", &day_selected_cb);
   gtk_container_add (box, widget);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
