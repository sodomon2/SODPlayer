--[[--
 @package   player
 @filename  init.lua
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

keybindings = {
   [Gdk.KEY_Left]     = function() prev() end,
   [Gdk.KEY_Right]    = function() next() end,
   [Gdk.KEY_q]        = function() pipeline.state = 'NULL' end,
}

function ui.main_window:on_key_press_event(event)
	key = keybindings[event.keyval]
	if key then
		key()
	end
end

function ui.btn_next:on_clicked(id)
  next()
end

function ui.btn_prev:on_clicked(id)
  prev()
end


