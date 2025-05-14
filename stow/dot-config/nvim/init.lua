vim.loader.enable()

-- [[ bootstrap lazy ]] --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- [[ initialization ]] --
local o = vim.opt
local g = vim.g

--------------------------------- globals -------------------------------------
g.markdown_recommended_style = 0 -- Fix markdown indentation settings
g.transparency = true
g.mapleader = " "

g.netrw_liststyle = 3 -- Set netrw in tree view
g.netrw_altv = true   -- Open new pane in netrw on the right

if g.neovide then
    -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
    g.neovide_transparency = 0.9
    g.transparency = 0.9
    g.neovide_background_color = "#0f1117" .. string.format("%x", math.floor(255 * g.transparency))
end

-- disable some default providers
g["loaded_node_provider"] = 0
g["loaded_perl_provider"] = 0
g["loaded_python3_provider"] = 0
g["loaded_ruby_provider"] = 0

--------------------------------- options -------------------------------------
-- o.clipboard = "unnamedplus" -- for what ever reason this breaks everything
-- See `:help 'clipboard'`
o.scrolloff = 8 -- Lines of context
o.showmode = false -- Dont show mode since we have a statusline
o.spelllang = { "en" }
o.colorcolumn = "80" -- show a black bar in the 80 collum. this thing -------->
o.confirm = true -- Confirm to save changes before exiting modified buffer
o.conceallevel = 2 -- Hide * markup for bold and italic
o.completeopt = "menu,menuone,noselect"
o.cursorline = true -- Enable highlighting of the current line
o.expandtab = true -- Use spaces instead of tabs
o.number = true -- show line numbers

-- [[ Search ]] --
o.ignorecase = true -- Ignore case
o.smartcase = true -- Don't ignore case with capitals

o.list = true -- Show some invisible characters (tabs...
o.mouse = "a" -- Enable mouse mode
o.shiftwidth = 4 -- Size of an indent
o.tabstop = 4 -- Number of spaces tabs count for

o.termguicolors = true -- True color support
o.timeoutlen = 300
o.undofile = true -- Save undo history
o.undolevels = 10000
o.updatetime = 200 -- Save swap file and trigger CursorHold
o.wildmode = "longest:full,full" -- Command-line completion mode
o.winminwidth = 5 -- Minimum window width
o.wrap = false -- Disable line wrap

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
o.whichwrap:append("<>[]hl")

--------------------------------- commands ------------------------------------

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank" , { clear = true }),
    callback = vim.highlight.on_yank,
    pattern = '*'
})

