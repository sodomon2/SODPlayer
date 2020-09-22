#!/usr/bin/env lua

--[[--
 @package   SODplayer
 @filename  init.lua  
 @version   2.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com> 
 @date      19.06.2020 15:43:09 -04
--]]

require 'lib.middleclass'
json      = require 'lib.json'
config    = require 'lib.configuration'
utils     = require 'lib.utils'
ml        = require 'lib.ml'
gettext   = require 'lib.gettext'

lgi       = require 'lgi'             -- La libreria que me permitira usar GTK
GObject   = lgi.GObject               -- Parte de lgi
GLib      = lgi.GLib                  -- para el treeview
Gdk       = lgi.Gdk                   -- para las keybindings
Gtk       = lgi.require('Gtk', '3.0') -- El objeto GTK
Gst       = lgi.require("Gst", "1.0")
GdkX11    = lgi.GdkX11
if tonumber(Gst._version) >= 1.0 then
   GstVideo = lgi.GstVideo
end

print(Gst._version)
assert    = lgi.assert
builder   = Gtk.Builder({
	translation_domain = 'sodplayer'
})

assert(builder:add_from_file('vistas/player.ui'))
ui = builder.objects

config:create_config('sodplayer','sodplayer.json')
dir = ('%s/sodplayer'):format(GLib.get_user_config_dir())
conf = config:load(('%s/sodplayer.json'):format(dir))

-- SODPlayer
require('components.volume')
require('components.video')
require('components.keys')
require('components.subtitles')
require('components.preferences')
require('components.statusicon')
require('components.menus')
require('components.toolbar')
require('components.duration')
require('components.recents')

function quit()
    Gtk.main_quit()
    main_loop:quit()
end 

function ui.main_window:on_destroy()
    quit()
end

function menu_archive_item_quit:on_button_press_event()
    quit()
end

function ui.menu_archive_item_open:on_button_press_event()
    ui.file_media_chooser:run()
    ui.file_media_chooser:hide()
end

function ui.menu_subtitles_item:on_button_press_event()
    ui.file_subtitle_chooser:run()
    ui.file_subtitle_chooser:hide()
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

ui.main_window:show_all()
panel_sensitive(false)
Gtk.main()
