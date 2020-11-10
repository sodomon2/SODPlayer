--[[--
 @package   SODPlayer
 @filename  SODPlayer-volume.lua
 @version   2.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      19.06.2020 15:43:09 -04
--]]  


function ui.volume_control:on_value_changed()
	if  (ui.volume_control:get_value() == 100) then
		conf.general.volume = 100
	else
		conf.general.volume = (math.floor(ui.volume_control:get_value())/100)
	end
	config:save(('%s/sodplayer.json'):format(dir), conf)
end

function ui.btn_volume:on_clicked()
	ui.menu_volume:show()
end

function ui.volume_control:on_value_changed()
	ui.volume_control:set_range(0, 100 )
	local value = (math.floor(ui.volume_control:get_value())/100)
	print( value )
	play.volume = conf.general.volume
end

ui.volume_control:set_value(conf.general.volume)