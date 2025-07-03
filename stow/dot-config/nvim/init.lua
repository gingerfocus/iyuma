local vim = _G.vim
vim.loader.enable()

-- [[ bootstrap lazy ]] --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

--------------------------------- globals -------------------------------------
vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings
vim.g.transparency = true
vim.g.mapleader = " "

vim.g.netrw_liststyle = 3 -- Set netrw in tree view
vim.g.netrw_altv = true   -- Open new pane in netrw on the right

-- disable some default providers
vim.g["loaded_node_provider"] = 0
vim.g["loaded_perl_provider"] = 0
vim.g["loaded_python3_provider"] = 0
vim.g["loaded_ruby_provider"] = 0

--------------------------------- options -------------------------------------
-- o.clipboard = "unnamedplus" -- for what ever reason this breaks everything
-- See `:help 'clipboard'`
vim.opt.scrolloff = 8      -- Lines of context
vim.opt.showmode = false   -- Dont show mode since we have a statusline
vim.opt.spelllang = { "en" }
vim.opt.colorcolumn = "80" -- show a black bar in the 80 collum. this thing -------->
vim.opt.confirm = true     -- Confirm to save changes before exiting modified buffer
vim.opt.conceallevel = 2   -- Hide * markup for bold and italic
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.cursorline = true  -- Enable highlighting of the current line
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.number = true      -- show line numbers

-- [[ Search ]] --
vim.opt.ignorecase = true              -- Ignore case
vim.opt.smartcase = true               -- Don't ignore case with capitals

