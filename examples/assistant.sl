% Assistant
%
% Demonstrates a sample multi-step assistant. Assistants are used to divide
% an operation into several simpler sequential steps, and to guide the user
% through these steps.
%

define apply_changes_gradually (assistant, progress_bar)
{
   variable fraction;

   % Work, work, work...
   fraction = gtk_progress_bar_get_fraction (progress_bar);
   fraction += 0.05;

   if (fraction < 1.0)
     {
	gtk_progress_bar_set_fraction (progress_bar, fraction);
	return G_SOURCE_CONTINUE;
     }
   else
     {
	% Close automatically once changes are fully applied.
	gtk_widget_destroy (assistant);
	% assistant = NULL;
	return G_SOURCE_REMOVE;
     }
}

define on_assistant_apply (assistant, progress_bar)
{
   % Start a timer to simulate changes taking a few seconds to apply.
   () = g_timeout_add (100, &apply_changes_gradually, assistant, progress_bar);
}

define on_assistant_close_cancel (widget)
{
   gtk_widget_destroy (widget);
}

define on_assistant_prepare (widget, page)
{
   variable current_page, n_pages, title;

   current_page = gtk_assistant_get_current_page (widget);
   n_pages = gtk_assistant_get_n_pages (widget);

   title = sprintf ("Sample assistant (%d of %d)", current_page + 1, n_pages);
   gtk_window_set_title (widget, title);

   % The fourth page (counting from zero) is the progress page.  The
   % user clicked Apply to get here so we tell the assistant to commit,
   % which means the changes up to this poare permanent and cannot
   % be cancelled or revisited. */
   if (current_page == 3)
     gtk_assistant_commit (widget);
}

define on_entry_changed (widget, assistant)
{
   variable current_page, page_number, text;

   page_number = gtk_assistant_get_current_page (assistant);
   current_page = gtk_assistant_get_nth_page (assistant, page_number);
   text = gtk_entry_get_text (widget);

   if (text != "")
     gtk_assistant_set_page_complete (assistant, current_page, TRUE);
   else
     gtk_assistant_set_page_complete (assistant, current_page, FALSE);
}

define create_page1 (assistant)
{
   variable box, label, entry;

   box = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 12);
   gtk_container_set_border_width ( (box), 12);
   
   label = gtk_label_new ("You must fill out this entry to continue:");
   gtk_box_pack_start ((box), label, FALSE, FALSE, 0);

   entry = gtk_entry_new ();
   gtk_entry_set_activates_default (entry, TRUE);
   gtk_widget_set_valign (entry, GTK_ALIGN_CENTER);
   gtk_box_pack_start (box, entry, TRUE, TRUE, 0);
   () = g_signal_connect (entry, "changed", &on_entry_changed, assistant);

   gtk_widget_show_all (box);
   gtk_assistant_append_page (assistant, box);
   gtk_assistant_set_page_title (assistant, box, "Page 1");
   gtk_assistant_set_page_type (assistant, box, GTK_ASSISTANT_PAGE_INTRO);
}

define create_page2 (assistant)
{
   variable box, checkbutton;

   box = gtk_box_new (GTK_ORIENTATION_VERTICAL, 12);
   gtk_container_set_border_width ( (box), 12);

   checkbutton = gtk_check_button_new_with_label ("This is optional data, you may continue even if you do not check this");
   gtk_box_pack_start (box, checkbutton, FALSE, FALSE, 0);

   gtk_widget_show_all (box);
   gtk_assistant_append_page (assistant, box);
   gtk_assistant_set_page_complete (assistant, box, TRUE);
   gtk_assistant_set_page_title (assistant, box, "Page 2");
}

define create_page3 (assistant)
{
   variable label;

   label = gtk_label_new ("This is a confirmation page, press 'Apply' to apply changes");

   gtk_widget_show (label);
   gtk_assistant_append_page (assistant, label);
   gtk_assistant_set_page_type (assistant, label, GTK_ASSISTANT_PAGE_CONFIRM);
   gtk_assistant_set_page_complete (assistant, label, TRUE);
   gtk_assistant_set_page_title (assistant, label, "Confirmation");
}

define create_page4 (assistant, progress_bar)
{  
   gtk_widget_set_halign (progress_bar, GTK_ALIGN_CENTER);
   gtk_widget_set_valign (progress_bar, GTK_ALIGN_CENTER);
   gtk_widget_show (progress_bar);
   % variable n = gtk_assistant_get_current_page (assistant);
   % variable page = gtk_assistant_get_nth_page (n);
   gtk_assistant_append_page (assistant, progress_bar);
   gtk_assistant_set_page_type (assistant, progress_bar, GTK_ASSISTANT_PAGE_PROGRESS);
   gtk_assistant_set_page_title (assistant, progress_bar, "Applying changes");
   
   % This prevents the assistant window from being
   % closed while we're "busy" applying changes.
   gtk_assistant_set_page_complete (assistant, progress_bar, FALSE);
}

define create_assistant (do_widget)
{
   variable assistant, progress_bar;
   
   assistant = gtk_assistant_new ();
   progress_bar = gtk_progress_bar_new ();
   
   gtk_window_set_default_size (assistant, -1, 300);
   
   gtk_window_set_screen (assistant, gtk_widget_get_screen (do_widget));
   
   create_page1 (assistant);
   create_page2 (assistant);
   create_page3 (assistant);
   create_page4 (assistant, progress_bar);
   
   () = g_signal_connect (assistant, "cancel", &on_assistant_close_cancel);
   () = g_signal_connect (assistant, "close", &on_assistant_close_cancel);
   () = g_signal_connect (assistant, "apply", &on_assistant_apply, progress_bar);
   () = g_signal_connect (assistant, "prepare", &on_assistant_prepare);
   
   ifnot (gtk_widget_get_visible (assistant))
     gtk_widget_show (assistant);
   else
    {
       gtk_widget_destroy (assistant);
       assistant = NULL;
    }

  return assistant;
}
