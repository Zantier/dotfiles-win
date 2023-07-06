# dotfiles

Combined dotfiles for Windows, Linux, MacOS

### Install

Share Windows clipboard with vim on WSL, for example:
- On WSL, run `sudo apt install vim-gtk`
- Install `VcXsrv`
- Run `XLaunch`, go through the dialog, and save the configuration file to `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup`

Clone this repository into `~/.dotfiles`.

Run `./setup.sh` to configure symlinks.

Create `.bashrc`, which should source `.my.sh`

If using regular vim, create `.vimrc`, which should source `.my.vim` or `.mytiny.vim`.
