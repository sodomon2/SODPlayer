cd ..
find vistas/* -name "*.ui" -print0 | xargs -0 xgettext --from-code=utf-8 --language=Glade -k_ -kN_ -o locale/messages.po
find . -name "*.lua" -print0 | xargs -0 xgettext --from-code=utf-8 --language=Lua --keyword=gettext -o locale/messages.po --join-existing
