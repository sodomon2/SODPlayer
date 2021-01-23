--[[--
 @package   SODPlayer
 @filename  SODPlayer-volume.lua
 @version   2.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      19.06.2020 15:43:09 -04
--]]  

ui.volume_control:set_value(conf.general.volume)

function ui.volume_control:on_value_changed()
	local value = (math.floor(ui.volume_control:get_value())/100)
	ui.volume_control:set_range(0, 100 )
	if  (value == 1) then
		conf.general.volume = 100
	else
		conf.general.volume = value
	end
	play.volume = conf.general.volume
	print( value )
	config:save(('%s/sodplayer.json'):format(dir), conf)
end

function ui.btn_volume:on_clicked()
	ui.menu_volume:show()
end
