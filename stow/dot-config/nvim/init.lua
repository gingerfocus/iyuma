local vim = _G.vim
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
o.scrolloff = 8      -- Lines of context
o.showmode = false   -- Dont show mode since we have a statusline
o.spelllang = { "en" }
o.colorcolumn = "80" -- show a black bar in the 80 collum. this thing -------->
o.confirm = true     -- Confirm to save changes before exiting modified buffer
o.conceallevel = 2   -- Hide * markup for bold and italic
o.completeopt = "menu,menuone,noselect"
o.cursorline = true  -- Enable highlighting of the current line
o.expandtab = true   -- Use spaces instead of tabs
o.number = true      -- show line numbers

-- [[ Search ]] --
o.ignorecase = true              -- Ignore case
o.smartcase = true               -- Don't ignore case with capitals

o.list = true                    -- Show some invisible characters (tabs...
o.mouse = "a"                    -- Enable mouse mode
o.shiftwidth = 4                 -- Size of an indent
o.tabstop = 4                    -- Number of spaces tabs count for

o.termguicolors = true           -- True color support
o.undofile = true                -- Save undo history
o.undolevels = 10000
o.updatetime = 200               -- Save swap file and trigger CursorHold
o.wildmode = "longest:full,full" -- Command-line completion mode
o.winminwidth = 5                -- Minimum window width
o.wrap = false                   -- Disable line wrap

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
o.whichwrap:append("<>[]hl")

--------------------------------- commands ------------------------------------

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    callback = vim.hl.on_yank,
    pattern = "*",
})

