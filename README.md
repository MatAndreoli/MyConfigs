# MyConfigs

## Using [GNU Stow](https://www.gnu.org/software/stow/)

Install:

```bash
sudo apt install stow
```

Usage:

```bash
stow nvim
```

### herdr

Herdr writes its own files into `~/.config/herdr-app`, so stow must link files individually:

```bash
stow --no-folding herdr
```

If Herdr recreates a file while you restow (it does when one goes missing), delete that target and run stow again right away.

Herdr does not render SVG icons through symlinks, so `herdr/.stow-local-ignore` skips `*.svg`. After a fresh stow, copy them by hand:

```bash
cp herdr/.config/herdr-app/mods/tabs-anim/*.svg ~/.config/herdr-app/mods/tabs-anim/
```
