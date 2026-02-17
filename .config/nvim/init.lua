
--Set path for finding folders.
vim.o.path = vim.o.path .. "**"

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

-- Format settings
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.list = true
vim.o.listchars = "trail:·,tab:»·,eol: "

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Netrw will sometimes be unable to close under any circumstance if this isn't set. I think it happens when I open the directory when nvim starts.
vim.g.netrw_fastbrowse = 0

-- Set completeopt to have a better completion experience
-- vim.o.completeopt = 'menuone,noselect'
vim.o.completeopt = "menu,menuone,noinsert"

-- Open to the right.
vim.o.splitright = true

--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Close buffer without closing window
vim.keymap.set("n", "<C-w>q", ":enew<bar>bd #<cr>", { silent = true })

--Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "numToStr/Comment.nvim", opts = {} },
	{ "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
	---- Completion and the editor plugins
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippets
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = "make install_jsregexp",
				dependencies = {
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load({
							exclude = { "terraform" },
						})
					end,
				},
			},
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "super-tab",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			fuzzy = {
				implementation = "prefer_rust",
			},
			sources = {
				default = { "lsp", "path", "snippets" },
			},
			snippets = { preset = "luasnip" },
			signature = { enabled = true },
			completion = {
				trigger = { show_in_snippet = false },
			},
		},
	},
	{
		"amitds1997/remote-nvim.nvim",
		version = "*", -- Pin to GitHub releases
		dependencies = {
			"nvim-lua/plenary.nvim", -- For standard functions
			"MunifTanjim/nui.nvim", -- To build the plugin UI
			"nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
		},
		opts = {
			client_callback = function(port, workspace_config)
				local cmd = ("tmux new-window -n '%s' nvim --server localhost:%s --remote-ui"):format(
					workspace_config.host,
					port
				)
				vim.fn.jobstart(cmd, {
					detach = true,
					on_exit = function(job_id, exit_code, event_type)
						-- This function will be called when the job exits
						print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
					end,
				})
			end,
		},
	},
	-- UI
	{
		"ribru17/bamboo.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.o.background = "dark"
			vim.o.termguicolors = true
			require("bamboo").setup({})
			vim.cmd.colorscheme("bamboo")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					component_separators = "|",
					section_separators = "",
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
		},
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-h"] = "which_key",
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
				},
			})

			telescope.load_extension("fzf")
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader><leader>", builtin.buffers)
			vim.keymap.set("n", "<leader>sf", function()
				builtin.find_files({ previewer = false })
			end)
			vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find)
			vim.keymap.set("n", "<leader>sp", builtin.live_grep)
			vim.keymap.set("n", "<leader>sg", builtin.grep_string)
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics)
			vim.keymap.set("n", "<leader>sh", builtin.help_tags)
			vim.keymap.set("n", "<leader>so", builtin.oldfiles)
			vim.keymap.set("n", "<leader>ss", builtin.builtin)
			vim.keymap.set("n", "<leader>sr", builtin.resume)
		end,
	},
	{
		"anuvyklack/windows.nvim",
		dependencies = "anuvyklack/middleclass",
		config = function()
			vim.o.winminwidth = 10
			vim.o.equalalways = false
			require("windows").setup()
		end,
	},
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		ft = { "org" },
		config = function()
			-- Setup orgmode
			require("orgmode").setup({
				org_use_property_inheritance = true,
				hyperlinks = { sources = {} },
				org_edit_src_filetype_map = {},
				org_agenda_files = "~/orgfiles/**/*",
				org_default_notes_file = "~/orgfiles/refile.org",
				org_capture_templates = {
					t = {
						target = "~/orgfiles/todo/todo.org",
						description = "Personal todo",
						headline = "Soon",
						template = "* [ ] %? \n %i %a",
					},
					k = {
						description = "Tasks",
						subtemplates = {
							k = {
								target = "~/orgfiles/todo/todo.org",
								description = "Task",
								headline = "Tasks",
								template = "* [ ] %? %^G%{extra}\n%i %a",
							},
							d = {
								target = "~/orgfiles/todo/todo.org",
								description = "Task",
								headline = "Tasks",
								template = "* [ ] %? %^G%{extra}\n%i %a\nDEADLINE: %^{Deadline:}t",
							},
							s = {
								target = "~/orgfiles/todo/todo.org",
								description = "Task",
								headline = "Tasks",
								template = "* [ ] %? %^G%{extra}\n%i %a\nSCHEDULED: %^{Scheduled:}t",
							},
						},
					},
				},
			})
		end,
	},
	-- Add indentation guides even on blank lines
	{ "lukas-reineke/indent-blankline.nvim", name = "ibl", event = "VimEnter" },
	-- Add git related info in the signs columns and popups
	{
		"lewis6991/gitsigns.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = { library = { path = "luvit-meta/library", words = { "vim%.uv" } } },
		dependencies = { { "Bilal2453/luvit-meta", lazy = true } },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"numine777/py-bazel.nvim",
			"mfussenegger/nvim-jdtls",
			"saghen/blink.cmp",
			{ "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("pnivlek-lsp-attach", { clear = true }),
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set("n", "grs", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.api.nvim_create_user_command("Format", function()
						vim.lsp.buf.format({ async = true })
					end, {})

					-- Taken from kickstart.nvim - highlights references to the word under your cursor.
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("pnivlek-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("pnivlek-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "pnivlek-lsp-highlight", buffer = event2.buf })
							end,
						})
					end
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				bashls = {},
				ansiblels = {},
				terraformls = {},
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							-- workspaceFiles = {
							--   "**/BUILD",
							--   "**/WORKSPACE",
							--   "**/*.{bzl,bazel}",
							-- },
							-- env = {
							--   GOPACKAGESDRIVER = "/Users/kporter/.config/nvim/tools/gopackagesdriver.sh",
							-- },
							directoryFilters = {
								"-bazel-bin",
								"-bazel-out",
								"-bazel-testlogs",
							},
						},
					},
				},
				omnisharp = {
					handlers = {
						["textDocument/definition"] = require("omnisharp_extended").definition_handler,
						["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,
						["textDocument/references"] = require("omnisharp_extended").references_handler,
						["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
					},
				},
				golangci_lint_ls = {},
				lua_ls = {
					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								path ~= vim.fn.stdpath("config")
								and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
							then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								version = "LuaJIT",
								path = { "lua/?.lua", "lua/?/init.lua" },
							},
							workspace = {
								checkThirdParty = false,
								-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
								--  See https://github.com/neovim/nvim-lspconfig/issues/3189
								library = vim.api.nvim_get_runtime_file("", true),
							},
						})
					end,
					settings = {
						Lua = {},
					},
				},
				jdtls = {
					settings = {
						java = {
							root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }),
						},
					},
				},
				pyright = {},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-lspconfig").setup({ ensure_installed = ensure_installed })

			for server, cfg in pairs(servers) do
				cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})

				vim.lsp.config(server, cfg)
				vim.lsp.enable(server)
			end
		end,
	},
	---- Tools
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context", -- How to find the tree
			"hiphish/rainbow-delimiters.nvim", -- make the twigs pretty
			"gpanders/editorconfig.nvim", -- tabs dont do weird stuff anymore!
		},
		build = ":TSUpdate",
		config = function()
			local filetypes = {
				"bash",
				"c",
				"dockerfile",
				"diff",
				"gitcommit",
				"go",
				"hcl",
				"html",
				"java",
				"javadoc",
				"json",
				"lua",
				"luadoc",
				markdown = { filetypes = { "AgenticChat", "markdown" } },
				"markdown_inline",
				"python",
				"query",
				"rust",
				starlark = { filetypes = { "bzl" } },
				"terraform",
				"vim",
				"vimdoc",
				yaml = { filetypes = { "ansible", "yaml", "yml" } }, -- ansible
			}

			local pattern = vim.iter(vim.iter(filetypes)
				:map(function(k)
					local v = filetypes[k]
					if type(v) == "table" then
						vim.treesitter.language.register(k, v.filetypes)
						return v.filetypes
					end
					return { v }
				end)
				:totable())
				:flatten(1)
				:totable()

			-- This can get optimized away on (at least) mac neovim,
			-- leading to a manual vim.treesitter.start() call.
			jit.opt.start(0)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = pattern,
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(ft)

					if not vim.treesitter.language.add(lang) then
						local available = vim.g.ts_available or require("nvim-treesitter").get_available()
						if not vim.g.ts_available then
							vim.g.ts_available = available
						end

						if vim.tbl_contains(available, lang) then
							require("nvim-treesitter").install(lang)
						end
					end

					if vim.treesitter.language.add(lang) then
						vim.treesitter.start(args.buf, lang)
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						-- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
						-- vim.wo[0][0].foldmethod = "expr"
					end
				end,
			})
			jit.opt.start(3)
		end,
	},

	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			require("nvim-tmux-navigation").setup({
				disable_when_zoomed = true, -- defaults to false
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
					last_active = "<C-\\>",
					next = "<C-Space>",
				},
			})
		end,
	},
	{
		"carlos-algms/agentic.nvim",
		event = "VeryLazy",
		opts = {
			provider = "codex-acp", -- claude-acp, gemini-acp, codex-acp, opencode-acp
			diff_preview = {
				enabled = true,
				layout = "split",
				center_on_navigate_hunks = true,
			},
		},
		keys = {
			{
				"<C-\\>",
				function()
					require("agentic").toggle()
				end,
				desc = "Agentic Open",
				mode = { "n", "v", "i" },
			},

			{
				"<C-'>",
				function()
					require("agentic").add_selection_or_file_to_context()
				end,
				desc = "Agentic add selection or current file to context",
				mode = { "n", "v" },
			},
			{
				"<C-,>",
				function()
					require("agentic").new_session()
				end,
				mode = { "n", "v", "i" },
				desc = "New Agentic Session",
			},
		},
	},
	---- Language specific plugins
	{
		"pearofducks/ansible-vim",
		ft = "ansible",
		init = function()
			vim.g.ansible_ftdetect_filename_regex = "\\v("
				.. table.concat({
					"*/ansible/*",
					"*/tasks/*",
					"*/handlers/*",
					"*/tests/*",
					"main",
					"site",
					"playbook",
				}, "|")
				.. ").ya?ml$"
		end,
	},
	"hashivim/vim-terraform",
}, {})
-- vim: ts=2 sts=2 sw=2 et
