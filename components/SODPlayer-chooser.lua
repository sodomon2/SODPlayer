--[[--
 @package   SODPlayer
 @filename  SODPlayer-chooser.lua
 @version   2.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      03.04.2021 22:47:05 -04
--]]  

file_media_chooser = Gtk.FileChooserDialog({
	title 		   = gettext:gettext("Select File"),
	filter		   = ui.media_filter,
	action		   = Gtk.FileChooserAction.OPEN
})

file_media_chooser:add_button(gettext:gettext("Open"), Gtk.ResponseType.OK)
file_media_chooser:add_button(gettext:gettext("Cancel"), Gtk.ResponseType.CANCEL)

file_subtitle_chooser = Gtk.FileChooserDialog({
	title 		      = gettext:gettext("Select subtitle"),
	action		      = Gtk.FileChooserAction.OPEN
})

file_subtitle_chooser:add_button(gettext:gettext("Open"), Gtk.ResponseType.OK)
file_subtitle_chooser:add_button(gettext:gettext("Cancel"), Gtk.ResponseType.CANCEL)

function open_media()
	local chooser = file_media_chooser:run()
	if chooser == Gtk.ResponseType.OK then
		media_name = file_media_chooser:get_filename(chooser)
		table.insert(conf.history.recents, 'file://' .. media_name)
		stop_media()
		config:save(('%s/sodplayer.json'):format(dir), conf)
		title(media_name)
		play.uri = ('file://%s'):format(media_name)
		file_media_chooser:hide()
		play_media()
	elseif chooser == Gtk.ResponseType.CANCEL then
		file_media_chooser:hide()
	end
end

function ui.menu_archive_item_open:on_button_press_event()
	open_media()
end