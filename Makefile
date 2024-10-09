sync: clean
	mkdir -p ~/.config/alacritty		# terminal
	mkdir -p ~/.config/nvim					# editor
	mkdir -p ~/.local/scripts				# custom made scripts

	[ -f ~/.config/alacritty/alacritty.toml ] || ln -s $(PWD)/alacritty.toml ~/.config/alacritty/alacritty.toml
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/init.lua ~/.config/nvim/init.lua
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmuxcfg ~/.tmux.conf
	# Scripts
	[ -f ~/.local/scripts/tmux-session ] || ln -s $(PWD)/scripts/tmux-session ~/.local/scripts/tmux-session

	@echo "✅ Successfully loaded configuration."
	
clean:
	rm -rf ~/.config/alacritty/*
	rm -rf ~/.config/nvim/*
	rm -f ~/.zshrc
	rm -f ~/.tmux.conf
	rm -rf ~/.local/scripts/*

.PHONY: clean sync
