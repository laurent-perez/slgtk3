% Links
%
% GtkLabel can show hyperlinks. The default action is to call
% gtk_show_uri_on_window() on their URI, but it is possible to override
% this with a custom handler.
%


define response_cb (dialog, response_id)
{
   gtk_widget_destroy (dialog);
}

define activate_link (label, uri)
{
   variable dialog, parent; 

   if (uri == "keynav")
    {
       parent = gtk_widget_get_toplevel (label);
       dialog = gtk_message_dialog_new_with_markup (parent,
						    GTK_DIALOG_DESTROY_WITH_PARENT,
						    GTK_MESSAGE_INFO,
						    GTK_BUTTONS_OK,
						    "The term <i>keynav</i> is a shorthand for" +
						    "keyboard navigation and refers to the process of using" +
						    "a program (exclusively) via keyboard input.");
       gtk_window_set_modal (dialog, TRUE);

       gtk_window_present (dialog);
       () = g_signal_connect (dialog, "response", &response_cb);
       
       return TRUE;
    }

   return FALSE;
}

define create_links (do_widget)
{
   variable window, label;

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Links");
   gtk_container_set_border_width ( window, 12);

   label = gtk_label_new ("Some <a href=\"http://en.wikipedia.org/wiki/Text\"" +
                             "title=\"plain text\">text</a> may be marked up\n" +
                             "as hyperlinks, which can be clicked\n" +
                             "or activated via <a href=\"keynav\">keynav</a>\n" +
                             "and they work fine with other markup, like when\n" +
                             "searching on <a href=\"http://www.google.com/\">" +
                             "<span color=\"#0266C8\">G</span><span color=\"#F90101\">o</span>" +
                             "<span color=\"#F2B50F\">o</span><span color=\"#0266C8\">g</span>" +
                             "<span color=\"#00933B\">l</span><span color=\"#F90101\">e</span>" +
                             "</a>.");
   gtk_label_set_use_markup (label, TRUE);
   () = g_signal_connect (label, "activate-link", &activate_link);
   gtk_container_add ( window, label);
   gtk_widget_show (label);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
