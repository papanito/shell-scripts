localPath=~/.local/share/gnome-shell/extensions/
for i in $localPath/*;do echo $(basename $i);gnome-extensions enable "$(basename $i)";done
gnome-extensions enable GPaste@gnome-shell-extensions.gnome.org
gnome-extensions enable gnome-shell-extensions.gcampax.github.com
