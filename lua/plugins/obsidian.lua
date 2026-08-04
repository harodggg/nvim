return {
	"epwalsh/obsidian.nvim",
	version = "*", -- 推荐使用最新稳定版
	lazy = true,
	-- 只有当打开你的 Obsidian 笔记目录下的文件时才延迟加载
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- 可选：用于模糊搜索笔记，推荐二选一
		"nvim-telescope/telescope.nvim",
		-- "ibhagwan/fzf-lua",
	},
	opts = {
		workspaces = {
			{
				name = "my-vault",
				-- 替换为你本地 clone 下来的 GitHub 仓库/Obsidian 库路径
				path = "~/GitHub/math",
			},
		},

		-- 配置双向链接的快捷跳转（默认用 gf 跳转）
		mappings = {
			-- 敲击 gf 快速跳转到光标下的双链笔记 [[Note]]
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- 切换复选框状态 [ ] -> [x]
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},

		-- 设置新笔记的命名规则
		note_id_func = function(title)
			-- 如果输入了标题，就用标题作为文件名；否则用时间戳
			if title ~= nil then
				return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				return tostring(os.time())
			end
		end,

		-- Markdown 链接语法支持
		completion = {
			nvim_cmp = true, -- 如果你用 nvim-cmp，开启 [[ 补全
			min_chars = 2,
		},
	},
}
