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
    {"yaocccc/nvim-hlchunk"},
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		opts = {
			-- add options here
			-- or leave it empty to use the default settings
		},
		keys = {
			-- suggested keymap
			{ "zi", ":PasteImage<cr>", desc = "Paste image from system clipboard" },
		},
	},
	{ "puremourning/vimspector" },
	{ "tpope/vim-fugitive" },
	{ "navarasu/onedark.nvim" },
	{ "HiPhish/rainbow-delimiters.nvim" },
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{ "nvim-lua/plenary.nvim" },
	{ "lukas-reineke/indent-blankline.nvim" },

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
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
})

-- HACK: temporary fix to ensure rainbow delimiters are highlighted in real-time
vim.api.nvim_create_autocmd("BufRead", {
	desc = "Ensure treesitter is initialized???",
	callback = function()
		-- if this fails then it means no parser is available for current buffer
		if pcall(vim.treesitter.start) then
			vim.treesitter.start()
		end
	end,
})
require("nvim-treesitter/configs").setup({
	ensure_installed = { "markdown", "python", "rust", "javascript", "bash", "lua", "vim", "c" },
	sync_install = true,
	auto_install = true,

	highlight = {
		enable = false,
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
		comments = "bold",
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
			require("formatter.filetypes.python").autopep8,
			require("formatter.filetypes.python").autopep8(),
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
		markdown = {
			require("formatter.filetypes.markdown").denofmt,
			require("formatter.filetypes.markdown").denofmt(),
		},

		toml = {
			require("formatter.filetypes.toml").taplo,
			require("formatter.filetypes.toml").taplo(),
		},

		yaml = {
			require("formatter.filetypes.yaml").yamlfmt,
			require("formatter.filetypes.yaml").yamlfmt(),
		},

		sh = {
			require("formatter.filetypes.sh").shfmt,
			require("formatter.filetypes.sh").shfmt(),
		},

		json = {
			require("formatter.filetypes.json").jq,
			require("formatter.filetypes.json").jq(),
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

-- rainbow
-- This module contains a number of default definitions
local rainbow_delimiters = require("rainbow-delimiters")

---@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
	strategy = {
		[""] = rainbow_delimiters.strategy["global"],
		vim = rainbow_delimiters.strategy["local"],
	},
	query = {
		[""] = "rainbow-delimiters",
		lua = "rainbow-blocks",
		py = "rainbow-blocks",
		rs = "rainbow-delimiters",

	},
	priority = {
		[""] = 110,
		lua = 210,
        py = 210,
        rs = 210,
	},
	highlight = {
		"RainbowDelimiterRed",
		"RainbowDelimiterYellow",
		"RainbowDelimiterBlue",
		"RainbowDelimiterOrange",
		"RainbowDelimiterGreen",
		"RainbowDelimiterViolet",
		"RainbowDelimiterCyan",
	},
}

--- indent
local highlight = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}
local hooks = require("ibl.hooks")

-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
	vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
	vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
	vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
	vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
	vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
	vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup({ scope = { highlight = highlight } })

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>m", ":PasteImage<cr>", {})

