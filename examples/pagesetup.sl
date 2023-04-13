% Printing/Page Setup
%
% GtkPageSetupUnixDialog can be used if page setup is needed
% independent of a full printing dialog.
%

define done_cb (dialog, response)
{
   gtk_widget_destroy (dialog);
}

define create_pagesetup (do_widget)
{
   variable window;

   window = gtk_page_setup_unix_dialog_new ("Page Setup", );
   () = g_signal_connect (window, "response", &done_cb);
   
   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
