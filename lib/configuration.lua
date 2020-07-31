#!/usr/bin/lua
--[[--
 @package
 @filename  ss.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex
 @date      22.07.2020 10:46:55 -04
]]

local configuration = class('configuration')

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
