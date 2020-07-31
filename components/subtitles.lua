--[[--
 @package   SODplayer
 @filename  subtitles.lua
 @version   1.5
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      10.07.2020 03:01:54 -04
--]]  

subtitle_size = conf.subtitles.font_size

function subtitle_load()
    srt_file = ui.file_subtitle_chooser:get_filename(chooser)
    play.suburi = 'file://' .. srt_file
    play.subtitle_font_desc = subtitle_size
    print (subtitle_size)
end

function ui.btn_subtitle_open:on_clicked()
    subtitle_load()
    ui.file_subtitle_chooser:hide()
end

function ui.btn_subtitle_close:on_clicked()
    ui.file_subtitle_chooser:hide()
end

ui.subtitle_font_widget:set_font(subtitle_size)