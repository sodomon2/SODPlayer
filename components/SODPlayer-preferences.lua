--[[--
 @package   SODPlayer
 @filename  SODPlayer-preferences.lua
 @version   3.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      15.07.2020 21:50:42 -04
--]]

recent_item_max = tonumber(conf.history.max_item)
url_item_max    = tonumber(conf.history.url_max_item)

function ui.btn_preferences_cancel:on_clicked()
	ui.preferences_window:hide()
end

function subtitles()
	local font_size = ui.subtitle_font_widget:get_font(fontchooser)
	conf.subtitles.font_size = font_size
end

function recent_max_item()
	local max_item = ui.recents_spin:get_value_as_int(ui.recents_spin)
	local url_max_item = ui.url_spin:get_value_as_int(ui.url_spin)
	conf.history.max_item = max_item
	conf.history.url_max_item = url_max_item
end

ui.recents_spin:set_value(recent_item_max)
ui.url_spin:set_value(url_item_max)

function showtoolbar()
	local check_toolbar = ui.setting_show_toolbar:get_active()
	conf.general.show_toolbar = check_toolbar
end

function ui.btn_preferences_apply:on_clicked()
	subtitles()
	recent_max_item()
	showtoolbar()
	config:save(('%s/sodplayer.json'):format(dir), conf)
end

function ui.btn_preferences_ok:on_clicked()
	ui.preferences_window:hide()
end

function ui.menu_preferences_tray:on_button_press_event()
	if (self:get_active()) then
		ui.tray:set_visible(false)
		conf.general.status_icon = false
	else
		ui.tray:set_visible(true)
		conf.general.status_icon = true
	end
	config:save(('%s/sodplayer.json'):format(dir), conf)
end

function ui.setting_general_delete_recents:on_clicked()
	if (self:get_active()) then
		conf.other.clear_recent = true
	else
		conf.other.clear_recent = false
	end
	config:save(('%s/sodplayer.json'):format(dir), conf)
end

ui.setting_general_delete_recents:set_active(conf.other.clear_recent)

function ui.setting_language:on_changed()
	if (self:get_active_id() == 'es') then
		conf.general.language = 'es'
	elseif (self:get_active_id() == 'en') then
		conf.general.language = 'en'
	else
		conf.general.language = 'en'
	end
	config:save(('%s/sodplayer.json'):format(dir), conf)
end

ui.setting_language:set_active_id(conf.general.language)

