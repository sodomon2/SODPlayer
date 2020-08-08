--[[--
 @package   SODplayer
 @filename  keys.lua
 @version   2.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      02.07.2020 17:27:23 -04
--]]

function prev_state()
	local current = pipeline:query_position(Gst.Format.TIME)
	pipeline:seek_simple(
		Gst.Format.TIME,
		{Gst.SeekFlags.FLUSH, Gst.SeekFlags.KEY_UNIT},
		current-10 * Gst.SECOND
	)
end

function next_state()
	local current = pipeline:query_position(Gst.Format.TIME)
	pipeline:seek_simple(
		Gst.Format.TIME,
		{Gst.SeekFlags.FLUSH, Gst.SeekFlags.KEY_UNIT},
		current+10 * Gst.SECOND
	)
end

function toggle_pause()
    playstate = not playstate
    if (playstate) then
        pipeline.state = 'PAUSED'
        ui.img_media_state.icon_name = 'media-playback-start'
    else
        pipeline.state = 'PLAYING'
        ui.img_media_state.icon_name = 'media-playback-pause'
    end
end 

function toggle_fullscreen()
    fullscreen = not fullscreen
    if ( fullscreen ) then
        ui.main_window:fullscreen()
        ui.menu_media:hide()
        ui.main_toolbar:hide()
        ui.img_fullscreen.stock = 'gtk-leave-fullscreen'
    else
        ui.img_fullscreen.stock = 'gtk-fullscreen'
        ui.main_window:unfullscreen()
        ui.menu_media:show()
        ui.main_toolbar:show()
    end
end 

function toggle_mute()
    mute = not mute
    if ( mute ) then
        ui.volume_control:set_value(0)
        ui.img_volume_state.icon_name = 'audio-volume-muted'
    else
        ui.volume_control:set_value(100)
        ui.img_volume_state.icon_name = 'audio-volume-high'
    end
end

function show_control()
    show = not show
    if ( show ) then
        ui.header_control:hide()
    else
        ui.header_control:show()        
    end
end

function quit_fullscreen()
    fullscreen = not fullscreen
    ui.img_fullscreen.stock = 'gtk-fullscreen'
    ui.main_window:unfullscreen()
    ui.menu_media:show()
end

keybindings = {
   [Gdk.KEY_space]    = function() toggle_pause() end,
   [Gdk.KEY_Left]     = function() prev_state() end,
   [Gdk.KEY_Right]    = function() next_state() end,
   [Gdk.KEY_q]        = function() stop_media() end,
   [Gdk.KEY_Q]        = function() stop_media() end,
   [Gdk.KEY_f]        = function() toggle_fullscreen() end,
   [Gdk.KEY_F]        = function() toggle_fullscreen() end,
   [Gdk.KEY_F11]      = function() toggle_fullscreen() end,
   [Gdk.KEY_Escape]   = function() quit_fullscreen() end,
   [Gdk.KEY_m]        = function() toggle_mute() end,
   [Gdk.KEY_M]        = function() toggle_mute() end,
   [Gdk.KEY_h]        = function() show_control() end
}

function ui.main_window:on_key_press_event(event)
	key = keybindings[event.keyval]
	if key then
		key()
	end
end

function ui.btn_fullscreen:on_clicked()
    toggle_fullscreen()
end 

function ui.btn_next:on_clicked(id)
    next_state()
end

function ui.btn_prev:on_clicked(id)
    prev_state()
end
