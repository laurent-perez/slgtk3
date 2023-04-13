% SC.debug = 1;

slirp_define_opaque ("GtkOpaque"); % This definition must remain first

% gdk
slirp_map_opaque ("GdkEventSequence*");

% gdk_pixbuf
slirp_map_opaque ("GdkPixbufFormat*");

% gio
slirp_map_opaque ("GAction*");
slirp_map_opaque ("GActionEntry*");
slirp_map_opaque ("GActionGroup*");
slirp_map_opaque ("GActionMap*");
slirp_map_opaque ("GAppInfo*");
slirp_map_opaque ("GAsyncResult*");
slirp_map_opaque ("GCancellable*");
slirp_map_opaque ("GDrive*");
slirp_map_opaque ("GEmblem*");
slirp_map_opaque ("GFile*");
slirp_map_opaque ("GFileAttributeInfoList*"); % boxed type
slirp_map_opaque ("GFileAttributeMatcher*");
slirp_map_opaque ("GFileInputStream*");
slirp_map_opaque ("GFileIOStream*");
slirp_map_opaque ("GFileOutputStream*");
slirp_map_opaque ("GIcon*");
slirp_map_opaque ("GInetAddressMask*");
slirp_map_opaque ("GInetSocketAddress*");
slirp_map_opaque ("GMount*");
slirp_map_opaque ("GNetworkAddress*");
slirp_map_opaque ("GNetworkMonitor*");
slirp_map_opaque ("GNetworkService*");
slirp_map_opaque ("GNotification*");
slirp_map_opaque ("GProxyAddress*");
slirp_map_opaque ("GProxyResolver*");
slirp_map_opaque ("GResolver*");
slirp_map_opaque ("GResource*");
slirp_map_opaque ("GSeekable*");
slirp_map_opaque ("GSettings*");
slirp_map_opaque ("GSettingsBackend*");
slirp_map_opaque ("GSettingsSchema*");
slirp_map_opaque ("GSettingsSchemaKey*");
slirp_map_opaque ("GSettingsSchemaSource*");
slirp_map_opaque ("GSimpleAction*");
slirp_map_opaque ("GSocketAddress*");
slirp_map_opaque ("GSocketConnectable*");
slirp_map_opaque ("GVfs*");
slirp_map_opaque ("GVolume*");
slirp_map_opaque ("GZlibCompressorFormat*");
slirp_map_opaque ("GZlibDecompressor*");

% glib
slirp_map_opaque ("gpointer");
slirp_map_opaque ("gconstpointer");
slirp_map_opaque ("GDir*");
slirp_map_opaque ("GIConv");
slirp_map_opaque ("GList");
slirp_map_opaque ("GPollFD*");
slirp_map_opaque ("GSList");
% slirp_map_opaque ("GStrvBuilder");

% gobject
slirp_map_opaque ("GBinding*");
slirp_map_opaque ("GClosure*");
% slirp_map_opaque ("GEnumClass*");
% slirp_map_opaque ("GFlagsClass*");
slirp_map_opaque ("GParamSpec*");
slirp_map_opaque ("GParamSpecPool*");
% slirp_map_opaque ("GSignalGroup*");
slirp_map_opaque ("GSimpleActionGroup*");
slirp_map_opaque ("GValue*");
slirp_map_opaque ("GTypeClass*");
slirp_map_opaque ("GTypeInstance*");
slirp_map_opaque ("GTypePlugin*");

% gtk (Boxed Types)
slirp_map_opaque ("GtkCssSection*");
slirp_map_opaque ("GtkIconSet*");

% pango
slirp_map_opaque ("PangoAttribute*");
slirp_map_opaque ("PangoAttrShape*");
slirp_map_opaque ("PangoCairoFontMap*");
slirp_map_opaque ("PangoContext*");
slirp_map_opaque ("PangoFont*");
slirp_map_opaque ("PangoFontDescription*");
slirp_map_opaque ("PangoFontFace*");
slirp_map_opaque ("PangoFontFamily*");
slirp_map_opaque ("PangoFontMap*");
slirp_map_opaque ("PangoLanguage*");
slirp_map_opaque ("PangoLayout*");
slirp_map_opaque ("PangoLayoutRun*");
slirp_map_opaque ("PangoRenderer*");

% glib
slirp_define_opaque ("GBookmarkFile", "GtkOpaque", "g_bookmark_file_free");
slirp_define_opaque ("GBytes", "GtkOpaque", "g_bytes_unref");
slirp_define_opaque ("GChecksum", "GtkOpaque", "g_checksum_free");
slirp_define_opaque ("GDate", "GtkOpaque", "g_date_free");
slirp_define_opaque ("GDateTime", "GtkOpaque", "g_date_time_unref");
slirp_define_opaque ("GDir", "GtkOpaque", "g_dir_close");
slirp_define_opaque ("GHmac", "GtkOpaque", "g_hmac_unref");
slirp_define_opaque ("GIOChannel", "GtkOpaque", "g_io_channel_unref");
slirp_define_opaque ("GKeyFile", "GtkOpaque", "g_key_file_unref");
slirp_define_opaque ("GMainContext", "GtkOpaque", "g_main_context_unref");
slirp_define_opaque ("GMainLoop", "GtkOpaque", "g_main_loop_unref");
slirp_define_opaque ("GMatchInfo", "GtkOpaque", "g_match_info_unref");
slirp_define_opaque ("GRegex", "GtkOpaque", "g_regex_unref");
slirp_define_opaque ("GSource", "GtkOpaque", "g_source_unref");
slirp_define_opaque ("GMappedFile", "GtkOpaque", "g_mapped_file_unref");
slirp_define_opaque ("GRand", "GtkOpaque", "g_rand_free");
slirp_define_opaque ("GTimer", "GtkOpaque", "g_timer_destroy");
slirp_define_opaque ("GTimeZone", "GtkOpaque", "g_time_zone_unref");
slirp_define_opaque ("GVariant", "GtkOpaque", "g_variant_unref");
slirp_define_opaque ("GVariantBuilder", "GtkOpaque", "g_variant_builder_unref");
slirp_define_opaque ("GVariantType", "GtkOpaque", "g_variant_type_free");

% slirp_define_opaque ("GObject", "GtkOpaque", "g_object_unref");
slirp_define_opaque ("GObject", "GtkOpaque");

% gio
slirp_map_opaque ("GAppInfoMonitor*");
slirp_map_opaque ("GAppLaunchContext*");
slirp_map_opaque ("GBytesIcon*");
slirp_map_opaque ("GCharsetConverter*");
slirp_map_opaque ("GCredentials*");
slirp_map_opaque ("GEmblem*");
slirp_map_opaque ("GEmblemedIcon*");
slirp_map_opaque ("GFileIcon*");
slirp_map_opaque ("GFileInfo*");
slirp_map_opaque ("GFileMonitor*");
slirp_map_opaque ("GFilenameCompleter*");
slirp_map_opaque ("GInetAddress*");
slirp_map_opaque ("GInputStream*");
slirp_map_opaque ("GIOStream*");
slirp_map_opaque ("GMenu*");
slirp_map_opaque ("GMenuAttributeIter*");
slirp_map_opaque ("GMenuItem*");
slirp_map_opaque ("GMenuLinkIter*");
slirp_map_opaque ("GMenuModel*");
slirp_map_opaque ("GMountOperation*");
slirp_map_opaque ("GOutputStream*");
slirp_map_opaque ("GPermission*");
slirp_map_opaque ("GSimpleProxyResolver*");
slirp_map_opaque ("GSocket*");
slirp_map_opaque ("GThemedIcon*");
slirp_map_opaque ("GVolumeMonitor*");

% gdk
slirp_map_opaque ("GdkAtom");
slirp_map_opaque ("GdkAppLaunchContext*");
slirp_map_opaque ("GdkCursor*");
slirp_map_opaque ("GdkDevice*");
slirp_map_opaque ("GdkDeviceManager*");
slirp_map_opaque ("GdkDevicePad*");
slirp_map_opaque ("GdkDeviceTool*");
slirp_map_opaque ("GdkDisplay*");
slirp_map_opaque ("GdkDisplayManager*");
slirp_map_opaque ("GdkDragContext*");
slirp_map_opaque ("GdkDrawingContext*");
slirp_map_opaque ("GdkEventKey*");
slirp_map_opaque ("GdkFrameClock*");
slirp_map_opaque ("GdkFrameTimings*");
slirp_map_opaque ("GdkGLContext*");
slirp_map_opaque ("GdkKeymap*");
slirp_map_opaque ("GdkMonitor*");
slirp_map_opaque ("GdkScreen*");
slirp_map_opaque ("GdkSeat*");
slirp_map_opaque ("GdkVisual*");
slirp_map_opaque ("GdkWindow*");

% gtk
slirp_map_opaque ("AtkObject*");
slirp_map_opaque ("GtkAccelGroup*");
slirp_map_opaque ("GtkAccelMap*");
slirp_map_opaque ("GtkAccessible*");
slirp_map_opaque ("GtkActionable*");
slirp_map_opaque ("GtkAdjustment*");
slirp_map_opaque ("GtkAppChooser*");
slirp_map_opaque ("GtkApplication*");
slirp_map_opaque ("GtkBuildable*");
slirp_map_opaque ("GtkBuilder*");
slirp_map_opaque ("GtkCellArea*");
slirp_map_opaque ("GtkCellAreaBox*");
slirp_map_opaque ("GtkCellAreaContext*");
slirp_map_opaque ("GtkCellEditable*");
slirp_map_opaque ("GtkCellLayout*");
slirp_map_opaque ("GtkCellRenderer*");
slirp_map_opaque ("GtkCellRendererAccel*");
slirp_map_opaque ("GtkCellRendererCombo*");
slirp_map_opaque ("GtkCellRendererPixbuf*");
slirp_map_opaque ("GtkCellRendererProgress*");
slirp_map_opaque ("GtkCellRendererSpin*");
slirp_map_opaque ("GtkCellRendererSpinner*");
slirp_map_opaque ("GtkCellRendererText*");
slirp_map_opaque ("GtkCellRendererToggle*");
slirp_map_opaque ("GtkClipboard*");
slirp_map_opaque ("GtkColorChooser*");
slirp_map_opaque ("GtkCssProvider*");
slirp_map_opaque ("GtkEditable*");
slirp_map_opaque ("GtkEntryBuffer*");
slirp_map_opaque ("GtkEntryCompletion*");
slirp_map_opaque ("GtkEventController*");
slirp_map_opaque ("GtkFileChooser*");
slirp_map_opaque ("GtkFileFilter*");
slirp_map_opaque ("GtkFileFilterInfo*");
slirp_map_opaque ("GtkFontChooser*");
slirp_map_opaque ("GtkGesture*");
slirp_map_opaque ("GtkGestureDrag*");
slirp_map_opaque ("GtkGestureLongPress*");
slirp_map_opaque ("GtkGestureMultiPress*");
slirp_map_opaque ("GtkGesturePan*");
slirp_map_opaque ("GtkGestureRotate*");
slirp_map_opaque ("GtkGestureSingle*");
slirp_map_opaque ("GtkGestureSwipe*");
slirp_map_opaque ("GtkGestureZoom*");
slirp_map_opaque ("GtkIMContext*");
slirp_map_opaque ("GtkIMContextSimple*");
slirp_map_opaque ("GtkIMMulticontext*");
slirp_map_opaque ("GtkIconInfo*");
slirp_map_opaque ("GtkIconSource*");
slirp_map_opaque ("GtkIconTheme*");
slirp_map_opaque ("GtkListStore*");
slirp_map_opaque ("GtkMountOperation*");
slirp_map_opaque ("GtkOrientable*");
slirp_map_opaque ("GtkPadController*");
slirp_map_opaque ("GtkPageSetup*");
slirp_map_opaque ("GtkPrintBackend*");
slirp_map_opaque ("GtkPrintContext*");
slirp_map_opaque ("GtkPrintJob*");
slirp_map_opaque ("GtkPrintOperation*");
slirp_map_opaque ("GtkPrintOperationPreview*");
slirp_map_opaque ("GtkPrintSettings*");
slirp_map_opaque ("GtkPrinter*");
slirp_map_opaque ("GtkRcStyle*");
slirp_map_opaque ("GtkRecentChooser*");
slirp_map_opaque ("GtkRecentFilter*");
slirp_map_opaque ("GtkRecentFilterInfo*");
slirp_map_opaque ("GtkRecentInfo*");
slirp_map_opaque ("GtkRecentManager*");
slirp_map_opaque ("GtkRequestedSize*");
slirp_map_opaque ("GtkScrollable*");
slirp_map_opaque ("GtkSettings*");
slirp_map_opaque ("GtkSizeGroup*");
slirp_map_opaque ("GtkStyle*");
slirp_map_opaque ("GtkStyleContext*");
slirp_map_opaque ("GtkStyleProperties*");
slirp_map_opaque ("GtkStyleProvider*");
slirp_map_opaque ("GtkTargetEntry*");
slirp_map_opaque ("GtkTextBuffer*");
slirp_map_opaque ("GtkTextChildAnchor*");
slirp_map_opaque ("GtkTextMark*");
slirp_map_opaque ("GtkTextTag*");
slirp_map_opaque ("GtkTextTagTable*");
slirp_map_opaque ("GtkToolShell*");
slirp_map_opaque ("GtkTooltip*");
slirp_map_opaque ("GtkTreeDragDest*");
slirp_map_opaque ("GtkTreeDragSource*");
slirp_map_opaque ("GtkTreeModel*");
slirp_map_opaque ("GtkTreeModelFilter*");
slirp_map_opaque ("GtkTreeModelSort*");
slirp_map_opaque ("GtkTreeSelection*");
slirp_map_opaque ("GtkTreeSortable*");
slirp_map_opaque ("GtkTreeStore*");
slirp_map_opaque ("GtkWindowGroup*");

% gdk_pixbuf

% slirp_map_opaque ("GdkPixbuf*");
slirp_map_opaque ("GdkPixbufAnimation*");
slirp_map_opaque ("GdkPixbufAnimationIter*");
slirp_map_opaque ("GdkPixbufLoader*");
slirp_map_opaque ("GdkPixbufSimpleAnim*");
% slirp_define_opaque ("GdkPixbuf", "GObject", "g_object_unref");
slirp_define_opaque ("GdkPixbuf", "GObject", "NULL");

