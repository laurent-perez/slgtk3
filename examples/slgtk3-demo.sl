#!/usr/bin/env slsh

_debug_info = 1;
_traceback  = 1;
_slangtrace = 1;

require ("gtk3");

variable resource = g_resource_load ("demo.gresource");

variable demos = {
   {"Application Class", ""},
   {"Assistant", "assistant"},
   {"Benchmark", ""}, % (fishbowl)
   {"Builder", "builder"},   
   {"Button Boxes", "buttonbox"},
   {"Change Display", ""},
   {"Clipboard", "clipboard"},
   {"Color Chooser", "colorsel"},
   {"Combo Boxes", "combobox"},
   {"Cursors", "cursors"},
   {"Dialog and Message Boxes", "dialog"},
   {"Drawing Area", "drawingarea"},
   {"Entry",
	{"Entry Buffer", "entry_buffer",
	     "Entry Completion", "entry_completion",
#ifeval _gtk3_version >= 30600
	     "Search Entry", "search_entry",
	     "Delayed Search Entry", "search_entry_delayed",
#endif
	}},
   {"Expander", "expander"},
#ifeval _gtk3_version >= 31200
   {"Flowbox", "flowbox"},
#endif
   {"Foreign Drawing", ""}, % foreigndrawing
#ifeval _gtk3_version >= 31400
   {"Gestures", "gestures"},
#endif		      
#ifeval _gtk3_version >= 30404
   {"Header Bar", "headerbar"},
#endif
   {"Icon View",
	{"Icon View Basic", "iconview",
	     "Editing and Drag-and-Drop", "iconview_edit"
	}},   
   {"Images", "images"},
   {"Info Bar", "infobar"},
   {"Links", "links"},
   {"List Box", ""}, % listbox.sl (low level)
   {"Menus", "menus"},
   {"Model Button", "modelbutton"},
   {"Offscreen Windows",
	{"Rotated Button", "",
	     "Effects", ""
	}},
   {"OpenGL Area", ""},
   {"Overlay",
	{"Interactive Overlay", "overlay",
	     "Decorative Overlay", "overlay_2",
	     "Transparency", "transparent"
	}},
   {"Paint", ""},
   {"Paned Widgets", "panes"},
   {"Pango",
	{"Rotated Text", "rotated_text",
	     "Text Mask", "textmask",
	     "Font Features", "" % needs harfbuzz (font_features.sl)
	}},
   {"Pickers", "pickers"},
#ifeval _gtk3_version >= 30800
   {"Pixbufs", "pixbufs"},
#endif
   {"Popovers", "popover"},
   {"Printing",
	{"Printing", "printing",
	     "Page Setup", "pagesetup"}},
   {"Revealer", "revealer"},
   {"Scale", "scale"},
   {"Shortcuts Window", "shortcuts"},
   {"Size Groups", "sizegroup"},
   {"Spin Button", "spinbutton"},
   {"Spinner", "spinner"},
   {"Stack", "stack"},
   {"Stack Sidebar", "sidebar"},
   {"Text View",	
	{"Hypertext", "hypertext",
	     "Markup", "markup",
	     "Tabs", "tabs",
	     "Multiple Views", "textview",
	     "Automatic Scrolling", "textscroll",
	}},
   {"Theming",
	{"CSS Accordion", "css_accordion",
	     "CSS Basics", "css_basics",
	     "CSS Blend Modes", "css_blendmodes",
	     "Multiple Backgrounds", "css_multiplebgs",
	     "Animated Backgrounds", "css_pixbufs",
	     "Shadows", "css_shadows",
	     "Style Classes", "theming_style_classes"
	}},
   {"Tool Palette", ""},
   {"Touch and Drawing Tablets", ""}, % event_axes.sl
   {"Tree View",
	{"Editable Cells", "editable_cells",
	     "Filter Model", "filtermodel",
	     "List Store", "list_store",
	     "Tree Store", "tree_store"
	}}
};

