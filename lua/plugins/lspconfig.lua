return {
  -- LSP Configuration & Servers
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- This function contains all your standard keymaps and auto-formatting logic.
      local on_attach = function(client, bufnr)
        -- Set up keymaps for the current buffer
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        map('n', 'gD', vim.lsp.buf.declaration, 'Go to Declaration')
        map('n', 'gd', vim.lsp.buf.definition, 'Go to Definition')
        map('n', 'gi', vim.lsp.buf.implementation, 'Go to Implementation')
        map('n', '<leader>K', vim.lsp.buf.hover, 'Hover Documentation')
        map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')

        -- Custom format keymap
        map('n', '<leader>f', function()
          vim.lsp.buf.format({ async = true })
        end, 'Format code')

        -- Enable format on save if the server supports it
        if client.supports_method('textDocument/formatting') then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = true })
            end,
          })
        end

        -- Handle special cases for linters like Eslint
        if client.name == 'eslint' then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll',
          })
        end
      end

      -- --- MASON-LSPCONFIG SETUP ---
      -- This handler function will run for every LSP server installed by Mason.
      require('mason-lspconfig').setup({
        ensure_installed = {
          "ts_ls", "lua_ls", "tailwindcss", "prismals", "cssls", "pyright",
          "eslint", "dockerls", "astro", "bashls", "jsonls", "yamlls", "gopls"
        },
        handlers = {
          -- Default handler for all servers
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end,

          -- Override handler for specific servers if needed
          ['lua_ls'] = function()
            lspconfig['lua_ls'].setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                Lua = {
                  runtime = { version = 'LuaJIT' },
                  diagnostics = { globals = { 'vim' } },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = { enable = false },
                },
              },
            })
          end,
        },
      })

      -- --- DIAGNOSTICS CONFIGURATION ---
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      })

      -- Custom signs for diagnostics in the sign column
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          }
        }
      })
    end,
  },

  ---
  -- Flutter Tools (includes Dart LSP setup)
  -- The configuration for this plugin remains largely the same as it's a specific-purpose tool.
  -- We just need to make sure the `on_attach` function is correct for its use case.
  ---
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    ft = 'dart',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      -- The flutter-tools on_attach will be called by flutter-tools, not the general mason-lspconfig handler.
      -- So we define it separately here.
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          if desc then desc = 'Flutter: ' .. desc end
          vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
        end

        map('n', '<leader>co', '<cmd>FlutterColorOn<CR>', 'Color Picker On')
        map('n', '<leader>cf', '<cmd>FlutterColorOff<CR>', 'Color Picker Off')
        map('n', '<leader>f', vim.lsp.buf.format, 'Format code') -- Re-add your format keybind
      end

      require("flutter-tools").setup {
        capabilities = capabilities,
        lsp = {
          on_attach = on_attach,
          color = {
            enabled = true,
            background = true,
            virtual_text = true,
            virtual_text_str = "■",
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            enableSnippets = true,
          },
        },
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "ErrorMsg",
          prefix = "// ",
          enabled = true
        },
        decorations = {
          statusline = {
            app_version = false,
            device = true,
          }
        },
        dev_log = {
          enabled = true,
          open_cmd = "tabedit",
        },
        dev_tools = {
          autolaunch = false,
          auto_open_devtools = "never",
        },
        debugger = {
          enabled = false,
          run_via_dap = false,
        },
        ui = {
          border = "rounded",
          notification_style = "native",
        },
      }

      vim.keymap.set("n", "<leader>;t", "<cmd>FlutterOutlineToggle<CR>")
      vim.keymap.set("n", "<leader>;m", "<cmd>Telescope flutter commands<CR>")
    end
  },

  ---
  -- MASON for LSP server management
  -- These configurations are fine and work as intended.
  ---
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    -- The config for this is now merged into the main nvim-lspconfig section above.
  },
}