vim.opt.list = true                    -- Show some invisible characters (tabs...
vim.opt.mouse = "a"                    -- Enable mouse mode
vim.opt.shiftwidth = 4                 -- Size of an indent
vim.opt.tabstop = 4                    -- Number of spaces tabs count for

vim.opt.termguicolors = true           -- True color support
vim.opt.undofile = true                -- Save undo history
vim.opt.undolevels = 10000
vim.opt.updatetime = 800               -- Save swap file and trigger CursorHold
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5                -- Minimum window width
vim.opt.wrap = false                   -- Disable line wrap

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

--------------------------------- commands ------------------------------------

-- [[ load plugins ]] --
require("lazy").setup({
    { "folke/lazy.nvim",           tag = "stable" },
    { "actionshrimp/direnv.nvim",  opts = {},             lazy = false },
    { "mbbill/undotree",           cmd = "UndotreeToggle" },
    { "echasnovski/mini.pairs",    event = "BufRead",     opts = {} },
    -- { "echasnovski/mini.ai",       event = "BufRead",     opts = { n_lines = 500 } },
    { "echasnovski/mini.surround", event = "BufRead",     opts = {} },
    { "folke/flash.nvim",          opts = {} }, -- a mouse alternative
    { "folke/which-key.nvim",      event = "VeryLazy",    opts = {} },
    { "j-hui/fidget.nvim",         event = "LspAttach",   opts = {} },

    -- use gx to open with system opener
    -- see :help Oil
    { "stevearc/oil.nvim",         opts = {},             lazy = false },

    -- better vim.ui
    -- { "stevearc/dressing.nvim", opts = {}, lazy = false },

    -- tokyonight
    {
        "folke/tokyonight.nvim",
        lazy = false,
        config = function()
            require("tokyonight").setup({
                transparent = true,
                styles = { sidebars = "transparent" },
            })
            vim.cmd.colorscheme("tokyonight-moon")
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
        main = "ibl",
    },

    {
        "echasnovski/mini.icons",
        opts = {},
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old
        -- branch = "main",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter-context", opts = {} },
        main = "nvim-treesitter.configs",
        opts = {
            auto_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            -- stylua: ignore
            ensure_installed = {
                "html", "markdown", "lua", "rust",
                "toml", "zig", "go", "python",
                "typescript", "ocaml", "elixir"
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            defaults = {
                prompt_prefix = "   ",
                selection_caret = " ",
                file_ignore_patterns = { "node_modules", "target", "build", ".zig-cache" },
            },
        },
    },

    {
        "stevearc/conform.nvim",
        cmd = "ConformInfo",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                sh = { "shfmt" },
                zig = { "zigfmt" },
                rust = { "rustfmt" },
                typst = { "prettypst" },
                nix = { "nixfmt", "alejandra" },
                c = { "uncrustify" },
                python = { "black" },
            },
            formatters = {
                stylua = { prepend_args = { "--indent-type", "Spaces" } },
            },
        },
    },

    {
        "olimorris/codecompanion.nvim",
        cmd = { "CodeCompanion", "CodeCompanionChat" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
    },

    {
        "supermaven-inc/supermaven-nvim",
        event = "InsertEnter",
        opts = {
            keymaps = { accept_suggestion = "<Tab>" },
            ignore_filetypes = { "bigfile", "" },
        },
    },


    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- { "simrat39/rust-tools.nvim", opts = {} },
        },
        config = function()
            local servers = {
                "zls", "pyright", "clangd", "hls",
                "ocamllsp", "lua_ls", "gopls",
                "ts_ls",
            }

            local lspconf = require("lspconfig")
            -- local capabilities = require("blink.cmp").get_lsp_capabilities()
            for _, server in pairs(servers) do
                -- lspconf[server].setup({ capabilities = capabilities })
                lspconf[server].setup({})
            end

            -- vim.lsp.enable(servers)

            -- see :help lsp-lint for reimpl
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local map = function(mode, key, action, desc)
                        vim.keymap.set(mode, key, action, {
                            buffer = ev.buf,
                            desc = desc
                        })
                    end

                    -- if vim.lps.inlay_hint_enable then
                    --     vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                    -- end

                    map("n", "gd", function()
                        -- vim.cmd("tab split")
                        vim.lsp.buf.definition({
                            -- reuse_win = true,
                            loclist = true,
                        })
                    end, "[G]oto [D]efinition")

                    -- map("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map("n", "gi", vim.lsp.buf.implementation, "[G]o [I]mplementation")

                    -- see :help grr
                    -- map("n", "gr", vim.lsp.buf.references, "[G]oto [R]eferences")

                    map("n", "<leader>cn", vim.lsp.buf.rename, "[C]ode Re[N]ame")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")

                    -- vim.lsp.buf.format({ async = true })
                    map("n", "<leader>cf", vim.lsp.buf.format, "[C]ode [F]ormat")

                    -- map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbol")
                    -- map("n", "<leader>ls", vim.lsp.buf.signature_help, "LSP signature help")
                    map("n", "grd", vim.lsp.buf.type_definition, "LSP definition type")

                    -- vim.api.nvim_create_autocmd('DiagnosticChanged', {
                    --   callback = function(args)
                    --     local diagnostics = args.data.diagnostics
                    --     vim.print(diagnostics)
                    --   end,
                    -- })

                    -- vim.diagnostic.config({
                    --     loclist = {
                    --         open = true,
                    --         severity = { min = vim.diagnostic.severity.WARN },
                    --     }
                    -- })

                    -- vim.diagnostic.handlers.loclist = {
                    --     show = function(_, _, _, opts)
                    --         -- Generally don't want it to open on every update
                    --         opts.loclist.open = opts.loclist.open or false
                    --         local winid = vim.api.nvim_get_current_win()
                    --         vim.diagnostic.setloclist(opts.loclist)
                    --         vim.api.nvim_set_current_win(winid)
                    --     end
                    -- }

                    -- map("n", "<leader>cd", function()
                    --     vim.diagnostic.setloclist({
                    --         open = true,
                    --     })
                    --     vim.cmd.lopen()
                    --     vim.diagnostic.open_float()
                    -- end, "[C]ode [D]iagnostics")

                    map("n", "[d", vim.diagnostic.goto_prev, "Previous [D]iagnostic")
                    map("n", "]d", vim.diagnostic.goto_next, "Next [D]iagnostic")

                    -- local clients = vim.lsp.get_clients({ bufnr = ev.buf })
                    -- if #clients == 0 then return end
                    -- vim.lsp.completion.enable(
                    --     true,
                    --     clients[0].id,
                    --     ev.buf, {
                    --         autotrigger = true,
                    --     })
                end,
            })
        end,
    },

    -- {
    --     "epwalsh/obsidian.nvim",
    --     enabled = true,
    --     ft = "markdown",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-telescope/telescope.nvim",
    --         "hrsh7th/nvim-cmp",
    --     },
    --     opts = {
    --         ui = { enable = false },
    --         workspaces = { { name = "main", path = "~/dox" } },
    --         notes_subdir = "05 - Fleeting",
    --         completion = { min_chars = 0 },
    --         mappings = {
    --             ["gf"] = {
    --                 action = function()
    --                     return require("obsidian").util.gf_passthrough()
    --                 end,
    --                 opts = { noremap = false, expr = true, buffer = true },
    --             },
    --             -- vim.keymap.set("n", "gl", "<cmd>ObsidianFollowLink<CR>", { desc = "Obsidian: Follow [L]ink" })
    --         },
    --         preferred_link_style = "wiki",
    --         disable_frontmatter = false,
    --         follow_url_func = function(url)
    --             vim.fn.jobstart({ "xdg-open", url })
    --         end,
    --         picker = { name = "telescope.nvim" },
    --     },
    -- },

    -- see :help lsp-completion to replace this
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            -- local luasnip = require("luasnip")

            local opts = {
                completion = { completeopt = "menu,menuone,noinsert" },
                formatting = {},
                window = {
                    completion = {},
                    documentation = {},
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
                    -- { name = "supermaven" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "buffer" },
                    { name = "path" },
                },
            }
            cmp.setup(opts)
        end,
    },
}, {
    defaults = { lazy = true },
    rocks = { enabled = false },
})

