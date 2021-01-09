project('SODPlayer', version: '2.0')

i18n = import('i18n')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'lua'
)

lua = find_program('lua')
gtk3_dep = dependency('gtk+-3.0')
gstreamer_dep = dependency('gstreamer-1.0')

sources = [
    'init.lua',
    'sodplayer.json',
]

install_data(
    sources,
    install_dir: '/usr/share/sodplayer'
)

subdir('components')
subdir('lib')
subdir('po')
subdir('data')


