--[[--
 @package   SODPlayer
 @filename  SODPlayer-menus.lua
 @version   2.0
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      03.08.2020 10:52:55 -04
]]

menu_archive_recent = Gtk.ImageMenuItem {
    label    = gettext:gettext("Recents"),
    image = Gtk.Image {stock = "gtk-directory"}
}

menu_archive_item_url = Gtk.ImageMenuItem {
    label    = gettext:gettext("URL..."),
    image = Gtk.Image {stock = "gtk-connect"}
}

separator = Gtk.SeparatorMenuItem()

menu_archive_item_quit = Gtk.ImageMenuItem {
    label    = gettext:gettext("Quit"),
    image = Gtk.Image {stock = "gtk-quit"}
}

function ui.main_window:on_button_press_event(event)	
	if (event.type == 'BUTTON_PRESS' and event.button == 3) then
		local menu = Gtk.Menu {
            Gtk.ImageMenuItem {
                label = gettext:gettext("File"),
                image = Gtk.Image {
                    stock = "gtk-open"
                },
                on_activate = function()
                    ui.file_media_chooser:run()
                end
            },
            Gtk.ImageMenuItem {
                label = gettext:gettext("URL..."),
                image = Gtk.Image {
                    stock = "gtk-connect"
                },
                on_activate = function()
                    ui.dialog_url:run()
                end
            },
            Gtk.SeparatorMenuItem {},
            Gtk.ImageMenuItem {
                label = gettext:gettext("Preferences"),
                image = Gtk.Image {
                    stock = "gtk-preferences"
                },
                on_activate = function()
                    ui.preferences_window:run()
                    ui.preferences_window:hide()
                end
            },
            Gtk.SeparatorMenuItem {},
            Gtk.ImageMenuItem {
                label = gettext:gettext("Quit"),
                image = Gtk.Image {
                    stock = "gtk-quit"
                },
                on_activate = function()
                    quit()
                end
            }
        }
        menu:attach_to_widget(ui.main_window, null)
		menu:show_all()
		menu:popup(nil, nil, nil, event.button, event.time)
	end
end

