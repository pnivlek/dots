--Set path for finding folders.
vim.o.path = vim.o.path .. "**"

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

-- Format settings
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Netrw will sometimes be unable to close under any circumstance if this isn't set. I think it happens when I open the directory when nvim starts.
vim.g.netrw_fastbrowse = 0

--Set colorscheme
vim.o.background = 'dark'
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Open to the right.
vim.o.splitright = true

--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Close buffer without closing window
vim.keymap.set('n', '<C-w>q', ':enew<bar>bd #<cr>', { silent = true })

--Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if vim.uv.fs_stat(lazypath) then
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

require 'lazy'.setup({
  { 'numToStr/Comment.nvim',  opts = {} },
  { 'kylechui/nvim-surround', event = "VeryLazy", opts = {} },
  ---- Completion and the editor plugins
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippets
      'L3MON4D3/LuaSnip',
      -- Completion sources
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete({}),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
        window = {
          documentation = {
            max_height = 0
          }
        }
      }
    end
  },
  -- UI
  {
    'dgox16/oldworld.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require 'oldworld'.setup {
        styles = {
          comments = { italic = true },
        },
      }
      vim.cmd.colorscheme("oldworld")
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = false,
          component_separators = '|',
          section_separators = '',
        },
      }
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      local telescope = require 'telescope'

      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ["<C-h"] = "which_key",
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
      }

      telescope.load_extension 'fzf'
      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader><leader>', builtin.buffers)
      vim.keymap.set('n', '<leader>sf', function()
        builtin.find_files { previewer = false }
      end)
      vim.keymap.set('n', '<leader>sb', builtin.current_buffer_fuzzy_find)
      vim.keymap.set('n', '<leader>sp', builtin.live_grep)
      vim.keymap.set('n', '<leader>sg', builtin.grep_string)
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics)
      vim.keymap.set('n', '<leader>sh', builtin.help_tags)
      vim.keymap.set('n', '<leader>so', builtin.oldfiles)
      vim.keymap.set('n', '<leader>ss', builtin.builtin)
      vim.keymap.set('n', '<leader>sr', builtin.resume)
    end
  },
  {
    'anuvyklack/windows.nvim',
    dependencies = 'anuvyklack/middleclass',
    config = function()
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require('windows').setup()
    end
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  -- Add indentation guides even on blank lines
  { 'lukas-reineke/indent-blankline.nvim', name = 'ibl', event = 'VimEnter' },
  -- Add git related info in the signs columns and popups
  {
    'lewis6991/gitsigns.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    }
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = { library = { path = "luvit-meta/library", words = { "vim%.uv" } } },
    dependencies = { { "Bilal2453/luvit-meta", lazy = true } },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = { {"Hoffs/omnisharp-extended-lsp.nvim", lazy = true } },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('pnivlek-lsp-attach', { clear = true }),
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wl', function()
            vim.inspect(vim.lsp.buf.list_workspace_folders())
          end, opts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.api.nvim_create_user_command("Format", function()
            vim.lsp.buf.format { async = true }
          end, {})
        end
      })

      -- nvim-cmp supports additional completion capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require 'cmp_nvim_lsp'.default_capabilities())

      local servers = {
        pyright = {},
        ansiblels = {},
        terraformls = {},
        omnisharp = {
          cmd = { "/usr/bin/omnisharp" },
          handlers = {
            ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
            ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
            ["textDocument/references"] = require('omnisharp_extended').references_handler,
            ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
          },
        },
        gopls = {},
        rust_analyzer = {},
        ts_ls = {},
        bashls = {},
        lua_ls = {
          diagnostics = { globals = { 'vim', 'require' } }
        }
      }
      for server, config in pairs(servers) do
        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require 'lspconfig'[server].setup(config)
      end
    end
  },
  ---- Tools
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects', -- tree objects go brrr
      'nvim-treesitter/nvim-treesitter-context',     -- How to find the tree
      'p00f/nvim-ts-rainbow',                        -- make the twigs pretty
      'gpanders/editorconfig.nvim',                  -- tabs dont do weird stuff anymore!
    },
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'go', 'java', 'lua', 'luadoc', 'python', 'rust', 'vim', 'vimdoc' },
      highlight = {
        enable = true, -- false will disable the whole extension
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
      indent = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        lsp_interop = {
          enable = true,
          border = 'none',
          floating_preview_opts = {},
          peek_definition_code = {
            ["<leader>df"] = "@function.outer",
            ["<leader>dF"] = "@class.outer",
          },
        },
      },
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
      }
    },
    config = function(_, opts)
      require 'nvim-treesitter.configs'.setup { opts }
    end
  },
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      require 'nvim-tmux-navigation'.setup {
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        }
      }
    end
  },
  ---- Language specific plugins
  {
    'pearofducks/ansible-vim',
    ft = 'ansible',
    init = function()
      vim.g.ansible_ftdetect_filename_regex = '\\v(' .. table.concat({
        '*/ansible/*',
        '*/tasks/*',
        '*/handlers/*',
        '*/tests/*',
        'main',
        'site',
        'playbook',
      }, '|') .. ').ya?ml$'
    end,
  },
  'hashivim/vim-terraform',
}, {})
-- vim: ts=2 sts=2 sw=2 et
