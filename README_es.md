# SODPlayer
Un software de reproducción de video basado en lua hecho con GTK y GStreamer

## Screenshot

![screenshot](https://github.com/sodomon2/project-screenshot/blob/master/SODPlayer/screenshot.png?raw=true)

## Instalación

```
git clone https://github.com/sodomon2/SODPlayer.git
cd SODPlayer/
meson build && cd build
[sudo] ninja install
```

## Dependencias 

- [Gstreamer](https://gstreamer.freedesktop.org/download/)
- [Lua-LGI](https://github.com/pavouk/lgi)
- [Lua5.1+](https://www.lua.org/download.html) (o [LuaJIT 2.0+](https://luajit.org/))
- [Lua-BitOp](http://bitop.luajit.org/download.html) (Para el soporte a Gettext)

### Execute

`lua5.1 init.lua` (o `luajit init.lua`)
