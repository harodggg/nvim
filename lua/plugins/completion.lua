return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- 仅在进入插入模式时加载，优化启动速度
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- 核心：获取 LSP 的补全建议
			"hrsh7th/cmp-buffer", -- 从当前文件内容获取补全
			"hrsh7th/cmp-path", -- 文件路径补全
			"L3MON4D3/LuaSnip", -- 代码片段引擎 (Snippets)
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets", -- 预设的常用代码片段 (如 Go 的 if err != nil)
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping.select_next_item(), -- 下一个建议
					["<S-Tab>"] = cmp.mapping.select_prev_item(), -- 上一个建议
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- 回车确认
					["<C-Space>"] = cmp.mapping.complete(), -- 手动强制弹出补全
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- 优先级 1: LSP (最准)
					{ name = "luasnip" }, -- 优先级 2: 代码片段
				}, {
					{ name = "buffer" }, -- 优先级 3: 文本内容
					{ name = "path" }, -- 优先级 4: 路径
				}),
			})
		end,
	},
}
