% Spin Button
%
% GtkSpinButton provides convenient ways to input data
% that can be seen as a value in a range. The examples
% here show that this does not necessarily mean numeric
% values, and it can include custom formatting.

define hex_spin_input (spin_button, new_val)
{
   variable buf, val;

   buf = gtk_entry_get_text (spin_button);
   try
     {	
	val = integer (buf);
	gpointer_set_double (new_val, val);
     }
   catch AnyError:
     {
	return GTK_INPUT_ERROR;
     }   
   return TRUE;
}

define hex_spin_output (spin_button)
{
   variable adjustment, buf, val;

   adjustment = gtk_spin_button_get_adjustment (spin_button);
   val = nint (gtk_adjustment_get_value (adjustment));
   if (abs (val) < 1e-5)
     buf = "0x00";
   else
     buf = sprintf ("0x%.2X", val);
   if (strcmp (buf, gtk_entry_get_text (spin_button)))
     gtk_entry_set_text (spin_button, buf);

   return TRUE;
}

define time_spin_input (spin_button, new_val)
{
   variable text, str, found = FALSE, hours, minutes;

   text = gtk_entry_get_text (spin_button);
   str = strchop (text, ':', 0);
   
   if (length (str) == 2)
     {
	hours = integer (str [0]);
	minutes = integer (str[1]);
	if (0 <= hours && hours < 24 && 0 <= minutes && minutes < 60)
	  {
	     gpointer_set_double (new_val, hours * 60 + minutes);
	     found = TRUE;
	  }
     }
   
   if (not found)
     {
	gpointer_set_double (new_val, 0.0);
	return GTK_INPUT_ERROR;
     }
   
   return TRUE;
}

define time_spin_output (spin_button)
{
   variable adjustment, buf, hours, minutes;

   adjustment = gtk_spin_button_get_adjustment (spin_button);
   hours = gtk_adjustment_get_value (adjustment) / 60.0;
   minutes = (hours - floor (hours)) * 60.0;
   buf = sprintf ("%02.0f:%02.0f", floor (hours), floor (minutes + 0.5));
   if (strcmp (buf, gtk_entry_get_text (spin_button)))
     gtk_entry_set_text (spin_button, buf);

  return TRUE;
}

variable month = ["January",
		  "February",
		  "March",
		  "April",
		  "May",
		  "June",
		  "July",
		  "August",
		  "September",
		  "October",
		  "November",
		  "December"];

define month_spin_input (spin_button, new_val)
{
   variable i, tmp1, tmp2, found = FALSE;

   for (i = 1; i <= 12; i ++)
     {
	tmp1 = strup (month [i - 1]);
	tmp2 = strup (gtk_entry_get_text (spin_button));
	if (is_substr (tmp1, tmp2))
	  found = TRUE;
	if (found)
	  break;
     }
   if (not found)
     {
	gpointer_set_double (new_val, 0.0);
	return GTK_INPUT_ERROR;
     }
   gpointer_set_double (new_val, 1.0 * i);
   
   return TRUE;
}

define month_spin_output (spin_button)
{
   variable adjustment, value, i;

   adjustment = gtk_spin_button_get_adjustment (spin_button);
   value = gtk_adjustment_get_value (adjustment);
   for (i = 1; i <= 12; i ++)
     if (abs (value - i) < 1e-5)
       {
	  if (strcmp (month [i-1], gtk_entry_get_text (spin_button)))
	    gtk_entry_set_text (spin_button, month [i-1]);
       }
   
   return TRUE;
}

define value_to_label (binding, from, to)
{
   % g_value_take_string (to, sprintf ("%g", g_value_get_double (from)));
   return TRUE;
}

define create_spinbutton (do_widget)
{
   variable window, builder, adj, label;
   variable hex_spin_val = 0;
   
   builder = gtk_builder_new_from_resource ("/spinbutton/spinbutton.ui");
   % gtk_builder_add_callback_symbol (builder,
   % 				    "hex_spin_input", &hex_spin_input);

   gtk_builder_add_callback_symbols (builder,
   				     "hex_spin_input", &hex_spin_input,
   				     "hex_spin_output", &hex_spin_output,
   				     "time_spin_input", &time_spin_input,
   				     "time_spin_output", &time_spin_output,
   				     "month_spin_input", &month_spin_input,
   				     "month_spin_output", &month_spin_output);

   gtk_builder_connect_signals (builder);
   
   window = gtk_builder_get_object (builder, "window");
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Spin Buttons");
   gtk_window_set_resizable (window, FALSE);

   adj = gtk_builder_get_object (builder, "basic_adjustment");
   label = gtk_builder_get_object (builder, "basic_label");   
   % g_object_bind_property_full (adj, "value",
   % 				label, "label",
   % 				G_BINDING_SYNC_CREATE,
   % 				value_to_label,
   % 				NULL,
   % 				NULL, NULL);
   g_object_bind_property (adj, "value",
			   label, "label",
			   G_BINDING_SYNC_CREATE);

   adj = gtk_builder_get_object (builder, "hex_adjustment");
   label = gtk_builder_get_object (builder, "hex_label");
   % g_object_bind_property_full (adj, "value",
   % 				label, "label",
   % 				G_BINDING_SYNC_CREATE,
   % 				value_to_label,
   % 				NULL,
   % 				NULL, NULL);
   g_object_bind_property (adj, "value",
			   label, "label",
			   G_BINDING_SYNC_CREATE);

   adj = gtk_builder_get_object (builder, "time_adjustment");
   label = gtk_builder_get_object (builder, "time_label");
   % g_object_bind_property_full (adj, "value",
   % 				label, "label",
   % 				G_BINDING_SYNC_CREATE,
   % 				value_to_label,
   % 				NULL,
   % 				NULL, NULL);
   g_object_bind_property (adj, "value",
			   label, "label",
			   G_BINDING_SYNC_CREATE);

   adj = gtk_builder_get_object (builder, "month_adjustment");
   label = gtk_builder_get_object (builder, "month_label");
   % g_object_bind_property_full (adj, "value",
   % 				label, "label",
   % 				G_BINDING_SYNC_CREATE,
   % 				value_to_label,
   % 				NULL,
   % 				NULL, NULL);
   g_object_bind_property (adj, "value",
			   label, "label",
			   G_BINDING_SYNC_CREATE);

   % g_object_unref (builder);

   if (not gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
