-- [ Settings ]
vim.g.loaded_netrw = 1        -- Disable netrw
vim.g.loaded_netrwPlugin = 1  -- Disable netrwPlugin

vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true     -- Highlight the current line
vim.opt.showmatch = true      -- Highlight matching parenthesis

vim.opt.ignorecase = true     -- Ignore case in searches
vim.opt.smartcase = true      -- Override ignorecase if search pattern contains uppercase letters
vim.opt.incsearch = true      -- Show matches as you type

vim.opt.termguicolors = true  -- Enable 24-bit RGB colors
vim.opt.colorcolumn = "80"    -- Highlight the 80th column

vim.opt.syntax = 'enable'     -- Enable syntax highlighting

vim.opt.expandtab = true      -- Expand tabs into spaces
vim.opt.shiftwidth = 2        -- Number of spaces to use for each step of indent
vim.opt.tabstop = 2           -- Number of spaces a TAB counts for
vim.opt.autoindent = true     -- Copy indent from the current line when starting a new line

vim.opt.laststatus = 3        -- Set a global status line for Neovim

vim.opt.swapfile = false      -- Disable swap files

-- Use undodir to store undos
vim.opt.undodir = vim.fn.expand('~/.vim/undodir')
vim.opt.undofile = true

-- Disable backup and write backup files
vim.opt.backup = false              -- Disable backup files
vim.opt.writebackup = false         -- Disable write backup files

vim.opt.clipboard = 'unnamedplus'   -- Enable system clipboard

vim.opt.list = true                 -- Enable display of whitespace characters
vim.opt.listchars:append("eol:¬")   -- Show end-of-line characters as '¬'
vim.opt.listchars:append("space:·") -- Show spaces as '·'
vim.opt.listchars:append("tab:> ")  -- Show tabs as '> '

-- [ Lazy Nvim ]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- colorscheme
  {
    'mcauley-penney/ice-cave.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('ice-cave')
    end
  },

  -- nvim transparency
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup()
      vim.cmd("TransparentEnable")
      vim.cmd("highlight WinSeparator guifg=#40484e ctermfg=235")
    end
  },

  { 'AndrewRadev/splitjoin.vim' }, -- plugin to toggle between single-line and multi-line code blocks

  {
    "rgroli/other.nvim",
    config = function()
      require("other-nvim").setup({
        mappings = { "laravel" },
      })
    end,
  },

  -- file explorer
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      local HEIGHT_RATIO = 0.4
      local WIDTH_RATIO = 0.4

      require("nvim-tree").setup({
        sort = {
          sorter = "case_sensitive",
        },
        filters = {
          dotfiles = false,
        },
        disable_netrw = true,
        hijack_netrw = true,
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = false,
          update_cwd = false
        },
        view = {
          relativenumber = true,
          float = {
            enable = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2)
                  - vim.opt.cmdheight:get()
              return {
                border = "rounded",
                relative = "editor",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
          width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
          end,
        },
        renderer = {
          add_trailing = false,
          group_empty = false,
          highlight_git = false,
          full_name = false,
          highlight_opened_files = 'none',
          root_folder_modifier = ':~',
          indent_markers = {
            enable = true,
          }
        },
      })
    end
  },

  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'meuter/lualine-so-fancy.nvim' },
    opts = {
      theme = 'auto',
      icons_enabled = true,
      globalstatus = true,
      refresh = { statusline = 1000 },
      sections = {
        lualine_a = {
          { 'mode', fmt = function(str) return str:sub(1, 1) end },
        },
        lualine_b = { 'fancy_branch' },
        lualine_c = {
          'filename',
          { "fancy_diagnostics", sources = { "nvim_lsp" }, symbols = { error = " ", warn = " ", info = " " } },
          'fancy_searchcount',
        },
        lualine_x = {
          'fancy_lsp_servers',
          'fancy_diff',
          'progress',
        },
        lualine_y = {},
        lualine_z = {}
      }
    },
  },

  -- telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = require('telescope.actions').move_selection_next,
              ["<C-k>"] = require('telescope.actions').move_selection_previous,
              ["<C-d>"] = require('telescope.actions').delete_buffer,
              ["<C-e>"] = require('telescope.actions').close,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "ivy",
            previewer = false,
            prompt_title = "",
            prompt_prefix = "[Find Files] ",
            layout_config = { height = 0.30 },
          },
          buffers = {
            theme = "ivy",
            previewer = false,
            prompt_title = "",
            prompt_prefix = "[Buffers] ",
            layout_config = { height = 0.30 },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",
          }
        },
      }

      require('telescope').load_extension('fzf')
      require('telescope').load_extension('ui-select')
    end
  },

  {
    'b0o/incline.nvim',
    event = 'VeryLazy',
    config = function()
      require('incline').setup()
    end,
  },

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'php',
          'html',
          'javascript',
          'typescript',
          'css',
          'vue',
        },
        indent = { enable = true },
        autopairs = { enable = true },
        highlight = { enable = true },
      }
    end
  },

  -- faster commenting and uncommenting
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  {
    'folke/todo-comments.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      search = {
        command = "rg",
        args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
        pattern = [[\b(KEYWORDS):]],
      },
    }
  },

  -- formatting and linting
  {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          php = { "pint", "php_cs_fixer" },
        },
        format_on_save = {
          timeout_ms = 1000,
          lsp_format = "fallback",
        },
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = "BufReadPre",
    config = function()
      require('lint').linters_by_ft = {
        php = {},
      }
    end,
  },

  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "V13Axel/neotest-pest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require('neotest-pest'),
        }
      })
    end
  },

  -- language server protocol
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "folke/neoconf.nvim",
    },
    config = function()
      require("neoconf").setup({})
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      local capabilities = cmp_nvim_lsp.default_capabilities()

      local servers = {
        lua_ls = {
          settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
        },
        emmet_language_server = {
          filetypes = { "css", "html", "javascript", "vue" },
          cmd = { "emmet-language-server", "--stdio" },
        },
        tsserver = {
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = "/usr/lib/node_modules/@vue/language-server",
                languages = { "vue" },
              }
            },
          },
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        },
        volar = {
          filetypes = { "vue", "javascript", "html", "css" },
          cmd = { "vue-language-server", "--stdio" },
        },
        phpactor = {
          init_options = {
            ["language_server_phpstan.enabled"] = false,
            ["language_Server_psalm.enalbed"] = false,
          }
        },
        lexical = {
          filetypes = { "elixir", "eelixir", "heex" },
          cmd = { "/home/p4d50/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
          settings = {},
        }
      }

      for server_name, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server_name].setup(config)
      end

      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-s>h', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })
    end
  },

  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { silent = true })

      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        complation = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end
  },
})

