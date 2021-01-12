--[[--
 @package   SODPlayer
 @filename  SODPlayer-recents.lua
 @version   2.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @co-author Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      31.07.2020 02:24:50 -04
--]]

recents_item = conf.history.recents

function create_submenu(depth)
	if depth < 1 then return nil end
	local menu_recent = Gtk.Menu()
	for i, uri in pairs(recents_item) do
        filename = utils:path_name(uri)['name']
        if i > recent_item_max then
			break
        end
        ui.menu_archive:add({menu_archive_recent})
		local item = Gtk.MenuItem {
			label = ("%d. %s"):format(i, filename),
			submenu = create_submenu(depth - 1, true),
			on_button_press_event = function ()
			    title(uri)
			    stop_media()
			    play.uri = uri
			    play_media()
			end
		}
		menu_recent:append(item)
	end
	return menu_recent
end

if #recents_item < 1 then
	ui.btn_clear_recent.sensitive = false
	ui.menu_archive:popdown({menu_archive_recent})
    return
end 

function ui.btn_clear_recent:on_clicked()
    if conf.other.clear_recent == true then
        ui.delete_dialog:run()
        ui.delete_dialog:hide()
    else
        ui.btn_clear_recent.sensitive = false			
        conf.history.recents = {}
        config:save(('%s/sodplayer.json'):format(dir), conf)
        ui.delete_dialog:hide()
    end
end 

function ui.btn_dialog_delete:on_clicked()
    conf.history.recents = {}
    config:save(('%s/sodplayer.json'):format(dir), conf)
    ui.delete_dialog:hide()
    ui.btn_clear_recent.sensitive = false
end

function ui.btn_dialog_cancel:on_clicked()
    ui.delete_dialog:hide()
end

menu_archive_recent.submenu = create_submenu(1)