-- see `:help mark`

-----------------------------[[ key mappings ]]--------------------------------
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- ## buffers
vim.keymap.set("n", "<leader>bd", "<cmd> bd <CR> <cmd> bnext <CR>", { desc = "Buffer Delete" })
vim.keymap.set("n", "<leader>bc", "<cmd> enew <CR> ", { desc = "Buffer Create" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Buffer Prev" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Buffer Next" })


-- ## windows
vim.keymap.set("n", "<leader>ww", "<C-w>p", { desc = "Other window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-w>c", { desc = "Delete window", remap = true })
vim.keymap.set("n", "<leader>ws", "<C-w>s<C-w>j", { desc = "Split window below", remap = true })
vim.keymap.set("n", "<leader>wv", "<C-w>v<C-w>l", { desc = "Window Vertical" })


vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Highlight" })
vim.keymap.set("n", ";", ":")

vim.keymap.set("n", "<leader>u", ":UndotreeToggle", { desc = "Undotree" })
-- vim.keymap.set("n", "<leader>m", "<cmd> Markview splitToggle <CR>", { desc = "Markview Toggle" })

vim.keymap.set({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end, { desc = "Flash Search" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
    require("flash").treesitter()
end, { desc = "Flash Treesitter Search", })

vim.keymap.set("n", "<leader>cf", function()
    local bufnr = vim.api.nvim_get_current_buf()
    require("conform").format({ bufnr = bufnr })
end, { desc = "Code Format" })

-- vim.keymap.set("n", "<leader>n", "<cmd> cnext <CR> zz", { desc = "See the next error" })
-- ]q

vim.keymap.set("v", "Y", '"+y', { desc = "[Y]ank to clipboard" })

vim.keymap.set("n", "n", "nzz") -- searching for terms keeps cursor/highlight in the middle
vim.keymap.set("n", "N", "Nzz")

-- insert undo markers
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- save file
vim.keymap.set({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
-- map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

vim.keymap.set("n", "-", "<cmd> Oil <CR>", { desc = "Edit Parent Dir" })

-- # Telelscope
vim.keymap.set("n", "<leader><space>", function()
    require("telescope.builtin").git_files()
end, { desc = "Find [ ] Files" })

vim.keymap.set("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
end, { desc = "Find Buffers" })

-- usually overkill
vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>fw", function()
    require("telescope.builtin").live_grep()
end, { desc = "[F]ind [W]ord" })

vim.keymap.set("n", "<leader>fc", function()
    require("telescope.builtin").git_commits()
end, { desc = "[F]ind Git [C]ommits" })

vim.keymap.set("n", "<leader>fd", function()
    require("telescope.builtin").diagnostics()
end, { desc = "[F]ind [D]iagnostics" })

vim.keymap.set("n", "<leader>fh", function()
    require("telescope.builtin").help_tags()
end, { desc = "[F]ind [H]elp" })

vim.keymap.set("n", "<leader>p", function()
    require("telescope.builtin").registers()
end, { desc = "Paste Register" })

vim.keymap.set("n", "<leader>/", function()
    local simpletheme = require("telescope.themes").get_dropdown({
        previewer = false,
        winblend = 10,
    })
    require("telescope.builtin").current_buffer_fuzzy_find(simpletheme)
end, { desc = "Search Buffer" })

-- ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "[F]ind [A]ll" },
-- vim.keymap.set("n", "<leader>fg", "<cmd> Telescope grep_string <CR>", { desc = "[F]ind [G]rep" }) -- looks for the work under your cursor + selection

-- ## ------------------------------------------------------------------- ## --

vim.keymap.set("n", "<leader>o", function()
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local actions = require "telescope.actions"
    local conf = require("telescope.config").values
    local action_state = require "telescope.actions.state"

    pickers.new({}, {
        prompt_title = "Select PDF to Open",
        finder = finders.new_oneshot_job({ "find", ".", "-name", "*.pdf" }),
        attach_mappings = function(prompt_bufnr, _)
            -- modifying what happens on selection with <CR>
            actions.select_default:replace(function()
                -- closing picker
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection == nil then
                    print("No PDF selected")
                    return
                end
                vim.cmd("silent ! zathura '" .. selection[1] .. "' &")
            end)
            -- keep default keybindings
            return true
        end,
        sorter = conf.generic_sorter({}),
    }):find()
end, { desc = "Open PDF" })


local commandactive = false
local group = vim.api.nvim_create_augroup("PdfMode", { clear = true })
vim.api.nvim_create_user_command("PdfMode", function()
    if commandactive then
        vim.api.nvim_clear_autocmds({ group = group })
        commandactive = false
    else
        local newfile = vim.fn.expand("%:r") .. ".pdf"
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = group,
            buffer = vim.api.nvim_get_current_buf(),
            command = "silent ! pandoc <afile> -o " .. newfile,
        })
        commandactive = true
    end
end, { desc = "Toggle Making Pdfs with Pandoc" })

