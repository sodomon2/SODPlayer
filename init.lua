#!/usr/bin/env lua

--[[--
 @package   SODplayer
 @filename  init.lua
 @version   3.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      19.06.2020 15:43:09 -04
--]]

require 'lib.middleclass'
json      = require 'lib.json'
config    = require 'lib.configuration'
utils     = require 'lib.utils'
lgettext  = require 'lib.lgettext'

lgi       = require 'lgi'                -- La libreria que me permitira usar GTK
GObject   = lgi.require('GObject','2.0') -- Parte de lgi
GLib      = lgi.require('GLib','2.0')    -- para el bucle de reproducción
Gdk       = lgi.require('Gdk', '3.0')    -- para las keybindings
Gtk       = lgi.require('Gtk', '3.0')    -- El objeto GTK
Gst       = lgi.require("Gst", "1.0")
GdkX11    = lgi.require('GdkX11', '3.0')
Gio       = lgi.require('Gio','2.0')
if tonumber(Gst._version) >= 1.0 then
   GstVideo = lgi.require('GstVideo','1.0')
end

print(Gst._version)
assert    = lgi.assert

config:create_config('sodplayer','sodplayer.json')
dir = ('%s/sodplayer'):format(GLib.get_user_config_dir())
conf = config:load(('%s/sodplayer.json'):format(dir))

if conf.general.language == 'es' then
  gettext   = lgettext.translation('sodplayer', '@prefix@/@localedir@/', {'es'}, 'UTF-8')
  builder   = Gtk.Builder({translation_domain = 'sodplayer'})
else
  gettext   = lgettext.translation('sodplayer', '@prefix@/@localedir@/', {'en'}, 'UTF-8')
  builder   = Gtk.Builder()
end

assert(builder:add_from_file('data/player.ui'))
ui = builder.objects
app = Gtk.Application.new ('com.github.sodomon2.SODPlayer',Gio.ApplicationFlags.HANDLES_OPEN)
fullscreen = false

-- SODPlayer
require('components.SODPlayer-app')
require('components.SODPlayer-volume')
require('components.SODPlayer-video')
require('components.SODPlayer-keys')
require('components.SODPlayer-subtitles')
require('components.SODPlayer-preferences')
require('components.SODPlayer-statusicon')
require('components.SODPlayer-menus')
require('components.SODPlayer-toolbar')
require('components.SODPlayer-duration')
require('components.SODPlayer-recents')
require('components.SODPlayer-chooser')

function quit()
	Gtk.main_quit()
	main_loop:quit()
	os.exit(0)
end

function ui.main_window:on_destroy()
	quit()
end

function menu_archive_item_quit:on_button_press_event()
	quit()
end

function ui.menu_about_item:on_button_press_event()
	ui.about_window:run()
	ui.about_window:hide()
end

function ui.menu_preferences_item:on_button_press_event()
	ui.preferences_window:run()
	ui.preferences_window:hide()
end

function menu_archive_item_url:on_button_press_event()
	ui.dialog_url:run()
	ui.dialog_url:hide()
end

ui.menu_archive:add({menu_archive_item_url})
ui.menu_archive:add({separator})
ui.menu_archive:add({menu_archive_item_quit})

panel_sensitive(false)
app:run({ arg[1], ... })
Gtk.main()