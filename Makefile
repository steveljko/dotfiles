sync: clean
	mkdir -p ~/.config/alacritty		# terminal
	mkdir -p ~/.config/nvim					# editor
	mkdir -p ~/.config/sway					# window manager
	mkdir -p ~/.config/swaylock			# screenlock 
	mkdir -p ~/.config/mako					# notification deamon
	# Waybar
	mkdir -p ~/.config/waybar				# bar
	mkdir -p ~/.config/waybar/modules
	# Scripts
	mkdir -p ~/.local/scripts				# custom made scripts

	[ -f ~/.config/alacritty/alacritty.toml ] || ln -s $(PWD)/alacritty.toml ~/.config/alacritty/alacritty.toml
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/init.lua ~/.config/nvim/init.lua
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmuxcfg ~/.tmux.conf
	[ -f ~/.config/sway/config ] || ln -s $(PWD)/swaycfg ~/.config/sway/config
	[ -f ~/.config/swaylock/config ] || ln -s $(PWD)/swaylockcfg ~/.config/swaylock/config
	[ -f ~/.config/mako/config ] || ln -s $(PWD)/makocfg ~/.config/mako/config
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
	# Reload window manager
	swaymsg reload

	@echo "✅ Successfully loaded configuration."
	
clean:
	rm -rf ~/.config/alacritty/*
	rm -rf ~/.config/nvim/*
	rm -f ~/.zshrc
	rm -f ~/.tmux.conf
	rm -rf ~/.config/sway/*
	rm -rf ~/.config/swaylock/*
	rm -rf ~/.config/mako/*
	rm -rf ~/.config/waybar/*
	rm -rf ~/.local/scripts/*
	rm -f ~/Pictures/.wp

.PHONY: clean sync
