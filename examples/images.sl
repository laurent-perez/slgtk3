% Images
%
% GtkImage is used to display an image; the image can be in a number of formats.
% Typically, you load an image into a GdkPixbuf, then display the pixbuf.
%
% This demo code shows some of the more obscure cases, in the simple
% case a call to gtk_image_new_from_file() is all you need.
%
% If you want to put image data in your program as a C variable,
% use the make-inline-pixbuf program that comes with GTK+.
% This way you won't need to depend on loading external files, your
% application binary can be self-contained.
%


variable window;
variable pixbuf_loader = NULL;
variable load_timeout = 0;
variable image_stream = NULL;

define progressive_prepared_callback (loader, image)
{
   variable pixbuf;
   
   pixbuf = gdk_pixbuf_loader_get_pixbuf (loader);

   % Avoid displaying random memory contents, since the pixbuf
   % isn't filled in yet.

   gdk_pixbuf_fill (pixbuf, 0xaaaaaaff);

   gtk_image_set_from_pixbuf (image, pixbuf);
}

define progressive_updated_callback (loader, x, y, width, height, image)
{
  variable pixbuf;

   % We know the pixbuf inside the GtkImage has changed, but the image
   % itself doesn't know this; so give it a hint by setting the pixbuf
   % again. Queuing a redraw used to be sufficient, but nowadays GtkImage
   % uses GtkIconHelper which caches the pixbuf state and will just redraw
   % from the cache.
   
   pixbuf = gtk_image_get_pixbuf (image);
   g_object_ref (pixbuf);
   gtk_image_set_from_pixbuf (image, pixbuf);
   g_object_unref (pixbuf);
}

