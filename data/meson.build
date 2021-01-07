i18n.merge_file(
    input: 'sodplayer.desktop.in',
    output: 'sodplayer.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: '/usr/share/applications'
)

install_data(
    'sodplayer',
    install_dir: '/usr/bin'
)

install_data(
    'images/sodplayer.svg',
    install_dir: '/usr/share/pixmaps'
)

install_data(
    'player.ui',
    install_dir: '/usr/share/sodplayer/vistas'
)

install_subdir('images/', install_dir : '/usr/share/sodplayer/vistas') 