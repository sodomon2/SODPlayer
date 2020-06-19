#!/usr/bin/env lua

--[[--
 @package   player
 @filename  init.lua  
 @version   0.2
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com> 
 @date      19.06.2020 15:43:09 -04
--]]  

lgi       = require 'lgi'             -- La libreria que me permitira usar GTK
GObject   = lgi.GObject               -- Parte de lgi
GLib      = lgi.GLib                  -- para el treeview
Gdk       = lgi.Gdk
Gtk       = lgi.require('Gtk', '3.0') -- El objeto GTK
Gst       = lgi.require("Gst", "1.0")

print(Gst._version)
assert    = lgi.assert
builder   = Gtk.Builder()

assert(builder:add_from_file('vistas/player.ui'))
ui = builder.objects

function ui.main_window:on_destroy()
  Gtk.main_quit()
end

function ui.menu_about_item:on_button_press_event()
	ui.about_window:run()
	ui.about_window:hide()
end

if ('Lua_Player') then
	require('components.volume')
	require('components.video')
end

ui.main_window:show_all()
Gtk.main()