% slirp_define_opaque ("GdkDevice", "GObject", "g_object_unref");
slirp_define_opaque ("GdkDevice", "GObject");

slirp_define_opaque ("GtkWidget", "GObject");
slirp_map_opaque ("GtkAboutDialog*");
slirp_map_opaque ("GtkAccelLabel*");
slirp_map_opaque ("GtkActionBar*");
slirp_map_opaque ("GtkAppChooserButton*");
slirp_map_opaque ("GtkAppChooserDialog*");
slirp_map_opaque ("GtkAppChooserWidget*");
slirp_map_opaque ("GtkApplicationWindow*");
slirp_map_opaque ("GtkAspectFrame*");
slirp_map_opaque ("GtkAssistant*");
slirp_map_opaque ("GtkBin*");
slirp_map_opaque ("GtkBox*");
slirp_map_opaque ("GtkButton*");
slirp_map_opaque ("GtkButtonBox*");
slirp_map_opaque ("GtkCalendar*");
slirp_map_opaque ("GtkCellView*");
slirp_map_opaque ("GtkCheckButton*");
slirp_map_opaque ("GtkCheckMenuItem*");
slirp_map_opaque ("GtkColorButton*");
slirp_map_opaque ("GtkColorChooserDialog*");
slirp_map_opaque ("GtkColorChooserWidget*");
slirp_map_opaque ("GtkComboBox*");
slirp_map_opaque ("GtkComboBoxText*");
slirp_map_opaque ("GtkContainer*");
slirp_map_opaque ("GtkDialog*");
slirp_map_opaque ("GtkDrawingArea*");
slirp_map_opaque ("GtkEntry*");
slirp_map_opaque ("GtkEventBox*");
slirp_map_opaque ("GtkExpander*");
slirp_map_opaque ("GtkFileChooserButton*");
slirp_map_opaque ("GtkFileChooserDialog*");
slirp_map_opaque ("GtkFileChooserNative*");
slirp_map_opaque ("GtkFileChooserWidget*");
slirp_map_opaque ("GtkFixed*");
slirp_map_opaque ("GtkFlowBox*");
slirp_map_opaque ("GtkFlowBoxChild*");
slirp_map_opaque ("GtkFontButton*");
slirp_map_opaque ("GtkFontChooserDialog*");
slirp_map_opaque ("GtkFontChooserWidget*");
slirp_map_opaque ("GtkFrame*");
slirp_map_opaque ("GtkGLArea*");
slirp_map_opaque ("GtkGrid*");
slirp_map_opaque ("GtkHeaderBar*");
slirp_map_opaque ("GtkIconView*");
slirp_map_opaque ("GtkImage*");
slirp_map_opaque ("GtkInfoBar*");
slirp_map_opaque ("GtkInvisible*");
slirp_map_opaque ("GtkLabel*");
slirp_map_opaque ("GtkLayout*");
slirp_map_opaque ("GtkLevelBar*");
slirp_map_opaque ("GtkLinkButton*");
slirp_map_opaque ("GtkListBox*");
slirp_map_opaque ("GtkListBoxRow*");
slirp_map_opaque ("GtkLockButton*");
slirp_map_opaque ("GtkMenu*");
slirp_map_opaque ("GtkMenuBar*");
slirp_map_opaque ("GtkMenuButton*");
slirp_map_opaque ("GtkMenuItem*");
slirp_map_opaque ("GtkMenuShell*");
slirp_map_opaque ("GtkMenuToolButton*");
slirp_map_opaque ("GtkMessageDialog*");
slirp_map_opaque ("GtkNativeDialog*");
slirp_map_opaque ("GtkNotebook*");
slirp_map_opaque ("GtkOffscreenWindow*");
slirp_map_opaque ("GtkOverlay*");
slirp_map_opaque ("GtkPageSetupUnixDialog*");
slirp_map_opaque ("GtkPaned*");
slirp_map_opaque ("GtkPlacesSidebar*");
slirp_map_opaque ("GtkPlug*");
slirp_map_opaque ("GtkPopover*");
slirp_map_opaque ("GtkPopoverMenu*");
slirp_map_opaque ("GtkPrintUnixDialog*");
slirp_map_opaque ("GtkProgressBar*");
slirp_map_opaque ("GtkRadioButton*");
slirp_map_opaque ("GtkRadioMenuItem*");
slirp_map_opaque ("GtkRadioToolButton*");
slirp_map_opaque ("GtkRange*");
slirp_map_opaque ("GtkRecentChooserDialog*");
slirp_map_opaque ("GtkRecentChooserMenu*");
slirp_map_opaque ("GtkRecentChooserWidget*");
slirp_map_opaque ("GtkRevealer*");
slirp_map_opaque ("GtkScale*");
slirp_map_opaque ("GtkScaleButton*");
slirp_map_opaque ("GtkScrollbar*");
slirp_map_opaque ("GtkScrolledWindow*");
slirp_map_opaque ("GtkSearchBar*");
slirp_map_opaque ("GtkSearchEntry*");
slirp_map_opaque ("GtkSeparator*");
slirp_map_opaque ("GtkSeparatorMenuItem*");
slirp_map_opaque ("GtkSeparatorToolItem*");
slirp_map_opaque ("GtkShortcutLabel*");
slirp_map_opaque ("GtkShortcutsWindow*");
slirp_map_opaque ("GtkSocket*");
slirp_map_opaque ("GtkSpinButton*");
slirp_map_opaque ("GtkSpinner*");
slirp_map_opaque ("GtkStack*");
slirp_map_opaque ("GtkStackSidebar*");
slirp_map_opaque ("GtkStackSwitcher*");
slirp_map_opaque ("GtkStatusbar*");
slirp_map_opaque ("GtkSwitch*");
slirp_map_opaque ("GtkTextView*");
slirp_map_opaque ("GtkToggleButton*");
slirp_map_opaque ("GtkToggleToolButton*");
slirp_map_opaque ("GtkToolButton*");
slirp_map_opaque ("GtkToolItem*");
slirp_map_opaque ("GtkToolItemGroup*");
slirp_map_opaque ("GtkToolPalette*");
slirp_map_opaque ("GtkToolbar*");
slirp_map_opaque ("GtkTreeView*");
slirp_map_opaque ("GtkTreeViewColumn*");
slirp_map_opaque ("GtkViewport*");
slirp_map_opaque ("GtkVolumeButton*");
slirp_map_opaque ("GtkWindow*");

% gdk
slirp_define_opaque ("GdkEvent", "GtkOpaque", "gdk_event_free");
% #ifeval _gtk3_version >= 30800
slirp_define_opaque ("GdkFrameTimings", "GtkOpaque", "gdk_frame_timings_unref");
% #endif

% gtk
slirp_define_opaque ("GtkPaperSize", "GtkOpaque", "gtk_paper_size_free");
slirp_define_opaque ("GtkSelectionData", "GtkOpaque", "gtk_selection_data_free");
slirp_define_opaque ("GtkTargetList", "GtkOpaque", "gtk_target_list_unref");
slirp_define_opaque ("GtkTextAttributes", "GtkOpaque", "gtk_text_attributes_unref");
% slirp_define_opaque ("GtkTextAttributes", "GtkOpaque", "NULL");
slirp_define_opaque ("GtkTextIter", "GtkOpaque", "gtk_text_iter_free");
slirp_define_opaque ("GtkTreeIter", "GtkOpaque", "gtk_tree_iter_free");
% slirp_define_opaque ("GtkTreeIter", "GtkOpaque", "NULL");
% slirp_define_opaque ("GtkTreePath","GtkOpaque","gtk_tree_path_free");
slirp_define_opaque ("GtkTreePath","GtkOpaque","NULL");
slirp_define_opaque ("GtkTreeRowReference", "GtkOpaque", "gtk_tree_row_reference_free");
slirp_define_opaque ("GtkWidgetPath", "GtkOpaque", "gtk_widget_path_unref");

% pango
% slirp_define_opaque ("PangoAttrList","GtkOpaque", "pango_attr_list_unref");
slirp_define_opaque ("PangoAttrList","GtkOpaque", "NULL");
slirp_define_opaque ("PangoCoverage","GtkOpaque", "pango_coverage_unref");
slirp_define_opaque ("PangoFontMetrics","GtkOpaque", "pango_font_metrics_unref");
slirp_define_opaque ("PangoGlyphString", "GtkOpaque", "pango_glyph_string_free");
slirp_define_opaque ("PangoItem", "GtkOpaque", "pango_item_free");
slirp_define_opaque ("PangoLayoutIter", "GtkOpaque", "pango_layout_iter_free");
slirp_define_opaque ("PangoLayoutLine","GtkOpaque", "pango_layout_line_unref");
slirp_define_opaque ("PangoScriptIter", "GtkOpaque", "pango_script_iter_free");
slirp_define_opaque ("PangoTabArray", "GtkOpaque", "pango_tab_array_free");

slirp_map_char ("gchar");		% Strictly speaking these mappings
slirp_map_uchar ("guchar");		% are not required, as SLIRP would
slirp_map_string ("gchar*");		% generate them automatically from
slirp_map_ushort ("gshort");		% gtypes.h and glibconfig.h, but
slirp_map_ushort ("gushort");		% presently those files are not
slirp_map_int ("gint");			% included during code generation.
slirp_map_uint ("guint");
slirp_map_long ("glong");
slirp_map_long ("gssize");
slirp_map_ulong ("gsize");
slirp_map_ulong ("gulong");
slirp_map_float ("gfloat");
slirp_map_double ("gdouble");
slirp_map_int ("gboolean");

slirp_map_int64 ("gint64");
slirp_map_int32 ("gint32");
slirp_map_uint32 ("guint32");
slirp_map_uint64 ("guint64");
slirp_map_char ("gint8");
slirp_map_ref ("gint8*");
slirp_map_uchar ("guint8");
slirp_map_uint16 ("guint16");
slirp_map_int16 ("gint16");
slirp_map_uint32 ("GQuark");
slirp_map_uint16 ("gunichar2");
slirp_map_uint32 ("gunichar");

slirp_map_ulong ("time_t");

slirp_map_struct ("GdkColor*");
slirp_map_struct ("GdkGeometry*");
slirp_map_struct ("GdkKeymapKey*");
slirp_map_struct ("GdkPoint*");
slirp_map_struct ("GdkRectangle*");
slirp_map_struct ("GdkRGBA*");
slirp_map_struct ("GdkKeymapKey*");
% slirp_map_struct ("GEnumValue*");
% slirp_map_struct ("GFlagsValue*");
slirp_map_struct ("GtkAllocation*"); % An instance of GdkRectangle
slirp_map_struct ("GtkBorder*");
slirp_map_struct ("GtkRequisition*");

slirp_map_struct ("GTimeVal*");

slirp_map_struct ("PangoRectangle*");
slirp_map_struct ("PangoColor*");

slirp_map_int ("GApplicationFlags");
slirp_map_int ("GChecksumType");
slirp_map_int ("GKeyFileFlags");
slirp_map_int ("GMountMountFlags");
slirp_map_int ("GResourceLookupFlags");

slirp_map_int ("GdkAxisUse");
slirp_map_int ("GdkByteOrder");
slirp_map_uint ("GdkModifierType");
slirp_map_int ("GdkScrollDirection");
slirp_map_int ("GdkVisualType");
slirp_map_int ("GPid");
slirp_map_int64 ("goffset");
slirp_map_ulong ("GType");
slirp_map_ulong ("GtkType");

slirp_map_int ("GtkCellRendererState");
slirp_map_int ("GtkDialogFlags");
slirp_map_int ("GtkIconSize");
slirp_map_int ("GtkPolicyType");
slirp_map_int ("GtkTextSearchFlags");

slirp_map_int ("PangoGravity");
slirp_map_int ("PangoGravityHint");
slirp_map_int ("PangoScript");
slirp_map_int ("PangoStyle");
slirp_map_int ("PangoVariant");
slirp_map_int ("PangoWeight");
slirp_map_int ("PangoStretch");

% cairo interaction
slirp_define_opaque ("Cairo", "void_ptr");
slirp_map_opaque ("cairo_t*");
slirp_define_opaque ("CairoFontOption", "void_ptr");
slirp_map_opaque ("cairo_font_options_t*");
slirp_define_opaque ("CairoPattern", "void_ptr");
slirp_map_opaque ("cairo_pattern_t*");
slirp_define_opaque ("CairoRegion", "void_ptr");
slirp_map_opaque ("cairo_region_t*");
slirp_define_opaque ("CairoSurface", "void_ptr");
slirp_map_opaque ("cairo_surface_t*");
slirp_map_int ("cairo_content_t");
slirp_map_int ("cairo_format_t");

% }}}

