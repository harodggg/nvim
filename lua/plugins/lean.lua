return {
	{
		"Julian/lean.nvim",
		event = { "BufReadPre *.lean", "BufNewFile *.lean" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-lua/plenary.nvim",

			-- 可选：增强体验的依赖插件
			"hrsh7th/nvim-cmp", -- 代码补全引擎
			"nvim-telescope/telescope.nvim", -- 用于定义跳转/搜索
			"AndrewRadev/switch.vim", -- 用于快速切换关键词 (如 true <-> false)
		},
		opts = {
			-- 自动向 nvim-lspconfig 注册 leanls
			lsp = {
				on_attach = function(client, bufnr)
					-- 在这里可以绑定你习惯的 LSP 快捷键
					local opts = { buffer = bufnr, silent = true }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				end,
			},

			-- 交互式证明窗口 (Infoview / Goal state) 配置
			infoview = {
				autoopen = true, -- 打开 .lean 文件时自动打开右侧 Infoview
				width = 50, -- Infoview 窗口宽度
				horizontal_position = "bottom", -- 也可以设为 "bottom" 放在底部
				separate_tab = false, -- 是否在独立 Tab 中打开
			},

			-- Unicode 符号输入配置 (\alpha -> α, \real -> ℝ 等)
			abbreviations = {
				enable = true, -- 开启类似 Lean VSCode 插件的 \ 快捷转义
				extra = {
					-- 你可以自定义额外的快捷转义
					-- my_symbol = "∑",
				},
			},

			-- 语法高亮与缩进
			ft = {
				nomodeline = true,
			},
		},
	},
}
