_G.vim = vim

vim.loader.enable()

-- [[ bootstrap lazy ]] --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

--------------------------------- globals -------------------------------------
-- vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings
-- vim.g.transparency = true
vim.g.mapleader = " "

-- <c-]> jump to definition
-- <c-t> jump back
-- :help tags

-- vim.g.netrw_liststyle = 3 -- Set netrw in tree view
-- vim.g.netrw_altv = true   -- Open new pane in netrw on the right

-- disable some default providers
vim.g["loaded_node_provider"] = 0
vim.g["loaded_perl_provider"] = 0
vim.g["loaded_python3_provider"] = 0
vim.g["loaded_ruby_provider"] = 0

--------------------------------- options -------------------------------------
vim.opt.clipboard = "unnamedplus" -- for what ever reason this breaks everything
-- See `:help 'clipboard'`
vim.opt.scrolloff = 8 -- Lines of context
vim.opt.spelllang = { "en" }
vim.opt.colorcolumn = "80" -- show a black bar in the 80 collum. this thing -------->
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.conceallevel = 0 -- Hide * markup for bold and italic
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.number = true -- show line numbers

vim.opt.swapfile = false

vim.opt.completeopt = "menu,menuone,noselect"

-- [[ Search ]] --
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true -- Don't ignore case with capitals

vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.mouse = "" -- Disable mouse mode
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.tabstop = 4 -- Number of spaces tabs count for

vim.opt.termguicolors = true -- True color support
vim.opt.undofile = true -- Save undo history
vim.opt.undolevels = 10000
vim.opt.updatetime = 800 -- Save swap file and trigger CursorHold
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

--------------------------------- commands ------------------------------------

-- [[ load plugins ]] --
require("lazy").setup({
    { "folke/lazy.nvim", tag = "stable" },
    -- { "actionshrimp/direnv.nvim", opts = {}, lazy = false },
    { "mbbill/undotree", cmd = "UndotreeToggle" },
    { "folke/flash.nvim", opts = {} }, -- a mouse alternative
    { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
    { "j-hui/fidget.nvim", event = "LspAttach", opts = {} },

    {
        "nvim-orgmode/orgmode",
        event = "VeryLazy",
        ft = { "org" },
        config = function()
            -- Setup orgmode
            require("orgmode").setup({
                org_agenda_files = "~/org/**/*",
                org_default_notes_file = "~/org/unsorted.org",
            })

            -- Experimental LSP support
            vim.lsp.enable("org")
        end,
    },
    {
        "chipsenkbeil/org-roam.nvim",
        lazy = false,
        tag = "0.2.0",
        dependencies = {
            {
                "nvim-orgmode/orgmode",
                tag = "0.7.0",
            },
        },
        config = function()
            require("org-roam").setup({
                directory = "~/dox",
            })
        end,
    },
    {
        "michaelb/sniprun",
        lazy = false,
        build = "sh install.sh true" -- manually build
    },

    -- use gx to open with system opener
    -- see :help Oil
    {
        "echasnovski/mini.nvim",
        version = "*",
        lazy = false,
        -- event = "BufRead",
        config = function()
            -- require("mini.ai").setup({ n_lines = 500 })
            -- require("mini.pairs").setup({})
            -- require("mini.pick").setup({})

            -- messes up flash
            -- require("mini.surround").setup({})

            -- require("mini.git").setup({
            --     command = { split = "horizontal" },
            -- })

            require("mini.icons").setup({})
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end

            require("mini.snippets").setup()

            -- see :help lsp-completion to replace this
            require("mini.completion").setup()

            -- vim.ui.open

            require("mini.tabline").setup({})

            require("mini.files").setup({
                mappings = {
                    go_out = "-",
                    go_in = "<CR>",
                },
            })

            vim.keymap.set("n", "-", function()
                require("mini.files").open()
            end, { desc = "Find Files" })
        end,
    },

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

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old
        -- branch = "main",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        -- dependencies = { "nvim-treesitter/nvim-treesitter-context", opts = {} },
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
        opts = function()
            return {
                defaults = require("telescope.themes").get_ivy(),
            }
        end,
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
                markdown = { "markdownlint-cli2" },
                -- cbfmt : codeblocks in markdown
                -- deon_fmt : markdown and js
                -- doctoc : toc for markdown
                python = { "black" },
            },
            formatters = {
                stylua = { prepend_args = { "--indent-type", "Spaces" } },
            },
        },
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- "mfussenegger/nvim-dap-python",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        -- event = "BufRead",
        lazy = false,
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup({})

            dap.listeners.before.attach.dapui_config = dapui.open
            dap.listeners.before.launch.dapui_config = dapui.open
            dap.listeners.before.event_terminated.dapui_config = dapui.close
            dap.listeners.before.event_exited.dapui_config = dapui.close

            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug Breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug Continue" })
            vim.keymap.set("n", "<leader>ds", dap.step_into, { desc = "Debug Step Into" })
            vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Debug Next" })

            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
            }

            -- print(("You entered: %s"):format(value))

            dap.configurations.c = {
                --- @feild program function|string
                {
                    name = "Launch",
                    type = "gdb",
                    request = "launch",
                    -- @type string | function(): string
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                },
            }
            dap.configurations.cpp = dap.configurations.c

            dap.configurations.rust = dap.configurations.c
            dap.configurations.rust[1].program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}"

            dap.configurations.zig = dap.configurations.c
            dap.configurations.zig[1].program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}"
        end,
    },

    -- -i | sed -e 's/0x//g' | sed -e 's/\([0-9a-f]\{2\}\)/\\x\1/g' | tr -d '\n' | pbcopy

    -- help :TOhtml
    -- :%!xxd
    -- :%!xxd -r

    -- :put w
    -- :reg
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

vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Window Move Left" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Window Move Down" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Window Move Up" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Window Move Right" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Highlight" })
vim.keymap.set("n", ";", ":")

vim.keymap.set("n", "<leader>u", ":UndotreeToggle", { desc = "Undotree" })
-- vim.keymap.set("n", "<leader>m", "<cmd> Markview splitToggle <CR>", { desc = "Markview Toggle" })

vim.keymap.set({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end, { desc = "Flash Search" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
    require("flash").treesitter()
end, { desc = "Flash Treesitter Search" })

-- vim.lsp.buf.format({ async = true })
-- map("n", "<leader>cf", vim.lsp.buf.format, "[C]ode [F]ormat")
vim.keymap.set("n", "<leader>cf", function()
    local bufnr = vim.api.nvim_get_current_buf()
    require("conform").format({ bufnr = bufnr })
end, { desc = "Code Format" })

-- vim.keymap.set("n", "<leader>n", "<cmd> cnext <CR> zz", { desc = "See the next error" })
-- ]q

-- vim.keymap.set("v", "Y", '"+y', { desc = "[Y]ank to clipboard" })

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

-- vim.keymap.set("n", "-", "<cmd> Oil <CR>", { desc = "Edit Parent Dir" })

-- # Telelscope
vim.keymap.set("n", "<leader><space>", function()
    require("telescope.builtin").find_files()
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").buffers()
end, { desc = "Find Buffers" })

vim.keymap.set("n", "<leader>fw", function()
    require("telescope.builtin").live_grep()
end, { desc = "[F]ind [W]ord" })

-- vim.keymap.set("n", "<leader>fc", function()
--     require("telescope.builtin").git_commits()
-- end, { desc = "[F]ind Git [C]ommits" })

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
    require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Search Buffer" })

-- ## ------------------------------------------------------------------- ## --

vim.keymap.set("n", "<leader>fo", function()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local actions = require("telescope.actions")
    local conf = require("telescope.config").values
    local action_state = require("telescope.actions.state")

    pickers
        .new({}, {
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
        })
        :find()
end, { desc = "Open PDF" })

-- exit terminal mode easily
vim.keymap.set("t", "<esc>", "<c-\\><c-n>", {})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("TermOpen", {}),
    callback = function()
        vim.cmd.startinsert()
    end,
})

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

