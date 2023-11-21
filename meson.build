project('SODPlayer', 'c' , version: '3.0')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'lua'
)

prefix = get_option('prefix')
datadir = get_option('datadir')
localedir = get_option('localedir')

cc = meson.get_compiler ('c')
i18n = import('i18n')

find_program('lua')
cc.find_library('gtk-3')
cc.find_library('gstreamer-1.0')

install_data(
    'init.lua',
    'sodplayer.json',
    install_dir: join_paths(datadir, 'sodplayer'),
)

search_mo_files = configuration_data()
search_mo_files.set('prefix', prefix)
search_mo_files.set('localedir', localedir)
configure_file (
    input: 'init.lua',
    output: ('init.lua').format(prefix, localedir),
    configuration: search_mo_files,
    install: true,
    install_dir: join_paths(datadir , 'sodplayer')
)

subdir('components')
subdir('lib')
subdir('po')
subdir('data')
