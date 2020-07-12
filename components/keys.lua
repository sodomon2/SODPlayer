--[[--
 @package   SODplayer
 @filename  keys.lua
 @version   0.2
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      02.07.2020 17:27:23 -04
--]]

function prev()
	local current = pipeline:query_position(Gst.Format.TIME)
	pipeline:seek_simple(
		Gst.Format.TIME,
		{Gst.SeekFlags.FLUSH, Gst.SeekFlags.KEY_UNIT},
		current-10 * Gst.SECOND
	)
end

function next()
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
        ui.img_fullscreen.stock = 'gtk-leave-fullscreen'
    else
        ui.img_fullscreen.stock = 'gtk-fullscreen'
        ui.main_window:unfullscreen()
        ui.menu_media:show()
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
   [Gdk.KEY_Left]     = function() prev() end,
   [Gdk.KEY_Right]    = function() next() end,
   [Gdk.KEY_q]        = function() stop_media() end,
   [Gdk.KEY_Q]        = function() stop_media() end,
   [Gdk.KEY_f]        = function() toggle_fullscreen() end,
   [Gdk.KEY_F]        = function() toggle_fullscreen() end,
   [Gdk.KEY_F11]      = function() toggle_fullscreen() end,
   [Gdk.KEY_Escape]   = function() quit_fullscreen() end
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
  next()
end

function ui.btn_prev:on_clicked(id)
  prev()
end
