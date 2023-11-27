#!/usr/bin/lua
--[[--
 @package   SODPlayer
 @filename  lib/configuration.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex
 @date      22.07.2020 10:46:55 -04
]]

local configuration = class('configuration')

function configuration:create_config(dir,file)
	local config_dir = ('%s/%s'):format(GLib.get_user_config_dir(), dir)
	if not utils:isfile(('%s/sodplayer.json'):format(config_dir)) then
		os.execute( ('mkdir -p %s'):format(config_dir) )
		os.execute( ('cp %s %s'):format(file,config_dir) )
	end
end

function configuration:load(filename)
	local fd = io.open(filename, "r")
	local config = fd:read("*all")
	fd:close()
	return json:decode(config) or {}
end

function configuration:save(filename, data)
	data = json:encode_pretty(data) or {}
	file = assert(io.open(filename,'w'), 'Error loading file : ' .. filename)
	file:write(data)
	file:close()
end

return configuration
