--[[--
 @package   SODPlayer
 @filename  statusicon.lua
 @version   2.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      26.07.2020 12:19:29 -04
--]]  

ui.tray:set_visible(conf.general.status_icon)

function statusicon()
	visible = not visible
    if visible then
      ui.main_window:show_all()
    else
      ui.main_window:hide()
    end 
end

function ui.tray:on_activate()
	statusicon()
end

function create_menu(event_button, event_time)
    menu = Gtk.Menu {
        Gtk.ImageMenuItem {
            label = gettext("File"),
            image = Gtk.Image {
              stock = "gtk-open"
            },
            on_activate = function()
                ui.file_media_chooser:run()
            end
        },
        Gtk.ImageMenuItem {
            label = gettext("URL..."),
            image = Gtk.Image {
              stock = "gtk-connect"
            },
            on_activate = function()
                ui.dialog_url:run()
            end
        },
        Gtk.SeparatorMenuItem {},
        Gtk.ImageMenuItem {
            label = gettext("Preferences"),
            image = Gtk.Image {
              stock = "gtk-preferences"
            },
            on_activate = function()
                ui.preferences_window:run()
            end
        },
        Gtk.SeparatorMenuItem {},
        Gtk.ImageMenuItem {
            label = gettext("Quit"),
            image = Gtk.Image {
              stock = "gtk-quit"
            },
            on_activate = function()
                quit()
            end
        }
    }
    menu:show_all()
    menu:popup(nil, nil, nil, event_button, event_time)
end

function ui.tray:on_popup_menu(ev, time)
    create_menu(ev, time)
end

ui.menu_preferences_tray:set_active(conf.general.status_icon)
