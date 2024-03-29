--[[--
 @package   SODPlayer
 @filename  src/SODPlayer-toolbar.lua
 @version   3.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      07.08.2020 18:22:27 -04
--]]

function show_and_hide_toolbar()
	if conf.general.show_toolbar == true then
		ui.box:add(ui.main_toolbar)
	elseif conf.general.show_toolbar == false then
		ui.box:remove(ui.main_toolbar)
	end
end
show_and_hide_toolbar()

function ui.btn_toolbar_file:on_clicked()
	open_media()
end

function ui.btn_toolbar_url:on_clicked()
	ui.dialog_url:run()
	ui.dialog_url:hide()
end

function ui.btn_toolbar_preferences:on_clicked()
	ui.preferences_window:run()
	ui.preferences_window:hide()
end

function ui.btn_toolbar_next:on_clicked()
	next_state(15)
end

function ui.btn_toolbar_prev:on_clicked()
	prev_state(15)
end

function ui.btn_toolbar_close:on_clicked()
	quit()
end

ui.setting_show_toolbar:set_active(conf.general.show_toolbar)

