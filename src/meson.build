project ('Gtk3 S-Lang module', 'c', version : '0.1',
	default_options : ['buildtype=release'])

sources= ['slgtk3.c', 'module.c']
gtkdep = [dependency ('gtk+-3.0'), dependency ('gtk+-unix-print-3.0')]
pangodep = dependency ('pangoft2')
slangdep = dependency ('slang')
library ('gtk3-module', sources, dependencies : [gtkdep, pangodep, slangdep], name_prefix : '', install : 'true')
