i18n.merge_file(
    input: 'sodplayer.desktop.in',
    output: 'sodplayer.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

sodplayer_bin = configuration_data()
sodplayer_bin.set('prefix', prefix)
sodplayer_bin.set('datadir', datadir)
configure_file (
    input: 'sodplayer.in',
    output: ('sodplayer').format(prefix, datadir),
    configuration: sodplayer_bin,
    install: true,
    install_dir: join_paths(get_option('bindir'))
)

install_data(
    'images/sodplayer.svg',
    install_dir: join_paths(get_option('datadir'), 'pixmaps')
)

install_data(
    'player.ui',
    install_dir: join_paths(get_option('datadir'), 'sodplayer/data')
)

install_subdir('images/', install_dir : join_paths(get_option('datadir'), 'sodplayer/data')) 