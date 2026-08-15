vim.env.EDITOR = "nv"
vim.env.PATH = vim.env.HOME .. "/.local/bin:" .. vim.env.PATH

vim.loader.enable()
vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/folke/flash.nvim",
	{ src = "https://github.com/nvim-orgmode/orgmode", version = "0.7.0" },
	{ src = "https://github.com/chipsenkbeil/org-roam.nvim", version = "0.2.0" },
	-- { src = "https://github.com/gingerfocus/org-roam-ui" },
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/folke/tokyonight.nvim",
})

-- for _, pkg in ipairs(vim.pack.get()) do if not pkg.active then vim.pack.del({ pkg.spec.name }) end end

--------------------------------- helpers -------------------------------------

-- modified from https://nvim-mini.org/MiniMax/configs/nvim-0.12/
local gr = vim.api.nvim_create_augroup("custom-config", {})
local function newautocmd(event, callback)
	vim.api.nvim_create_autocmd(event, { group = gr, callback = callback })
end

--------------------------------- globals -------------------------------------
-- vim.g.transparency = true
vim.g.mapleader = " "

-- disable some default providers
vim.g["loaded_node_provider"] = 0
vim.g["loaded_perl_provider"] = 0
vim.g["loaded_python3_provider"] = 0
vim.g["loaded_ruby_provider"] = 0

vim.g.neovide_opacity = 0.8

--------------------------------- options -------------------------------------
vim.opt.clipboard = "unnamedplus" -- see `:help 'clipboard'`
vim.opt.colorcolumn = "80" -- black bar, this thing ------------------->
vim.opt.confirm = true -- confirm exiting modified buffer
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic
vim.opt.concealcursor = "c"
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.ignorecase = true -- Search ignore case
vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.mouse = "a" -- Enable mouse for opencode in terminal mode
vim.opt.number = true -- show line numbers
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.scrolloff = 8 -- Lines of context
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.spelllang = { "en" } -- not enought to enable spelling
vim.opt.swapfile = false
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.undofile = true -- Save undo history
vim.opt.undolevels = 1000
vim.opt.updatetime = 800 -- Save swap file and trigger CursorHold
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

--------------------------------- plugins -------------------------------------

-- TODO: setup mini.pick before so ui.select is ready
-- require("neovim-project").setup {
--     projects = { "~/dev/*", "~/dox" },
--     -- ignore_projects = { "~/dev/*.git/" } -- TODO: worktrees
--     last_session_on_startup = true,
--     dashboard_mode = false,
-- }

require("mini.misc").setup({})

newautocmd("ColorScheme", function()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end)
require("tokyonight").setup({ transparent = true })

-- vim.cmd.colorscheme("minisummer")
-- vim.cmd.colorscheme("miniautumn")
vim.cmd.colorscheme("tokyonight-storm")

-- todo make these on very lazy
MiniMisc.safely("later", function()
	require("orgmode").setup({
		org_agenda_files = "~/dox/*", -- "~/dox/**/*"
		org_todo_keywords = { "TODO(t)", "PROJ(p)", "HOLD(h)", "|", "KILL(k)", "DONE(d)" },
		org_todo_keyword_faces = {
			TODO = ":foreground blue :background #000000",
			PROJ = ":foreground cyan :weight bold",
			HOLD = ":foreground white :background black",
			KILL = ":foreground red :slant italic",
			DONE = ":foreground green :slant italic",
		},
		org_hide_leading_stars = true,

		-- makes it so that I can be backwards compatible with my old config
		org_startup_indented = true,
		org_adapt_indentation = false,

		-- start on sunday
		calendar_week_start_day = 0,

		org_default_notes_file = "~/dox/10 - README.org",
		org_capture_templates = {
			t = { description = "Task", template = "* TODO %?" },
			p = { description = "Item", template = "* PROJ %?" }, -- date: %u
			l = { description = "Link", template = "** %?\n: %x", headline = "Links" },
			a = {
				description = "ASMR",
				template = "*** %?\n%u\n: %x\n\n+ Artist:", -- paste link from clipboard
				target = "~/dox/01 - Projects/ASMR List.org",
				headline = "Unsorted",
				properties = { empty_lines = 1 },
			},
		},
	})
	require("org-roam").setup({
		directory = "~/dox",
		database = { update_on_save = false },
		extensions = {
			dailies = {
				bindings = false,
				directory = "05 - Fleeting/Daily",
			},
		},
	})

	-- vim.opt.rtp:prepend("/home/focus/dev/org-roam-ui")
	-- require("org-roam-ui").setup {}
	-- build = "npm install",
end)

require("nvim-treesitter").setup({})
require("nvim-treesitter").install({
	"rust",
	"javascript",
	"zig",
	"java",
})

-- allows the ii and ai text object
require("mini.indentscope").setup({
	draw = {
		delay = 0, -- 100
		-- animation = require('mini.indentscope').gen_animation.none(),
	},
	-- Which character to use for drawing scope indicator
	symbol = "|", -- '╎',
})

-- require("mini.bracketed").setup {}
require("mini.icons").setup({})
-- require("mini.ai").setup({ n_lines = 500 })
-- require("mini.pairs").setup({})
-- require("mini.git").setup({ command = { split = "horizontal" } })
require("mini.tabline").setup({})
-- require("mini.snippets").setup()
require("mini.completion").setup({}) -- :help lsp-completion
-- help mini.cmdline
-- help mini.comment

-- :help nvim_open_win()
require("mini.pick").setup({ window = { config = { width = 999, height = 16 } } })

