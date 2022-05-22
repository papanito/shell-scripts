# ShellScripts

This repository contains arbitrary shell scripts.

- [nautilus](./nautilus/scripts/) - Scripts which can be executed in Gnome's file manager [Nautilus](https://fedoramagazine.org/integrating-scripts-nautilus/)
- [scripts](./scripts/scripts) - arbitrary shell scripts

## Setup

I've made this repo so you can use `setup.sh` - which uses [stow] - to make a symbolic link as follows

- `scripts` to `~ /.local/bin`
- `nautilus` to `~/.local/share/nautilus/`


[stow]: k8s-ingress-exporter.sh