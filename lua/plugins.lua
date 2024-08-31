local function bootstrap_pckr()
	local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

	if not vim.uv.fs_stat(pckr_path) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/lewis6991/pckr.nvim",
			pckr_path,
		})
	end

	vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require("pckr").add({
	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
	{ "puremourning/vimspector" },
	{ "tpope/vim-fugitive" },
	{ "navarasu/onedark.nvim" },
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{ "nvim-lua/plenary.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	},

	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({
				default_mappings = true,
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"hedyhli/outline.nvim",
		config = function()
			-- Example mapping to toggle outline
			vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
		end,
	},
	{
		"neoclide/coc.nvim",
		branch = "release",
		run = ":CocInstall coc-rust coc-pyright coc-git coc-markdown coc-javascript coc-bash",
	},
	{ "mhartington/formatter.nvim" },
	{ "nvim-tree/nvim-web-devicons" },
	{
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").on_attach()
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
})

require("nvim-treesitter/configs").setup({
	ensure_installed = { "markdown", "python", "rust", "javascript", "bash", "lua", "vim", "c" },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
})

vim.cmd("colorscheme onedark")

require("outline").setup({
	outline_window = {
		-- Where to open the split window: right/left
		position = "right",
	},

	providers = {
		priority = { "coc", "markdown", "norg" },
		-- Configuration for each provider (3rd party providers are supported)
		markdown = {
			-- List of supported ft's to use the markdown provider
			filetypes = { "markdown" },
		},
	},
})
require("lualine").setup({
	options = {
		theme = "onedark",
	},
})

-- Lua
require("onedark").load()

-- Lua
require("onedark").setup({
	-- Main options --
	style = "dark", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
	transparent = false, -- Show/hide background
	term_colors = true, -- Change terminal color as per the selected theme style
	ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
	cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

	-- toggle theme style ---
	toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
	toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

	-- Change code style ---
	-- Options are italic, bold, underline, none
	-- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
	code_style = {
		comments = "italic",
		keywords = "italic",
		functions = "italic",
		strings = "italic",
		variables = "italic",
	},

	-- Lualine options --
	lualine = {
		transparent = false, -- lualine center bar transparency
	},

	-- Custom Highlights --
	colors = {}, -- Override default colors
	highlights = {}, -- Override highlight groups

	-- Plugins Config --
	diagnostics = {
		darker = true, -- darker colors for diagnostic
		undercurl = true, -- use undercurl instead of underline for diagnostics
		background = true, -- use background color for virtual text
	},
})

require("nvim-tree").setup({})

-- require("nvim-tree.api").tree.open()
-- require("outline").open()

local util = require("formatter.util")

require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {

		lua = {
			require("formatter.filetypes.lua").stylua,

			function()
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},
		python = {
			require("formatter.filetypes.python").autoflake,
			function()
				return {
					exe = "black",
					args = {
						"-q",
						"--stdin-filename",
						util.escape_path(util.get_current_buffer_file_name()),
						"-",
					},
					stdin = true,
				}
			end,
		},
		rust = {
			require("formatter.filetypes.rust").rustfmt,
			function()
				return {
					exe = "rustfmt",
					args = { "--edition 2021" },
					stdin = true,
				}
			end,
		},
		terraform = {
			require("formatter.filetypes.terraform").terraformfmt,
			function()
				return {
					exe = "terraform",
					args = { "fmt", "-" },
					stdin = true,
				}
			end,
		},

		json = {
			require("formatter.filetypes.json").jq,
			function()
				return {
					exe = "jq",
					args = {
						".",
					},
					stdin = true,
				}
			end,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