% NULL arg acceptors % {{{
% howto find those functions ?
% search for "allow-none" in sources or "nullable" in docs
% "gir" files from GObject instrospection should probably be used to automate that
accepts_null_args ["g_environ_setenv"] = [1];
accepts_null_args ["g_filename_to_uri"] = [2];
accepts_null_args ["g_input_stream_close"] = [2];
accepts_null_args ["g_input_stream_skip"] = [3];
accepts_null_args ["g_key_file_get_comment"] = [2,3];
accepts_null_args ["g_key_file_get_locale_string"] = [4];
accepts_null_args ["g_key_file_get_locale_for_key"] = [4];
accepts_null_args ["g_key_file_get_locale_string_list"] = [4];
accepts_null_args ["g_key_file_set_comment"] = [2,3];
accepts_null_args ["g_key_file_remove_comment"] = [2,3];
accepts_null_args ["g_list_append"] = [1];
accepts_null_args ["g_main_loop_new"] = [1];
accepts_null_args ["g_resolver_lookup_by_name"] = [3];
accepts_null_args ["g_simple_action_new"] = [2];
accepts_null_args ["g_simple_action_new_stateful"] = [2,3];
accepts_null_args ["g_ucs4_to_utf16"] = [3,4];
accepts_null_args ["g_ucs4_to_utf8"] = [3,4];
accepts_null_args ["g_uri_escape_string"] = [2];
accepts_null_args ["g_uri_unescape_string"] = [2];
accepts_null_args ["g_uri_unescape_segment"] = [1,2,3];
accepts_null_args ["g_utf8_to_utf16"] = [3,4];
accepts_null_args ["g_utf8_to_ucs4"] = [3,4];
accepts_null_args ["g_utf8_to_ucs4_fast"] = [3];
accepts_null_args ["g_utf16_to_ucs4"] = [3,4];
accepts_null_args ["g_utf16_to_utf8"] = [3,4];
accepts_null_args ["gdk_cairo_surface_create_from_pixbuf"] = [3];
accepts_null_args ["gdk_device_get_position"] = [2];
accepts_null_args ["gdk_device_get_position_double"] = [2];
accepts_null_args ["gdk_draw_pixbuf"] = [2];
accepts_null_args ["gdk_pixbuf_get_from_drawable"] = [1,3];
accepts_null_args ["gdk_pixbuf_animation_get_iter"] = [2];
accepts_null_args ["gdk_pixbuf_animation_iter_advance"] = [2];
accepts_null_args ["gdk_window_set_icon"] = [2,3,4];
accepts_null_args ["gdk_window_set_back_pixmap"] = [2];
accepts_null_args ["gtk_menu_item_set_submenu"] = [2];
accepts_null_args ["gtk_about_dialog_set_version"] = [2];
accepts_null_args ["gtk_about_dialog_set_copyright"] = [2];
accepts_null_args ["gtk_about_dialog_set_comments"] = [2];
accepts_null_args ["gtk_about_dialog_set_license"] = [2];
accepts_null_args ["gtk_about_dialog_set_website"] = [2];
accepts_null_args ["gtk_about_dialog_set_translator_credits"] = [2];
accepts_null_args ["gtk_about_dialog_set_logo"] = [2];
accepts_null_args ["gtk_about_dialog_set_logo_icon_name"] = [2];
accepts_null_args ["gtk_accel_group_disconnect"] = [2];
accepts_null_args ["gtk_accelerator_get_label_with_keycode"] = [1];
accepts_null_args ["gtk_action_bar_set_center_widget"] = [2];
accepts_null_args ["gtk_app_chooser_dialog_new"] = [1];
accepts_null_args ["gtk_app_chooser_dialog_new_for_content_type"] = [1];
accepts_null_args ["gtk_application_new"] = [1];
accepts_null_args ["gtk_application_add_accelerator"] = [4];
accepts_null_args ["gtk_application_remove_accelerator"] = [3];
accepts_null_args ["gtk_application_set_app_menu"] = [2];
accepts_null_args ["gtk_application_set_menubar"] = [2];
accepts_null_args ["gtk_application_inhibit"] = [2,4];
accepts_null_args ["gtk_aspect_frame_new"] = [1];
accepts_null_args ["gtk_assistant_set_page_header_image"] = [3];
accepts_null_args ["gtk_assistant_set_page_side_image"] = [3];
accepts_null_args ["gtk_box_set_center_widget"] = [2];
accepts_null_args ["gtk_buildable_add_child"] = [4];
accepts_null_args ["gtk_builder_set_translation_domain"] = [2];
accepts_null_args ["gtk_cell_editable_start_editing"] = [2];
accepts_null_args ["gtk_cell_view_set_model"] = [2];
accepts_null_args ["gtk_cell_view_set_displayed_row"] = [2];
accepts_null_args ["gtk_color_chooser_dialog_new"] = [1,2];
accepts_null_args ["gtk_combo_box_set_active_iter"] = [2];
accepts_null_args ["gtk_combo_box_set_model"] = [2];
accepts_null_args ["gtk_combo_box_set_active_id"] = [2];
accepts_null_args ["gtk_combo_box_text_append"] = [2];
accepts_null_args ["gtk_combo_box_text_prepend"] = [2];
accepts_null_args ["gtk_combo_box_text_insert"] = [3];
accepts_null_args ["gtk_container_set_focus_child"] = [2];
accepts_null_args ["gtk_expander_new"] = [1];
accepts_null_args ["gtk_expander_new_with_mnemonic"] = [1];
accepts_null_args ["gtk_font_chooser_dialog_new"] = [1,2];
accepts_null_args ["gtk_frame_new"] = [1];
accepts_null_args ["gtk_icon_theme_list_icons"] = [2];
% accepts_null_args ["gtk_icon_view_get_cell_rect"] = [3];
accepts_null_args ["gtk_image_new_from_pixbuf"] = [1];
accepts_null_args ["gtk_item_factory_new"] = [3];
accepts_null_args ["gtk_layout_new"] = [1,2];
accepts_null_args ["gtk_label_new"] = [1];
accepts_null_args ["gtk_menu_popup_at_pointer"] = [2];
accepts_null_args ["gtk_menu_popup_at_rect"] = [6];
accepts_null_args ["gtk_menu_popup_at_widget"] = [5];
accepts_null_args ["gtk_menu_set_accel_path"] = [2];
accepts_null_args ["gtk_menu_set_screen"] = [2];
accepts_null_args ["gtk_menu_set_title"] = [2];
accepts_null_args ["gtk_mount_operation_new"] = [1];
accepts_null_args ["gtk_mount_operation_set_parent"] = [2];
accepts_null_args ["gtk_notebook_append_page"] = [3];
accepts_null_args ["gtk_notebook_append_page_menu"] = [3,4];
accepts_null_args ["gtk_notebook_prepend_page"] = [3];
accepts_null_args ["gtk_notebook_prepend_page_menu"] = [3,4];
accepts_null_args ["gtk_notebook_insert_page"] = [3];
accepts_null_args ["gtk_notebook_insert_page_menu"] = [3,4];
accepts_null_args ["gtk_notebook_set_menu_label"] = [3];
accepts_null_args ["gtk_notebook_set_tab_label"] = [3];
accepts_null_args ["gtk_notebook_set_group_name"] = [2];
accepts_null_args ["gtk_message_dialog_new"] = [1,5];
accepts_null_args ["gtk_message_dialog_new_with_markup"] = [1,5];
accepts_null_args ["gtk_page_setup_unix_dialog_new"] = [1,2];
accepts_null_args ["gtk_print_operation_run"] = [3];
accepts_null_args ["gtk_progress_bar_new_with_adjustment"] = [1];
accepts_null_args ["gtk_radio_button_new"] = [1];
accepts_null_args ["gtk_radio_button_new_with_label"] = [1];
accepts_null_args ["gtk_radio_button_new_from_widget"] = [1];
accepts_null_args ["gtk_radio_button_new_with_label_from_widget"] = [1];
accepts_null_args ["gtk_radio_button_new_with_mnemonic"] = [1];
accepts_null_args ["gtk_radio_button_new_with_mnemonic_from_widget"] = [1];
accepts_null_args ["gtk_radio_menu_item_join_group"] = [2];
accepts_null_args ["gtk_radio_menu_item_new"] = [1];
accepts_null_args ["gtk_radio_menu_item_new_with_label"] = [1];
accepts_null_args ["gtk_radio_menu_item_new_with_label_from_widget"] = [1,2];
accepts_null_args ["gtk_radio_menu_item_new_with_mnemonic"] = [1];
accepts_null_args ["gtk_radio_menu_item_new_with_mnemonic_from_widget"] = [1,2];
accepts_null_args ["gtk_radio_tool_button_new"] = [1];
accepts_null_args ["gtk_radio_tool_button_new_from_stock"] = [1];
accepts_null_args ["gtk_scale_new"] = [2];
accepts_null_args ["gtk_scrollbar_new"] = [2];
accepts_null_args ["gtk_scrolled_window_new"] = [1,2];
accepts_null_args ["gtk_spin_button_new"] = [1];
accepts_null_args ["gtk_text_buffer_new"] = [1];
accepts_null_args ["gtk_text_buffer_create_mark"] = [2];
accepts_null_args ["gtk_text_iter_backward_search"] = [6];
accepts_null_args ["gtk_text_iter_forward_search"] = [6];
accepts_null_args ["gtk_text_view_new_with_buffer"] = [1];
accepts_null_args ["gtk_toggle_action_new"] = [2,3,4];
accepts_null_args ["gtk_tool_button_new"] = [1,2];
accepts_null_args ["gtk_tree_model_iter_children"] = [3];
accepts_null_args ["gtk_tree_model_iter_n_children"] = [2];
accepts_null_args ["gtk_tree_model_iter_nth_child"] = [3];
accepts_null_args ["gtk_tree_model_rows_reordered"] = [3];
accepts_null_args ["gtk_toolbar_append_widget"] = [4];
accepts_null_args ["gtk_tree_view_new_with_model"] = [1];
accepts_null_args ["gtk_tree_view_set_expander_column"] = [2];
accepts_null_args ["gtk_viewport_new"] = [1,2];
accepts_null_args ["gtk_vscale_new"] = [1];
accepts_null_args ["gtk_vscrollbar_new"] = [1];
accepts_null_args ["gtk_scale_button_new"] = [5];
accepts_null_args ["gtk_list_store_insert_after"] = [3];
accepts_null_args ["gtk_list_store_insert_before"] = [3];
accepts_null_args ["gtk_list_store_move_after"] = [3];
accepts_null_args ["gtk_list_store_move_before"] = [3];
accepts_null_args ["gtk_tree_model_filter_new"] = [2];
accepts_null_args ["gtk_tree_store_insert_after"] = [3,4];
accepts_null_args ["gtk_tree_store_insert_before"] = [3,4];
accepts_null_args ["gtk_tree_store_move_after"] = [3];
accepts_null_args ["gtk_tree_store_move_before"] = [3];
accepts_null_args ["gtk_widget_create_pango_layout"] = [2];
accepts_null_args ["gtk_widget_modify_fg"] = [3];
accepts_null_args ["gtk_widget_modify_bg"] = [3];
accepts_null_args ["gtk_widget_modify_text"] = [3];
accepts_null_args ["gtk_widget_modify_base"] = [3];
accepts_null_args ["gtk_widget_modify_cursor"] = [2,3];
accepts_null_args ["gtk_widget_override_background_color"] = [3];
accepts_null_args ["gtk_widget_override_color"] = [3];
accepts_null_args ["gtk_widget_override_font"] = [2];
accepts_null_args ["gtk_widget_override_symbolic_color"] = [3];
accepts_null_args ["gtk_widget_override_cursor"] = [2,3];
accepts_null_args ["pango_context_get_metrics"] = [2,3];
accepts_null_args ["pango_itemize"] = [6];
accepts_null_args ["pango_itemize_with_base_dir"] = [7];
accepts_null_args ["pango_context_set_matrix"] = [2];
accepts_null_args ["pango_default_break"] = [3];
accepts_null_args ["pango_shape_full"] = [3];
accepts_null_args ["pango_parse_markup"] = [4,5,6,7];
accepts_null_args ["pango_markup_parser_finish"] = [2,3,4,5];
% accepts_null_args [""] = [];
% }}}

% Some functions are passed structures to be filled.
% In S-Lang, filled structures are pushed on the stack
% returns_struct [""] = [];
% returns_struct ["g_date_time_to_timeval"] = [2];
% returns_struct ["g_get_current_time"] = [1];
% returns_struct ["g_source_get_current_time"] = [2];
% returns_struct ["g_time_val_from_iso8601"] = [2];
% returns_struct ["gdk_cairo_get_clip_rectangle"] = [2];
returns_struct ["gdk_monitor_get_geometry"] = [2];
returns_struct ["gdk_monitor_get_workarea"] = [2];
% returns_struct ["gdk_rgba_parse"] = [1];
returns_struct ["gdk_screen_get_monitor_geometry"] = [3];
returns_struct ["gdk_screen_get_monitor_workarea"] = [3];
returns_struct ["gdk_window_get_frame_extents"] = [2];
returns_struct ["gtk_cell_area_get_cell_allocation"] = [6];
returns_struct ["gtk_cell_area_get_cell_at_position"] = [7];
returns_struct ["gtk_cell_area_inner_cell_area"] = [4];
returns_struct ["gtk_cell_renderer_get_aligned_area"] = [5];
returns_struct ["gtk_cell_renderer_get_preferred_size"] = [3,4];
returns_struct ["gtk_color_button_get_color"] = [2];
returns_struct ["gtk_color_button_get_rgba"] = [2];
returns_struct ["gtk_color_chooser_get_rgba"] = [2];
returns_struct ["gtk_entry_get_icon_area"] = [3];
returns_struct ["gtk_entry_get_text_area"] = [2];
returns_struct ["gtk_gesture_get_bounding_box"] = [2];
returns_struct ["gtk_gesture_multi_press_get_area"] = [2];
% returns_struct ["gtk_icon_info_get_embedded_rect"] = [2];
% returns_struct ["gtk_icon_view_get_cell_rect"] = [4]; 
returns_struct ["gtk_popover_get_pointing_to"] = [2];
returns_struct ["gtk_range_get_range_rect"] = [2];
returns_struct ["gtk_render_background_get_clip"] = [6];
% returns_struct ["gtk_scrollable_get_border"] = [2];
returns_struct ["gtk_style_context_get_color"] = [3];
returns_struct ["gtk_style_context_get_background_color"] = [3];
returns_struct ["gtk_style_context_get_border"] = [3];
returns_struct ["gtk_style_context_get_border_color"] = [3];
returns_struct ["gtk_style_context_lookup_color"] = [3];
returns_struct ["gtk_style_context_get_padding"] = [3];
returns_struct ["gtk_style_context_get_margin"] = [3];
returns_struct ["gtk_text_view_get_visible_rect"] = [2];
returns_struct ["gtk_text_view_get_cursor_locations"] = [3,4];
returns_struct ["gtk_text_view_get_iter_location"] = [3];
returns_struct ["gtk_tree_view_get_cell_area"] = [4];
returns_struct ["gtk_tree_view_get_background_area"] = [4];
returns_struct ["gtk_tree_view_get_visible_rect"] = [2];
returns_struct ["gtk_widget_get_preferred_size"] = [2,3];
returns_struct ["gtk_widget_intersect"] = [3];
returns_struct ["gtk_widget_get_allocated_size"] = [2];
returns_struct ["gtk_widget_get_allocation"] = [2];
returns_struct ["gtk_widget_get_clip"] = [2];
returns_struct ["gtk_widget_get_preferred_size"] = [2,3];
returns_struct ["gtk_window_get_resize_grip_area"] = [2];

