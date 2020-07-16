--[[--
 @package   SODplayer
 @filename  preferences.lua
 @version   0.2
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      15.07.2020 21:50:42 -04
--]]

function ui.btn_preferences_cancel:on_clicked()
	ui.preferences_window:hide()
end

function ui.btn_preferences_save:on_clicked()
	font_size = ui.subtitle_font_widget:get_font(fontchooser)
    ui.preferences_window:hide()
	print(font_size)
end