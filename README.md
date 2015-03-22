This repository is a collections of scripts intended to provision a common shell and tools configuration in a distribution indipendent way.

It uses puppet to manage packages and config files. The main repository containing configuration files is [here](https://github.com/riso/dotfiles).

## Usage

It shoud suffice to run the `install.sh` script specifying (through the `-c | --class` option) the puppet manifest that the user wants to provision:

	wget https://raw.githubusercontent.com/riso/dev-provision/master/install.sh
	chmod +x install.sh
	sudo ./install.sh -c base

Available manifests are:

* `base`: will provision basic shell with zsh, tmux, oh-my-zsh, vim and config files.
* `desktop`: all in `base` plus keepass2.

If run with no arguments `install.sh` will run `base` manifest by default. Therefore the same effect of the previous code can be achieved with the following one liner:

`wget -O - https://raw.githubusercontent.com/riso/dev-provision/master/install.sh | sudo sh`
