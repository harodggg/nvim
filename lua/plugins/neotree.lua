return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- 需要图标支持
		"MunifTanjim/nui.nvim",
	},
	keys = {
		-- 快捷键：使用 <leader>e 打开/关闭目录树
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
	},
	opts = {
		filesystem = {
			filtered_items = {
				visible = true, -- 是否显示隐藏文件 (如 .env)
				hide_dotfiles = false,
				hide_gitignored = false,
			},
			follow_current_file = { enabled = true }, -- 自动追踪当前打开的文件
		},
		window = {
			width = 30,
			mappings = {
				["<space>"] = "none", -- 禁用空格，防止干扰 leader key
			},
		},
	},
}