-- [[ load plugins ]] --
require("lazy").setup({
    { "folke/lazy.nvim",           tag = "stable" },
    { "actionshrimp/direnv.nvim",  opts = {},             lazy = false },
    { "stevearc/oil.nvim",         opts = {},             lazy = false },
    { "mbbill/undotree",           cmd = "UndotreeToggle" },
    { "folke/flash.nvim",          opts = {} }, -- a mouse alternative
    { "echasnovski/mini.pairs",    event = "BufRead",     opts = {} },
    { "echasnovski/mini.ai",       event = "BufRead",     opts = { n_lines = 500 } },
    { "echasnovski/mini.surround", event = "BufRead",     opts = {} },


    -- tokyonight
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                transparent = true,
                styles = {
                    sidebars = "transparent",
                    comments = { italic = false }, -- nice but doesnt work in tmux
                },
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

    -- better vim.ui
    -- { "stevearc/dressing.nvim", opts = {}, lazy = false },


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
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context",
        },
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
        -- branch = "0.1.x",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            defaults = {
                prompt_prefix = "   ",
                selection_caret = " ",
                initial_mode = "insert",
                file_ignore_patterns = { "node_modules", "target", "build", ".zig-cache" },
                set_env = { ["COLORTERM"] = "truecolor" },
            },
        },
    },

    {
        "stevearc/conform.nvim",
        cmd = "ConformInfo",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                fish = { "fish_indent" },
                sh = { "shfmt" },
                zig = { "zig" },
            },
            formatters = {
                stylua = { prepend_args = { "--indent-type", "Spaces" } },
                zig = { prepend_args = { "fmt" } },
            },
        },
    },


    {
        "olimorris/codecompanion.nvim",
        cmd = { "CodeCompanion", "CodeCompanionChat" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "OXY2DEV/markview.nvim",
                ft = { "markdown", "codecompanion" },
                opts = {
                    preview = {
                        filetypes = { "markdown", "codecompanion" },
                        ignore_buftypes = {},
                    },
                },
            },
        },
        opts = {},
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            {
                "supermaven-inc/supermaven-nvim",
                opts = {
                    keymaps = { accept_suggestion = nil },
                    disable_inline_completion = true,
                    ignore_filetypes = { "bigfile", "" },
                },
            }
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
                    { name = "supermaven" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "buffer" },
                    { name = "path" },
                },
            }
            cmp.setup(opts)
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "j-hui/fidget.nvim",        event = "LspAttach", opts = {} },
            { "simrat39/rust-tools.nvim", opts = {} },
        },
        config = function()
            local lspconfig = require("lspconfig")
            -- local capabilities = require("blink.cmp").get_lsp_capabilities()
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            local servers = { "zls", "pyright", "clangd", "hls", "ocamllsp", "lua_ls", "gopls" }
            for _, server in pairs(servers) do
                lspconfig[server].setup({ capabilities = capabilities })
            end

            -- vim.diagnostic.config({
            --     underline = true,
            --     update_in_insert = false,
            --     virtual_text = {
            --         spacing = 4,
            --         source = "if_many",
            --         prefix = "●",
            --     },
            --     severity_sort = true,
            -- })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local bufnr = ev.buf

                    -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                    local map = function(mode, key, action, desc)
                        local opt = { buffer = bufnr }
                        opt["desc"] = desc
                        vim.keymap.set(mode, key, action, opt)
                    end

                    map("n", "K", vim.lsp.buf.hover, "LSP hover")

                    map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
                    -- map("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map("n", "gi", vim.lsp.buf.implementation, "[G]o [I]mplementation")
                    map("n", "gr", vim.lsp.buf.references, "[G]oto [R]eferences")

                    map("n", "<leader>cn", vim.lsp.buf.rename, "[C]ode Re[N]ame")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
                    map("n", "<leader>cf", function()
                        vim.lsp.buf.format({ async = true })
                    end, "[C]ode [F]ormat")

                    -- map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbol")
                    -- map("n", "<leader>ls", vim.lsp.buf.signature_help, "LSP signature help")
                    -- ["<leader>D"] = {
                    --     vim.lsp.buf.type_definition,
                    --     "LSP definition type",
                    -- },

                    map("n", "<leader>cd", vim.diagnostic.open_float, "[C]ode [D]iagnostics")
                    map("n", "[d", vim.diagnostic.goto_prev, "Previous [D]iagnostic")
                    map("n", "]d", vim.diagnostic.goto_next, "Next [D]iagnostic")
                end,
            })
        end,
    },

    {
        "epwalsh/obsidian.nvim",
        enabled = false,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "hrsh7th/nvim-cmp",
        },
        opts = {
            workspaces = { { name = "main", path = "~/dox" } },
            notes_subdir = "notes",
            completion = { min_chars = 0 },
            mappings = {
                ["gf"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
                -- vim.keymap.set("n", "gl", "<cmd>ObsidianFollowLink<CR>", { desc = "Obsidian: Follow [L]ink" })
            },
            preferred_link_style = "wiki",
            disable_frontmatter = false,
            follow_url_func = function(url)
                vim.fn.jobstart({ "xdg-open", url })
            end,
            picker = { name = "telescope.nvim" },
        },
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        opts = {
            menu = {
                width = vim.api.nvim_win_get_width(0) - 4,
            },
            settings = {
                save_on_toggle = true,
            },
        },
        keys = function()
            local keys = {
                {
                    "<leader>a",
                    function()
                        require("harpoon"):list():add()
                    end,
                    desc = "Harpoon File",
                },
                {
                    "<c-e>", -- "<leader>h",
                    function()
                        local harpoon = require("harpoon")
                        harpoon.ui:toggle_quick_menu(harpoon:list())
                    end,
                    desc = "Harpoon Quick Menu",
                },
            }

            for i = 1, 5 do
                table.insert(keys, {
                    "<leader>" .. i,
                    function()
                        require("harpoon"):list():select(i)
                    end,
                    desc = "Harpoon to File " .. i,
                })
            end
            return keys
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
vim.keymap.set("n", "<leader>bd", "<cmd> bd <CR> <cmd> bnext <CR>", { desc = "[B]uffer [D]elete" })
vim.keymap.set("n", "<leader>bc", "<cmd> enew <CR> ", { desc = "[B]uffer [C]reate" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "[B]uffer [N]ext" })

-- ## windows
vim.keymap.set("n", "<leader>ww", "<C-w>p", { desc = "Other window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-w>c", { desc = "Delete window", remap = true })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split window below", remap = true })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window right", remap = true })
vim.keymap.set("n", "<leader>wv", "<C-w>v<C-w>l", { desc = "[S]plit [V]ertical pane" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Highlight" })
vim.keymap.set("n", ";", ":")

vim.keymap.set("n", "<leader>u", ":UndotreeToggle", { desc = "Toggle [U]ndotree" })

vim.keymap.set({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end, { desc = "Flash [S]earch" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
    require("flash").treesitter()
end, { desc = "Flash Treesitter [S]earch", })

vim.keymap.set("n", "<leader>cf", function()
    local bufnr = vim.api.nvim_get_current_buf()
    require("conform").format({ bufnr = bufnr })
end, { desc = "[C]ode [F]ormat" })

-- vim.keymap.set("n", "<leader>n", "<cmd> cnext <CR> zz", { desc = "See the next error" })
-- ]q

vim.keymap.set("v", "Y", '"+y', { desc = "[Y]ank to clipboard" })

vim.keymap.set("n", "n", "nzz") -- searching for terms keeps cursor/highlight in the middle
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Resize window using <ctrl> arrow keys
-- map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
-- map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
-- map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

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
end, { desc = "[F]ind [B]uffers" })

vim.keymap.set("n", "<leader>fw", function()
    require("telescope.builtin").live_grep()
end, { desc = "[F]ind [W]ord" })

vim.keymap.set("n", "<leader>fc", function()
    require("telescope.builtin").git_commits()
end, { desc = "[F]ind Git [C]ommits" })

vim.keymap.set("n", "<leader>fd", function()
    require("telescope.builtin").diagnostics()
end, { desc = "[F]ind [D]iagnostics" })

vim.keymap.set("n", "<leader>p", function()
    require("telescope.builtin").registers()
end, { desc = "[P]aste Register" })

vim.keymap.set("n", "<leader>/", function()
    local simpletheme = require("telescope.themes").get_dropdown({
        previewer = false,
        winblend = 10,
    })
    require("telescope.builtin").current_buffer_fuzzy_find(simpletheme)
end, { desc = "[/] Search in current buffer" })

-- vim.keymap.set('n', '<leader>fh', tele.help_tags, { desc = '[S]earch [H]elp' })
-- ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "[F]ind [A]ll" },
-- ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "[F]u[Z]zy Find" },
-- vim.keymap.set("n", "<leader>fg", "<cmd> Telescope grep_string <CR>", { desc = "[F]ind [G]rep" }) -- looks for the work under your cursor + selection
-- { "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },

-- { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
-- { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
-- { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },

-- ## ------------------------------------------------------------------- ## --

vim.g.pdf_viewer = false
vim.api.nvim_create_user_command("PdfOpen", function(opts)
    if not vim.g.pdf_viewer then
        vim.cmd("silent ! setsid -f zathura")
        vim.g.pdf_viewer = true
    end

    opts.args = opts.fargs
    vim.cmd("silent ! setsid -f zathura " .. opts.args)
end, { desc = "Open PDF" })

local group = vim.api.nvim_create_augroup("PdfMode", { clear = true })
vim.api.nvim_create_user_command("PdfMode", function()
    if vim.g.pandoc_autocmd_active then
        vim.api.nvim_clear_autocmds({ group = group })
        vim.g.pandoc_autocmd_active = false
    else
        local newfile = vim.fn.expand("%:r") .. ".pdf"
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = group,
            pattern = "*.md",
            command = "silent ! pandoc <afile> -o " .. newfile,
        })
        vim.g.pandoc_autocmd_active = true
    end
end, { desc = "Toggle Making Pdfs with Pandoc" })

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

-- See `:help modeline`
-- vim: ts=4 sts=4 sw=4 et
