--[[--
 @package   SODplayer
 @filename  video.lua
 @version   1.5
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      19.06.2020 15:58:49 -04
--]]

pipeline    = Gst.Pipeline.new('pipeline')
play        = Gst.ElementFactory.make('playbin', 'play')
main_loop   = GLib.MainLoop()

function stop_media()
    pipeline.state = 'NULL'
    main_loop:quit()
    ui.media_slider:set_value(0)
    ui.img_media_state.icon_name = 'media-playback-start'
end

local btn_play_trigger = true
function play_media()
	ui.img_media_state.icon_name = 'media-playback-pause'

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
	pipeline.state = 'READY'
end

local function bus_callback(bus, message)
	if message.type.ERROR then
		print('Error:', message:parse_error().message)
		pipeline.state = 'READY'
	elseif message.type.EOS then
		print 'end of stream'
		stop_media()
		quit_fullscreen()
    elseif message.type.STATE_CHANGED then
      local old, new, pending = message:parse_state_changed()
      print(string.format('state changed: %s->%s:%s', old, new, pending))
	end

	return true
end

function ui.btn_chooser_open:on_clicked()
    media_name = ui.file_media_chooser:get_filename(chooser)
    ui.file_media_chooser:hide()
    play.uri = 'file://' .. media_name
    play_media()
end

function ui.btn_chooser_close:on_clicked()
    ui.file_media_chooser:hide()
end

function ui.btn_url_ok:on_clicked()
    play.uri = ui.entry_url.text
    ui.dialog_url:hide()
    play_media()
end

function ui.btn_url_cancel:on_clicked()
    ui.dialog_url:hide()
end

function ui.btn_play:on_clicked()
    toggle_pause()
end

pipeline:add_many(play)
pipeline.bus:add_watch(GLib.PRIORITY_DEFAULT, bus_callback)

function ui.btn_stop:on_clicked()
    stop_media()
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

-- Retarget video output to the drawingarea.
function ui.video:on_realize()
    print(self.window:get_xid())
    play:set_window_handle(self.window:get_xid())
end

-- paint the background
function ui.video:on_draw(cr)
    cr:paint()
end
