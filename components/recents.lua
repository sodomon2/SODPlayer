--[[--
 @package   SODplayer
 @filename  recents.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      31.07.2020 02:24:50 -04
--]]

recents_item = conf.history.recents

function create_submenu(depth)
	if depth < 1 then return nil end
	local menu_recent = Gtk.Menu()
	for i, uri in pairs(recents_item) do
		local item = Gtk.MenuItem {
			label = ("%d. %s"):format(i, uri),
			submenu = create_submenu(depth - 1, true),
			on_button_press_event = function ()
				-- @TODO: esto se puede mejorar
				play.uri = 'file://' .. uri
			    play_media()
			end
		}
		menu_recent:append(item)
	end
	return menu_recent
end

ui.menu_archive_item_recent.submenu = create_submenu(1)