-- [[ load plugins ]] --
require("lazy").setup({
    { "folke/lazy.nvim", tag = "stable" },
    { "actionshrimp/direnv.nvim", opts = {} },

    -- tokyonight
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
            styles = { sidebars = "transparent" },
            style = "moon",
        },
        init = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },

    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Oil",
        event = "User DirOpened",
        opts = {},
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        cmd = "Gitsigns",
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                end

                -- stylua: ignore start
                -- map("n", "]h", gs.next_hunk, "Next Hunk")
                -- map("n", "[h", gs.prev_hunk, "Prev Hunk")
                -- map("n", "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                -- map("n", "<leader>ghr", gs.reset_hunk, "Reset Hunk")
                -- map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                -- map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                -- map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                -- map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                -- map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Full Line")
                -- map("n", "<leader>ghB", gs.blame_line, "Blame Line")
                -- map("n", "<leader>ghd", gs.diffthis, "Diff This")
                -- map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                -- gs.toggle_deleted
            end,
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        -- "hoob3rt/lualine.nvim",
        -- "Lunarvim/lualine.nvim",
        event = "VimEnter",
        -- event = "VeryLazy",
        opts = {
            options = {
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha" } },
                -- disabled_filetypes = { 'neo-tree', }
                -- icons_enabled = true,
                -- component_separators = '|',
                -- section_separators = '',
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                lualine_c = {
                    {
                        "diagnostics",
                        symbols = {
                            -- error = icons.diagnostics.Error,
                            -- warn = icons.diagnostics.Warn,
                            -- info = icons.diagnostics.Info,
                            -- hint = icons.diagnostics.Hint,
                        },
                    },
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
                },
                lualine_x = {
                    { "diff" },
                },
                lualine_y = {
                    { "progress", separator = " ", padding = { left = 1, right = 0 } },
                    { "location", padding = { left = 0, right = 1 } },
                },
                lualine_z = {
                    function()
                        return " " .. os.date("%R")
                    end,
                },
            },
            extensions = {
                --"neo-tree",
                "lazy",
            },
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            -- char = '┊',
            -- char = "│",
        },
        main = "ibl",
    },

    -- better vim.ui
    {
        "stevearc/dressing.nvim",
        lazy = false, -- needs to change vim.ui.select and vim.ui.input
        opts = {},
    },

    -- auto pairs
    {
        "echasnovski/mini.pairs",
        event = "BufRead",
        opts = {},
    },

    -- Fast and feature-rich surround actions. For text that includes
    -- surrounding characters like brackets or quotes, this allows you
    -- to select the text inside, change or modify the surrounding characters,
    -- and more.
    {
        "echasnovski/mini.surround",
        keys = {
            { "gza", desc = "[A]dd surrounding", mode = { "n", "v" } },
            { "gzd", desc = "[D]elete surrounding" },
            { "gzf", desc = "[F]ind right surrounding" },
            { "gzF", desc = "[F]ind left surrounding" },
            { "gzh", desc = "[H]ighlight surrounding" },
            { "gzr", desc = "[R]eplace surrounding" },
            { "gzn", desc = "Update `MiniSurround.config.n_lines`" },
        },
        opts = {
            mappings = {
                add = "gza", -- Add surrounding in Normal and Visual modes
                delete = "gzd", -- Delete surrounding
                find = "gzf", -- Find surrounding (to the right)
                find_left = "gzF", -- Find surrounding (to the left)
                highlight = "gzh", -- Highlight surrounding
                replace = "gzr", -- Replace surrounding
                update_n_lines = "gzn", -- Update `n_lines`
            },
        },
    },

    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = { { "<leader>gu", ":UndotreeToggle", desc = "To[G]gle [U]ndotree" } },
    },

    {
        "folke/zen-mode.nvim",
        dependencies = "folke/twilight.nvim",
        cmd = "ZenMode",
        opts = {
            plugins = {
                options = {
                    enabled = true,
                    ruler = false,
                    showcmd = false,
                },
                twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
                gitsigns = { enabled = true }, -- disables git signs
            },
        },
        keys = {
            {
                "<leader>uz",
                function()
                    require("zen-mode").toggle()
                end,
                desc = "Toggle [Z]en Mode",
            },
        },
    },

    {
        'numToStr/Comment.nvim',
        opts = {},
        lazy = false
    },

    -- 'theprimeagen/vim-be-good',
    {
        "theprimeagen/harpoon",
        opts = {},
        -- keys = {
        --     {
        --         "<leader>a",
        --         function()
        --             require("harpoon.mark").add_file()
        --         end,
        --         desc = "[A]dd to harpoon",
        --     },
        --     {
        --         "<C-e>",
        --         function()
        --             require("harpoon.ui").toggle_quick_menu()
        --         end,
        --         desc = "Open harpoon switcher",
        --     },
        -- },
    },

    -- Finds and lists all of the TODO, HACK, BUG, etc comment
    -- in your project and loads them into a browsable list.
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
        -- keys = {
        --     {
        --         "]t",
        --         function()
        --             require("todo-comments").jump_next()
        --         end,
        --         desc = "Next todo comment",
        --     },
        --     {
        --         "[t",
        --         function()
        --             require("todo-comments").jump_prev()
        --         end,
        --         desc = "Previous todo comment",
        --     },
        --     { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
        --     { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
        --     { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
        --     { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
        -- },
    },

    -- better diagnostics list and others
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        -- keys = {
        --     { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
        --     { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
        --     { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
        --     { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
        --     {
        --         "[q",
        --         function()
        --             if require("trouble").is_open() then
        --                 require("trouble").previous({ skip_groups = true, jump = true })
        --             else
        --                 local ok, err = pcall(vim.cmd.cprev)
        --                 if not ok then
        --                     vim.notify(err, vim.log.levels.ERROR)
        --                 end
        --             end
        --         end,
        --         desc = "Previous trouble/quickfix item",
        --     },
        --     {
        --         "]q",
        --         function()
        --             if require("trouble").is_open() then
        --                 require("trouble").next({ skip_groups = true, jump = true })
        --             else
        --                 local ok, err = pcall(vim.cmd.cnext)
        --                 if not ok then
        --                     vim.notify(err, vim.log.levels.ERROR)
        --                 end
        --             end
        --         end,
        --         desc = "Next trouble/quickfix item",
        --     },
        -- },
        -- "<cmd> TroubleToggle lsp_workspace_diagnostics<CR>",
        -- "<cmd> TroubleToggle lsp_document_diagnostics<CR>",
        -- "<cmd> TroubleToggle loclist<CR>",
        -- "<cmd> TroubleToggle quickfix<CR>",
        -- "<cmd> TroubleToggle lsp_references<CR>"
    },

    -- { "mg979/vim-visual-multi" },
    -- { 'LionC/nest.nvim' }

    -- {
    --     "zbirenbaum/copilot.lua",
    --     cmd = "Copilot",
    --     lazy = false,
    --     event = "InsertEnter",
    --     config = function()
    --       require("copilot").setup({})
    --     end,
    -- },

    -- Flash enhances the built-in search functionality by showing labels
    -- at the end of each match, letting you quickly jump to a specific
    -- location.
    {
        "folke/flash.nvim",
        opts = {},
        keys = {
            {
                "s",
                function()
                    require("flash").jump()
                end,
                mode = { "n", "x", "o" },
                desc = "Flash [S]earch",
            },
            {
                "S",
                function()
                    require("flash").treesitter()
                end,
                mode = { "n", "o", "x" },
                desc = "Flash Treesitter [S]earch",
            },
        },
    },

    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local nls = require("null-ls")
            local opts = {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git"),
                sources = {
                    -- nls.builtins.formatting.rustfmt,
                    -- nls.builtins.formatting.brittany, -- haskell
                    -- nls.builtins.formatting.alejandra, -- nix

                    -- go
                    nls.builtins.formatting.gofmt,

                    -- nls.builtins.formatting.ktlint, -- kotlin
                    nls.builtins.formatting.stylua, -- lua
                    -- nls.builtins.formatting.trim_whitespace,
                    -- nls.builtins.formatting.zigfmt,

                    -- nls.builtins.diagnostics.credo, -- elixir, requires mix

                    -- [[ python things ]]
                    -- nls.builtins.diagnostics.mypy,
                    -- nls.builtins.diagnostics.ruff,
                    -- nls.builtins.formatting.black

                    nls.builtins.formatting.fish_indent,
                    nls.builtins.diagnostics.fish,
                    nls.builtins.formatting.shfmt,
                    -- nls.builtins.diagnostics.shellcheck,
                },
            }

            -- auto format on save
            -- vim.api.nvim_create_autocmd("BufWritePre", {
            --     group = vim.api.nvim_create_augroup("NvimFormater", {}),
            --     callback = function()
            --         local buf = vim.api.nvim_get_current_buf()
            --         vim.lsp.buf.format({
            --             bufnr = buf,
            --         })
            --     end,
            -- })

            nls.setup(opts)
        end,

        -- M.null_ls = {
        -- 	i = {
        -- 		["<C-t>"] = { "<cmd> lua vim.lsp.buf.format()<CR>", "Format" },
        -- 		["<C-space>"] = { "<cmd> lua vim.lsp.buf.hover()<CR>", "Hover" },
        -- 	},
        -- 	n = {
        -- 		["<leader>cf"] = { "<cmd> lua vim.lsp.buf.format()<CR>", "Format" },
        -- 		["<leader>rn"] = { "<cmd> lua vim.lsp.buf.rename()<CR>", "Rename" },
        -- 		["<leader>gi"] = {
        -- 			"<cmd> lua vim.lsp.buf.implementation()<CR>",
        -- 			"Go to Implementation",
        -- 		},
        -- 		["<leader>gr"] = {
        -- 			"<cmd> lua vim.lsp.buf.references()<CR>",
        -- 			"Go to References",
        -- 		},
        -- 		["<leader>sd"] = {
        -- 			"<cmd> lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
        -- 			"Show Line Diagnostics",
        -- 		},
        -- 		-- ["<leader>sr"] = {
        -- 		--     "<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>",
        -- 		--     "Go to Previous Diagnostic"
        -- 		-- },
        -- 		-- ["<leader>sn"] = {
        -- 		--     "<cmd> lua vim.lsp.diagnostic.goto_next()<CR>",
        -- 		--     "Go to Next Diagnostic"
        -- 		-- },
        -- 		-- ["<leader>sp"] = {
        -- 		--     "<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>", "Set Loclist"
        -- 		-- }
        -- 	},
        -- }
    },

    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            {
                "L3MON4D3/LuaSnip",
                dependencies = { "rafamadriz/friendly-snippets" },
                opts = {
                    history = true,
                    delete_check_events = "TextChanged",
                },
            },
        },
        config = function()
            -- See `:help cmp`

            local cmp = require("cmp")
            local luasnip = require("luasnip")

            local opts = {
                completion = { completeopt = "menu,menuone,noinsert" },
                formatting = {},
                window = {
                    completion = {},
                    documentation = {},
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-y>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }),
                },
                sources = {
                    { name = "nvim_lsp" },
                    -- { name = "luasnip" },
                    { name = "buffer" },
                    { name = "nvim_lua" },
                    { name = "path" },
                },
            }

            cmp.setup(opts)
        end,
    },

    -- Whichkey
    {
        "folke/which-key.nvim",
        cmd = "WhichKey",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gz"] = { name = "+surrond" },
                ["gc"] = { name = "+comment" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
                ["<leader>d"] = { name = "+debug" },
            },
        },
        config = function(_, opts)
            vim.o.timeout = true
            vim.o.timeoutlen = 200

            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            -- "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
        },
        keys = {
            { "<c-space>", desc = "Increment selection" },
            { "<bs>", desc = "Decrement selection", mode = "x" },
        },
        main = "nvim-treesitter.configs",
        opts = {
            auto_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "html", "markdown", "markdown_inline", "lua", "rust", "toml",
                "zig", "haskell", "c", "cpp", "go", "python",
                "typescript", "vim"
            },
            -- "ron",
            -- 'ocaml'
            -- "elixir"
            -- incremental_selection = {
            --     enable = true,
            --     keymaps = {
            --         init_selection = "<C-space>",
            --         node_incremental = "<C-space>",
            --         scope_incremental = false,
            --         node_decremental = "<bs>",
            --     },
            -- },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>sa"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>sA"] = "@parameter.inner",
                    },
                },
            },
        },
    },

    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function(_, _)
            local dashboard = require("alpha.themes.dashboard")

            dashboard.section.header.val = {
                "⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷",
                "⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇",
                "⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽",
                "⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕",
                "⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕",
                "⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕",
                "⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄",
                "⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕",
                "⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿",
                "⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
                "⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟",
                "⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠",
                "⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙",
                "⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣",
            }

            dashboard.section.buttons.val = {
                dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
                dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
                dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
                dashboard.button("c", " " .. " Vim Config", ":e $MYVIMRC <CR>"),
                dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
                dashboard.button("q", " " .. " Quit", ":qa<CR>"),
            }

            for _, button in ipairs(dashboard.section.buttons.val) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end

            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.section.footer.opts.hl = "AlphaFooter"
            dashboard.opts.layout[1].val = 8

            require("alpha").setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        -- init = function() require("core.keys").load_module("telescope") end,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            defaults = {
                -- prompt_prefix = " ",
                prompt_prefix = "   ",
                selection_caret = " ",
                -- entry_prefix = "  ",
                initial_mode = "insert",
                file_ignore_patterns = { "node_modules", "target", "build", "zig-cache" },
                set_env = { ["COLORTERM"] = "truecolor" },
                -- these mappings apply when in a telescope buffer
                mappings = {
                    i = {
                        ["<c-t>"] = function(...)
                            return require("trouble.providers.telescope").open_with_trouble(...)
                        end,
                        ["<a-t>"] = function(...)
                            return require("trouble.providers.telescope").open_selected_with_trouble(...)
                        end,
                        ["<C-f>"] = function(...)
                            return require("telescope.actions").preview_scrolling_down(...)
                        end,
                        ["<C-b>"] = function(...)
                            return require("telescope.actions").preview_scrolling_up(...)
                        end,
                    },
                    n = {
                        ["q"] = function()
                            require("telescope.actions").close(1)
                        end,
                    },
                },
            },
            extensions_list = {
                -- "fzf"
            },
        },
        config = function(_, opts)
            -- require("conf.telescope")

            local telescope = require("telescope")
            telescope.setup(opts)

            -- load extensions
            for _, ext in ipairs(opts.extensions_list) do
                telescope.load_extension(ext)
            end
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- documentation for vim api calls in lua
            { "folke/neodev.nvim", opts = {} },
            -- loading indicator for lsps
            { "j-hui/fidget.nvim", tag = "legacy", event = "LspAttach", opts = {} },
            -- show crate versions in Cargo.toml
            -- { "Saecki/crates.nvim", event = { "BufRead Cargo.toml" }, opts = {} },
            -- show implied types
            { "simrat39/rust-tools.nvim", ft = "rust", opts = {} },
            -- { "tamago324/nlsp-settings.nvim", cmd = "LspSettings", opts = {} },
            -- { "pmizio/typescript-tools.nvim", ft = {"js", "ts"}, opts = {} }
        },
        opts = {
            servers = {
                -- rust_analyzer = {},
                taplo = {},
                zls = {},
                pyright = {},
                -- gleam = {},
                -- clangd = {
                --     capabilities = { offsetEncoding = { "utf-16" } },
                --     -- keys = { { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" }, },
                --     cmd = {
                --         "clangd",
                --         "--background-index",
                --         "--clang-tidy",
                --         "--header-insertion=iwyu",
                --         "--completion-style=detailed",
                --         "--function-arg-placeholders",
                --         "--fallback-style=llvm",
                --     },
                --     init_options = {
                --         usePlaceholders = true,
                --         completeUnimported = true,
                --         clangdFileStatus = true,
                --     },
                -- },
                -- kotlin_language_server = {},
                -- hls = {},
                -- ocamllsp = {},
                -- lua_ls = {
                --     -- on_attach = function(client, bufnr)
                --     --     -- Done by NoneLs
                --     --     client.server_capabilities.documentFormattingProvider = false
                --     --     client.server_capabilities.documentRangeFormattingProvider = false
                --     --
                --     --     -- Done by Treesitter
                --     --     client.server_capabilities.semanticTokensProvider = nil
                --     -- end,
                --     -- capabilities = capabilities,
                --     settings = {
                --         Lua = {
                --             -- diagnostics = { globals = { "vim" } },
                --             workspace = {
                --                 library = {
                --                     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                --                     [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                --                     -- [vim.fn.stdpath("data") .. "/lazy/extensions/nvchad_types"] = true,
                --                     [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
                --                 },
                --                 maxPreload = 100000,
                --                 preloadFileSize = 10000,
                --                 checkThirdParty = false,
                --             },
                --             completion = { callSnippet = "Replace" },
                --             telemetry = { enable = false },
                --         },
                --     },
                -- },
            },
        },
        config = function(_, opts)
            local lspconfig = require("lspconfig")

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local bufnr = ev.buf

                    -- Enable completion triggered by <c-x><c-o>
                    -- vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

                    -- local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
                    --
                    -- if inlay_hint then
                    --     inlay_hint(bufnr, true)
                    -- end

                    local map = function(mode, key, action, desc)
                        local opt = { buffer = bufnr }
                        opt["desc"] = desc
                        vim.keymap.set(mode, key, action, opt)
                    end

                    map("n", "K", vim.lsp.buf.hover, "LSP hover")

                    -- map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
                    map("n", "gd", function()
                        require("telescope.builtin").lsp_definitions({ reuse_win = true })
                    end, "[G]oto [D]efinition")
                    map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map("n", "gi", vim.lsp.buf.implementation, "[G]o [I]mplementation")
                    map("n", "gr", vim.lsp.buf.references, "[G]oto [R]eferences")

                    -- return ":" .. require("inc_rename").config.cmd_name .. " " .. vim.fn.expand("<cword>")
                    map("n", "<leader>cn", vim.lsp.buf.rename, "[C]ode Re[N]ame")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
                    map("n", "<leader>cf", function()
                        vim.lsp.buf.format({ async = true })
                    end, "[C]ode [F]ormat")
                    map("n", "<leader>cd", vim.diagnostic.open_float, "[C]ode [D]iagnostics")

                    -- map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbol")
                    -- map("n", "<leader>ls", vim.lsp.buf.signature_help, "LSP signature help")
                    -- ["<leader>D"] = {
                    --     vim.lsp.buf.type_definition,
                    --     "LSP definition type",
                    -- },

                    map("n", "[d", vim.diagnostic.goto_prev, "Previous [D]iagnostic")
                    map("n", "]d", vim.diagnostic.goto_next, "Next [D]iagnostic")
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem = {
                documentationFormat = { "markdown", "plaintext" },
                snippetSupport = true,
                preselectSupport = true,
                insertReplaceSupport = true,
                labelDetailsSupport = true,
                deprecatedSupport = true,
                commitCharactersSupport = true,
                tagSupport = { valueSet = { 1 } },
                resolveSupport = {
                    properties = { "documentation", "detail", "additionalTextEdits" },
                },
            }

            for server, _ in pairs(opts.servers) do
                local options = opts.servers[server] or {}

                if options.capabilities then
                    local new = vim.deepcopy(capabilities)
                    for k, v in pairs(options.capabilities) do
                        new[k] = v
                    end
                    options.capabilities = new
                else
                    options.capabilities = capabilities
                end

                lspconfig[server].setup(options)
            end

            lspconfig.gopls.setup({
                -- capabilities = capabilities,
                -- cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                root_dir = lspconfig.util.root_pattern("go.mod", "go.work", ".git"),
                settings = {
                    gopls = {
                        completeUnimported = true,
                        analyses = {
                            unusedparams = true,
                        },
                    },
                },
            })

            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                },
                severity_sort = true,
            })
        end,
    },

    -- {
    --     "epwalsh/obsidian.nvim",
    --     ft = "markdown",
    --     -- vim.keymap.set("n", "gl", "<cmd>ObsidianFollowLink<CR>", { desc = "Obsidian: Follow [L]ink" })
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "hrsh7th/nvim-cmp",
    --         "nvim-telescope/telescope.nvim",
    --     },
    --     opts = {
    --         workspaces = { {
    --             name = "main",
    --             path = "~/dox",
    --         } },
    --         -- dir = vim.fn.expand("$XDG_DOCUMENTS_DIR"),
    --
    --         -- Optional, if you keep notes in a specific subdirectory of your vault.
    --         notes_subdir = "notes",
    --
    --         completion = { min_chars = 0 },
    --
    --         -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
    --         -- way then set 'mappings = {}'.
    --         mappings = {
    --             -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    --             ["gf"] = {
    --                 action = function()
    --                     return require("obsidian").util.gf_passthrough()
    --                 end,
    --                 opts = { noremap = false, expr = true, buffer = true },
    --             },
    --             -- Toggle check-boxes.
    --             ["<leader>ch"] = {
    --                 action = function()
    --                     return require("obsidian").util.toggle_checkbox()
    --                 end,
    --                 opts = { buffer = true },
    --             },
    --         },
    --
    --         -- Where to put new notes.
    --         -- "current_dir" OR "notes_subdir"
    --         new_notes_location = "current_dir",
    --
    --         -- Optional, customize how wiki links are formatted. You can set this to one of:
    --         --  * "use_alias_only", e.g. '[[Foo Bar]]'
    --         --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
    --         --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
    --         --  * "use_path_only", e.g. '[[foo-bar.md]]'
    --         wiki_link_func = "prepend_note_id",
    --
    --         -- Either 'wiki' or 'markdown'.
    --         preferred_link_style = "wiki",
    --
    --         -- Optional, boolean or a function that takes a filename and returns a boolean.
    --         -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
    --         disable_frontmatter = false,
    --
    --         -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    --         -- URL it will be ignored but you can customize this behavior here.
    --         ---@param url string
    --         follow_url_func = function(url)
    --             vim.fn.jobstart({ "handlr", "open", url })
    --         end,
    --
    --         picker = { name = "telescope.nvim" },
    --     },
    -- },

    -- {
    --     'michaelb/sniprun', 
    --     build = "sh install.sh",
    --     cmd = { "SnipRun", "SnipInfo" },
    --     opts = {},
    -- }
}, { defaults = { lazy = true } })

