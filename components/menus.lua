--[[--
 @package   SODplayer
 @filename  menus.lua
 @version   1.5
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      03.08.2020 10:52:55 -04
]]

menu_archive_recent = Gtk.ImageMenuItem {
    label    = "Recientes",
    image = Gtk.Image {stock = "gtk-directory"}
}

menu_archive_item_url = Gtk.ImageMenuItem {
    label    = "URL...",
    image = Gtk.Image {stock = "gtk-connect"}
}

separator = Gtk.SeparatorMenuItem()

menu_archive_item_quit = Gtk.ImageMenuItem {
    label    = "Salir",
    image = Gtk.Image {stock = "gtk-quit"}
}