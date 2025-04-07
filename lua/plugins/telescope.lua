return {
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-telescope/telescope-file-browser.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			-- Telescope is a fuzzy finder that comes with a lot of different things that
			-- it can fuzzy find! It's more than just a "file finder", it can search
			-- many different aspects of Neovim, your workspace, LSP, and more!
			--
			-- The easiest way to use Telescope, is to start by doing something like:
			--  :Telescope help_tags
			--
			-- After running this command, a window will open up and you're able to
			-- type in the prompt window. You'll see a list of `help_tags` options and
			-- a corresponding preview of the help.
			--
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			--
			-- This opens a window that shows you all of the keymaps for the current
			-- Telescope picker. This is really useful to discover what Telescope can
			-- do as well as how to actually do it!

			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			require("telescope").setup({
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				--
				-- defaults = {
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>sp", builtin.git_files, { desc = "[sp] search for git files" })
			vim.keymap.set("n", "<leader>fg", builtin.git_status, { desc = "[G]it [S]tatus" })

			vim.keymap.set("n", "<leader>;f", function()
				local telescope = require("telescope")

				local function telescope_buffer_dir()
					return vim.fn.expand("%:p:h")
				end

				telescope.extensions.file_browser.file_browser({
					path = "%:p:h",
					cwd = telescope_buffer_dir(),
					respect_gitignore = false,
					hidden = true,
					grouped = true,
					previewer = false,
					initial_mode = "normal",
					layout_config = { height = 40 },
				})
			end, { desc = "[ ] Open File Browser with the path of the current buffer" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })

			-- View file history in Telescope floating window
			vim.keymap.set("n", "<leader>gh", function()
				require("telescope.builtin").git_bcommits()
			end, { desc = "File commit history in Telescope" })

			-- View commit history of the current file with patches
			vim.keymap.set("n", "<leader>gH", ":0Gclog --patch<CR>", { desc = "File commit history with patches" })

			-- View repo history in Telescope floating window
			vim.keymap.set("n", "<leader>gl", function()
				require("telescope.builtin").git_commits()
			end, { desc = "Repository commit history in Telescope" })
		end,
	},
}

-- return {
-- 	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
-- {
-- 		"telescope.nvim",
-- 		dependencies = {
-- 			{
-- 				"nvim-telescope/telescope-fzf-native.nvim",
-- 				build = "make",
-- 			},
-- 			"nvim-telescope/telescope-file-browser.nvim",
-- 		},
-- 		keys = {
-- 			{
-- 				"<leader>fP",
-- 				function()
-- 					require("telescope.builtin").find_files({
-- 						cwd = require("lazy.core.config").options.root,
-- 					})
-- 				end,
-- 				desc = "Find Plugin File",
-- 			},
-- 			{
-- 				";f",
-- 				function()
-- 					local builtin = require("telescope.builtin")
-- 					builtin.find_files({
-- 						no_ignore = false,
-- 						hidden = true,
-- 					})
-- 				end,
-- 				desc = "Lists files in your current working directory, respects .gitignore",
-- 			},
-- 			{
-- 				";r",
-- 				function()
-- 					local builtin = require("telescope.builtin")
-- 					builtin.live_grep({
-- 						additional_args = { "--hidden" },
-- 					})
-- 				end,
-- 				desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
-- 			},
-- 			{
-- 				";b",
-- 				function()
-- 					local builtin = require("telescope.builtin")
-- 					builtin.buffers()
-- 				end,
-- 				desc = "Lists open buffers",
-- 			},
-- 			{
-- 				";t",
-- 				function()
-- 					local builtin = require("telescope.builtin")
-- 					builtin.help_tags()
-- 				end,
-- 				desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
-- 			},
-- 			{
-- 				";;",
-- 				function()
-- 					local builtin = require("telescope.builtin")
-- 					builtin.resume()
-- 				end,
-- 				desc = "Resume the previous telescope picker",
-- 			},
-- 			{
-- 				";e",
-- 				function()
-- 					local builtin = require("telescope.builtin")
-- 					builtin.diagnostics()
-- 				end,
-- 				desc = "Lists Diagnostics for all open buffers or a specific buffer",
-- 			},
-- 			{
-- 				";s",
-- 				function()
-- 					local builtin = require("telescope.builtin")
-- 					builtin.treesitter()
-- 				end,
-- 				desc = "Lists Function names, variables, from Treesitter",
-- 			},
-- 			{
-- 				"<leader>sf",
-- 				function()
-- 					local telescope = require("telescope")
--
-- 					local function telescope_buffer_dir()
-- 						return vim.fn.expand("%:p:h")
-- 					end
--
-- 					telescope.extensions.file_browser.file_browser({
-- 						path = "%:p:h",
-- 						cwd = telescope_buffer_dir(),
-- 						respect_gitignore = false,
-- 						hidden = true,
-- 						grouped = true,
-- 						previewer = false,
-- 						initial_mode = "normal",
-- 						layout_config = { height = 40 },
-- 					})
-- 				end,
-- 				desc = "Open File Browser with the path of the current buffer",
-- 			},
-- 		},
-- 		config = function(_, opts)
-- 			local telescope = require("telescope")
-- 			local actions = require("telescope.actions")
-- 			local fb_actions = require("telescope").extensions.file_browser.actions
--
-- 			opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
-- 				wrap_results = true,
-- 				layout_strategy = "horizontal",
-- 				layout_config = { prompt_position = "top" },
-- 				sorting_strategy = "ascending",
-- 				winblend = 0,
-- 				mappings = {
-- 					n = {},
-- 				},
-- 			})
-- 			opts.pickers = {
-- 				diagnostics = {
-- 					theme = "ivy",
-- 					initial_mode = "normal",
-- 					layout_config = {
-- 						preview_cutoff = 9999,
-- 					},
-- 				},
-- 			}
-- 			opts.extensions = {
-- 				file_browser = {
-- 					theme = "dropdown",
-- 					-- disables netrw and use telescope-file-browser in its place
-- 					hijack_netrw = true,
-- 					mappings = {
-- 						-- your custom insert mode mappings
-- 						["n"] = {
-- 							-- your custom normal mode mappings
-- 							["N"] = fb_actions.create,
-- 							["h"] = fb_actions.goto_parent_dir,
-- 							["/"] = function()
-- 								vim.cmd("startinsert")
-- 							end,
-- 							["<C-u>"] = function(prompt_bufnr)
-- 								for i = 1, 10 do
-- 									actions.move_selection_previous(prompt_bufnr)
-- 								end
-- 							end,
-- 							["<C-d>"] = function(prompt_bufnr)
-- 								for i = 1, 10 do
-- 									actions.move_selection_next(prompt_bufnr)
-- 								end
-- 							end,
-- 							["<PageUp>"] = actions.preview_scrolling_up,
-- 							["<PageDown>"] = actions.preview_scrolling_down,
-- 						},
-- 					},
-- 				},
-- 			}
-- 			telescope.setup(opts)
-- 			require("telescope").load_extension("fzf")
-- 			require("telescope").load_extension("file_browser")
-- 		end,
-- 	}
-- }
