#!/usr/bin/env slsh

require ("gtk3");

define slsh_main ()
{
   variable err, key, ui, wdg;

   try (err)
     ui = gtk_builder_new_from_file (__argv [1]);
   catch ApplicationError:
     message (err.object.message);
   
   wdg = gtk_builder_get_objects (ui);
   foreach key (assoc_get_keys (wdg))
     vmessage ("%s : %s", key, g_object_type_name (wdg [key]));
   
   () = g_signal_connect (gtk_builder_get_object (ui, "win"), "delete_event", &gtk_main_quit);
   () = g_signal_connect (wdg ["button"], "clicked", &gtk_main_quit);

   gtk_widget_show_all (wdg ["win"]);
   gtk_main ();
}