define launch_demo (tv, path, col)
{
   variable model, iter, name, demo, fun, main_win, demo_win, err;

   model = gtk_tree_view_get_model (tv);
   iter = gtk_tree_model_get_iter (model, path);
   if (iter != NULL)
     {
	name = gtk_tree_model_get (model, iter, 1);
	if (name == "")
	  message ("Not implemented yet.");
	else if (name != NULL)
	  {
	     demo = "./" + name + ".sl";	     
	     try (err)
	       {		  
		  () = evalfile (demo);
	       }	     
	     catch AnyError:
	       {
		  vmessage ("Can't launch : %s", demo);
		  vmessage ("%s : %s", err.descr, err.message);
		  return;
	       }
	     vmessage ("Launch : %s", demo);
	     fun = sprintf ("create_%s", name);
	     main_win = gtk_widget_get_toplevel (tv);
	     demo_win = (@__get_reference (fun)) (main_win);
	     if (demo_win != NULL)
	       {		  
		  if (gtk_widget_is_toplevel (demo_win))
		    {		  
		       gtk_window_set_transient_for (demo_win, main_win);
		       gtk_window_set_modal (demo_win, TRUE);
		    }
	       }
	  }
     }
}

private define do_exit (widget, window)
{
   gtk_widget_destroy (window);
   gtk_main_quit ();
}

define create_main_win ()
{   
   variable win, vbox, sw, tv, model, iter, renderer, col, name, scripts, demo;
   variable buffer, label;

   g_resources_register (resource);
   
   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_window_set_title (win, "SLgtk3 demo");
   gtk_container_set_border_width (win, 10);
   gtk_widget_set_size_request (win, 300, 400);
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
   gtk_container_add (win, vbox);

   variable vers = strtok (_gtk3_module_version_string, ".");
   buffer = sprintf ("SLgtk3 %s.%s.%s", vers [0], vers [1], vers [2]);
   label = gtk_label_new (buffer);
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

   buffer = _slang_version_string;
   if (strlen (buffer) > 12)
     buffer = buffer [[:12]];
   buffer = sprintf ("S-Lang %s", buffer);
   label = gtk_label_new (buffer);
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

   buffer = sprintf ("GTK %d.%d.%d", gtk_get_major_version,
		     gtk_get_minor_version, gtk_get_micro_version);
   label = gtk_label_new (buffer);
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

   sw = gtk_scrolled_window_new (,);
   gtk_box_pack_start (vbox, sw, TRUE, TRUE, 0);
   gtk_scrolled_window_set_policy (sw, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);

   model = gtk_tree_store_new ([G_TYPE_STRING, G_TYPE_STRING]);
   tv = gtk_tree_view_new_with_model (model);
   % gtk_tree_view_set_level_indentation (tv, 10);
   % gtk_tree_view_set_show_expanders (tv, 1);
   % gtk_scrolled_window_add_with_viewport (sw, tv);
   gtk_container_add (sw, tv);
   % gtk_tree_view_set_rules_hint (tv, TRUE);   

   renderer = gtk_cell_renderer_text_new ();
   col = gtk_tree_view_column_new_with_attributes ("Demo", renderer, "text", 0);
   () = gtk_tree_view_append_column (tv, col);

   foreach demo (demos)
     {
	name = list_pop (demo);
	scripts = list_pop (demo);	
	if (typeof (scripts) == List_Type)
	  {
	     iter = gtk_tree_store_append (model,, 0, name);
	     loop (length (scripts) / 2)
	       () = gtk_tree_store_append (model, iter, 0, list_pop (scripts), 1, list_pop (scripts));
	  }
	else
	  () = gtk_tree_store_append (model,, 0, name, 1, scripts);
     }

   gtk_tree_view_expand_all (tv);

   variable hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 10);
   gtk_container_set_border_width (hbox, 10);
   gtk_box_pack_start (vbox, hbox, FALSE, TRUE, 0);

   variable button = gtk_button_new_with_label ("Close");
   () = g_signal_connect (button, "clicked", &do_exit, win);
   gtk_box_pack_start (hbox, button, TRUE, TRUE, 0);
   gtk_widget_grab_focus (button);

   gtk_widget_show_all (win);
   
   () = g_signal_connect (win, "destroy", &gtk_main_quit);
   () = g_signal_connect (tv, "row-activated", &launch_demo);
}

define slsh_main ()
{
   create_main_win ();

   gtk_main ();
}
