-- ~/.config/nvim/lua/plugins/dap.lua
return {
	{
		"mfussenegger/nvim-dap",
		lazy = false, -- 确保插件立即加载，避免 require 返回 nil
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- 自动打开/关闭调试界面
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- ==================== 快捷键 ====================
			vim.keymap.set("n", "<F5>", function()
				dap.continue()
			end, { desc = "启动/继续" })
			vim.keymap.set("n", "<F10>", function()
				dap.step_over()
			end, { desc = "单步跳过" })
			vim.keymap.set("n", "<F11>", function()
				dap.step_into()
			end, { desc = "单步进入" })
			vim.keymap.set("n", "<F12>", function()
				dap.step_out()
			end, { desc = "单步跳出" })
			vim.keymap.set("n", "<Leader>b", function()
				dap.toggle_breakpoint()
			end, { desc = "切换断点" })
			vim.keymap.set("n", "<Leader>B", function()
				dap.set_breakpoint(vim.fn.input("条件断点: "))
			end, { desc = "条件断点" })
			vim.keymap.set("n", "<Leader>lp", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("日志消息: "))
			end, { desc = "日志点" })
			vim.keymap.set("n", "<Leader>dr", function()
				dap.repl.open()
			end, { desc = "打开 REPL" })
			vim.keymap.set("n", "<Leader>dl", function()
				dap.run_last()
			end, { desc = "运行上次配置" })

			-- ==================== 各语言适配器 ====================

			-- Python (需要: pip install debugpy)
			dap.adapters.python = {
				type = "executable",
				command = "python3",
				args = { "-m", "debugpy.adapter" },
			}
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					console = "integratedTerminal",
				},
			}

			-- JavaScript / TypeScript (需要 Mason 安装 js-debug-adapter)
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			}
			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.typescript = dap.configurations.javascript

			-- C / C++ / Rust (需要 Mason 安装 codelldb)
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.exepath("codelldb") or "codelldb",
					args = { "--port", "${port}" },
				},
			}
			dap.configurations.c = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.cpp = dap.configurations.c
			dap.configurations.rust = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			-- Go (需要: go install github.com/go-delve/delve/cmd/dlv@latest)
			dap.adapters.go = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}
			dap.configurations.go = {
				{
					type = "go",
					name = "Debug file",
					request = "launch",
					program = "${file}",
				},
			}

			-- 可继续添加其他语言适配器...
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		opts = {},
	},
}