#ignore
% gdk

gdk_cairo_get_clip_rectangle

gdk_color_parse				% coded manually, to deal with odd API
					% (wants GdkColor* reference)
gdk_color_free				% need to think about this more; to
gdk_color_copy				% see why, comment out and rerun CG

gdk_cursor_ref % deprecated for g_object_ref
gdk_cursor_unref % deprecated for g_object_unref

gdk_device_get_state
gdk_device_get_axis_value
gdk_device_get_history
gdk_device_free_history
gdk_device_list_axes

gdk_display_store_clipboard

gdk_init
gdk_init_check

gdk_keymap_get_entries_for_keyval
gdk_keymap_get_entries_for_keycode
gdk_keymap_translate_keyboard_state

gdk_parse_args

gdk_property_get

gdk_query_depths
gdk_query_visual_types

gdk_rectangle_intersect
gdk_rectangle_union

gdk_rgba_copy % GdkRGBA is a slang struct -> color2 = @color1
gdk_rgba_free
gdk_rgba_parse % coded manually

gdk_screen_list_visuals
gdk_screen_get_toplevel_windows
gdk_screen_get_setting
gdk_screen_get_window_stack

gdk_selection_property_get

gdk_text_property_to_utf8_list_for_display

% gdk-pixbuf

gdk_pixbuf_animation_new_from_stream_async
gdk_pixbuf_animation_iter_get_pixbuf    % returned pixbuf must not be refcounted
     
gdk_pixbuf_get_pixels_with_length % coded manually (todo)
gdk_pixbuf_loader_write % coded manually
gdk_pixbuf_new_from_data % coded manually
gdk_pixbuf_new_from_xpm_data % coded manually
gdk_pixbuf_ref				% deprecated in favor of g_object_ref
gdk_pixbuf_unref			% deprecated in favor of g_object_unref
gdk_pixbuf_get_pixels			% coded manually
gdk_pixbuf_save % coded manually
gdk_pixbuf_save_to_callback
gdk_pixbuf_save_to_callbackv
gdk_pixbuf_save_to_buffer
gdk_pixbuf_save_to_bufferv
gdk_pixbuf_new_from_stream
gdk_pixbuf_new_from_stream_async
gdk_pixbuf_new_from_stream_finish
gdk_pixbuf_new_from_stream_at_scale
gdk_pixbuf_new_from_stream_at_scale_async
gdk_pixbuf_save_to_stream
gdk_pixbuf_save_to_stream_async
gdk_pixbuf_save_to_stream_finish
gdk_pixbuf_saturate_and_pixelate % coded manually (todo)
     
% glib

g_action_map_add_action_entries % coded manually

g_build_filename			% coded manually
g_build_filenamev			% coded manually
g_build_path				% coded manually
g_build_pathv				% coded manually
g_build_filename_valist

% g_bookmark_file_get_uris % coded manually
% g_bookmark_file_get_groups % coded manually
% g_bookmark_file_get_applications % coded manually
g_bookmark_file_get_icon

g_checksum_get_digest % coded manually
g_compute_checksum_for_bytes

g_date_set_time				% deprecated since version 2.10
g_date_strftime				% coded manually
g_date_to_struct_tm			% coded manually     

g_convert
g_convert_with_fallback
g_convert_with_iconv

g_environ_setenv % coded manually
g_environ_unsetenv % coded manually

g_key_file_get_boolean_list % coded manually
g_key_file_get_double_list % coded manually
g_key_file_get_integer_list % coded manually

g_locale_to_utf8
g_locale_from_utf8
g_filename_to_utf8
g_filename_from_utf8     
g_get_filename_charsets
g_get_charset
g_get_current_time

g_input_stream_read
g_input_stream_read_all
g_input_stream_read_all_async
g_input_stream_read_all_finish
g_input_stream_read_async
g_input_stream_read_finish
g_input_stream_skip_async
g_input_stream_skip_finish
g_input_stream_close_async
g_input_stream_close_finish
g_input_stream_read_bytes
g_input_stream_read_bytes_async
g_input_stream_read_bytes_finish

g_io_channel_read_chars
g_io_channel_read_unichar
g_io_channel_read_line
g_io_channel_read_line_string
g_io_channel_read_to_end
g_io_channel_write_chars
g_io_channel_write_unichar
g_io_add_watch
g_io_add_watch_full
g_io_channel_get_line_term
g_io_channel_set_line_term     
     
g_list_remove_link
g_list_free_1
g_list_alloc
     
g_main_context_find_source_by_id
g_main_context_find_source_by_user_data
g_main_context_find_source_by_funcs_user_data
g_main_context_wait
g_main_context_query
g_main_context_check
g_main_context_set_poll_func
g_main_context_get_poll_func

g_mapped_file_free % ??? slirp parsing error

g_option_context_parse
g_option_context_parse_strv

g_settings_backend_flatten_tree

g_settings_schema_source_list_schemas

g_shell_parse_argv

g_source_get_current_time
g_source_set_callback
g_source_set_funcs
g_source_set_callback_indirect
g_source_remove_by_user_data
g_source_remove_by_funcs_user_data

g_str_tokenize_and_fold

g_timeout_add_full
g_timeout_add
g_timeout_add_seconds_full
g_timeout_add_seconds
g_child_watch_add_full
g_child_watch_add
g_idle_add
g_idle_add_full
g_idle_remove_by_data
g_main_context_invoke_full
g_main_context_invoke     
     
g_time_val_add                 		% coded manually
g_time_val_from_iso8601                 % coded manually

g_time_zone_adjust_time
     
% g_timer_elapsed

g_unichar_to_utf8 % coded manually

g_variant_new_tuple

g_parse_debug_string
g_snprintf
g_vsnprintf
g_nullify_pointer
g_format_size_for_display
g_atexit
GVoidFunc
GFreeFunc
g_qsort_with_data

g_variant_type_new_tuple
g_variant_new_array

% gobject
 
g_object_set_qdata_full
g_object_set_data			% coded manually
g_object_get_data			% coded manually
g_object_set_data_full
g_object_set
g_object_set_property
g_object_get
g_object_get_property
% g_object_unref
g_cclosure_new_object
g_cclosure_new_object_swap
g_value_set_object
g_signal_connect_object
g_signal_emitv     
g_object_force_floating
g_object_run_dispose
g_value_set_object_take_ownership
g_object_compat_control
g_object_class_list_properties

g_param_spec_set_qdata			% coded manually
g_param_spec_get_qdata			% coded manually
g_param_spec_steal_qdata		% coded manually     
g_param_spec_set_qdata_full

g_signal_newv     
g_signal_new
g_signal_new_valist
g_signal_new_class_handler
g_signal_set_va_marshaller
g_signal_emit_valist
g_signal_emit
g_signal_emit_by_name
g_signal_query
g_signal_list_ids
g_signal_parse_name
g_signal_get_invocation_hint
g_signal_add_emission_hook
g_signal_connect_data
g_signal_handler_find
g_signal_handlers_block_matched
g_signal_handlers_unblock_matched
g_signal_handlers_disconnect_matched
g_signal_override_class_closure
g_signal_override_class_handler
g_signal_chain_from_overridden
g_signal_chain_from_overridden_handler     

g_type_value_table_peek			% See above for comments on type system
g_type_add_class_cache_func
g_type_remove_class_cache_func
g_type_class_unref
g_type_class_unref_uncached
g_type_class_ref
g_type_class_peek
g_type_class_peek_parent
g_type_interface_peek
g_type_interface_peek_parent
g_type_get_qdata
g_type_set_qdata
g_type_children	
g_type_interfaces
g_type_interface_prerequisites
_g_type_debug_flags
     
% gtk

gtk_accelerator_parse_with_keycode

gtk_accel_label_get_accel

gtk_assistant_set_forward_page_func

gtk_buildable_custom_tag_start
gtk_buildable_custom_tag_end
gtk_buildable_custom_finished
gtk_buildable_set_buildable_property

gtk_builder_add_callback_symbol
gtk_builder_add_callback_symbols
gtk_builder_lookup_callback_symbol
gtk_builder_get_objects			% coded manually
gtk_builder_value_from_string
gtk_builder_value_from_string_type
gtk_builder_connect_signals		% to be coded manually
gtk_builder_connect_signals_full

gtk_cell_layout_set_attributes     	% coded manually
gtk_cell_layout_set_cell_data_func
_gtk_cell_layout_buildable_custom_tag_start
_gtk_cell_layout_buildable_custom_tag_end

gtk_cell_area_cell_get_property
gtk_cell_area_cell_set_property

gtk_cell_renderer_get_size
gtk_cell_renderer_start_editing

gtk_clipboard_request_text
gtk_clipboard_set_can_store % coded manually
gtk_clipboard_wait_for_targets

gtk_color_chooser_add_palette % to be coded
     
% gtk_combo_box_get_active_iter % coded manually
gtk_combo_box_set_row_separator_func % coded manually
     
gtk_container_foreach % var arglists not supported
gtk_container_forall % var arglists not supported
gtk_container_child_set_valist % var arglists not supported
gtk_container_child_get_valist % var arglists not supported
gtk_container_child_set % var arglists not supported
gtk_container_child_get % var arglists not supported
gtk_container_child_get_property % coded manually
gtk_container_child_set_property
gtk_container_set_focus_chain
gtk_container_get_focus_chain
% gtk_container_get_children % coded manually
% gtk_container_class_list_child_properties

gtk_dialog_new_with_buttons % var arglists not supported
gtk_dialog_add_buttons % var arglists not supported
gtk_dialog_set_alternative_button_order  % var arglists not supported

gtk_distribute_natural_allocation

gtk_drag_dest_set % coded manually
gtk_drag_source_set % coded manually

% gtk_entry_buffer_new % coded manually
gtk_entry_completion_set_match_func
gtk_entry_get_inner_border % deprecated

gtk_file_chooser_dialog_new		% coded manually
gtk_file_chooser_dialog_new_with_backend     % deprecated
     
gtk_file_filter_add_custom

gtk_flow_box_selected_foreach
gtk_flow_box_set_filter_func
gtk_flow_box_set_sort_func
gtk_flow_box_bind_model
     
gtk_font_chooser_set_filter_func

gtk_gesture_multi_press_get_area

gtk_icon_info_get_attach_points
gtk_icon_info_get_embedded_rect
gtk_icon_info_load_symbolic_async
gtk_icon_info_load_symbolic_finish
gtk_icon_info_load_symbolic_for_context_async
gtk_icon_info_load_symbolic_for_context_finish

% gtk_icon_theme_list_contexts		% coded manually
% gtk_icon_theme_list_icons		% coded manually
gtk_icon_theme_set_search_path		% coded manually     
gtk_icon_theme_get_search_path		% coded manually
gtk_icon_theme_get_icon_sizes          	% coded manually

gtk_icon_view_selected_foreach
gtk_icon_view_get_tooltip_context
gtk_icon_view_enable_model_drag_source
gtk_icon_view_enable_model_drag_dest
gtk_icon_view_get_visible_range
% gtk_icon_view_get_selected_items	% coded manually
gtk_icon_view_get_item_at_pos		% coded manually
gtk_icon_view_get_cursor		% coded manually
gtk_icon_view_get_drag_dest_item	% coded manually
gtk_icon_view_get_dest_item_at_pos	% coded manually
gtk_icon_view_get_cell_rect
gtk_icon_view_get_cursor		% coded manually
gtk_icon_view_get_drag_dest_item_at_pos % coded manually

gtk_icon_set_get_sizes

gtk_info_bar_new_with_buttons		% coded manually
gtk_info_bar_add_buttons		% coded manually

gtk_list_store_new			% coded manually
% gtk_list_store_newv			% replaced by gtk_list_store_new
gtk_list_store_set			% coded manually
gtk_list_store_set_value		% coded manually
gtk_list_store_set_valuesv		% replaced by gtk_list_store_new
gtk_list_store_set_valist
gtk_list_store_append			% coded manually
gtk_list_store_prepend			% coded manually
gtk_list_store_insert			% coded manually
% gtk_list_store_insert_before		% coded manually
% gtk_list_store_insert_after		% coded manually
gtk_list_store_insert_with_value       	% coded manually
gtk_list_store_insert_with_valuesv	% replaced by gtk_list_store_insert_with_value

% gtkmain.h     
gtk_init			% gtk_init() is called automatically by SLgtk
gtk_init_check			% module internals, so no need to wrap it
gtk_init_with_args
gtk_init_check_abi_check
gtk_init_abi_check
gtk_parse_args
gtk_key_snooper_install
gtk_main_quit				% coded by hand, for user-friendliness;
					% will automatically remove from stack
					% args registered by signal_connect

gtk_menu_popup			% coded manually, avoids use of
gtk_menu_popup_for_device		% GtkMenuFunc and other little-used
					% parameters (per Gtk docs)
% gtk_menu_get_for_attach_widget
gtk_menu_attach_to_widget		% coded manually (no support for GtkMenuDetachFunc)

% gtk_message_dialog_new			% coded manually
% gtk_message_dialog_new_with_markup
% gtk_message_dialog_format_secondary_text	% coded manually
% gtk_message_dialog_format_secondary_markup	% coded manually

% gtk_paper_size_get_paper_sizes

gtk_print_job_get_page_ranges
gtk_print_job_set_page_ranges

gtk_print_run_page_setup_dialog_async

gtk_print_settings_foreach     
gtk_print_settings_get_page_ranges % coded manually
gtk_print_settings_set_page_ranges % coded manually

gtk_recent_chooser_dialog_new % coded manually
gtk_recent_chooser_dialog_new_for_manager % coded manually     

gtk_recent_chooser_set_sort_func
% gtk_recent_chooser_get_items     
gtk_recent_chooser_get_uris     
gtk_recent_chooser_list_filters

gtk_recent_filter_add_custom

% gtk_recent_manager_get_items % coded manually
gtk_recent_info_get_application_info % coded manually

gtk_scale_button_new			% coded manually
gtk_scale_button_set_icons		% coded manually

gtk_scrollable_get_border

gtk_selection_data_get_data_with_length
gtk_selection_data_get_targets

gtk_show_about_dialog

gtk_status_icon_position_menu
gtk_status_icon_get_geometry
     
