sync: clean
	mkdir -p ~/.config/alacritty
	mkdir -p ~/.config/nvim
	mkdir -p ~/.config/sway
	mkdir -p ~/.config/swaylock
	mkdir -p ~/.config/swaycons
	# Waybar
	mkdir -p ~/.config/waybar
	mkdir -p ~/.config/waybar/modules
	# Scripts
	mkdir -p ~/.local/scripts

	[ -f ~/.config/alacritty/alacritty.toml ] || ln -s $(PWD)/alacritty.toml ~/.config/alacritty/alacritty.toml
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/init.lua ~/.config/nvim/init.lua
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmuxconf ~/.tmux.conf
	[ -f ~/.config/sway/config ] || ln -s $(PWD)/swayconf ~/.config/sway/config
	[ -f ~/.config/swaylock/config ] || ln -s $(PWD)/swaylockconf ~/.config/swaylock/config
	[ -f ~/.config/swaycons/config.toml ] || ln -s $(PWD)/swaycons.toml ~/.config/swaycons/config.toml
	# Waybar
	[ -f ~/.config/waybar/config.jsonc ] || ln -s $(PWD)/waybar/config.jsonc ~/.config/waybar/config.jsonc
	[ -f ~/.config/waybar/style.css ] || ln -s $(PWD)/waybar/style.css ~/.config/waybar/style.css
	[ -f ~/.config/waybar/modules/tasks.sh ] || ln -s $(PWD)/waybar/modules/tasks.sh ~/.config/waybar/modules/tasks.sh
	# Scripts
	[ -f ~/.local/scripts/tmux-session ] || ln -s $(PWD)/scripts/tmux-session ~/.local/scripts/tmux-session
	[ -f ~/.local/scripts/screenshot-tool ] || ln -s $(PWD)/scripts/screenshot-tool ~/.local/scripts/screenshot-tool
	[ -f ~/.local/scripts/volume ] || ln -s $(PWD)/scripts/volume ~/.local/scripts/volume
	# Wallpaper
	[ -f ~/Pictures/.wp ] || ln -s $(PWD)/.wp ~/Pictures/.wp
	
clean:
	rm -rf ~/.config/alacritty/*
	rm -rf ~/.config/nvim/*
	rm -f ~/.zshrc
	rm -f ~/.tmux.conf
	rm -rf ~/.config/sway/*
	rm -rf ~/.config/swaylock/*
	rm -rf ~/.config/swaycons/*
	rm -rf ~/.config/waybar/*
	rm -rf ~/.local/scripts/*
	rm -f ~/Pictures/.wp

.PHONY: clean sync
