return {
	{
		"sainnhe/sonokai",
		lazy = false, -- 主题必须在启动时加载
		priority = 1000, -- 确保在其他 UI 插件之前渲染
		config = function()
			-- 在加载主题前设置配置变量
			-- 'shusia' (默认), 'maia', 'espresso', 'atlantis', 'andromeda'
			vim.g.sonokai_style = "atlantis"

			-- 允许透明背景（如果你喜欢配合终端透明度）
			-- vim.g.sonokai_transparent_background = 1

			-- 更好的诊断颜色（配合 LSP）
			vim.g.sonokai_diagnostic_text_highlight = 1
			vim.g.sonokai_diagnostic_line_highlight = 1

			-- 正式启用主题
			vim.cmd([[colorscheme sonokai]])
		end,
	},
	--	{
	--		"catppuccin/nvim",
	--		name = "catppuccin",
	--		priority = 1000,
	--
	--		config = function()
	--			require("catppuccin").setup({
	--				theme = "",
	--			})
	--			vim.cmd("colorscheme catppuccin")
	--		end,
	--	},

	--	-- 1. Kanagawa 主题：提供深沉、护眼的背景
	--	{
	--		"rebelot/kanagawa.nvim",
	--		lazy = false, -- 主题不应延迟加载
	--		priority = 1000, -- 确保最高优先级
	--		config = function()
	--			require("kanagawa").setup({
	--				theme = "dragon", -- 可选 "wave", "dragon", "lotus"
	--				background = { dark = "dragon", light = "dragon" },
	--			})
	--			vim.cmd("colorscheme kanagawa") -- 正式启用
	--		end,
	--	},

	-- 2. Noice.nvim：重塑命令行、搜索栏和通知系统
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				-- 覆盖 LSP 的浮窗显示
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.styled_parts"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true, -- 底部搜索栏
				command_palette = true, -- 命令面板
				long_message_to_split = true, -- 长消息自动拆分
				inc_rename = false, -- 如果你安装了 inc-rename.nvim 可开启
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim", -- UI 组件库
			"rcarriga/nvim-notify", -- 漂亮的通知弹窗
		},
	},

	-- 3. Telescope.nvim：强大的模糊查找与预览界面
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			defaults = {
				path_display = { "truncate" },
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = { prompt_position = "top", preview_width = 0.55 },
				},
			},
		},
	},

	-- 4. Lualine.nvim：动感十足的状态栏
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "kanagawa",
				component_separators = "|",
				section_separators = { left = "", right = "" },
			},
		},
	},

	-- 5. Indent-blankline.nvim (IBL)：清晰的缩进引导线
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = "│" },
			scope = { enabled = true, show_start = true }, -- 高亮当前代码块的作用域
		},
	},
}
