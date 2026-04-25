return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" }, -- 在保存前触发
	cmd = { "ConformInfo" },
	keys = {
		{
			-- 手动格式化的快捷键：<leader>f
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		-- 1. 定义不同语言使用的格式化器
		formatters_by_ft = {
			lua = { "stylua" },
			-- 针对你的技术栈：
			go = { "gofmt", "goimports" },
			rust = { "rustfmt" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			sh = { "shfmt" },
		},
		-- 2. 开启保存时自动格式化
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true, -- 如果没找到专用格式化器，尝试用 LSP 格式化
		},
	},
}