-- [ KEYMAPS ]
vim.g.mapleader = ','      -- set leader key to ','
vim.g.maplocalleader = ',' -- set local leader key to ','

-- faster escaping
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- faster file navigation
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- next search word on center
vim.keymap.set('n', 'n', "nzzzv")
vim.keymap.set('n', 'N', "Nzzzv")

-- don't jump forward if I higlight and search for a word
local function stay_star()
  local sview = vim.fn.winsaveview()
  local args = string.format("keepjumps keeppatterns execute %q", "sil normal! *")
  vim.api.nvim_command(args)
  vim.fn.winrestview(sview)
end

vim.keymap.set('n', '*', stay_star, { noremap = true, silent = true })                           -- search word under the cursor with '*'

vim.keymap.set('n', '<leader>h', '<Cmd>:nohlsearch<CR>')                                         -- clear search highlights

vim.keymap.set('n', '<leader>tr', "<Cmd>lua require('neotest').run.run()<CR>")                   -- Run nearest test
vim.keymap.set('n', '<leader>tt', "<Cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>") -- Run all tests in the current file
vim.keymap.set('n', '<leader>to', "<Cmd>lua require('neotest').summary.toggle()<CR>")            -- Toggle test summary

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>', builtin.find_files, {})
vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
vim.keymap.set('n', '<C-b>', builtin.buffers, {})
vim.keymap.set('n', '<C-t>', '<Cmd>:TodoTelescope<CR>', { noremap = true, silent = true })

-- navigate between TODO comments
vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end)             -- jump bo next TODO comment
vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end)             -- jump to previous TODO comment

vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { noremap = true, silent = true }) -- toggle file tree

-- window split
vim.keymap.set('n', '<leader>sv', ':vsplit<CR><C-w>l', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sh', ':split<CR><C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>se', '<C-w>=', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sx', '<cmd>close<CR>')

-- resize splits
vim.keymap.set('n', '<C-w>>', ':vertical resize +6<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-w><', ':vertical resize -5<CR>', { noremap = true, silent = true })

-- close split
vim.keymap.set('n', '<leader>qc', ':q<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>qo', ':only<CR>', { noremap = true, silent = true })


vim.keymap.set({ 'n', 'x', 'o' }, 'H', '^')
vim.keymap.set({ 'n', 'x', 'o' }, 'L', '$')

-- split switching
vim.keymap.set('', '<C-j>', '<C-W>j')
vim.keymap.set('', '<C-k>', '<C-W>k')
vim.keymap.set('', '<C-h>', '<C-W>h')
vim.keymap.set('', '<C-l>', '<C-W>l')
