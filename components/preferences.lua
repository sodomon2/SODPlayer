--[[--
 @package   SODplayer
 @filename  preferences.lua
 @version   1.5
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      15.07.2020 21:50:42 -04
--]]

conf = inifile:load('sodplayer.ini')

function ui.btn_preferences_cancel:on_clicked()
    ui.preferences_window:hide()
end

function subtitles()
    font_size = ui.subtitle_font_widget:get_font(fontchooser)
    conf['subtitles'] = {
        font_size = font_size
    }
    inifile:save('sodplayer.ini', conf)
end

function ui.btn_preferences_save:on_clicked()
    subtitles()
    ui.preferences_window:hide()
end

menu_preferences_tray      = Gtk.CheckMenuItem()
menu_preferences_tray_item = menu_preferences_tray.new_with_mnemonic('_Show icon in system tray')
ui.menu_preferences:add({menu_preferences_tray_item})

function menu_preferences_tray_item:on_button_press_event()
    if (self:get_active()) then
      ui.tray:set_visible(false)
    else
      ui.tray:set_visible(true)
    end
end