local files = require("mini.files")
files.setup({ mappings = {
	go_out = "-",
	go_in = "<CR>",
} })

local flash = require("flash")
flash.setup({})

require("mini.extra").setup({})

require("gemivim").setup({})

local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		{ mode = { "n", "x" }, keys = "<Leader>" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = { "n", "x" }, keys = "g" },
		{ mode = { "n", "x" }, keys = "'" },
		{ mode = { "n", "x" }, keys = '"' },
		{ mode = "n", keys = "<C-w>" },
		{ mode = { "n", "x" }, keys = "z" },
	},
	clues = {
		miniclue.gen_clues.square_brackets(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
		{ mode = "n", keys = "<leader>b", desc = "+buffer" },
		-- { mode = "n", keys = "<leader>c", desc = "+code" },
		{ mode = "n", keys = "<leader>f", desc = "+find" },
		{ mode = "n", keys = "<leader>n", desc = "+roam" },
		{ mode = "n", keys = "<leader>o", desc = "+org" },
		{ mode = "n", keys = "<leader>r", desc = "+run" },
		{ mode = "n", keys = "<leader>g", desc = "+gmni" },
	},
	window = { delay = 200 },
})

-----------------------------[[ key mappings ]]--------------------------------
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- ## buffers
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR><cmd>bnext<CR>", { desc = "buffer delete" })
vim.keymap.set("n", "<leader>bc", "<cmd>enew<cr> ", { desc = "buffer create" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "buffer prev" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "buffer next" })
vim.keymap.set("n", "<leader>bw", MiniExtra.pickers.buf_lines, { desc = "search word" })

-- ## pickers
vim.keymap.set("n", "<leader> ", MiniPick.builtin.files, { desc = "find files" })
vim.keymap.set("n", "<leader>fb", MiniPick.builtin.buffers, { desc = "find buffers" })
vim.keymap.set("n", "<leader>fh", MiniPick.builtin.help, { desc = "find help" })
vim.keymap.set("n", "<leader>fw", MiniPick.builtin.grep_live, { desc = "find word" })
vim.keymap.set("n", "<leader>fd", MiniExtra.pickers.diagnostic, { desc = "find diagnostic" })
vim.keymap.set("n", "<leader>fo", MiniExtra.pickers.oldfiles, { desc = "find oldfiles" })
vim.keymap.set("n", "<leader>fe", MiniExtra.pickers.explorer, { desc = "find explore" })
vim.keymap.set("n", "<leader>fm", MiniExtra.pickers.manpages, { desc = "find manpages" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR><cmd>update<CR>", {})
-- vim.keymap.set("n", ";", ":", { desc = "command mode" })
vim.keymap.set("n", "-", files.open, { desc = "Find Files" })

vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "search" })
vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "search treesitter" })

vim.keymap.set("n", "n", "nzz", { desc = "next search" }) -- searching for terms keeps cursor/highlight in the middle
vim.keymap.set("n", "N", "Nzz", { desc = "prev search" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>rt", function()
	vim.cmd.vsplit()
	vim.cmd.terminal()
end, { desc = "run terminal" })

-- TODO: how to fuck does this work
vim.keymap.set("n", "<leader>rf", function()
	local selection = MiniPick.builtin.cli(
		{ command = { "fd", "-I" } },
		{ source = {
			choose = function()
				return false
			end,
		} }
	)
	if not selection then
		return
	end
	vim.system({ "open", selection }, { env = {} }) -- env sets up server name
end, { desc = "run file" })

-- opens links in specific profile
-- try it: https://example.com
vim.keymap.set("n", "gx", function()
	local url = vim.fn.expand("<cfile>")
	if not url then
		return
	end
	if url:match("https?://") then
		local profiles = { "work", "priv", "ingonito" }
		MiniPick.ui_select(profiles, { prompt = "browser profile" }, function(choice)
			if not choice then
				return
			end
			if choice == "ingonito" then
				vim.system({ "zen-beta", "--new-tab", "--private-window", url })
				return
			end
			vim.system({ "zen-beta", "--new-tab", "-P", choice, url })
		end, { window = { config = { height = #profiles } } })
	else
		vim.system({ "open", url })
	end
end, { desc = "Open link in specific browser" })

vim.keymap.set("t", "<esc>", "<c-\\><c-n>", {}) -- exit easily
newautocmd("TermOpen", function()
	vim.cmd.startinsert()
end)

-- MiniExtra.pickers.lsp({ scope = 'references' })
-- todo: remap `,` to something better

--- ## ----------------------------------------------------------------- ## ---
-- grt, gri

vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
vim.lsp.enable({ "clangd", "tsgo", "gopls", "zls", "lua_ls", "rust_analyzer", "pyright", "tinymist" })
local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		zig = { "zigfmt" },
	},
})
newautocmd("BufWritePre", function()
	-- vim.lsp.buf.format()
	conform.format()
end)

--- ## ----------------------------------------------------------------- ## ---

-- :'<,'>w !bash
-- ]q
-- see `:help mark`
-- todo: disable org-roam dailies
-- -i | sed -e 's/0x//g' | sed -e 's/\([0-9a-f]\{2\}\)/\\x\1/g' | tr -d '\n' | pbcopy
-- :help :TOhtml
-- :%!xxd
-- :%!xxd -r
-- :put w
-- :reg
-- <c-]> jump to definition
-- <c-t> jump back
-- :help tags
-- Define your preferred browser executable (e.g., "firefox", "google-chrome", "brave")

-- See `:help modeline`
-- vim: ts=4 sts=4 sw=4 et