gtk_style_context_get_valist
gtk_style_context_get
gtk_style_context_state_is_running
gtk_style_context_notify_state_change
gtk_style_context_pop_animatable_region
gtk_style_context_push_animatable_region
gtk_style_context_cancel_animations
gtk_style_context_scroll_animations
gtk_style_context_set_direction
gtk_style_context_get_property
gtk_style_context_get_style_property

gtk_style_properties_get
gtk_style_properties_get_valist
gtk_style_properties_lookup_property
gtk_style_properties_register_property
gtk_style_properties_set
gtk_style_properties_set_valist
     
gtk_style_provider_get_style
gtk_style_provider_get_icon_factory     
gtk_style_provider_get_style_property
     
gtk_text_buffer_create_tag     
% gtk_text_buffer_get_iter_at_offset		% these were coded manually
% gtk_text_buffer_get_iter_at_line
% gtk_text_buffer_get_iter_at_line_index
% gtk_text_buffer_get_iter_at_line_offset
% gtk_text_buffer_get_iter_at_mark
% gtk_text_buffer_get_iter_at_child_anchor
% gtk_text_buffer_get_start_iter
% gtk_text_buffer_get_end_iter
% gtk_text_buffer_get_bounds
% gtk_text_buffer_get_selection_bounds
gtk_text_buffer_deserialize
gtk_text_buffer_get_deserialize_formats
gtk_text_buffer_get_serialize_formats
gtk_text_buffer_register_deserialize_format
gtk_text_buffer_register_serialize_format
gtk_text_buffer_insert_with_tags
gtk_text_buffer_insert_with_tags_by_name
gtk_text_buffer_serialize

gtk_text_iter_forward_find_char
gtk_text_iter_backward_find_char     
% gtk_text_iter_forward_search
% gtk_text_iter_backward_search

gtk_text_child_anchor_register_child % Don't use these
gtk_text_child_anchor_unregister_child % see gtktextlayout.h
gtk_text_child_anchor_queue_resize
gtk_text_anchored_child_set_layout

gtk_text_tag_table_foreach

gtk_text_view_get_line_at_y % coded manually
% gtk_text_view_get_iter_at_location % coded manually
% gtk_text_view_get_iter_at_position % coded manually
     
gtk_tool_palette_get_hadjustment
gtk_tool_palette_get_vadjustment

gtk_tree_iter_new			% coded manually
     
gtk_tree_path_new_from_indices % coded manually
gtk_tree_path_new_from_indicesv % replaced by gtk_tree_path_new_from_indices
gtk_tree_path_get_indices % coded manually
gtk_tree_path_get_indices_with_depth % not needed as gtk_tree_path_get_indices return an array

gtk_tree_model_get_value		% coded manually
% gtk_tree_model_get_iter			% coded manually
% gtk_tree_model_get_iter_from_string
% gtk_tree_model_get_iter_first     
gtk_tree_model_get			% coded manually
gtk_tree_model_get_valist
% gtk_tree_model_iter_nth_child
gtk_tree_model_foreach
gtk_tree_model_rows_reordered		% coded manually
gtk_tree_model_rows_reordered_with_length

% gtk_tree_model_filter_convert_iter_to_child_iter
% gtk_tree_model_filter_convert_child_iter_to_iter
gtk_tree_model_filter_set_modify_func

gtk_tree_row_reference_reordered
     
gtk_tree_selection_get_selected		% coded manually

gtk_tree_sortable_get_type % coded manually
gtk_tree_sortable_set_default_sort_func % coded manually

gtk_tree_store_new			% coded manually
gtk_tree_store_newv			% replaced by gtk_tree_store_new     
gtk_tree_store_set			% coded manually
gtk_tree_store_set_valist		% replaced by gtk_tree_store_set
gtk_tree_store_set_value     
gtk_tree_store_set_valuesv		% replaced by gtk_tree_store_set
% gtk_tree_store_set_value		% coded manually
gtk_tree_store_insert			% coded manually
% gtk_tree_store_insert_before		% coded manually
% gtk_tree_store_insert_after		% coded manually
gtk_tree_store_insert_with_values	% coded manually
gtk_tree_store_insert_with_valuesv
gtk_tree_store_append			% coded manually
gtk_tree_store_prepend			% coded manually
gtk_tree_store_reorder

gtk_tree_view_insert_column_with_attributes
gtk_tree_view_insert_column_with_data_func
gtk_tree_view_get_cursor
gtk_tree_view_get_path_at_pos
gtk_tree_view_is_blank_at_pos
gtk_tree_view_set_drag_dest_row
gtk_tree_view_get_drag_dest_row
gtk_tree_view_get_dest_row_at_pos
gtk_tree_view_create_row_drag_icon
gtk_tree_view_get_search_equal_func
gtk_tree_view_set_search_equal_func
gtk_tree_view_get_search_position_func
gtk_tree_view_set_search_position_func
gtk_tree_view_get_row_separator_func
gtk_tree_view_set_row_separator_func
gtk_tree_view_get_tooltip_context
gtk_tree_view_set_destroy_count_func
% gtk_tree_view_get_columns
gtk_tree_view_get_visible_range % coded manually

gtk_requisition_new
gtk_requisition_copy
gtk_requisition_free     

% gtk_widget_get_window			% prefer my version, which returns
   					% bin_window for GtkLayout
gtk_widget_add_tick_callback
gtk_widget_class_install_style_property_parser
gtk_widget_class_install_style_property
gtk_widget_destroy			% NULLifies the instance field
gtk_widget_destroyed
gtk_widget_get_child_requisition
gtk_widget_get_pointer % deprecated
gtk_widget_get_requisition
gtk_widget_new
gtk_widget_set_state % deprecated
gtk_widget_size_request % deprecated
gtk_widget_style_get_valist % var arglists not supported
gtk_widget_style_get
gtk_widget_style_get_property     

gtk_window_set_geometry_hints
gtk_window_set_icon_list

% pango

% to be coded manually

pango_attr_shape_new_with_data
pango_attr_iterator_get_font
pango_attr_iterator_get_attrs

pango_color_parse
pango_color_free
pango_color_to_string
pango_color_copy

pango_context_list_families

pango_coverage_to_bytes

pango_font_face_list_sizes

pango_font_family_list_faces

pango_font_map_list_families

pango_layout_get_log_attrs
pango_layout_index_to_pos
pango_layout_get_cursor_pos
pango_layout_get_extents
pango_layout_get_pixel_extents
pango_layout_get_lines
pango_layout_get_lines_readonly
pango_layout_line_get_x_ranges
pango_layout_line_get_extents
pango_layout_line_get_pixel_extents
pango_layout_iter_get_char_extents
pango_layout_iter_get_cluster_extents
pango_layout_iter_get_run_extents
pango_layout_iter_get_line_extents
pango_layout_iter_get_layout_extents     

pango_tab_array_get_tabs

pango_extents_to_pixels

pango_split_file_list
pango_trim_string
pango_read_line
pango_skip_space
pango_scan_word
pango_scan_string
pango_scan_int
pango_config_key_get_system
pango_config_key_get
pango_lookup_aliases
pango_parse_enum
pango_parse_style
pango_parse_variant
pango_parse_weight
pango_parse_stretch
pango_get_sysconf_subdirectory
pango_get_lib_subdirectory
pango_log2vis_get_embedding_levels
pango_font_get_hb_font
pango_font_find_shaper

GDK_SELECTION_CLIPBOARD

% functions that are deprecated is Gtk3.xx / Glib / Pango
% uncomment if you want some of them to be wrapped anyway

% gtk_widget_override_color
% gtk_widget_override_background_color
g_drive_eject_finish
g_file_eject_mountable_finish
g_file_unmount_mountable_finish
g_mount_eject_finish
g_mount_unmount_finish
g_volume_eject_finish
g_io_channel_close
g_io_channel_write
g_source_get_current_time
g_get_current_time
g_value_set_param_take_ownership
g_value_set_string_take_ownership
gtk_entry_set_inner_border
gtk_button_get_alignment
gtk_text_iter_begins_tag
gdk_set_double_click_time
gtk_cell_view_get_size_of_row
gtk_popover_get_transitions_enabled
gtk_color_button_get_color
gdk_screen_height
gtk_container_resize_children
gtk_adjustment_value_changed
gdk_display_open_default_libgtk_only
gtk_window_set_has_resize_grip
gdk_cursor_new
gtk_drag_source_set_icon_stock
g_settings_list_keys
gtk_color_button_new_with_color
gtk_window_set_opacity
gtk_notebook_get_tab_hborder
gdk_visual_get_bits_per_rgb
gdk_window_thaw_toplevel_updates_libgtk_only
g_variant_parser_get_error_quark
gdk_screen_get_n_monitors
gtk_menu_item_get_right_justified
gtk_radio_tool_button_new_from_stock
gtk_menu_item_set_right_justified
gtk_widget_path_iter_remove_region
gdk_screen_get_height_mm
gdk_visual_get_best_type
gdk_screen_get_monitor_width_mm
gtk_widget_path_iter_list_regions
gdk_keymap_get_default
gdk_window_begin_paint_region
gtk_file_chooser_button_get_focus_on_click
gtk_combo_box_set_focus_on_click
gtk_container_get_resize_mode
gtk_tool_button_get_stock_id
gtk_image_new_from_stock
gtk_layout_get_hadjustment
gtk_radio_tool_button_new_with_stock_from_widget
gtk_window_get_opacity
gtk_drag_begin
gtk_text_view_get_hadjustment
gdk_window_end_paint
gtk_assistant_get_page_header_image
gtk_tree_view_get_hadjustment
gtk_places_sidebar_set_show_connect_to_server
gdk_device_ungrab
gdk_screen_get_width
gdk_window_set_background_rgba
gtk_combo_box_get_title
g_settings_range_check
gtk_style_context_get_border_color
gtk_button_set_alignment
gtk_image_get_stock
gtk_application_add_accelerator
gtk_alternative_dialog_button_order
gtk_button_get_focus_on_click
gtk_window_get_resize_grip_area
gtk_toggle_tool_button_new_from_stock
gtk_menu_tool_button_new_from_stock
gtk_widget_set_margin_right
gdk_device_manager_list_devices
gdk_screen_get_monitor_scale_factor
g_date_time_new_from_timeval_utc
gdk_window_set_composited
gtk_render_frame_gap
g_bookmark_file_set_app_info
gtk_widget_get_margin_left
gdk_keyboard_ungrab
gdk_keyboard_grab
gdk_display_keyboard_ungrab
gtk_style_context_lookup_icon_set
gdk_visual_get_best_with_depth
g_settings_get_range
gtk_application_remove_accelerator
gdk_screen_get_height
gtk_widget_render_icon_pixbuf
gdk_screen_get_active_window
gtk_icon_theme_add_builtin_icon
gtk_button_set_use_stock
g_type_class_add_private
gdk_window_set_background
gtk_icon_set_render_icon_surface
gtk_color_button_set_use_alpha
gtk_container_set_resize_mode
gtk_style_context_list_regions
gtk_adjustment_changed
gtk_tree_view_set_hadjustment
gtk_widget_region_intersect
gtk_menu_get_tearoff_state
gtk_layout_get_vadjustment
gtk_icon_info_set_raw_coordinates
gtk_range_get_min_slider_size
g_bookmark_file_get_modified
gtk_combo_box_get_focus_on_click
gtk_combo_box_set_title
gtk_message_dialog_set_image
gtk_button_new_from_stock
gtk_size_group_set_ignore_hidden
gtk_layout_set_hadjustment
gtk_menu_set_tearoff_state
g_type_init
gdk_flush
gtk_font_button_set_font_name
gdk_display_get_device_manager
g_simple_action_group_remove
g_simple_action_group_insert
gtk_widget_path_iter_has_qregion
gtk_draw_insertion_cursor
gdk_window_get_composited
gdk_visual_get_best_with_type
g_binding_get_target
gtk_window_parse_geometry
gtk_combo_box_set_add_tearoffs
gtk_range_set_min_slider_size
gtk_image_set_from_stock
gtk_entry_get_icon_stock
gdk_get_display
gdk_window_freeze_toplevel_updates_libgtk_only
gtk_window_resize_to_geometry
g_notification_set_urgent
gtk_tree_view_set_rules_hint
gtk_window_get_has_resize_grip
g_memdup
g_settings_list_schemas
gtk_color_button_get_alpha
gtk_viewport_set_vadjustment
gtk_widget_path_iter_add_region
gdk_beep
g_time_zone_new
gtk_render_icon_pixbuf
gtk_widget_override_symbolic_color
gdk_visual_get_byte_order
gtk_viewport_set_hadjustment
gdk_display_supports_composite
g_bookmark_file_set_modified
gdk_display_get_window_at_pointer
g_settings_list_relocatable_schemas
gtk_menu_get_title
gdk_list_visuals
gtk_widget_pop_composite_child
gdk_screen_width_mm
gtk_size_group_get_ignore_hidden
gdk_display_list_devices
gtk_color_button_set_color
gtk_popover_set_transitions_enabled
gtk_window_set_wmclass
gdk_screen_get_monitor_height_mm
gtk_menu_set_title
gtk_dialog_get_action_area
gtk_button_set_focus_on_click
gtk_widget_set_margin_left
gtk_dialog_set_alternative_button_order_from_array
gtk_widget_get_margin_right
gtk_tree_view_get_rules_hint
gtk_style_context_get_font
gdk_screen_get_monitor_at_point
gtk_icon_info_get_builtin_pixbuf
gtk_layout_set_vadjustment
gtk_scrolled_window_add_with_viewport
gtk_key_snooper_remove
gtk_style_context_get_background_color
gtk_color_button_get_use_alpha
gtk_color_button_get_rgba
gdk_screen_get_monitor_plug_name
g_unicode_canonical_decomposition
gtk_tool_button_new_from_stock
gdk_screen_get_width_mm
gdk_device_manager_get_client_pointer
g_binding_get_source
gdk_pre_parse_libgtk_only
gdk_error_trap_pop_ignored
gtk_widget_get_state
pango_bidi_type_for_unichar
gtk_icon_info_copy
gdk_screen_get_monitor_workarea
gtk_image_get_icon_set
gdk_display_pointer_is_grabbed
gtk_widget_path_iter_clear_regions
gdk_window_enable_synchronized_configure
gtk_tree_view_set_vadjustment
gtk_icon_info_load_symbolic_for_style
gdk_device_grab
g_date_time_to_timeval
gdk_visual_get_best_with_both
gdk_screen_get_monitor_at_window
gtk_text_view_get_vadjustment
g_time_val_to_iso8601
gdk_screen_get_number
gtk_drag_dest_set_proxy
gtk_message_dialog_get_image
gdk_device_grab_info_libgtk_only
gtk_viewport_get_vadjustment
gdk_screen_make_display_name
gtk_notebook_get_tab_vborder
g_bookmark_file_get_added
gdk_window_process_all_updates
gtk_combo_box_get_add_tearoffs
gdk_display_get_screen
g_date_set_time_val
gtk_accessible_connect_widget_destroyed
gdk_cairo_set_source_color
g_bookmark_file_set_visited
gtk_tree_view_get_vadjustment
gtk_font_button_get_font_name
gtk_image_new_from_icon_set
gtk_button_get_use_stock
gtk_color_button_set_alpha
gtk_icon_info_get_display_name
gdk_window_process_updates
gtk_widget_get_double_buffered
gtk_assistant_get_page_side_image
gtk_tooltip_set_icon_from_stock
g_value_get_char
gtk_widget_override_cursor
gdk_screen_get_monitor_geometry
gtk_window_reshow_with_initial_size
g_type_init_with_debug_flags
g_simple_action_group_lookup
gtk_cell_view_set_background_color
gtk_window_resize_grip_is_visible
gtk_container_set_reallocate_redraws
gtk_assistant_set_page_header_image
gdk_screen_width
g_simple_action_group_add_entries
gdk_screen_height_mm
gtk_widget_path_iter_has_region
gtk_tool_button_set_stock_id
gtk_icon_set_render_icon_pixbuf
gtk_widget_get_composite_name
gdk_display_get_n_screens
gdk_window_set_static_gravities
gtk_viewport_get_hadjustment
gtk_widget_get_root_window
gtk_assistant_set_page_side_image
g_bookmark_file_get_app_info
gdk_window_set_debug_updates
gtk_file_chooser_button_set_focus_on_click
gtk_widget_reparent
pango_coverage_from_bytes
g_file_info_get_modification_time
gdk_window_flush
g_file_info_set_modification_time
gdk_pixbuf_new_from_inline
gtk_style_context_remove_region
gtk_style_context_has_region
gtk_style_context_set_background
g_date_time_new_from_timeval_local
gtk_places_sidebar_get_show_connect_to_server
gdk_window_begin_paint_rect
gtk_image_set_from_icon_set
gtk_window_set_default_geometry
gtk_icon_info_free
gtk_widget_override_font
gtk_entry_set_icon_from_stock
gdk_visual_get_best
gtk_color_button_set_rgba
gdk_visual_get_system
g_bookmark_file_set_added
gtk_widget_set_double_buffered
g_bookmark_file_get_visited
gdk_visual_get_colormap_size
gdk_window_configure_finished
gtk_style_context_invalidate
gdk_pointer_is_grabbed
pango_coverage_max
gtk_style_context_add_region
gdk_display_warp_pointer
gtk_widget_send_expose
gdk_screen_get_primary_monitor
gtk_style_context_get_direction
gtk_drag_set_icon_stock
gdk_visual_get_best_depth
gtk_container_unset_focus_chain
gdk_color_parse
gdk_query_depths
g_source_get_current_time
g_get_current_time
g_time_val_add
g_time_val_from_iso8601
gtk_menu_popup
g_basename
g_io_channel_read
g_io_channel_seek

