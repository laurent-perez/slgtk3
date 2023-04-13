% Theming/CSS Blend Modes
%
% You can blend multiple backgrounds using the CSS blend modes available.

% These are the available blend modes.

variable blend_modes = {
   { "Color", "color" },
   { "Color (burn)", "color-burn" },
   { "Color (dodge)", "color-dodge" },
   { "Darken", "darken" },
   { "Difference", "difference" },
   { "Exclusion", "exclusion" },
   { "Hard Light", "hard-light" },
   { "Hue", "hue" },
   { "Lighten", "lighten" },
   { "Luminosity", "luminosity" },
   { "Multiply", "multiply" },
   { "Normal", "normal" },
   { "Overlay", "overlay" },
   { "Saturate", "saturate" },
   { "Screen", "screen" },
   { "Soft Light", "soft-light" }};

define update_css_for_blend_mode (provider, blend_mode)
{
   variable css, bytes, fp, lines;  
   
   % bytes = g_resources_lookup_data ("/css_blendmodes/css_blendmodes.css", 0);

   % css = sprintf (g_bytes_get_data (bytes, NULL),
   % 		  blend_mode,
   % 		  blend_mode,
   % 		  blend_mode);

   fp = fopen ("css/css_blendmodes.css", "r");
   lines = fgetslines (fp);
   () = fclose (fp);   
   bytes = strjoin (lines, "");
   css = sprintf (bytes, blend_mode, blend_mode, blend_mode);

   gtk_css_provider_load_from_data (provider, css, -1);

   % g_bytes_unref (bytes);
}

define row_activated (listbox, row, provider)
{
   variable blend_mode;

   blend_mode = blend_modes [gtk_list_box_row_get_index (row)][1];

   update_css_for_blend_mode (provider, blend_mode);
}

define setup_listbox (builder, provider)
{
   variable normal_row, listbox, i, label, row;

   normal_row = NULL;
   listbox = gtk_list_box_new ();
   gtk_container_add (gtk_builder_get_object (builder, "scrolledwindow"), listbox);

   () = g_signal_connect (listbox, "row-activated", &row_activated, provider);

   % Add a row for each blend mode available
   for (i = 0 ; i < length (blend_modes) ; i ++)
    {
       row = gtk_list_box_row_new ();
       % label = g_object_new (GTK_TYPE_LABEL,
       % 			     "label", blend_modes [i][0],
       % 			     "xalign", 0.0,
       % 			     NULL);
       label = gtk_label_new (blend_modes [i][0]);
       gtk_container_add (row, label);
       gtk_container_add (listbox, row);
       
       % The first selected row is "normal"
       if (blend_modes [i][1] == "normal")
	 normal_row = row;
    }
   
   % Select the "normal" row
   gtk_list_box_select_row (listbox, normal_row);
   g_signal_emit_by_name (normal_row, "activate");
   
   gtk_widget_grab_focus (normal_row);
}

define create_css_blendmodes (do_widget)
{
   variable window, provider, builder;

   builder = gtk_builder_new_from_resource ("/css_blendmodes/blendmodes.ui");

   window = gtk_builder_get_object (builder, "window");
   gtk_window_set_transient_for (window, do_widget);

   % Setup the CSS provider for window
   provider = gtk_css_provider_new ();

   gtk_style_context_add_provider_for_screen (gdk_screen_get_default (),
					      provider,
					      GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

   setup_listbox (builder, provider);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
