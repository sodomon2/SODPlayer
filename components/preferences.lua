--[[--
 @package   SODplayer
 @filename  preferences.lua
 @version   1.5
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      15.07.2020 21:50:42 -04
--]]

function ui.btn_preferences_cancel:on_clicked()
    ui.preferences_window:hide()
end

function subtitles()
	local font_size = ui.subtitle_font_widget:get_font(fontchooser)
	conf.subtitles = {
		font_size = font_size
	}
end

function recent_max_item()
    local max_item = ui.recents_spin:get_value_as_int(ui.recents_spin)
    local url_max_item = ui.url_spin:get_value_as_int(ui.url_spin)
    conf.history.max_item = max_item
    conf.history.url_max_item = url_max_item 
end

recent_item = tonumber(conf.history.max_item)
url_item    = tonumber(conf.history.url_max_item)

ui.recents_spin:set_value(recent_item)
ui.url_spin:set_value(url_item)

function ui.btn_preferences_apply:on_clicked()
	subtitles()
    recent_max_item()
	config:save('sodplayer.json', conf)
	ui.preferences_window:hide()
end

function ui.btn_preferences_ok:on_clicked()
    ui.preferences_window:hide()
end

menu_preferences_tray      = Gtk.CheckMenuItem()
menu_preferences_tray_item = menu_preferences_tray.new_with_mnemonic('_Show icon in system tray')
ui.menu_preferences:add({menu_preferences_tray_item})

function menu_preferences_tray_item:on_button_press_event()
    if (self:get_active()) then
		ui.tray:set_visible(false)
		conf.general.status_icon = false
    else
		ui.tray:set_visible(true)
		conf.general.status_icon = true
    end
    config:save('sodplayer.json', conf)
end