% these constants are deprecated
G_REGEX_JAVASCRIPT_COMPAT
G_PARAM_PRIVATE
G_APPLICATION_FLAGS_NONE
#end

% slirp_discard_line ("");
slirp_discard_line ("G_DEFINE_AUTOPTR_CLEANUP_FUNC");
slirp_discard_line ("GDK_DEPRECATED_IN");
slirp_discard_line ("G_GNUC_BEGIN_IGNORE_DEPRECATIONS");
slirp_discard_line ("G_GNUC_END_IGNORE_DEPRECATIONS");
slirp_discard_line ("GLIB_DEPRECATED_IN");
slirp_discard_line ("GLIB_DEPRECATED_FOR");

#define G_MINSHORT SHRT_MIN
#define G_MAXSHORT SHRT_MAX
#define G_MAXUSHORT USHRT_MAX
#define G_MININT INT_MIN
#define G_MAXINT INT_MAX
#define G_MAXUINT UINT_MAX
% #define G_MINLONG LONG_MIN
% #define G_MAXLONG LONG_MAX
% #define G_MAXULONG ULONG_MAX
% #define G_MININT8	((gint8) (-G_MAXINT8 - 1))
% #define G_MAXINT8	((gint8)  0x7f)
% #define G_MAXUINT8	((guint8) 0xff)
% #define G_MININT16	((gint16) (-G_MAXINT16 - 1))
% #define G_MAXINT16	((gint16)  0x7fff)
% #define G_MAXUINT16	((guint16) 0xffff)
% #define G_MININT32	((gint32) (-G_MAXINT32 - 1))
% #define G_MAXINT32	((gint32)  0x7fffffff)
% #define G_MAXUINT32	((guint32) 0xffffffff)
% #define G_MININT64	((gint64) (-G_MAXINT64 - G_GINT64_CONSTANT(1)))
% #define G_MAXINT64	G_GINT64_CONSTANT(0x7fffffffffffffff)
% #define G_MAXUINT64	G_GUINT64_CONSTANT(0xffffffffffffffff)
#define G_MINFLOAT FLT_MIN
#define G_MAXFLOAT FLT_MAX
#define G_MINDOUBLE DBL_MIN
#define G_MAXDOUBLE DBL_MAX

% Replacement macro substitutions
#define G_BEGIN_DECLS
#define G_END_DECLS
#define G_GNUC_CONST
#define G_GNUC_NULL_TERMINATED
#define G_STMT_END
#define G_STMT_BEGIN
#define G_STMT_START
#define G_GNUC_MALLOC
#define G_GNUC_WARN_UNUSED_RESULT
#define G_GNUC_NORETURN
#define G_ANALYZER_NORETURN
#define PANGO_GLYPH_EMPTY 0x0FFFFFFF
#define PANGO_GLYPH_INVALID_INPUT 0xFFFFFFFF
#define PANGO_GLYPH_UNKNOWN_FLAG 0x10000000
#define PANGO_GET_UNKNOWN_GLYPH

#define GDK_AVAILABLE_IN_ALL
#define GDK_AVAILABLE_IN_3_2
#define GDK_AVAILABLE_IN_3_4
#define GDK_AVAILABLE_IN_3_6     
#define GDK_AVAILABLE_IN_3_8
#define GDK_AVAILABLE_IN_3_10
#define GDK_AVAILABLE_IN_3_12
#define GDK_AVAILABLE_IN_3_14
#define GDK_AVAILABLE_IN_3_16
#define GDK_AVAILABLE_IN_3_18     
#define GDK_AVAILABLE_IN_3_20
#define GDK_AVAILABLE_IN_3_22
#define GDK_AVAILABLE_IN_3_24

#define GDK_DEPRECATED_FOR

#define GDK_PIXBUF_AVAILABLE_IN_ALL
#define GDK_PIXBUF_AVAILABLE_IN_2_0
#define GDK_PIXBUF_AVAILABLE_IN_2_2
#define GDK_PIXBUF_AVAILABLE_IN_2_4
#define GDK_PIXBUF_AVAILABLE_IN_2_6
#define GDK_PIXBUF_AVAILABLE_IN_2_8
#define GDK_PIXBUF_AVAILABLE_IN_2_10
#define GDK_PIXBUF_AVAILABLE_IN_2_12
#define GDK_PIXBUF_AVAILABLE_IN_2_14
#define GDK_PIXBUF_AVAILABLE_IN_2_16
#define GDK_PIXBUF_AVAILABLE_IN_2_18
#define GDK_PIXBUF_AVAILABLE_IN_2_20
#define GDK_PIXBUF_AVAILABLE_IN_2_22
#define GDK_PIXBUF_AVAILABLE_IN_2_24
#define GDK_PIXBUF_AVAILABLE_IN_2_26
#define GDK_PIXBUF_AVAILABLE_IN_2_28
#define GDK_PIXBUF_AVAILABLE_IN_2_30
#define GDK_PIXBUF_AVAILABLE_IN_2_32
#define GDK_PIXBUF_AVAILABLE_IN_2_34    
#define GDK_PIXBUF_AVAILABLE_IN_2_36
#define GDK_PIXBUF_AVAILABLE_IN_2_38
#define GDK_PIXBUF_AVAILABLE_IN_2_40

#define GDK_PIXBUF_DEPRECATED_IN_2_2
#define GDK_PIXBUF_DEPRECATED_IN_2_4
#define GDK_PIXBUF_DEPRECATED_IN_2_6
#define GDK_PIXBUF_DEPRECATED_IN_2_8
#define GDK_PIXBUF_DEPRECATED_IN_2_10
#define GDK_PIXBUF_DEPRECATED_IN_2_12
#define GDK_PIXBUF_DEPRECATED_IN_2_14
#define GDK_PIXBUF_DEPRECATED_IN_2_16
#define GDK_PIXBUF_DEPRECATED_IN_2_18
#define GDK_PIXBUF_DEPRECATED_IN_2_20
#define GDK_PIXBUF_DEPRECATED_IN_2_22
#define GDK_PIXBUF_DEPRECATED_IN_2_24
#define GDK_PIXBUF_DEPRECATED_IN_2_26
#define GDK_PIXBUF_DEPRECATED_IN_2_28
#define GDK_PIXBUF_DEPRECATED_IN_2_30
#define GDK_PIXBUF_DEPRECATED_IN_2_32
#define GDK_PIXBUF_DEPRECATED_IN_2_34
#define GDK_PIXBUF_DEPRECATED_IN_2_36
#define GDK_PIXBUF_DEPRECATED_IN_2_38
#define GDK_PIXBUF_DEPRECATED_IN_2_40

#define GDK_PIXBUF_DEPRECATED_IN_2_0_FOR

#define GLIB_AVAILABLE_IN_ALL
#define GLIB_AVAILABLE_IN_2_26
#define GLIB_AVAILABLE_IN_2_28
#define GLIB_AVAILABLE_IN_2_30
#define GLIB_AVAILABLE_IN_2_32
#define GLIB_AVAILABLE_IN_2_34
#define GLIB_AVAILABLE_IN_2_36
#define GLIB_AVAILABLE_IN_2_38
#define GLIB_AVAILABLE_IN_2_40
#define GLIB_AVAILABLE_IN_2_42
#define GLIB_AVAILABLE_IN_2_44
#define GLIB_AVAILABLE_IN_2_46
#define GLIB_AVAILABLE_IN_2_48
#define GLIB_AVAILABLE_IN_2_50
#define GLIB_AVAILABLE_IN_2_52
#define GLIB_AVAILABLE_IN_2_54
#define GLIB_AVAILABLE_IN_2_56
#define GLIB_AVAILABLE_IN_2_58
#define GLIB_AVAILABLE_IN_2_60
#define GLIB_AVAILABLE_IN_2_62
#define GLIB_AVAILABLE_IN_2_64

#define GLIB_DEPRECATED_IN_2_26
#define GLIB_DEPRECATED_IN_2_28
#define GLIB_DEPRECATED_IN_2_30
#define GLIB_DEPRECATED_IN_2_32
#define GLIB_DEPRECATED_IN_2_34
#define GLIB_DEPRECATED_IN_2_36
#define GLIB_DEPRECATED_IN_2_38
#define GLIB_DEPRECATED_IN_2_40
#define GLIB_DEPRECATED_IN_2_42
#define GLIB_DEPRECATED_IN_2_44
#define GLIB_DEPRECATED_IN_2_46
#define GLIB_DEPRECATED_IN_2_48
#define GLIB_DEPRECATED_IN_2_50
#define GLIB_DEPRECATED_IN_2_52
#define GLIB_DEPRECATED_IN_2_54
#define GLIB_DEPRECATED_IN_2_56
#define GLIB_DEPRECATED_IN_2_58
#define GLIB_DEPRECATED_IN_2_60
#define GLIB_DEPRECATED_IN_2_62
#define GLIB_DEPRECATED_IN_2_64

% #define GLIB_DEPRECATED_MACRO_IN_2_26
#define GLIB_DEPRECATED_ENUMERATOR_IN_2_26
#define GLIB_AVAILABLE_ENUMERATOR_IN_2_74

% #define _GLIB_EXTERN
#define GLIB_VAR

#define GDK_DEPRECATED_IN_3_2
#define GDK_DEPRECATED_IN_3_4
#define GDK_DEPRECATED_IN_3_6
#define GDK_DEPRECATED_IN_3_8
#define GDK_DEPRECATED_IN_3_10
#define GDK_DEPRECATED_IN_3_12
#define GDK_DEPRECATED_IN_3_14
#define GDK_DEPRECATED_IN_3_16
#define GDK_DEPRECATED_IN_3_18
#define GDK_DEPRECATED_IN_3_20
#define GDK_DEPRECATED_IN_3_22
#define GDK_DEPRECATED_IN_3_24

#define PANGO_AVAILABLE_IN_ALL
#define PANGO_AVAILABLE_IN_1_2
#define PANGO_AVAILABLE_IN_1_4
#define PANGO_AVAILABLE_IN_1_6
#define PANGO_AVAILABLE_IN_1_8
#define PANGO_AVAILABLE_IN_1_10
#define PANGO_AVAILABLE_IN_1_12
#define PANGO_AVAILABLE_IN_1_14
#define PANGO_AVAILABLE_IN_1_16
#define PANGO_AVAILABLE_IN_1_18
#define PANGO_AVAILABLE_IN_1_20
#define PANGO_AVAILABLE_IN_1_22
#define PANGO_AVAILABLE_IN_1_24
#define PANGO_AVAILABLE_IN_1_26
#define PANGO_AVAILABLE_IN_1_28
#define PANGO_AVAILABLE_IN_1_30
#define PANGO_AVAILABLE_IN_1_32
#define PANGO_AVAILABLE_IN_1_34
#define PANGO_AVAILABLE_IN_1_36
#define PANGO_AVAILABLE_IN_1_38
#define PANGO_AVAILABLE_IN_1_40
#define PANGO_AVAILABLE_IN_1_42
#define PANGO_AVAILABLE_IN_1_44
#define PANGO_AVAILABLE_IN_1_46
#define PANGO_AVAILABLE_IN_1_48
#define PANGO_AVAILABLE_IN_1_50

