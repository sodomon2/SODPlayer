--[[--
 @package   SODPlayer
 @filename  src/SODPlayer-subtitles.lua
 @version   3.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      10.07.2020 03:01:54 -04
--]]

subtitle_size = conf.subtitles.font_size

function open_subtitle()
	local chooser = file_subtitle_chooser:run()
	if chooser == Gtk.ResponseType.OK then
		srt_file = file_subtitle_chooser:get_filename(chooser)
		play.suburi = ('file://%s'):format(srt_file)
		play.subtitle_font_desc = subtitle_size
		file_subtitle_chooser:hide()
	elseif chooser == Gtk.ResponseType.CANCEL then
		file_subtitle_chooser:hide()
	end
end

function ui.menu_subtitles_item:on_button_press_event()
	open_subtitle()
end

ui.subtitle_font_widget:set_font(subtitle_size)