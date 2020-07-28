--[[--
 @package   SODplayer
 @filename  subtitles.lua
 @version   1.5
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      10.07.2020 03:01:54 -04
--]]  

function ui.btn_subtitle_open:on_clicked()
    srt_file = ui.file_subtitle_chooser:get_filename(chooser)
    ui.file_subtitle_chooser:hide()
    play.suburi = 'file://' .. srt_file
    play.subtitle_font_desc = font_size
end

function ui.btn_subtitle_close:on_clicked()
    ui.file_subtitle_chooser:hide()
end