#define PANGO_DEPRECATED_IN_1_2
#define PANGO_DEPRECATED_IN_1_4
#define PANGO_DEPRECATED_IN_1_6
#define PANGO_DEPRECATED_IN_1_8
#define PANGO_DEPRECATED_IN_1_10
#define PANGO_DEPRECATED_IN_1_12
#define PANGO_DEPRECATED_IN_1_14
#define PANGO_DEPRECATED_IN_1_16
#define PANGO_DEPRECATED_IN_1_18
#define PANGO_DEPRECATED_IN_1_20
#define PANGO_DEPRECATED_IN_1_22
#define PANGO_DEPRECATED_IN_1_24
#define PANGO_DEPRECATED_IN_1_26
#define PANGO_DEPRECATED_IN_1_28
#define PANGO_DEPRECATED_IN_1_30
#define PANGO_DEPRECATED_IN_1_32
#define PANGO_DEPRECATED_IN_1_34
#define PANGO_DEPRECATED_IN_1_36
#define PANGO_DEPRECATED_IN_1_38
#define PANGO_DEPRECATED_IN_1_40
#define PANGO_DEPRECATED_IN_1_42
#define PANGO_DEPRECATED_IN_1_44

#define PANGO_DEPRECATED_FOR
#define PANGO_DEPRECATED_IN_1_22_FOR
#define PANGO_DEPRECATED_IN_1_30_FOR
#define PANGO_DEPRECATED_IN_1_44_FOR
#define PANGO_DEPRECATED_IN_1_48_FOR
#define PANGO_DEPRECATED_IN_1_52_FOR

slirp_map_struct ("GError*");
slirp_map_ref ("GError**");

#argmap (in, omit) GError**
   $1 = NULL;
#end

#argmap (final) GError**
   if ($1 != NULL)
     throw_gerror($1);
#end
   
% gdk_pango_layout_line_get_clip_region
#argmap (in, which=[1,2,3,4]) PangoLayoutLine *line, gint x_origin, gint y_origin, const gint *index_ranges, gint n_ranges
   $5 = ($5_type) $4_dim0 / 2;
#end

% gdk_pango_layout_get_clip_region
#argmap (in, which=[1,2,3,4]) PangoLayout *layout, gint x_origin, gint y_origin, const gint *index_ranges, gint n_ranges
   $5 = ($5_type) $4_dim0;
#end

% gtk_entry_buffer_new
#argmap (in, which=1) const gchar *initial_chars, gint n_initial_chars
   $2 = ($2_type) strlen ($1);
#end

% gtk_entry_buffer_set_text   
#argmap (in, which=[1,2]) GtkEntryBuffer *buffer, const gchar *chars, gint n_chars
   $3 = ($3_type) strlen ($2);
#end

% gtk_entry_buffer_insert_text
% gtk_entry_buffer_emit_inserted_text   
#argmap (in, which=[1,2,3]) GtkEntryBuffer *buffer, guint position, const gchar *chars, gint n_chars
   $4 = ($4_type) strlen ($3);
#end

% gtk_icon_theme_set_search_path
#argmap (in, which=[1,2]) GtkIconTheme *icon_theme, const gchar *path[], gint n_elements
   $3 = ($3_type) $2_dim0;
#end

% gtk_text_buffer_set_text
#argmap (in, which=[1,2]) GtkTextBuffer *buffer, const gchar *text, gint len
   $3 = ($3_type) strlen ($2);
#end

% g_compute_checksum_for_string   
#argmap (in, which=[1,2]) GChecksumType checksum_type, const gchar *str, gssize length
   $3 = ($3_type) strlen ($2);
#end

% pango_layout_set_text   
#argmap (in, which=[1,2]) PangoLayout *layout, const char *text, int length
   $3 = ($3_type) strlen ($2);
#end

% gtk_list_store_newv / gtk_list_store_set_column_types / gtk_tree_store_set_column_types
#argmap (in, which=2) gint n_columns, GType *types
   $1 = ($1_type) $2_dim0;
#end

#rename gtk_list_store_newv gtk_list_store_new

% g_key_file_set_string_list
#argmap (in, which=[1,2,3,4]) GKeyFile *key_file, const gchar *group_name, const gchar *key, const gchar **list, gsize length
   $5 = ($5_type) $4_dim0;
#end

% g_key_file_set_locale_string_list
#argmap (in, which=[1,2,3,4,5]) GKeyFile *key_file, const gchar *group_name, const gchar *key, const gchar *locale, const gchar **list, gsize length
   $6 = ($6_type) $5_dim0;
#end

% g_key_file_set_boolean_list
#argmap (in, which=[1,2,3,4]) GKeyFile *key_file, const gchar *group_name, const gchar *key, gboolean *list, gsize length
   $5 = ($5_type) $4_dim0;
#end

% g_key_file_set_integer_list
#argmap (in, which=[1,2,3,4]) GKeyFile *key_file, const gchar *group_name, const gchar *key, gint *list, gsize length
   $5 = ($5_type) $4_dim0;
#end

% g_key_file_set_double_list
#argmap (in, which=[1,2,3,4]) GKeyFile *key_file, const gchar *group_name, const gchar *key, gdouble *list, gsize length
   $5 = ($5_type) $4_dim0;
#end

% for functions that return a null terminated array of strings
% we don't need to know array length
#argmap (in, omit) gsize *length
#end

#argmap (in, omit) glong *items_written
#end

#argmap (in, omit) glong *items_read
#end

#argmap (out) gint *x
   $return;
#end

#copy gint *x {guint *padding_top, guint *padding_bottom, guint *padding_left, guint *padding_right}   
#copy gint *x {gint *y, gint *dest_x, gint *dest_y, gint *minimum_height, gint *natural_height}
#copy gint *x {gint *minimum_width, gint *natural_width, gint *width, gint *height, gint *x_offset, gint *y_offset}
#copy gint *x {guint *padding_top, guint *padding_bottom, guint *padding_left, guint *padding_right}
#copy gint *x {gboolean *expand, gboolean *fill, guint *padding, gint *major, gint *minor}
#copy gint *x {gint *minimum_size, gint *natural_size, gint *win_x, gint *win_y}
#copy gint *x {gint *indicator_size, gint *indicator_spacing, gint *bx, gint *by}
#copy gint *x {gdouble *r, gdouble *g, gdouble *b, gdouble *h, gdouble *s, gdouble *v}
#copy gint *x {gfloat *xalign, gfloat *yalign, gint *xpad, gint *ypad, gint *start, gint *end}
#copy gint *x {guint *width, guint *height, gdouble *value, gint *slider_start, gint *slider_end}
#copy gint *x {gdouble *step, gdouble *page, gdouble *min, gdouble *max, gdouble *parent_x, gdouble *parent_y}
#copy gint *x {gint *line_top, gint *trailing, gint *window_x, gint *window_y, gint *buffer_x, gint *buffer_y}
#copy gint *x {gint *widget_x, gint *widget_y, gint *effective_group, gint *level}
#copy gint *x {gint *tx, gint *ty, gint *wx, gint *wy, gint *bx, gint *by, gint *root_x, gint *root_y}
#copy gint *x {int *new_index, int *new_trailing, int *index_, int *trailing, int *width, int *height, int *x_pos, int *y0_, int *y1_}
#copy gint *x {gdouble *x_win, gdouble *y_win, gdouble *x_root, gdouble *y_root}
#copy gint *x {guint *button, guint *click_count, guint *keyval, guint16 *keycode}
#copy gint *x {gdouble *delta_x, gdouble *delta_y, gdouble *value, gdouble *distance, gdouble *x, gdouble *y}
#copy gint *x {guint32 *mask, gint *shift, gint *precision, gint *new_width, gint *new_height}   
#copy gint *x {GdkModifierType *mask, GtkIconSize *size, GdkModifierType *modifiers}
% #copy gint *x {GtkPolicyType *hscrollbar_policy, GtkPolicyType *vscrollbar_policy}
% #copy gint *x {int *hscrollbar_policy, int *vscrollbar_policy}
#copy gint *x {gunichar *ch, gunichar *a, gunichar *b, gunichar *result, gunichar *mirrored_ch}
#copy gint *x {int *thickness, int *position, guint *count, time_t *time_, gulong *microseconds}
#copy gint *x {gdouble *top, gdouble *bottom, gdouble *left, gdouble *right, gint *num_ranges}
#copy gint *x {gdouble *x_hot, gdouble *y_hot, gdouble *axes, gint *new_width, gint *new_height}
#copy gint *x {gint *actual_format, gint *actual_length, gsize *bytes_read}
#copy gint *x {guint *year, guint *month, guint *day, guint *accelerator_key, GdkModifierType *accelerator_mods}
#copy gint *x {const gchar **icon_name, gsize *size, guint32 *flags, gsize *bytes_written}
#copy gint *x {guint64 *disk_usage, guint64 *num_dirs, guint64 *num_files, guint64 *out_num}
#copy gint *x {gchar **exec, time_t *stamp}

#argmap (out) GtkPolicyType *hscrollbar_policy
   $return;
#end

#argmap (out) GtkPolicyType *vscrollbar_policy
   $return;
#end

% Some functions are returning GList or GSList.
% Almost all of those lists are lists of opaque pointers (GtkOpaque)
% and a few of them are lists of strings.
% Among lists of opaque pointers, some are lists of GObject which can
% be g_object_unref'ed and some are lists of other opaque types that may
% have their own way of beeing freed/unrefed (GBoxed, GInterface (what
% is a GInterface type, by the way ?), GdkDevice...)
% I thought that "gir" files from GObject instrospection would be
% of some help to automate things, but no, you have to read the doc/code.
% Or maybe I am missing something...

#typedef GList* GLIST_OF_STRINGS
#typedef GList* GLIST_OF_STRINGS_FREE
#typedef GSList* GSLIST_OF_STRINGS
#typedef GSList* GSLIST_OF_STRINGS_FREE

#retmap GList*
   GList *list;
   SLang_List_Type *lst;
   if (NULL == (lst = SLang_create_list (0)))
      goto free_and_return;
   for (list = retval ; list ; list = g_list_next (list))
   {
      (void) SLang_push_opaque (GtkOpaque_Type, (void*) list->data, 0);
      if (-1 == SLang_list_append (lst, -1))
        goto free_and_return;
   }
   (void) SLang_push_list (lst, 1);
   g_list_free (retval);
#end

#retmap const GList*
   GList *list;
   SLang_List_Type *lst;
   if (NULL == (lst = SLang_create_list (0)))
      goto free_and_return;
   for (list = retval ; list ; list = g_list_next (list))
   {
      (void) SLang_push_opaque (GtkOpaque_Type, (void*) list->data, 0);
      if (-1 == SLang_list_append (lst, -1))
        goto free_and_return;
   }
   (void) SLang_push_list (lst, 1);
#end

#retmap GLIST_OF_STRINGS
   GList *list;
   SLang_List_Type *lst;
   if (NULL == (lst = SLang_create_list (0)))
      goto free_and_return;
   for (list = retval ; list ; list = g_list_next (list))
   {
      (void) SLang_push_string ((gchar*) list->data);
      if (-1 == SLang_list_append (lst, -1))
        goto free_and_return;
   }
   (void) SLang_push_list (lst, 1);
   g_list_free (retval);
#end

#retmap GLIST_OF_STRINGS_FREE
   GList *list;
   SLang_List_Type *lst;
   if (NULL == (lst = SLang_create_list (0)))
      goto free_and_return;
   for (list = retval ; list ; list = g_list_next (list))
   {
      (void) SLang_push_string ((gchar*) list->data);
      if (-1 == SLang_list_append (lst, -1))
        goto free_and_return;
      g_free (list->data);
   }
   (void) SLang_push_list (lst, 1);
   g_list_free (retval);
#end

#retmap GSList*
   GSList *list;
   SLang_List_Type *lst;
   if (NULL == (lst = SLang_create_list (0)))
      goto free_and_return;
   for (list = retval ; list ; list = g_slist_next (list))
   {
      (void) SLang_push_opaque (GtkOpaque_Type, (void*) list->data, 0);
      if (-1 == SLang_list_append (lst, -1))
        goto free_and_return;
   }
   (void) SLang_push_list (lst, 1);
   g_slist_free (retval);
#end

#retmap const GSList*
   GSList *list;
   SLang_List_Type *lst;
   if (NULL == (lst = SLang_create_list (0)))
      goto free_and_return;
   for (list = retval ; list ; list = g_slist_next (list))
   {
      (void) SLang_push_opaque (GtkOpaque_Type, (void*) list->data, 0);
      if (-1 == SLang_list_append (lst, -1))
        goto free_and_return;
   }
   (void) SLang_push_list (lst, 1);
#end

#retmap GSLIST_OF_STRINGS
   GSList *list;
   SLang_List_Type *lst;
   if (NULL == (lst = SLang_create_list (0)))
      goto free_and_return;
   for (list = retval ; list ; list = g_slist_next (list))
   {
      (void) SLang_push_string ((gchar*) list->data);
      if (-1 == SLang_list_append (lst, -1))
        goto free_and_return;
   }
   (void) SLang_push_list (lst, 1);
   g_slist_free (retval);
#end

#retmap GSLIST_OF_STRINGS_FREE
   GSList *list;
   SLang_List_Type *lst;
   if (NULL == (lst = SLang_create_list (0)))
      goto free_and_return;
   for (list = retval ; list ; list = g_slist_next (list))
   {
      (void) SLang_push_string ((gchar*) list->data);
      if (-1 == SLang_list_append (lst, -1))
        goto free_and_return;
      g_free (list->data);
   }
   (void) SLang_push_list (lst, 1);
   g_slist_free (retval);
#end

% some functions are returning null terminated array of strings
% freeable ones
#retmap gchar**
   push_null_term_str_array ($1, $funcname, 1);