-- vim.keymap.set("n", "<leader>tn", ":tabnext<cr>", {}) -- gt
-- vim.keymap.set("n", "<leader>tp", ":tabprev<cr>", {}) -- gT
vim.keymap.set("t", "<esc>", "<c-\\><c-n>", {})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("TermOpen", {}),
    callback = function()
        vim.cmd.startinsert()
    end
})

-- vim.api.nvim_create_autocmd("CursorHold", {
--     group = vim.api.nvim_create_augroup("asfaafs", {}),
--     callback = function()
--         vim.notify("asdfasdf")
--     end
-- })

-- ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷
-- ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇
-- ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽
-- ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕
-- ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕
-- ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕
-- ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄
-- ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕
-- ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿
-- ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
-- ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟
-- ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠
-- ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙
-- ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣
--
-- :'<,'>w !bash
-- local M = {}
--
-- local markdown_code_block = [[
--   (
--   fenced_code_block
--   (info_string (language) @language) (#eq? @language "python")
--   (code_fence_content) @content
--   (fenced_code_block_delimiter) @delimiter
--   )
-- ]]
--
-- local markdown_query = vim.treesitter.parse_query("markdown", markdown_code_block)
--
-- local run_code_block = function(text)
--   local split = vim.split(text, "\n")
--   local code_block = table.concat(vim.list_slice(split, 1, #split), "\n")
--   local job = require("plenary.job"):new({
--     command = "python",
--     args = { "-c", code_block },
--   })
--   return job:sync()
-- end
--
-- M.config = {}
--
-- M.setup = function(args)
--   M.config = vim.tbl_deep_extend("force", M.config, args or {})
-- end
--
-- local get_root = function(bufnr)
--   local parser = vim.treesitter.get_parser(bufnr, "markdown", {})
--   local tree = parser:parse()[1]
--   return tree:root()
-- end
--
-- M.run = function(bufnr)
--   bufnr = bufnr or vim.api.nvim_get_current_buf()
--   if vim.bo[bufnr].filetype ~= "markdown" then
--     vim.notify("Only Markdown is supported")
--     return
--   end
--   local root = get_root(bufnr)
--   for id, node in markdown_query:iter_captures(root, bufnr, 0, -1) do
--     local name = markdown_query.captures[id]
--     if name == "content" then
--       local range = { node:range() }
--       local code_block = vim.treesitter.get_node_text(node, bufnr)
--       local result = run_code_block(code_block)
--       table.insert(result, 1, "```text")
--       table.insert(result, 1, "")
--       table.insert(result, #result + 1, "```")
--       vim.api.nvim_buf_set_lines(bufnr, range[3] + 1, range[3] + 1, false, result)
--     end
--   end
-- end
--
-- return M

local gemivim = require('gemivim')
gemivim.setup({})

-- vim.keymap.set("n", "<leader>g", gemivim.open, { desc = "Open Gemini URL" })
-- vim.api.nvim_create_autocmd("BufRead", {
--     pattern = "gemtext",
--     callback = function()
--         vim.keymap.set("n", "gx", gemivim.gx, { desc = "goto link in gemtext", buffer = true})
--     end,
-- })

vim.notify = function(msg)
    vim.system({ "notify-send", msg })
    return true
end

-- See `:help modeline`
-- vim: ts=4 sts=4 sw=4 et
