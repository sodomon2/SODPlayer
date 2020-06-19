--[[--
 @package   player
 @filename  video.lua
 @version   0.2
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      19.06.2020 15:58:49 -04
--]]  

local function bus_callback(bus, message)

	if message.type.ERROR then
		print('Error:', message:parse_error().message)
		pipeline.state = 'READY'
	elseif message.type.EOS then
		print 'end of stream'
		pipeline.state = 'READY'
	end

	return true
end

media_name = ui.load_media:get_filename()

play.uri = 'file://' .. media_name 
--play.uri = 'file:///home/diego/Videos/1.mp4'
pipeline:add_many(play)
pipeline.bus:add_watch(GLib.PRIORITY_DEFAULT, bus_callback)

local btn_play_trigger = true
function ui.btn_play:on_clicked()

	GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 1,function()
		local duration = pipeline:query_duration(Gst.Format.TIME)
		if duration then
			ui.media_slider:set_range(0, math.floor(duration/Gst.SECOND) )
		end
		local current = pipeline:query_position(Gst.Format.TIME)
		if current then
			btn_play_trigger = false
			ui.media_slider:set_value( math.floor(current / Gst.SECOND) )
			btn_play_trigger = true
		end
		return true
	end)
	pipeline.state = 'PLAYING'
	main_loop:run()
	pipeline.state = 'NULL'
end

function ui.media_slider:on_value_changed(id)
	if btn_play_trigger then
		local value = ui.media_slider:get_value()
		pipeline:seek_simple(
			Gst.Format.TIME,
			{Gst.SeekFlags.FLUSH, Gst.SeekFlags.KEY_UNIT},
			value * Gst.SECOND
		)
	end
end

