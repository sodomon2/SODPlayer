--[[--
 @package   SODplayer
 @filename  duration.lua
 @version   2.0
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      09.08.2020 13:36:42 -04 
]]

function ns_to_str (ns)
	if (not ns) then return nil end
		seconds = ns / Gst.SECOND
		minutes = math.floor(seconds / 60)
		seconds = math.floor(seconds - (minutes * 60))
		str = minutes .. ':' .. seconds
        return str
end

function get_position()
	position_ns = pipeline:query_position(Gst.Format.TIME)
	position = position_ns and ns_to_str(position_ns) or '0:00'
	return position
end

function get_duration()
	duration_ns = pipeline:query_duration(Gst.Format.TIME)
	duration = duration_ns and ns_to_str(duration_ns) or '0:00'
	return duration
end
