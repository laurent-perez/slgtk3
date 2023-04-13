% Button Boxes
%
% The Button Box widgets are used to arrange buttons with padding.
%

define create_bbox (horizontal, title, spacing, layout)
{
  variable frame;
  variable bbox;
  variable button;

  frame = gtk_frame_new (title);

  if (horizontal)
    bbox = gtk_button_box_new (GTK_ORIENTATION_HORIZONTAL);
  else
    bbox = gtk_button_box_new (GTK_ORIENTATION_VERTICAL);

  gtk_container_set_border_width (bbox, 5);
  gtk_container_add (frame, bbox);

  gtk_button_box_set_layout (bbox, layout);
  gtk_box_set_spacing (bbox, spacing);

  button = gtk_button_new_with_label ("OK");
  gtk_container_add (bbox, button);

  button = gtk_button_new_with_label ("Cancel");
  gtk_container_add (bbox, button);

  button = gtk_button_new_with_label ("Help");
  gtk_container_add (bbox, button);

  return frame;
}

define create_buttonbox (do_widget)
{
   variable window, main_vbox, vbox, hbox, frame_horz, frame_vert;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Button Boxes");

   gtk_container_set_border_width (window, 10);

   main_vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_add (window, main_vbox);

   frame_horz = gtk_frame_new ("Horizontal Button Boxes");
   gtk_box_pack_start (main_vbox, frame_horz, TRUE, TRUE, 10);

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_set_border_width (vbox, 10);
   gtk_container_add (frame_horz, vbox);
   
   gtk_box_pack_start (vbox,
		       create_bbox (TRUE, "Spread", 40, GTK_BUTTONBOX_SPREAD),
		       TRUE, TRUE, 0);

   gtk_box_pack_start (vbox,
		       create_bbox (TRUE, "Edge", 40, GTK_BUTTONBOX_EDGE),
		       TRUE, TRUE, 5);

   gtk_box_pack_start (vbox,
		       create_bbox (TRUE, "Start", 40, GTK_BUTTONBOX_START),
		       TRUE, TRUE, 5);

   gtk_box_pack_start (vbox,
		       create_bbox (TRUE, "End", 40, GTK_BUTTONBOX_END),
		       TRUE, TRUE, 5);

   gtk_box_pack_start (vbox,
		       create_bbox (TRUE, "Center", 40, GTK_BUTTONBOX_CENTER),
		       TRUE, TRUE, 5);

   gtk_box_pack_start (vbox,
		       create_bbox (TRUE, "Expand", 0, GTK_BUTTONBOX_EXPAND),
		       TRUE, TRUE, 5);

   frame_vert = gtk_frame_new ("Vertical Button Boxes");
   gtk_box_pack_start ((main_vbox), frame_vert, TRUE, TRUE, 10);
   
   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 0);
   gtk_container_set_border_width (hbox, 10);
   gtk_container_add (frame_vert, hbox);

   gtk_box_pack_start (hbox,
		       create_bbox (FALSE, "Spread", 10, GTK_BUTTONBOX_SPREAD),
		       TRUE, TRUE, 0);
   
   gtk_box_pack_start (hbox,
		       create_bbox (FALSE, "Edge", 10, GTK_BUTTONBOX_EDGE),
		       TRUE, TRUE, 5);

   gtk_box_pack_start (hbox,
		       create_bbox (FALSE, "Start", 10, GTK_BUTTONBOX_START),
		       TRUE, TRUE, 5);

   gtk_box_pack_start (hbox,
		       create_bbox (FALSE, "End", 10, GTK_BUTTONBOX_END),
		       TRUE, TRUE, 5);
   
   gtk_box_pack_start (hbox,
		       create_bbox (FALSE, "Center", 10, GTK_BUTTONBOX_CENTER),
		       TRUE, TRUE, 5);
   
   gtk_box_pack_start (hbox,
		       create_bbox (FALSE, "Expand", 0, GTK_BUTTONBOX_EXPAND),
		       TRUE, TRUE, 5);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
    gtk_widget_destroy (window);
   
   return window;
}
