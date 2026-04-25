return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "rust", "go", "lua", "markdown" },
			highlight = { enable = true },
		},
	},
}
