--[[--
 @package   SODPlayer
 @filename  volume.lua
 @version   2.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      19.06.2020 15:43:09 -04
--]]  

function ui.btn_volume:on_clicked()
	ui.menu_volume:show()
end

function ui.volume_control:on_value_changed()
	ui.volume_control:set_range(0, 100 )
	local value = (math.floor(ui.volume_control:get_value())/100)
	print( value )
	play.volume = value
end