define progressive_timeout (image)
{
   variable buf, bytes_read, dialog, err;

   % This shows off fully-paranoid error handling, so looks scary.
   % You could factor out the error handling code into a nice separate
   % function to make things nicer.

   if (image_stream != NULL)
     {
	try	  
	  bytes_read = g_input_stream_read (image_stream, &buf, 256, );
	% buf = g_input_stream_read_bytes (image_stream, 256,);
	% if (bytes_read < 0)
	catch ApplicationError:
  	  {
	     dialog = gtk_message_dialog_new (window,
  					      GTK_DIALOG_DESTROY_WITH_PARENT,
  					      GTK_MESSAGE_ERROR,
  					      GTK_BUTTONS_CLOSE,
  					      "Failure reading image file 'alphatest.png'");

	     gtk_dialog_run (dialog);
	     gtk_widget_destroy (dialog);

  	     g_object_unref (image_stream);
  	     image_stream = NULL;
	     
  	     load_timeout = 0;
	     
  	     return FALSE; % uninstall the timeout
	  }

	try (err)
	  () = gdk_pixbuf_loader_write (pixbuf_loader, buf);
	% () = gdk_pixbuf_loader_write (pixbuf_loader, buf, bytes_read);
	% () = gdk_pixbuf_loader_write (pixbuf_loader, array_to_bstring (buf));	  
	catch ApplicationError:	
  	  {
  	     dialog = gtk_message_dialog_new (window,
  					      GTK_DIALOG_DESTROY_WITH_PARENT,
  					      GTK_MESSAGE_ERROR,
  					      GTK_BUTTONS_CLOSE,
  					      err.object.message);

	     gtk_dialog_run (dialog);
	     gtk_widget_destroy (dialog);
	     
  	     g_object_unref (image_stream);
  	     image_stream = NULL;
	     
  	     load_timeout = 0;
	     
  	     return FALSE; % uninstall the timeout
  	  }

	if (bytes_read == 0)
	% if (length (buf) == 0)
  	  {
	     % Errors can happen on close, e.g. if the image
	     % file was truncated we'll know on close that
	     % it was incomplete.
  	     % ifnot (g_input_stream_close (image_stream, ))
	     try (err)
	       () = g_input_stream_close (image_stream, );
	     catch ApplicationError:
  	       {
		  dialog = gtk_message_dialog_new (window,
  						   GTK_DIALOG_DESTROY_WITH_PARENT,
  						   GTK_MESSAGE_ERROR,
  						   GTK_BUTTONS_CLOSE,
  						   err.object.message);
	     
		  gtk_dialog_run (dialog);
		  gtk_widget_destroy (dialog);
		  
  		  g_object_unref (image_stream);
  		  image_stream = NULL;
  		  g_object_unref (pixbuf_loader);
  		  pixbuf_loader = NULL;
		  
  		  load_timeout = 0;
		  
  		  return FALSE; % uninstall the timeout
  	       }
	     
	     g_object_unref (image_stream);
  	     image_stream = NULL;
	     
	     % Errors can happen on close, e.g. if the image
	     % file was truncated we'll know on close that
	     % it was incomplete.
	     
  	     % ifnot (gdk_pixbuf_loader_close (pixbuf_loader))
	     try (err)
	       () = gdk_pixbuf_loader_close (pixbuf_loader);
	     catch ApplicationError:
	       {
  		  dialog = gtk_message_dialog_new (window,
  						   GTK_DIALOG_DESTROY_WITH_PARENT,
  						   GTK_MESSAGE_ERROR,
  						   GTK_BUTTONS_CLOSE,
						   err.object.message):

		  gtk_dialog_run (dialog);
		  gtk_widget_destroy (dialog);
		  
		  g_object_unref (pixbuf_loader);
  		  pixbuf_loader = NULL;
		  
  		  load_timeout = 0;

  		  return FALSE; % uninstall the timeout
  	       }
	     
  	     g_object_unref (pixbuf_loader);
  	     pixbuf_loader = NULL;
  	  }
     }
   else
     {
	try (err)
	  image_stream = g_resources_open_stream ("/images/alphatest.png", 0);
	catch ApplicationError:
	% if (image_stream == NULL)
  	  {  	     
  	     dialog = gtk_message_dialog_new (window,
  					      GTK_DIALOG_DESTROY_WITH_PARENT,
  					      GTK_MESSAGE_ERROR,
  					      GTK_BUTTONS_CLOSE,
  					      err.object.message);
	     
	     gtk_dialog_run (dialog);
	     gtk_widget_destroy (dialog);
	     
  	     load_timeout = 0;
	     
  	     return FALSE; % uninstall the timeout
  	  }

  	if (pixbuf_loader != NULL)
  	  {
  	     () = gdk_pixbuf_loader_close (pixbuf_loader);
  	     g_object_unref (pixbuf_loader);
  	  }

  	pixbuf_loader = gdk_pixbuf_loader_new ();

  	() = g_signal_connect (pixbuf_loader, "area-prepared", &progressive_prepared_callback, image);

  	() = g_signal_connect (pixbuf_loader, "area-updated", &progressive_updated_callback, image);
     }
   
   % leave timeout installed
   return TRUE;
}

define start_progressive_loading (image)
{
   % This is obviously totally contrived (we slow down loading
   % on purpose to show how incremental loading works).
   % The real purpose of incremental loading is the case where
   % you are reading data from a slow source such as the network.
   % The timeout simply simulates a slow data source by inserting
   % pauses in the reading process.

   % load_timeout = gdk_threads_add_timeout (150, progressive_timeout, image);
   load_timeout = g_timeout_add (150, &progressive_timeout, image);
   g_source_set_name_by_id (load_timeout, "[gtk+] progressive_timeout");
}

define cleanup_callback (wdg)
{
   if (load_timeout)
     {
	g_source_remove (load_timeout);
	load_timeout = 0;
     }
   
   if (pixbuf_loader != NULL)
     {
	gdk_pixbuf_loader_close (pixbuf_loader);
	g_object_unref (pixbuf_loader);
	pixbuf_loader = NULL;
     }
   
   if (image_stream != NULL)
     {
	g_object_unref (image_stream);
	image_stream = NULL;
    }
}

