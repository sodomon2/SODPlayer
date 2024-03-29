--[[--
 @package   SODPlayer
 @filename  src/SODPlayer-app.lua
 @version   3.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      01.10.2020 18:21:47 -04
--]]

local screen					= Gdk.Screen:get_default()
ui.main_window.default_width	= screen:get_width()
ui.main_window.default_height	= screen:get_height()

function title(media)
	filename = utils:path_name(media)['name']
	ui.main_window.title = ('SODPlayer - %s'):format(filename)
end

function app:on_activate()
	ui.main_window:show_all()
end

function app:on_open(files)
	file = files[1] and files[1]:get_parse_name()
	if(file) then
		if (string.find(file, '://')) then
			uri = file
		else
			uri = 'file://' .. file
		end
	end
	print('Playing', uri)
	table.insert(conf.history.recents, uri)
	config:save(('%s/sodplayer.json'):format(dir), conf)
	title(uri)
	ui.main_window:show_all()
	play.uri = uri
	play_media()
end



