return {
	{
		"Julian/lean.nvim",
		event = { "BufReadPre *.lean", "BufNewFile *.lean" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-lua/plenary.nvim",

			-- 可选依赖
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
		},
		-- 核心修改：使用 config 代替 opts，手动设置 vim.g.lean_config
		config = function()
			vim.g.lean_config = {
				lsp = {
					on_attach = function(client, bufnr)
						local opts = { buffer = bufnr, silent = true }
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
						vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
						vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					end,
				},
				infoview = {
					autoopen = true,
					width = 50,
				},
				abbreviations = {
					enable = true,
				},
			}
		end,
	},
}
