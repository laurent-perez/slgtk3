% Printing/Printing
%
% GtkPrintOperation offers a simple API to support printing
% in a cross-platform way.
%
%

require ("cairo");

% In points
variable HEADER_HEIGHT = 10*72/25.;
variable HEADER_GAP = 3*72/25.4;

define begin_print (operation, context, data)
{
   variable bytes, i, height, fp;

   height = gtk_print_context_get_height (context) - HEADER_HEIGHT - HEADER_GAP;

   data.lines_per_page = floor (height / data.font_size);

   fp = fopen (data.resourcename, "r");
   data.lines = fgetslines (fp);
   () = fclose (fp);

   data.num_lines = length (data.lines);

   data.num_pages = int (data.num_lines / data.lines_per_page + 1);

   gtk_print_operation_set_n_pages (operation, data.num_pages);
}

define draw_page (operation, context, page_nr, data)
{
   variable cr, layout, text_width, text_height, width, line, i, desc, page_str;

   cr = gtk_print_context_get_cairo_context (context);
   width = gtk_print_context_get_width (context);

   cairo_rectangle (cr, 0, 0, width, HEADER_HEIGHT);

   cairo_set_source_rgb (cr, 0.8, 0.8, 0.8);
   cairo_fill_preserve (cr);

   cairo_set_source_rgb (cr, 0, 0, 0);
   cairo_set_line_width (cr, 1);
   cairo_stroke (cr);

   layout = gtk_print_context_create_pango_layout (context);

   desc = pango_font_description_from_string ("sans 14");
   pango_layout_set_font_description (layout, desc);
   pango_font_description_free (desc);

   pango_layout_set_text (layout, data.resourcename);
   (text_width, text_height) = pango_layout_get_pixel_size (layout);

   if (text_width > width)
     {
	pango_layout_set_width (layout, width);
	pango_layout_set_ellipsize (layout, PANGO_ELLIPSIZE_START);
	(text_width, text_height) = pango_layout_get_pixel_size (layout);
     }

   cairo_move_to (cr, (width - text_width) / 2,  (HEADER_HEIGHT - text_height) / 2);
   pango_cairo_show_layout (cr, layout);

   page_str = sprintf ("%d/%d", page_nr + 1, data.num_pages);
   pango_layout_set_text (layout, page_str);

   pango_layout_set_width (layout, -1);
   (text_width, text_height) = pango_layout_get_pixel_size (layout);
   cairo_move_to (cr, width - text_width - 4, (HEADER_HEIGHT - text_height) / 2);
   pango_cairo_show_layout (cr, layout);

   % g_object_unref (layout);

   layout = gtk_print_context_create_pango_layout (context);

   desc = pango_font_description_from_string ("monospace");
   pango_font_description_set_size (desc, int (data.font_size * PANGO_SCALE));
   pango_layout_set_font_description (layout, desc);
   pango_font_description_free (desc);
   
   cairo_move_to (cr, 0, HEADER_HEIGHT + HEADER_GAP);
   line = int (page_nr * data.lines_per_page);
   for (i = 0 ; i < data.lines_per_page && line < data.num_lines ; i ++)
     {
	% message (data.lines [line]);
	pango_layout_set_text (layout, data.lines [line]);
	pango_cairo_show_layout (cr, layout);
	cairo_rel_move_to (cr, 0, data.font_size);
	line ++;
     }
   
   % g_object_unref (layout);
}

define end_print (operation, context, data)
{
   % g_free (data->resourcename);
   % g_strfreev (data->lines);
   % g_free (data);
}


define create_printing (do_widget)
{
   variable operation, settings, data, err;

   data = struct
     {
	resourcename,
	font_size,
	lines_per_page,
	lines,
	num_lines,
	num_pages
     };

   operation = gtk_print_operation_new ();

   data.resourcename = "printing.sl";
   data.font_size = 12.0;

   () = g_signal_connect (operation, "begin-print", &begin_print, data);
   () = g_signal_connect (operation, "draw-page", &draw_page, data);
   () = g_signal_connect (operation, "end-print", &end_print, data);

   gtk_print_operation_set_use_full_page (operation, FALSE);
   gtk_print_operation_set_unit (operation, GTK_UNIT_POINTS);
   gtk_print_operation_set_embed_page_setup (operation, TRUE);

   settings = gtk_print_settings_new ();
   
   % gtk_print_settings_set (settings, GTK_PRINT_SETTINGS_OUTPUT_BASENAME, "gtk-demo");
   gtk_print_operation_set_print_settings (operation, settings);

   % g_object_unref (operation);
   % g_object_unref (settings);   
   
   try (err)
     () = gtk_print_operation_run (operation, GTK_PRINT_OPERATION_ACTION_PRINT_DIALOG, );
   catch AnyError:
     {
	variable dialog;
	
	dialog = gtk_message_dialog_new (NULL, GTK_DIALOG_DESTROY_WITH_PARENT,
					 GTK_MESSAGE_ERROR, GTK_BUTTONS_CLOSE,
					 err.object.message);
	
	() = g_signal_connect (dialog, "response", &gtk_widget_destroy);

	gtk_widget_show (dialog);
     }
   
   return NULL;
}
