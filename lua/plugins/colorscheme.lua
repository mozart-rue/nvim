function ColorMyPencils(color)
	color = color or "rose-pine-moon"
	vim.cmd.colorscheme(color)
end

return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
			}
		end,
	},

	{ "erikbackman/brightburn.vim" },
	{ "savq/melange-nvim" },
	{ "bluz71/vim-nightfly-colors" },
	{ "ribru17/bamboo.nvim" },
	{ "AlexvZyl/nordic.nvim" },
	{ "rebelot/kanagawa.nvim" },
	{ "neanias/everforest-nvim" },
	{ "ntk148v/habamax.nvim", dependencies = { "rktjmp/lush.nvim" } },

	{
		"sainnhe/sonokai",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
			}
		end,
	},

	{
		"Mofiqul/dracula.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
			}
		end,
	},

	{
		"scottmckendry/cyberdream.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
				italic_comments = true,
			}
		end,
	},

	{
		"navarasu/onedark.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
				style = "deep",
				lualine = {
					transparent = true,
				},
			}
		end,
	},

	{
		"0xstepit/flow.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("flow").setup({
				transparent = true, -- Set transparent background.
				fluo_color = "pink", --  Fluo color: pink, yellow, orange, or green.
				mode = "normal", -- Intensity of the palette: normal, bright, desaturate, or dark. Notice that dark is ugly!
				aggressive_spell = false, -- Display colors for spell check.
			})

			-- vim.cmd "colorscheme flow"
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		opts = {},
		config = function()
			ColorMyPencils()
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		config = function()
			require("gruvbox").setup({
				terminal_colors = true, -- add neovim terminal colors
				undercurl = true,
				underline = false,
				bold = true,
				italic = {
					strings = false,
					emphasis = false,
					comments = false,
					operators = false,
					folds = false,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true, -- invert background for search, diffs, statuslines and errors
				contrast = "", -- can be "hard", "soft" or empty string
				palette_overrides = {},
				overrides = {},
				dim_inactive = false,
				transparent_mode = true,
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		config = function()
			require("tokyonight").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
				transparent = true, -- Enable this to disable setting the background color
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = false },
					keywords = { italic = false },
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "dark", -- style for sidebars, see below
					floats = "dark", -- style for floating windows
				},
			})
		end,
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				disable_background = true,
				styles = {
					italic = false,
				},
			})
		end,
	},

	{
		"zenbones-theme/zenbones.nvim",
		-- Optionally install Lush. Allows for more configuration or extending the colorscheme
		-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
		-- In Vim, compat mode is turned on as Lush only works in Neovim.
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000,
		-- you can set set configuration options here
		config = function()
			vim.g.zenbones_darken_comments = 45
		end,
	},
}
