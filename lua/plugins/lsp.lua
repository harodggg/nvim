return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- 1. 显式获取模块
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local lspconfig = require("lspconfig")

		-- 2. 严格按顺序初始化
		-- 先初始化 Mason 基础
		mason.setup()

		-- 再初始化 Mason 与 LSP 的桥接
		mason_lspconfig.setup({
			ensure_installed = { "lua_ls", "gopls", "rust_analyzer" },
		})
	end,
}
