if true then
	return
end

local M = {}

M.config = {
	notes_dir = vim.env.HOME .. "/notes",
	depth = 5,
}

M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

--- Collect all 12-digit IDs from notes_dir/*.typ files, with filenames for preview
M._collect_ids = function()
	local cmd = string.format(
		[[find "%s" -maxdepth %d -type f -name '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-*.typ' 2>/dev/null %s]],
		M.config.notes_dir,
		M.config.depth,
		[[| while IFS= read -r f; do base="${f##*/}"; printf "%s\t%s\n" "${base%%-*}" "${base##[0-9]*-}"; done]]
	)
	local handle = io.popen(cmd)
	if not handle then
		return {}
	end
	local items = {}
	for line in handle:lines() do
		local id, name = line:match("^(%d%d%d%d%d%d%d%d%d%d%d%d)\t(.+)$")
		if id then
			items[#items + 1] = {
				id = id,
				label = id .. "  " .. name,
				insertText = id,
				filterText = id .. " " .. name,
			}
		end
	end
	handle:close()
	return items
end

M.complete = function(findstart, base)
	if findstart == 1 then
		local line = vim.api.nvim_get_current_line()
		local col = vim.api.nvim_win_get_cursor(0)[2]
		local before = line:sub(1, col)

		-- Find start position: inside #link-id("...") quotes
		local start = before:find('#link%-id%("', 1)
		if start then
			start = start + 10 -- length of #link-id("
			if start <= col then
				return start
			end
		end
		return -3 -- cancel if not inside the right context
	end

	-- Completion candidates
	local items = M._collect_ids()
	local results = {}
	for _, item in ipairs(items) do
		if item.id:find(base, 1, true) then
			table.insert(results, item)
		end
	end
	return results
end

--- Convenience: set up omni-completion for typ files
M.attach = function(bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.require'zlink'.complete"
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = function(args)
		M.attach(args.buf)
	end,
})

return M