-- see `:help mark`

-----------------------------[[ key mappings ]]--------------------------------
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "<leader>bd", "<cmd> bd <CR> <cmd> bnext <CR>", { desc = "[B]uffer [D]elete" })
vim.keymap.set("n", "<leader>bn", "<cmd> enew <CR> ", { desc = "[N]ew [B]uffer" })

vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear Highlight" })

-- Move windows using the <ctrl> hjkl keys
-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window Left", remap = true })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window Left", remap = true })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window Left", remap = true })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window Left", remap = true })

-- vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Window Right", remap = true })
-- vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Window Left", remap = true })
-- vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Window Down", remap = true })
-- vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Window Up", remap = true })

-- n = {
-- ["q"] = { "<nop>", "Vim macros are garbage" },
-- ["Q"] = { "<nop>", "I dont know what this does" },

-- ["<leader>n"] = { "<cmd> cnext <CR> zz", "See the next error" },

-- ["<A-j>"] = { "<cmd> m .+1<CR>==", "Move line down" },
-- ["<A-k>"] = { "<cmd> m .-2<CR>==", "Move line up" },
-- },

-- v = {
-- ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
-- ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
-- ["<"] = { "<gv", "Remove indent" },
-- [">"] = { ">gv", "Add indent" },

-- ["<A-j>"] = { ":m '>+1<CR>gv-gv", "Move selection up" },
-- ["<A-k>"] = { ":m '>-2<CR>gv-gv", "Move selection up" },
-- },

