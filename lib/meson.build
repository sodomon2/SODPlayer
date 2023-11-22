sources = [
    'configuration.lua',
    'json.lua',
    'lgettext.lua',
    'middleclass.lua',
    'utils.lua'
]

configure_file (
    input: 'lgettext.lua',
    output: ('lgettext.lua').format(prefix, localedir),
    configuration: search_mo_files,
    install: true,
    install_dir: join_paths(datadir , 'sodplayer')
)

install_data(
    sources,
    install_dir: join_paths(get_option('datadir'), 'sodplayer/lib'),
)
