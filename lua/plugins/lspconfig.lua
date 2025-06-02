return {
  -- LSP Configuration & Servers
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' }, -- Load LSP configuration early for attached events
    dependencies = {
      -- cmp-nvim-lsp provides LSP completion capabilities
      { 'hrsh7th/cmp-nvim-lsp' },

      -- Optional: Mason for easy LSP server installation
      -- { 'williamboman/mason.nvim', cmd = 'Mason' },
      -- { 'williamboman/mason-lspconfig.nvim' },

      -- Optional: Nice icons for completion and diagnostics
      -- { 'nvim-tree/nvim-web-devicons', lazy = true }, -- For filetype icons
      -- { 'onsails/lspkind.nvim', event = 'VeryLazy' }, -- For nice completion kind icons
    },
    config = function()
      local lspconfig = require('lspconfig')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local capabilities = cmp_nvim_lsp.default_capabilities() -- Get capabilities AFTER cmp-nvim-lsp is loaded

      -- Formatting autocmd function
      local augroup_format = vim.api.nvim_create_augroup("LspFormat", { clear = true })
      local enable_format_on_save = function(_, bufnr)
        vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup_format,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr, async = true }) -- Use async formatting
          end,
        })
      end

      -- Standard on_attach function (called for each server)
      local on_attach = function(client, bufnr)
        -- Use vim.keymap.set for modern keybindings
        local map = function(mode, lhs, rhs, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end
          vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
        end

        -- Keybindings (add descriptions for which-key etc.)
        map('n', 'gD', vim.lsp.buf.declaration, 'Go to Declaration')
        -- map('n', 'gd', vim.lsp.buf.definition, 'Go to Definition') -- Original commented out
        map('n', 'gi', vim.lsp.buf.implementation, 'Go to Implementation')
        -- map('n', 'K', vim.lsp.buf.hover, 'Hover Documentation') -- Original commented out
        map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
        map('n', 'gr', '<cmd>Trouble lsp_references<cr>', 'Go to References (Trouble)') -- Example using Trouble.nvim

        -- Enable formatting on save *if* the server supports it
        if client.supports_method('textDocument/formatting') then
          enable_format_on_save(client, bufnr)
        end

        -- Add additional capabilities or settings based on client capabilities if needed
        -- if client.server_capabilities.documentHighlightProvider then ... end
      end

      -- ----- Server Setup -----
      -- Use a loop or mason-lspconfig for cleaner setup (see optional Mason setup below)
      lspconfig.ts_ls.setup {
        on_attach = on_attach,
        filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
        -- cmd is often handled by mason-lspconfig or PATH, uncomment if needed manually
        -- cmd = { "typescript-language-server.cmd", "--stdio" },
        capabilities = capabilities,
      }

      -- Example: Setup Lua (using lua_ls)
      lspconfig.lua_ls.setup { -- Use lua_ls instead of sumneko_lua
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr) -- Call the standard on_attach
          -- Note: Lua formatting on save is already handled by the standard on_attach
          -- if the server supports it. The old `enable_format_on_save` call here might
          -- be redundant unless lua_ls requires special handling or wasn't reporting
          -- formatting capability correctly before. Test if removing it works.
          -- enable_format_on_save(client, bufnr)
        end,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' }, -- Adjust as needed
            diagnostics = { globals = { 'vim' } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false -- Consider 'true' for checking deps like plenary, telescope
            },
            telemetry = { enable = false },
          },
        },
      }

      -- Add setups for other servers, reusing on_attach and capabilities
      lspconfig.flow.setup { on_attach = on_attach, capabilities = capabilities }
      lspconfig.sourcekit.setup { on_attach = on_attach, capabilities = capabilities } -- Ensure sourcekit LS is installed
      lspconfig.tailwindcss.setup { on_attach = on_attach, capabilities = capabilities }
      lspconfig.prismals.setup { on_attach = on_attach, capabilities = capabilities }
      lspconfig.cssls.setup { on_attach = on_attach, capabilities = capabilities }
      lspconfig.pyright.setup { on_attach = on_attach, capabilities = capabilities }
      lspconfig.eslint.setup {
        on_attach = on_attach,
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        -- cmd = { "vscode-eslint-language-server", "--stdio" }, -- Handled by Mason or PATH
        capabilities = capabilities
      }
      lspconfig.dockerls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        -- cmd = { "docker-langserver.cmd", "--stdio" }, -- Handled by Mason or PATH
        filetypes = { "dockerfile" },
      }
      lspconfig.astro.setup { on_attach = on_attach, capabilities = capabilities }

      -- Elixir language server
      lspconfig.elixirls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "elixir", "eelixir", "heex", "surface" },
        settings = {
          elixirLS = {
            dialyzerEnabled = true,
            fetchDeps = false,
            enableTestLenses = true,
            suggestSpecs = true,
          }
        }
      }

      -- PHP (intelephense) language server
      lspconfig.intelephense.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "php" },
        settings = {
          intelephense = {
            stubs = {
              "bcmath", "bz2", "calendar", "Core", "curl", "date", "dom", "mysqli",
              "filter", "ftp", "gd", "gettext", "hash", "iconv", "imap", "intl",
              "json", "ldap", "libxml", "mbstring", "mcrypt", "mysql", "pcntl",
              "pdo", "pgsql", "Phar", "readline", "regex", "session", "SimpleXML",
              "sockets", "sodium", "standard", "superglobals", "tokenizer", "xml",
              "xdebug", "xmlreader", "xmlwriter", "yaml", "zip", "zlib"
            },
            -- environment = {
            --   phpVersion = "8.2", -- Set your PHP version here
            -- },
            format = {
              enable = true, -- Enable formatting
            },
            diagnostics = {
              enable = true, -- Enable diagnostics
            },
          },
        },
      }

      -- Dart is often handled by flutter-tools (see below), but if you need dartls separately:
      -- lspconfig.dartls.setup { on_attach = on_attach, capabilities = capabilities }


      -- ----- Diagnostics Configuration -----
      -- Customize diagnostic appearance
      -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      --   vim.lsp.diagnostic.on_publish_diagnostics, {
      --     underline = true,
      --     update_in_insert = false, -- Don't update diagnostics in insert mode
      --     virtual_text = { spacing = 4, prefix = "●" }, -- Use prefix instead of severity icons here
      --     severity_sort = true,
      --   }
      -- )

      vim.diagnostic.config({
        underline = true,
        update_in_insert = false, -- Don't update diagnostics in insert mode
        virtual_text = { spacing = 4, prefix = "●" }, -- Use prefix instead of severity icons
        severity_sort = true,
      })

      -- Use custom signs for diagnostics in the sign column
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = signs.Error,
            [vim.diagnostic.severity.WARN] = signs.Warn,
            [vim.diagnostic.severity.HINT] = signs.Hint,
            [vim.diagnostic.severity.INFO] = signs.Info,
          }
        }
      })

      -- Configure diagnostic float window
      vim.diagnostic.config({
        virtual_text = false, -- Disable virtual text inline in favor of signs/float
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = true, -- Show source of diagnostic eg. "eslint"
          header = "",
          prefix = "",
        },
      })

      -- Optional: Dim unused code
      vim.api.nvim_set_hl(0, 'LspCodeLens', { link = 'Comment' }) -- Make CodeLens less obtrusive
      vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'LspReferenceRead', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'LspReferenceWrite', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { link = 'Comment' }) -- Dim unused variables
    end,
  },

  -- Flutter Tools (includes Dart LSP setup)
  {
    'akinsho/flutter-tools.nvim',
    lazy = false, -- Load early if you work with Flutter often, or use ft = 'dart'
    ft = 'dart',  -- Load only when opening Dart files
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig', -- Ensure LSP config is loaded
      -- Optional: nvim-dap for debugging support
      -- 'mfussenegger/nvim-dap',
    },
    config = function()
      -- Need capabilities and on_attach from lspconfig setup.
      -- Lazy loads plugins in order, but config functions run in isolation.
      -- Easiest is to re-require/re-define them here.
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      -- Optional: Add lspkind symbols if using lspkind.nvim
      -- capabilities = require('lspkind').enhance_capabilities(capabilities)

      -- Define a minimal on_attach or reuse the one from lspconfig if structured differently
      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          if desc then desc = 'Flutter: ' .. desc end
          vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
        end
        -- Add flutter specific keymaps here if needed, or rely on generic LSP maps
        map('n', '<leader>co', '<cmd>FlutterColorOn<CR>', 'Color Picker On')
        map('n', '<leader>cf', '<cmd>FlutterColorOff<CR>', 'Color Picker Off')
        -- Generic LSP maps (re-apply if needed, or ensure lspconfig's on_attach runs for dartls via flutter-tools)
        map('n', 'gD', vim.lsp.buf.declaration, 'Go to Declaration')
        map('n', 'gi', vim.lsp.buf.implementation, 'Go to Implementation')
        map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        print("Flutter Tools Attached to buffer: " .. bufnr)
      end

      require("flutter-tools").setup {
        -- Use the capabilities defined above
        capabilities = capabilities,
        lsp = {
          on_attach = on_attach, -- Use the on_attach specifically for flutter/dart
          color = {
            enabled = true,
            background = true, -- Highlight background for colours
            virtual_text = true,
            virtual_text_str = "■",
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            enableSnippets = true,
            -- lineLength = 120, -- Example: Set Dart line length
          },
        },
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "ErrorMsg", -- Highlight colour for closing tags
          prefix = "// ",         -- Prefix for comment artefacts
          enabled = true
        },
        decorations = {
          statusline = {
            app_version = false, -- Don't show app version
            device = true,       -- Show device name
          }
        },
        dev_log = {
          enabled = true,
          open_cmd = "tabedit", -- Open dev log in new tab
        },
        dev_tools = {
          autolaunch = false,           -- Don't autolaunch devtools
          auto_open_devtools = "never", -- OFF, REPL, BROWSER
        },
        debugger = {
          enabled = false, -- Set to true if using nvim-dap for Flutter debugging
          run_via_dap = false,
          -- Register configurations with nvim-dap
          -- register_configurations = function(_) ... end,
        },
        ui = {
          border = "rounded",
          notification_style = "native", -- Use native notifications
        },
      }

      vim.keymap.set("n", "<leader>;t", "<cmd>FlutterOutlineToggle<CR>")
      vim.keymap.set("n", "<leader>;m", "<cmd>Telescope flutter commands<CR>")
    end
  },

  -- ======== MASON FOR LSP SERVER MANAGEMENT ========
  {
    "williamboman/mason.nvim",
    cmd = "Mason", -- Load when running :Mason
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
    -- Must run AFTER mason.nvim and nvim-lspconfig
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      -- Define which servers to install automatically
      local ensure_installed = {
        "ts_ls",
        "lua_ls",
        "tailwindcss",
        "prismals",
        "cssls",
        "pyright",
        "eslint",
        "dockerls",
        "astro",
        "intelephense", -- PHP language server
        "bashls",       -- Example: add bash
        "jsonls",       -- Example: add json
        "yamlls",       -- Example: add yaml
        "elixirls",     -- Elixir language server
        -- Add other servers you need here
        -- Note: dartls is usually installed via Flutter SDK, not Mason
        -- Note: sourcekit might need manual installation depending on OS/setup
      }

      require("mason-lspconfig").setup({
        automatic_installation = true, -- Automatically install servers
        ensure_installed = ensure_installed,
        -- This handler function runs for every server installed by mason-lspconfig
        -- It calls the setup function from nvim-lspconfig using the capabilities
        -- and on_attach function defined in the nvim-lspconfig plugin spec above.
        handlers = {
          -- Default handler: Sets up servers with capabilities and on_attach
          function(server_name)
            local lspconfig = require('lspconfig')
            local cmp_nvim_lsp = require('cmp_nvim_lsp')
            local capabilities = cmp_nvim_lsp.default_capabilities()
            -- Optional: Enhance capabilities with lspkind icons
            -- capabilities = require('lspkind').enhance_capabilities(capabilities)

            -- Define your standard on_attach here *again* or structure it
            -- in a way that it can be required (e.g., lua/core/lsp_attach.lua)
            local on_attach = function(client, bufnr)
              local map = function(mode, lhs, rhs, desc)
                if desc then desc = 'LSP: ' .. desc end
                vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
              end
              map('n', 'gD', vim.lsp.buf.declaration, 'Go to Declaration')
              map('n', 'gi', vim.lsp.buf.implementation, 'Go to Implementation')
              map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
              map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
              map('n', 'gr', '<cmd>Trouble lsp_references<cr>', 'Go to References') -- Using Trouble

              if client.supports_method('textDocument/formatting') then
                -- Create formatting autocmd here if needed
                local augroup_format = vim.api.nvim_create_augroup("LspFormat_" .. server_name, { clear = true })
                vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                  group = augroup_format,
                  buffer = bufnr,
                  callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr, async = true })
                  end,
                })
              end
            end

            lspconfig[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end,

          -- Custom setup for specific servers if needed (overrides default handler)
          ["lua_ls"] = function()
            local lspconfig = require('lspconfig')
            local cmp_nvim_lsp = require('cmp_nvim_lsp')
            local capabilities = cmp_nvim_lsp.default_capabilities()
            -- capabilities = require('lspkind').enhance_capabilities(capabilities) -- Optional icons

            local on_attach = function(client, bufnr) -- Reuse or redefine on_attach
              local map = function(mode, lhs, rhs, desc)
                if desc then desc = 'LSP: ' .. desc end
                vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
              end
              map('n', 'gD', vim.lsp.buf.declaration, 'Go to Declaration')
              map('n', 'gi', vim.lsp.buf.implementation, 'Go to Implementation')
              map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
              -- Add other common maps...

              -- Formatting setup for Lua
              if client.supports_method('textDocument/formatting') then
                local augroup_format = vim.api.nvim_create_augroup("LspFormat_lua_ls", { clear = true })
                vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                  group = augroup_format,
                  buffer = bufnr,
                  callback = function() vim.lsp.buf.format({ bufnr = bufnr, async = true }) end,
                })
              end
            end

            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              on_attach = on_attach, -- Use the specific on_attach if needed
              settings = {           -- Your specific Lua settings
                Lua = {
                  runtime = { version = 'LuaJIT' },
                  diagnostics = { globals = { 'vim' } },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = { enable = false },
                }
              }
            })
          end,

          ["elixirls"] = function()
            local lspconfig = require('lspconfig')
            local cmp_nvim_lsp = require('cmp_nvim_lsp')
            local capabilities = cmp_nvim_lsp.default_capabilities()

            local on_attach = function(client, bufnr)
              local map = function(mode, lhs, rhs, desc)
                if desc then desc = 'LSP: ' .. desc end
                vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
              end
              map('n', 'gD', vim.lsp.buf.declaration, 'Go to Declaration')
              map('n', 'gi', vim.lsp.buf.implementation, 'Go to Implementation')
              map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
              map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
              map('n', 'gr', '<cmd>Trouble lsp_references<cr>', 'Go to References')

              if client.supports_method('textDocument/formatting') then
                local augroup_format = vim.api.nvim_create_augroup("LspFormat_elixirls", { clear = true })
                vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                  group = augroup_format,
                  buffer = bufnr,
                  callback = function() vim.lsp.buf.format({ bufnr = bufnr, async = true }) end,
                })
              end
            end

            lspconfig.elixirls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              filetypes = { "elixir", "eelixir", "heex", "surface" },
              settings = {
                elixirLS = {
                  dialyzerEnabled = true,
                  fetchDeps = false,
                  enableTestLenses = true,
                  suggestSpecs = true,
                }
              }
            })
          end,
          -- Add more custom handlers here if default isn't sufficient
        }
      })
    end,
  },
}
