
# Dirty, brutish hack to help convert GTK sample code from C to S-Lang

cat $1 | sed \
	-e "s/G_OBJECT[ \t]*(/(/g" \
	-e "s/G_CALLBACK[ \t]*(/(/g" \
	-e "s/GTK_OBJECT[ \t]*//g" \
	-e "s/GTK_WIDGET[ \t]*//g" \
	-e "s/GTK_BUTTON[ \t]*(/(/g" \
	-e "s/GTK_BUTTON_BOX[ \t]*(/(/g" \
	-e "s/GTK_TOGGLE_BUTTON[ \t]*(/(/g" \
	-e "s/GTK_BOX[ \t]*(/(/g" \
	-e "s/GTK_ENTRY[ \t]*(/(/g" \
	-e "s/GTK_MENU//g" \	
	# -e "s/GTK_CHECK_MENU_ITEM//g" \
	# -e "s/GTK_OPTION_MENU//g" \
	-e "s/GTK_WINDOW[ ]*(/(/g" \
	-e "s/GTK_LABEL[ ]*(/(/g" \
	-e "s/GTK_CONTAINER//g" \
	-e "s/GTK_TABLE//g" \
	-e "s/GTK_TOOLBAR (toolbar)/toolbar/g" \
	-e "s/GTK_SIGNAL_FUNC//g" \
	-e "s/(GtkSignalFunc) /\&/g" \
	-e "s/gtk_signal_connect_object/\(\) \= g_signal_connect_swapped/g" \
	-e "s/gtk_signal_connect/\(\) \= g_signal_connect/g" \
	\
	-e "s/static void/define /g" \
	-e "s/void /define /g" \
	-e "s/(GtkWidget \*/(/g" \
	-e "s/(void)/()/g" \
	\
	-e "s/static GtkWidget \*/static variable /g" \
	-e "s/GtkWidget[ ]*\*/variable /g" \
	-e "s/GtkNotebook[ ]*\*/variable /g" \
	-e "s/GtkNotebookPage[ ]*\*/variable /g" \
	-e "s/GdkPixmap[ ]*\*/variable /g" \
	-e "s/GdkBitmap[ ]*\*/variable /g" \
	-e "s/GtkPaned[ ]*\*/variable /g" \
	-e "s/gboolean/variable/g" \
	-e "s/gint/variable/g" \
	-e "s/gchar[ ]*\*/variable /g" \
	-e "s/const[ ]+gchar[ ]*\*/variable /g" \
	-e "s/static[ ]* char[ ]*\*/variable /g" \
	-e "s/=[ ]*{/ = [/g" \
	-e "s/};/];/g" \
	\
	-e "s/g_print/vmessage/g" \
	-e "s/((window)/(window/g" \
	-e "s/((button)/(button/g" \
	-e "s/,(window)/,window/g" \
	-e "s/(window),/window,/g" \
	-e "s/((label)/(label/g" \
	-e "s/((csd)/(csd/g" \
	-e "s/((box1)/(box1/g" \
	-e "s/,(box1)/,box1/g" \
	-e "s/(box1),/box1,/g" \
	-e "s/((box2)/(box2/g" \
	-e "s/,(box2)/,box2/g" \
	-e "s/(box2),/box2,/g" \
	-e "s/(frame),/frame,/g" \
	-e "s/(vbox),/vbox,/g" \
	-e "s/(hbox),/hbox,/g" \
	-e "s/\/\*/%/g" \
	-e "s/^[ \t]*\*[/]*/%/g" \
	-e "s/double[ \t][ \t]*//g" \
	-e "s/int[ \t][ \t]*//g" \
	-e "s/float[ \t][ \t]*//g" \
	-e "s/short[ \t][ \t]*//g" \
	-e "s/#define[ \t][ \t]*/variable /g" \
	-e "s/if (!window)/if (window == NULL)/g" \
	-e "/#include.*/d" \
	-e "s/(gtk_widget_destroyed)/\&gtk_widget_destroyed/g" \
	-e "s/(gtk_widget_destroy)/\&gtk_widget_destroy/g" \
	\
	-e "s/GTK_PLOT[ \t]*(/(/g" \
	-e "s/GTK_PLOT_CANVAS[ \t]*(/(/g" \
	-e "s/GTK_PLOT_DATA[ \t]*(/(/g" \
	-e "s/GTK_FIXED[ \t]*(/(/g" \
	-e "s/GTK_SCROLLED_WINDOW[ \t]*(/(/g" \
	-e "s/\<cairo_t\>[ \t]*[*]*//g"

	#-e "s/GTK_//g" \
	#-e "s/GDK_//g" \


