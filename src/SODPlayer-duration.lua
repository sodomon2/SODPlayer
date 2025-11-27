--[[--
 @package   SODPlayer
 @filename  src/SODPlayer-duration.lua
 @version   3.0
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      09.08.2020 13:36:42 -04
]]

local function ns_to_str (ns)
	if (not ns) or (ns <= 0) then
		return "00:00:00"
	end

	local total_seconds = math.floor(ns / Gst.SECOND)
	local hours = math.floor(total_seconds / 3600)
	local minutes = math.floor((total_seconds % 3600) / 60)
	local seconds = math.floor(total_seconds % 60)

	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function get_position()
	local position_ns = pipeline:query_position(Gst.Format.TIME)
	local position = position_ns and ns_to_str(position_ns) or '0:00'
	return position
end

function get_duration()
	local duration_ns = pipeline:query_duration(Gst.Format.TIME)
	local duration = duration_ns and ns_to_str(duration_ns) or '0:00'
	return duration
end
