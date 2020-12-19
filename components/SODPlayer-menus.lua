--[[--
 @package   SODPlayer
 @filename  SODPlayer-menus.lua
 @version   2.0
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      03.08.2020 10:52:55 -04
]]

menu_archive_recent = Gtk.ImageMenuItem {
    label    = gettext("Recents"),
    image = Gtk.Image {stock = "gtk-directory"}
}

menu_archive_item_url = Gtk.ImageMenuItem {
    label    = gettext("URL..."),
    image = Gtk.Image {stock = "gtk-connect"}
}

separator = Gtk.SeparatorMenuItem()

menu_archive_item_quit = Gtk.ImageMenuItem {
    label    = gettext("Quit"),
    image = Gtk.Image {stock = "gtk-quit"}
}