define toggle_sensitivity_callback (togglebutton, box)
{
   variable lst, widget;

   lst = gtk_container_get_children (box);

   foreach widget (lst)
     {
	% don't disable our toggle
	if (g_type_name_from_instance (widget) != g_type_name_from_instance (togglebutton))
	  gtk_widget_set_sensitive (widget, not gtk_toggle_button_get_active (togglebutton));
     }
}

define create_images (do_widget)
{
   variable frame, vbox, image, label, button, gicon;
   
   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_screen (window, gtk_widget_get_screen (do_widget));
   gtk_window_set_title (window, "Images");

   () = g_signal_connect (window, "destroy", &cleanup_callback);

   gtk_container_set_border_width (window, 8);

   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 8);
   gtk_container_set_border_width (vbox, 8);
   gtk_container_add (window, vbox);

   label = gtk_label_new ("");
   gtk_label_set_markup (label, "<u>Image loaded from a file</u>");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

   frame = gtk_frame_new (NULL);
   gtk_frame_set_shadow_type (frame, GTK_SHADOW_IN);
   gtk_widget_set_halign (frame, GTK_ALIGN_CENTER);
   gtk_widget_set_valign (frame, GTK_ALIGN_CENTER);
   gtk_box_pack_start (vbox, frame, FALSE, FALSE, 0);

   image = gtk_image_new_from_icon_name ("list-add", GTK_ICON_SIZE_DIALOG);

   gtk_container_add (frame, image);

   % Animation
	
   label = gtk_label_new (NULL);
   gtk_label_set_markup (label, "<u>Animation loaded from a file</u>");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);
	
   frame = gtk_frame_new (NULL);
   gtk_frame_set_shadow_type (frame, GTK_SHADOW_IN);
   gtk_widget_set_halign (frame, GTK_ALIGN_CENTER);
   gtk_widget_set_valign (frame, GTK_ALIGN_CENTER);
   gtk_box_pack_start (vbox, frame, FALSE, FALSE, 0);

   image = gtk_image_new_from_resource ("/images/floppybuddy.gif");
   % image = gtk_image_new_from_file ("images/floppybuddy.gif");

   gtk_container_add (frame, image);

   % Symbolic icon
	
   label = gtk_label_new (NULL);
   gtk_label_set_markup (label, "<u>Symbolic themed icon</u>");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);
	
   frame = gtk_frame_new (NULL);
   gtk_frame_set_shadow_type (frame, GTK_SHADOW_IN);
   gtk_widget_set_halign (frame, GTK_ALIGN_CENTER);
   gtk_widget_set_valign (frame, GTK_ALIGN_CENTER);
   gtk_box_pack_start (vbox, frame, FALSE, FALSE, 0);

   gicon = g_themed_icon_new_with_default_fallbacks ("battery-caution-charging-symbolic");
   image = gtk_image_new_from_gicon (gicon, GTK_ICON_SIZE_DIALOG);

   gtk_container_add (frame, image);
   
   % Progressive

   label = gtk_label_new (NULL);
   gtk_label_set_markup (label, "<u>Progressive image loading</u>");
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

   frame = gtk_frame_new (NULL);
   gtk_frame_set_shadow_type (frame, GTK_SHADOW_IN);
   gtk_widget_set_halign (frame, GTK_ALIGN_CENTER);
   gtk_widget_set_valign (frame, GTK_ALIGN_CENTER);
   gtk_box_pack_start (vbox, frame, FALSE, FALSE, 0);
   
   % Create an empty image for now; the progressive loader
   % will create the pixbuf and fill it in.
   
   image = gtk_image_new_from_pixbuf (NULL);
   gtk_container_add (frame, image);
   
   start_progressive_loading (image);
   
   % Sensitivity control
   button = gtk_toggle_button_new_with_mnemonic ("_Insensitive");
   gtk_box_pack_start (vbox, button, FALSE, FALSE, 0);
   
   () = g_signal_connect (button, "toggled", &toggle_sensitivity_callback, vbox);

   ifnot (gtk_widget_get_visible (window))
     gtk_widget_show_all (window);
   else
     gtk_widget_destroy (window);
   
   return window;
}
