REPO_URL = https://github.com/steveljko/dotfiles.git
LOCAL_DIR = ~/path/to/local/dir
CONFIG_FILES = \
    .tmux.conf:~/.tmux.conf \
    .wp:~/.wp \
    .zshrc:~/.zshrc \
    alacritty:~/.config/alacritty \
    nvim:~/.config/nvim \
    sway:~/.config/sway \
    swaycons:~/.config/swaycons \
    swaylock:~/.config/swaylock \
    waybar:~/.config/waybar

sync: pull
	@echo "Creating symbolic links for configuration files..."
	@for file in $(CONFIG_FILES); do \
		IFS=: read src dest <<< "$file"; \
		if [ -e "$dest" ] || [ -L "$dest" ]; then \
			echo "Removing existing file/link: $dest"; \
			rm -rf "$dest"; \
		fi; \
		ln -s $(LOCAL_DIR)/$src $dest; \
		echo "Created symlink: $dest -> $(LOCAL_DIR)/$src"; \
	done
	@echo "Sync complete."

pull:
	@echo "Pulling latest changes from the repository..."
	@cd $(LOCAL_DIR) && git pull $(REPO_URL)

setup:
	@echo "Setting up local directory..."
	@mkdir -p $(LOCAL_DIR)
	@cd $(LOCAL_DIR) && git clone $(REPO_URL) .

.PHONY: sync pull setup

