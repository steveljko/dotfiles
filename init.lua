-- ========================================================================= --
-- ==                          EDITOR SETTINGS                            == --
-- ========================================================================= --

-- disable netrw at the very start of our init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true         -- show line numbers
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.cursorline = true     -- highlight the current line
vim.opt.showmatch = true      -- highlight matching parenthesis

vim.opt.ignorecase = true     -- ignore case in searches
vim.opt.smartcase = true      -- override ignorecase if search pattern contains uppercase letters
vim.opt.incsearch = true      -- show matches as you type

vim.opt.termguicolors = true  -- enable 24-bit RGB colors
vim.opt.colorcolumn = "80"    -- highlight the 80th column

vim.opt.syntax = 'enable'     -- enable syntax highlighting

vim.opt.expandtab = true      -- expand tabs into spaces
vim.opt.shiftwidth = 2        -- number of spaces to use for each step of indent
vim.opt.tabstop = 2           -- number of spaces a TAB counts for
vim.opt.autoindent = true     -- copy indent from the current line when starting a new line

vim.opt.laststatus = 3        -- set a global status line for Neovim

vim.opt.swapfile = false      -- disable swap files

-- use undodir to store undos
vim.opt.undodir = vim.fn.expand('~/.vim/undodir')
vim.opt.undofile = true

-- disable backup and write backup files
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.clipboard = 'unnamedplus' -- enable system clipboard

-- ========================================================================= --
-- ==                              PLUGINS                                == --
-- ========================================================================= --

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
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
  },

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },

  -- fzf
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<C-f>", "<Cmd>:FzfLua files<CR>" },
    },
  },

  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'meuter/lualine-so-fancy.nvim' },
  },

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },

  -- lsp
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "folke/neoconf.nvim",
    },
  },

  -- complition
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
  },

  -- mini ai
  { 'nvim-mini/mini.ai', version = false },
})

-- ========================================================================= --
-- ==                        PLUGIN CONFIGURATION                         == --
-- ========================================================================= --

vim.cmd('set background=light')
vim.cmd.colorscheme('zenbones')

vim.g.fzf_colors = true
require('fzf-lua').setup({
  files = {
    cmd = "fd --type f --hidden --follow --exclude node_modules --exclude vendor",
    finder = "fd",
    fd_opts = "--type f --hidden --follow --exclude node_modules --exclude vendor",
  },
  grep = {
    rg_opts =
    "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob '!node_modules' --glob '!vendor'",
  }
})

require('lualine').setup({
  options = {
    theme = "auto",
    icons_enabled = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      {
        "fancy_diagnostics",
        sources = { "nvim_lsp" },
        symbols = { error = " ", warn = " ", info = " " } 
      }
    },
    lualine_c = {},
    lualine_x = { "diff" },
    lualine_y = { "fancy_lsp_servers", "fancy_branch" },
    lualine_z = { "filetype" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {},
})

-- treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'lua', 'php' },
  highlight = { enable = true },
  indent = { enable = true },
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- laravel blade treesitter
parser_config.blade = {
  install_info = {
    url = "https://github.com/EmranMR/tree-sitter-blade",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "blade"
}

vim.api.nvim_create_augroup("BladeFileTypeRelated", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.blade.php",
  callback = function()
    vim.bo.filetype = "blade"
  end,
  group = "BladeFileTypeRelated"
})

-- lsp
require("neoconf").setup({})
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

local servers = {
  lua_ls = {
    settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
  },
  intelephense = {
    filetypes = { "php" },
    root_dir = function(fname)
      return require('lspconfig.util').find_git_ancestor(fname) or
          require('lspconfig.util').path.dirname(fname)
    end,
    settings = {
      intelephense = {
        files = {
          maxSize = 1000000,
        },
      },
    },
  },
  html = {
    filetypes = { "html", "blade" },
    init_options = {
      configurationSection = { "html", "css", "javascript" },
      embeddedLanguages = {
        css = true,
        javascript = true,
      },
      provideFormatter = true,
    },
  },
  gopls = {
    filetypes = { "go" },
    root_dir = function(fname)
      return require('lspconfig.util').find_git_ancestor(fname) or
          require('lspconfig.util').path.dirname(fname)
    end,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
      },
    },
  },
}

for server_name, config in pairs(servers) do
  config.capabilities = capabilities
  lspconfig[server_name].setup(config)
end

-- complition
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  completion = {
    completeopt = "menu,menuone,preview,noselect",
    keyword_length = 2,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  window = {
    completion = cmp.config.window.bordered({ border = "rounded" }),
    documentation = cmp.config.window.bordered({ border = "rounded" }),
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        path = "[Path]",
      })[entry.source.name]

      return vim_item
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

-- ========================================================================= --
-- ==                            KEY MAPPINGS                             == --
-- ========================================================================= --
local bind = vim.keymap.set
local remap = { noremap = true, silent = true }

-- set leader key
vim.g.mapleader = ','

-- faster escaping
bind('i', 'jj', '<Esc>', remap)

-- window split
bind('n', '<leader>sv', ':vsplit<CR><C-w>l', remap)
bind('n', '<leader>sh', ':split<CR><C-w>j', remap)
bind('n', '<leader>se', '<C-w>=', remap)
bind('n', '<leader>sx', '<cmd>close<CR>')

-- change window focus
bind('n', '<C-h>', '<C-w>h', remap)
bind('n', '<C-j>', '<C-w>j', remap)
bind('n', '<C-k>', '<C-w>k', remap)
bind('n', '<C-l>', '<C-w>l', remap)

-- faster start/end of line
bind({ 'n', 'x', 'o' }, 'H', '^')
bind({ 'n', 'x', 'o' }, 'L', '$')

-- indenting in visual mode
bind('v', '<', '<gv')
bind('v', '>', '>gv')

-- fzf keymaps
bind('n', '<C-f>', '<Cmd>:FzfLua files<CR>')
bind('n', '<C-g>', '<Cmd>:FzfLua grep<CR>')
bind('n', '<C-b>', '<Cmd>:FzfLua buffers<CR>')

-- file explorer
bind('n', '<leader>e', '<Cmd>Neotree toggle<CR>')

-- lsp keymaps
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf }

    bind({ 'n', 'x' }, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    bind('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    bind('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    bind('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

    bind('n', 'K', '<cmd>lua vim.lsp.buf.hover({border = "rounded"})<cr>', opts)
    bind({ 'i', 'n' }, '<C-s>', '<cmd>lua vim.lsp.buf.signature_help({border = "rounded"})<cr>', opts)
  end,
})

-- tab to expand/jump forward, with fallback to regular tab
bind({ "i", "s" }, "<Tab>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    return "<Tab>"
  end
end, { expr = true, silent = true, desc = "Expand snippet or jump forward" })

bind({ "i", "s" }, "<S-Tab>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    return "<S-Tab>"
  end
end, { expr = true, silent = true, desc = "Jump backward in snippet" })