-- :'<,'>w !bash

-- vim.keymap.set("n", "<leader>cr", function()
--     local markdown_code_block = [[
--       (
--         fenced_code_block
--         (info_string (language) @language) (#eq? @language "python")
--         (code_fence_content) @content
--         (fenced_code_block_delimiter) @delimiter
--       )
--     ]]
--
--     local markdown_query = vim.treesitter.parse_query("markdown", markdown_code_block)
--
--     local run_code_block = function(text)
--         local split = vim.split(text, "\n")
--         local code_block = table.concat(vim.list_slice(split, 1, #split), "\n")
--         local job = require("plenary.job"):new({
--             command = "python",
--             args = { "-c", code_block },
--         })
--         return job:sync()
--     end
--
--     local get_root = function(bufnr)
--         local parser = vim.treesitter.get_parser(bufnr, "markdown", {})
--         local tree = parser:parse()[1]
--         return tree:root()
--     end
--
--     local bufnr = vim.api.nvim_get_current_buf()
--     if vim.bo[bufnr].filetype ~= "markdown" then
--         vim.notify("Only Markdown is supported")
--         return
--     end
--     local root = get_root(bufnr)
--     for id, node in markdown_query:iter_captures(root, bufnr, 0, -1) do
--         local name = markdown_query.captures[id]
--         if name == "content" then
--             local range = { node:range() }
--             local code_block = vim.treesitter.get_node_text(node, bufnr)
--             local result = run_code_block(code_block)
--             table.insert(result, 1, "```text")
--             table.insert(result, 1, "")
--             table.insert(result, #result + 1, "```")
--             vim.api.nvim_buf_set_lines(bufnr, range[3] + 1, range[3] + 1, false, result)
--         end
--     end
-- end, { desc = "Run Code Block" })

local gemivim = require("gemivim")
gemivim.setup({})

local default_notify = vim.notify
local global_notify = function(msg)
    vim.system({ "notify-send", msg })
    return true
end

local usingglobal = false
vim.api.nvim_create_user_command("Notify", function()
    if usingglobal then
        vim.notify = default_notify
        usingglobal = false
    else
        vim.notify = global_notify
        usingglobal = true
    end
    return true
end, {})

vim.lsp.config["zls"] = {
    cmd = { "zls" },
    filetypes = { "zig" },
    root_markers = { "build.zig", ".git" },
    settings = {},
}

vim.lsp.config["rust-analyzer"] = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", ".git" },
    settings = {},
}

vim.lsp.enable({
    "zls",
    "pyright",
    "clangd",
    "lua_ls",
    "gopls",
    "ts_ls",
    "rust-analyzer",
})

-- see :help lsp-lint for reimpl
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local map = function(mode, key, action, desc)
            vim.keymap.set(mode, key, action, {
                buffer = ev.buf,
                desc = desc,
            })
        end

        map("n", "gd", function()
            -- vim.cmd("tab split")
            vim.lsp.buf.definition({
                -- reuse_win = true,
                -- loclist = true,
            })
        end, "[G]oto [D]efinition")

        map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("n", "gi", vim.lsp.buf.implementation, "[G]o [I]mplementation")
        map("n", "<leader>cn", vim.lsp.buf.rename, "[C]ode Re[N]ame")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
        map("n", "grd", vim.lsp.buf.type_definition, "LSP definition type")
        map("n", "[d", vim.diagnostic.goto_prev, "Previous [D]iagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next [D]iagnostic")
    end,
})

-- See `:help modeline`
-- vim: ts=4 sts=4 sw=4 et
