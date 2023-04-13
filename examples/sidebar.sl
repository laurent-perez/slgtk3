% Stack Sidebar
%
% GtkStackSidebar provides an automatic sidebar widget to control
% navigation of a GtkStack object. This widget automatically updates it
% content based on what is presently available in the GtkStack object,
% and using the "title" child property to set the display labels.


define create_sidebar (do_widget)
{
   variable window, sidebar, stack, box, widget, header, c, i;
   variable pages = ["Welcome to GTK+",
		     "GtkStackSidebar Widget",
		     "Automatic navigation",
		     "Consistent appearance",
		     "Scrolling",
		     "Page 6",
		     "Page 7",
		     "Page 8",
		     "Page 9"];

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_resizable (window, TRUE);
   gtk_widget_set_size_request (window, 500, 350);

   header = gtk_header_bar_new ();
   gtk_header_bar_set_show_close_button (header, TRUE);
   gtk_window_set_titlebar (window, header);
   gtk_window_set_title (window, "Stack Sidebar");

   box = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 0);

   sidebar = gtk_stack_sidebar_new ();
   gtk_box_pack_start (box, sidebar, FALSE, FALSE, 0);

   stack = gtk_stack_new ();
   gtk_stack_set_transition_type (stack, GTK_STACK_TRANSITION_TYPE_SLIDE_UP_DOWN);

   gtk_stack_sidebar_set_stack (sidebar, stack);
   
   % Separator between sidebar and stack
   widget = gtk_separator_new (GTK_ORIENTATION_VERTICAL);
   gtk_box_pack_start (box, widget, FALSE, FALSE, 0);

   gtk_box_pack_start (box, stack, TRUE, TRUE, 0);

   for (i = 0 ; i < length (pages) ; i ++)
     {
   	c = pages [i];
   	if (i == 0)
   	  {
   	     widget = gtk_image_new_from_icon_name ("help-about", GTK_ICON_SIZE_MENU);
   	     gtk_image_set_pixel_size (widget, 256);
   	  }
   	else
   	  {
   	     widget = gtk_label_new (c);
   	  }
   	% gtk_stack_add_named (stack, widget, c);
   	% gtk_container_child_set_property (stack, widget, "title", c);
	gtk_stack_add_titled (stack, widget, c, c);
     }

   gtk_container_add (window, box);
   
   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