-- Remaps
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open [P]roject explorer [V]iew (netrw)" })
-- vim.keymap.set("v", "Y", "\"+y", { desc = "[Y]ank to clipboard" })
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- vim.keymap.set("n", "J", "mzJ`z")                                                       -- use J to append line to end and make the cursor stay at the top
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")                                                 -- move to next half of file without moving cursor
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "n", "nzzzv")                                                       -- searching for terms keeps cursor/highlight in the middle
-- vim.keymap.set("n", "N", "Nzzzv")
-- vim.keymap.set("n", "<leader>vs", "<C-w>v<C-w>l", { desc = "[S]plit [V]ertical pane" }) -- open a vertical on the right and switch to it (replaced by tmux)
-- vim.keymap.set("n", "<leader><Tab>", ":bnext<CR>", { desc = "Next buffer" })            -- go to next buffer

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


-- better up/down
--
-- TODO: fix this
--
-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
-- ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
-- ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
-- map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
-- map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
-- map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })


-- vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })
-- vim.keymap.set('n', "n", "<nop>", {})
-- vim.keymap.set('n', "N", "<nop>", {})

-- save file
-- map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
-- map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })


-- if not Util.has("trouble.nvim") then
-- 	map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
-- 	map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
-- end


-- highlights under cursor
-- map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- ## buffers
-- map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
-- map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
-- map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- ## windows
vim.keymap.set("n", "<leader>ww", "<C-w>p", { desc = "Other window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-w>c", { desc = "Delete window", remap = true })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split window below", remap = true })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window right", remap = true })

