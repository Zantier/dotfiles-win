# dotfiles-win

dotfiles to be used on Windows

Installed programs:
- Windows Subsystem for Linux (WSL)
- VsVim for Visual Studio

### Install

Share Windows clipboard with vim on WSL, for example:
- On WSL, run `sudo apt install vim-gtk`
- Install `VcXsrv`
- Run `XLaunch`, go through the dialog, and save the configuration file to `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup`

Clone this repository into `~/.dotfiles`.

Move all files, except the `.git` directory, from `~/.dotfiles` to `~`.

Create `.bashrc`, which should source `.my.sh`

Create `.vimrc`, which should source `.my.vim` or `.mytiny.vim`.

### Develop

To edit this repository, open WSL to `~`, and use the command `dgit` in place of `git`.
