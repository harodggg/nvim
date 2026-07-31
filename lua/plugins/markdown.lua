return {
	-- 1. 浏览器实时预览
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	-- 2. 表格自动对齐
	{
		"dhruvasagar/vim-table-mode",
		ft = { "markdown" },
	},

	-- 3. 终端 Markdown 渲染 (可选)
	{
		"ellisonleao/glow.nvim",
		config = true,
		cmd = { "Glow" },
	},
}