-- ## tabs
-- vim.keymap.set("n", "<leader><tab>y", "<cmd>tabnew<cr>", { desc = "New [y] [T]ab" })
-- vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "[N]ext Tab" })
-- vim.keymap.set("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "[P]revious Tab" })
-- vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })


vim.keymap.set("n", "-", "<cmd> Oil <CR>", { desc = "Edit Parent Dir" })

-- # Telelscope
vim.keymap.set("n", "<leader>ff", "<cmd> Telescope buffers <CR>", { desc = "Find [ ] buffers" })
vim.keymap.set("n", "<leader><space>", "<cmd> Telescope find_files <CR>", { desc = "[F]ind [F]iles" })

-- rg
vim.keymap.set("n", "<leader>fw", "<cmd> Telescope live_grep <CR>", { desc = "[F]ind [W]ord" })
-- looks for the work under your cursor + selection
vim.keymap.set("n", "<leader>fg", "<cmd> Telescope grep_string <CR>", { desc = "[F]ind [G]rep" })

vim.keymap.set("n", "<leader>p", "<cmd> Telescope registers <CR>", { desc = "[P]aste Register" })

-- -- ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "[F]ind [A]ll" },
--
-- ["<leader>fH"] = { "<cmd> Telescope help_tags <CR>", "[F]ind [H]elp" },
--
-- -- finds files you have recently opend in any project
-- ["<leader>fh"] = { "<cmd> Telescope oldfiles <CR>", "[F]ind [H]istory" },
--
-- ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "[F]u[Z]zy Find" },
--
-- -- finds text within git diffs
-- -- ["<leader>fg"] = { "<cmd> Telescope git_status <CR>", "[F]ind Active [G]it" },
--
-- -- ["<leader>fG"] = { "<cmd> Telescope git_files <CR>", "[F]ind All [G]it" },
-- ["<leader>fc"] = { "<cmd> Telescope git_commits <CR>", "[F]ind Git [C]ommits" },
-- -- 	{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
-- ["<leader>fd"] = { "<cmd> Telescope diagnostics <CR>", "[F]ind [D]iagnostics" },
-- ["<leader>fm"] = { "<cmd> Telescope marks <CR>", "[F]ind [M]arks" },
-- ["<leader>f:"] = { "<cmd> Telescope command_history <cr>", "[F]ind [:] Command" },
--
-- -- need nvim-notify
-- ["<leader>fn"] = { "<cmd> Telescope notify <CR>", "[F]ind [N]otifications" },
--
-- -- ["<leader>uC"] = { "<cmd> Telescope colorscheme enable_preview=true", "Colorscheme" }
--
-- 	{ "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
-- 	-- search
--
-- 	{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
-- 	{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
-- 	{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
-- 	{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
-- 	{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
-- 	{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
-- 	{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
-- 	{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
-- 	{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
-- 	{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
-- 	{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
-- 	{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
-- 	{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
-- 	{ "<leader>sw", Util.telescope("grep_string"), desc = "Word (root dir)" },
-- 	{ "<leader>sW", Util.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },

-- local telescope_builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>pg', telescope_builtin.git_files, { desc = "[P]roject [G]it file search" })
-- vim.keymap.set('n', '<leader>ps', telescope_builtin.live_grep, { desc = "[P]roject [S]earch with grep" })
-- vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>/', function()
--     -- You can pass additional configuration to telescope to change theme, layout, etc.
--     telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--         winblend = 10,
--         previewer = false,
--     })
-- end, { desc = '[/] Search in current buffer' })

-- See `:help modeline`
-- vim: ts=4 sts=4 sw=4 et