#end
% or not freeable ones
#retmap gchar* const*
   push_null_term_str_array ($1, $funcname, 0);
#end

#retmap const gchar* const*
   push_null_term_str_array ((char **) $1, $funcname, 0);
#end

% some function like 'g_resource_enumerate_children' return a char** and not a gchar**
#retmap char**
   push_null_term_str_array ($1, $funcname, 1);
#end

#typedef gchar* owned_by_glib

#retmap owned_by_glib
   (void) SLang_push_malloced_string (g_strdup (retval));
#end

#typedef gboolean GKEYFILE_OUT

#retmap GKEYFILE_OUT
   if (retval == TRUE)
      (void) SLang_push_opaque (GKeyFile_Type, (void*) arg1, 0);
   else
      (void) SLang_push_null ();
#end

#argmap (in, omit) GKeyFile *GKEYFILE
   $1 = g_key_file_new ();
#end

#argmap (in, omit) gchar **full_path
   arg$argnum = NULL;
#end

#argmap (in) GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT
   if (($2 = (GtkTextIter *) SLmalloc (sizeof (GtkTextIter))) == NULL)
      goto free_and_return;
#end

#argmap (in) GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT, GtkTextIter *TEXT_ITER_OUT
   if (($2 = (GtkTextIter *) SLmalloc (sizeof (GtkTextIter))) == NULL)
      goto free_and_return;
   if (($3 = (GtkTextIter *) SLmalloc (sizeof (GtkTextIter))) == NULL)
      goto free_and_return;
#end

#argmap (in, which=[1,2,3,4,5,6]) const GtkTextIter *iter, const gchar *str, GtkTextSearchFlags flags, GtkTextIter *TEXT_ITER_OUT, GtkTextIter *TEXT_ITER_OUT, const GtkTextIter *limit
   if (($4 = (GtkTextIter *) SLmalloc (sizeof (GtkTextIter))) == NULL)
      goto free_and_return;
   if (($5 = (GtkTextIter *) SLmalloc (sizeof (GtkTextIter))) == NULL)
      goto free_and_return;
#end

#argmap (in) GtkTextView *text_view, GtkTextIter *TEXT_ITER_OUT
   if (($2 = (GtkTextIter *) SLmalloc (sizeof (GtkTextIter))) == NULL)
      goto free_and_return;
#end

#argmap (out) GtkTextIter *TEXT_ITER_OUT
   (void) SLang_push_opaque (GtkTextIter_Type, $1, 1);
#end

#argmap (in) GtkTreeModel *tree_model, GtkTreeIter *TREE_ITER_OR_NULL
   if (($2 = (GtkTreeIter *) SLmalloc (sizeof (GtkTreeIter))) == NULL)
      goto free_and_return;
#end

#argmap (in) GtkTreeModelFilter *filter, GtkTreeIter *TREE_ITER_OR_NULL
   if (($2 = (GtkTreeIter *) SLmalloc (sizeof (GtkTreeIter))) == NULL)
      goto free_and_return;
#end

#argmap (in) GtkTreeModelFilter *filter, GtkTreeIter *TREE_ITER_OUT
   if (($2 = (GtkTreeIter *) SLmalloc (sizeof (GtkTreeIter))) == NULL)
      goto free_and_return;
#end

#argmap (in) GtkComboBox *combo_box, GtkTreeIter *TREE_ITER_OR_NULL
   if (($2 = (GtkTreeIter *) SLmalloc (sizeof (GtkTreeIter))) == NULL)
      goto free_and_return;
#end

#argmap (out) GtkTreeIter *TREE_ITER_OR_NULL
   if (retval)
      (void) SLang_push_opaque (GtkTreeIter_Type, $1, 1);
   else
      {
         SLfree ((char *) $1);
         (void) SLang_push_null ();
      }
#end

#argmap (in) GtkListStore *list_store, GtkTreeIter *TREE_ITER_OUT
   if (($2 = (GtkTreeIter *) SLmalloc (sizeof (GtkTreeIter))) == NULL)
      goto free_and_return;
#end

#argmap (in) GtkTreeStore *list_store, GtkTreeIter *TREE_ITER_OUT
   if (($2 = (GtkTreeIter *) SLmalloc (sizeof (GtkTreeIter))) == NULL)
      goto free_and_return;
#end

#argmap (in) GtkTreeStore *tree_store, GtkTreeIter *TREE_ITER_OUT
   if (($2 = (GtkTreeIter *) SLmalloc (sizeof (GtkTreeIter))) == NULL)
      goto free_and_return;
#end

#argmap (out) GtkTreeIter *TREE_ITER_OUT
   (void) SLang_push_opaque (GtkTreeIter_Type, $1, 1);
#end

#argmap (out) gdouble *VAL_OR_NULL
   if (retval)
      $return;
   else
      (void) SLang_push_null ();
#end

#copy gdouble *VAL_OR_NULL {guint *VAL_OR_NULL, guint16 *VAL_OR_NULL, gint *VAL_OR_NULL, guint64 *VAL_OR_NULL, GdkScrollDirection *VAL_OR_NULL, GdkModifierType *VAL_OR_NULL}

#typedef gboolean Ignore
      
#retmap (omit) Ignore
#end

#prototype
% const GList* gdk_display_list_devices (GdkDisplay *display);
const GList* gtk_menu_get_for_attach_widget (GtkWidget *widget);
const GSList* gtk_radio_button_get_group (GtkRadioButton *radio_button);
const GSList* gtk_size_group_get_widgets (GtkSizeGroup *size_group);
GLIST_OF_STRINGS gtk_style_context_list_classes (GtkStyleContext *context);
% GLIST_OF_STRINGS gtk_style_context_list_regions (GtkStyleContext *context);
GLIST_OF_STRINGS_FREE gtk_icon_theme_list_contexts (GtkIconTheme *icon_theme);
GLIST_OF_STRINGS_FREE gtk_icon_theme_list_icons (GtkIconTheme *icon_theme, const gchar *context);
GSLIST_OF_STRINGS gtk_widget_path_iter_list_classes (const GtkWidgetPath *path, gint pos);
% GSLIST_OF_STRINGS gtk_widget_path_iter_list_regions (const GtkWidgetPath *path, gint pos);
GSLIST_OF_STRINGS_FREE gtk_file_chooser_get_filenames (GtkFileChooser *chooser);
GSLIST_OF_STRINGS_FREE gtk_file_chooser_get_uris (GtkFileChooser *chooser);
GSLIST_OF_STRINGS_FREE gtk_file_chooser_list_shortcut_folders (GtkFileChooser *chooser);
GSLIST_OF_STRINGS_FREE gtk_file_chooser_list_shortcut_folder_uris (GtkFileChooser *chooser);

GKEYFILE_OUT g_key_file_load_from_file (GKeyFile *GKEYFILE, const gchar *file, GKeyFileFlags flags, GError **error);
GKEYFILE_OUT g_key_file_load_from_data (GKeyFile *GKEYFILE, const gchar *data, gsize length, GKeyFileFlags flags, GError **error);
GKEYFILE_OUT g_key_file_load_from_data_dirs (GKeyFile *GKEYFILE, const gchar *file, gchar **full_path, GKeyFileFlags flags, GError **error);
GKEYFILE_OUT g_key_file_load_from_dirs (GKeyFile *GKEYFILE, const gchar *file, const gchar **search_dirs, gchar **full_path, GKeyFileFlags flags, GError **error);

owned_by_glib g_dir_read_name (GDir *dir);

Ignore gdk_event_get_axis (const GdkEvent *event, GdkAxisUse axis_use, gdouble *VAL_OR_NULL);
Ignore gdk_event_get_button (const GdkEvent *event, guint *VAL_OR_NULL);
Ignore gdk_event_get_click_count (const GdkEvent *event, guint *VAL_OR_NULL);
Ignore gdk_event_get_coords (const GdkEvent *event, gdouble *VAL_OR_NULL, gdouble *VAL_OR_NULL);
Ignore gdk_event_get_keycode (const GdkEvent *event, guint16 *VAL_OR_NULL);
Ignore gdk_event_get_keyval (const GdkEvent *event, guint *VAL_OR_NULL);
Ignore gdk_event_get_root_coords (const GdkEvent *event, gdouble *VAL_OR_NULL, gdouble *VAL_OR_NULL);
Ignore gdk_event_get_scroll_direction (const GdkEvent *event, GdkScrollDirection *VAL_OR_NULL);
Ignore gdk_event_get_scroll_deltas (const GdkEvent *event, gdouble *VAL_OR_NULL, gdouble *VAL_OR_NULL);
Ignore gdk_event_get_state (const GdkEvent *event, GdkModifierType *VAL_OR_NULL);
Ignore gdk_events_get_angle (GdkEvent *event1, GdkEvent *event2, gdouble *VAL_OR_NULL);
Ignore gdk_events_get_center (GdkEvent *event1, GdkEvent *event2, gdouble *VAL_OR_NULL, gdouble *VAL_OR_NULL);
Ignore gdk_events_get_distance (GdkEvent *event1, GdkEvent *event2, gdouble *VAL_OR_NULL);

Ignore gdk_device_get_key (GdkDevice *device, guint index, guint *VAL_OR_NULL, GdkModifierType *VAL_OR_NULL);

Ignore g_file_measure_disk_usage_finish (GFile *file, GAsyncResult *result, guint64 *VAL_OR_NULL, guint64 *VAL_OR_NULL, guint64 *VAL_OR_NULL, GError **error);

void gtk_text_buffer_get_start_iter (GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT);
void gtk_text_buffer_get_iter_at_line (GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT, gint char_offset);
void gtk_text_buffer_get_iter_at_offset (GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT, gint char_offset);
void gtk_text_buffer_get_iter_at_line (GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT, gint line_number);
void gtk_text_buffer_get_iter_at_line_index (GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT, gint line_number, gint byte_index);
void gtk_text_buffer_get_iter_at_line_offset (GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT, gint line_number, gint char_offset);
void gtk_text_buffer_get_iter_at_mark (GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT, GtkTextMark *mark);
void gtk_text_buffer_get_iter_at_child_anchor (GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT, GtkTextChildAnchor *anchor);
void gtk_text_buffer_get_end_iter (GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT);

void gtk_text_buffer_get_bounds (GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT, GtkTextIter *TEXT_ITER_OUT);
void gtk_text_buffer_get_selection_bounds (GtkTextBuffer *buffer, GtkTextIter *TEXT_ITER_OUT, GtkTextIter *TEXT_ITER_OUT);

void gtk_text_iter_forward_search (const GtkTextIter *iter, const gchar *str, GtkTextSearchFlags flags, GtkTextIter *TEXT_ITER_OUT, GtkTextIter *TEXT_ITER_OUT, const GtkTextIter *limit);
void gtk_text_iter_backward_search (const GtkTextIter *iter, const gchar *str, GtkTextSearchFlags flags, GtkTextIter *TEXT_ITER_OUT, GtkTextIter *TEXT_ITER_OUT, const GtkTextIter *limit);

gboolean gtk_text_view_get_iter_at_location (GtkTextView *text_view, GtkTextIter *TEXT_ITER_OUT, gint x, gint y);
gboolean gtk_text_view_get_iter_at_position (GtkTextView *text_view, GtkTextIter *TEXT_ITER_OUT, gint *trailing, gint x, gint y);

Ignore gtk_tree_model_get_iter (GtkTreeModel *tree_model, GtkTreeIter *TREE_ITER_OR_NULL, GtkTreePath *path);
Ignore gtk_tree_model_get_iter_from_string (GtkTreeModel *tree_model, GtkTreeIter *TREE_ITER_OR_NULL, const gchar *path_string);
Ignore gtk_tree_model_get_iter_first (GtkTreeModel *tree_model, GtkTreeIter *TREE_ITER_OR_NULL);

Ignore gtk_tree_model_filter_convert_child_iter_to_iter (GtkTreeModelFilter *filter, GtkTreeIter *TREE_ITER_OR_NULL, GtkTreeIter *child_iter);
void gtk_tree_model_filter_convert_iter_to_child_iter (GtkTreeModelFilter *filter, GtkTreeIter *TREE_ITER_OUT, GtkTreeIter *filter_iter);

void gtk_list_store_insert_after (GtkListStore *list_store, GtkTreeIter *TREE_ITER_OUT, GtkTreeIter *sibling);
void gtk_list_store_insert_before (GtkListStore *list_store, GtkTreeIter *TREE_ITER_OUT, GtkTreeIter *sibling);

void gtk_tree_store_insert_after (GtkTreeStore *tree_store, GtkTreeIter *TREE_ITER_OUT, GtkTreeIter *parent, GtkTreeIter *sibling);
void gtk_tree_store_insert_before (GtkTreeStore *tree_store, GtkTreeIter *TREE_ITER_OUT, GtkTreeIter *parent, GtkTreeIter *sibling);

GtkWidget * gtk_message_dialog_new (GtkWindow *parent, gint flags, gint type, gint buttons, const gchar *message_format);
GtkWidget * gtk_message_dialog_new_with_markup (GtkWindow *parent, gint flags, gint type, gint buttons, const gchar *message_format);
void gtk_message_dialog_format_secondary_text (GtkMessageDialog *message_dialog, const gchar *message_format);
void gtk_message_dialog_format_secondary_markup (GtkMessageDialog *message_dialog, const gchar *message_format);

Ignore gtk_combo_box_get_active_iter (GtkComboBox *combo_box, GtkTreeIter *TREE_ITER_OR_NULL);

% void g_date_time_to_timeval (GDateTime *datetime, GTimeVal *tv);

void g_error (const gchar *str);
void g_message (const gchar *str);
void g_critical (const gchar *str);
void g_warning (const gchar *str);
void g_info (const gchar *str);
void g_debug (const gchar *str);
#end

% allow insertion of "push_null_term_str_array" function in glue code
SC.have_null_term_str_arrays = 1;
% structures mapped from C scope to proper S-Lang structures will be
% pushed on the stack as "interpreter structures".
% ex. : gtk_gl_area_get_error, pango_renderer_get_color
SC.types ["GError*"].returner = &struct_returner;
SC.types ["PangoColor*"].returner = &struct_returner;

provide ("slirprc-gtk3");
