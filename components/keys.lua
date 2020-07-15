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

-- 'next' es una función de Lua
function next2()
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

function toggle_mute()
    mute = not mute
    if ( mute ) then ui.volume_control:set_value(0)
    else ui.volume_control:set_value(100) end
end

function show_control()
    show = not show
    if show then ui.header_control:hide()
    else ui.header_control:show() end
end

function quit_fullscreen()
    fullscreen = not fullscreen
    ui.img_fullscreen.stock = 'gtk-fullscreen'
    ui.main_window:unfullscreen()
    ui.menu_media:show()
end

keybindings = {
   [Gdk.KEY_space]    = toggle_pause,
   [Gdk.KEY_Left]     = prev,
   [Gdk.KEY_Right]    = next2,
   [Gdk.KEY_q]        = stop_media,
   [Gdk.KEY_Q]        = stop_media,
   [Gdk.KEY_f]        = toggle_fullscreen,
   [Gdk.KEY_F]        = toggle_fullscreen,
   [Gdk.KEY_F11]      = toggle_fullscreen,
   [Gdk.KEY_Escape]   = quit_fullscreen,
   [Gdk.KEY_m]        = toggle_mute,
   [Gdk.KEY_M]        = toggle_mute,
   [Gdk.KEY_h]        = show_control
}

function ui.main_window:on_key_press_event(event)
  key = keybindings[event.keyval]
  if key then key() end
end

ui.btn_fullscreen.on_clicked = toggle_fullscreen
ui.btn_next.on_clicked = next2
ui.btn_prev.on_clicked = prev
