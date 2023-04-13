% Theming/CSS Accordion
%
% A simple accordion demo written using CSS transitions and multiple backgrounds
%

define apply_css ();

define apply_css (widget, provider)
{
   gtk_style_context_add_provider (gtk_widget_get_style_context (widget), provider,
				   G_MAXUINT);

   % if (gtk_is (widget, "container"))
   if (gtk_is_container (widget))   
     gtk_container_forall (widget, &apply_css, provider);
}

define create_css_accordion (do_widget)
{
   variable window, container, child, provider;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_title (window, "CSS Accordion");
   gtk_window_set_transient_for (window, do_widget);
   gtk_window_set_default_size (window, 600, 300);

   container = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 0);
   gtk_widget_set_halign (container, GTK_ALIGN_CENTER);
   gtk_widget_set_valign (container, GTK_ALIGN_CENTER);
   gtk_container_add (window, container);
	
   child = gtk_button_new_with_label ("This");
   gtk_container_add (container, child);
   
   child = gtk_button_new_with_label ("Is");
   gtk_container_add (container, child);
   
   child = gtk_button_new_with_label ("A");
   gtk_container_add (container, child);
   
   child = gtk_button_new_with_label ("CSS");
   gtk_container_add (container, child);
   
   child = gtk_button_new_with_label ("Accordion");
   gtk_container_add (container, child);
   
   child = gtk_button_new_with_label (":-)");
   gtk_container_add (container, child);
   
   provider = gtk_css_provider_new ();
   gtk_css_provider_load_from_resource (provider, "/css_accordion/css_accordion.css");
   % () = gtk_css_provider_load_from_path (provider, "/home/lperez/devel/slang/gtk/slgtk/slgtk-0.9/examples/css_accordion.css");
   apply_css (window, provider);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
