local Path = require("obsidian.path")
local Note = require("obsidian.note")
local AsyncExecutor = require("obsidian.async").AsyncExecutor
local File = require("obsidian.async").File
local log = require("obsidian.log")
local search = require("obsidian.search")
local util = require("obsidian.util")
local enumerate = require("obsidian.itertools").enumerate
local zip = require("obsidian.itertools").zip
local compat = require("obsidian.compat")

--  modified version of obsidian.commands.rename

---@param client obsidian.Client
local obrename = function(client, data)
    -- {
    --   dryrun = true,
    --   src = ""
    --   dst = ""
    -- }

    local dryrun = data.dryrun

    ---@type string|?
    local arg = data.dst

    -- Resolve the note to rename.
    ---@type boolean
    local is_current_buf = false
    ---@type obsidian.Path
    local cur_note_path = Path.new(data.src)
    ---@type obsidian.Note
    local cur_note = Note.from_file(cur_note_path)

    local cur_note_id = tostring(cur_note.id)

    assert(cur_note_path)
    local dirname = assert(cur_note_path:parent(), string.format("failed to resolve parent of '%s'", cur_note_path))

    -- Parse new note ID / path from args.
    local parts = vim.split(arg, "/", { plain = true })
    local new_note_id = parts[#parts]
    if new_note_id == "" then
        log.err("Invalid new note ID")
        return
    elseif vim.endswith(new_note_id, ".md") then
        new_note_id = string.sub(new_note_id, 1, -4)
    end

    vim.notify("new_note_id: " .. new_note_id)

    ---@type obsidian.Path
    local new_note_path = (dirname / new_note_id):with_suffix(".md")

    if new_note_id == cur_note_id then
        log.warn("New note ID is the same, doing nothing")
        return
    end

    -- Write all buffers. TODO: except this one
    -- quietly(vim.cmd.wall)


    -- When the note is not loaded into a buffer we just need to rename the file.
    if not dryrun then
        cur_note_path:rename(new_note_path)
    else
        vim.notify("Dry run: renaming file '" .. tostring(cur_note_path) .. "' to '" .. tostring(new_note_path) .. "'")
    end

    -- vim.notify("cur_note_rel_path: " .. cur_note_path)
    -- vim.notify("new_note_rel_path: " .. new_note_path)

    -- TODO:
    -- if not is_current_buf then
    --     -- When the note to rename is not the current buffer we need to update its frontmatter
    --     -- to account for the rename.
    --     cur_note.id = new_note_id
    --     cur_note.path = Path.new(new_note_path)
    --     if not dryrun then
    --         cur_note:save()
    --     else
    --         log.info("Dry run: updating frontmatter of '" .. tostring(new_note_path) .. "'")
    --     end
    -- end

    local cur_note_rel_path = tostring(client:vault_relative_path(cur_note_path, { strict = true }))
    local new_note_rel_path = tostring(client:vault_relative_path(new_note_path, { strict = true }))

    -- Search notes on disk for any references to `cur_note_id`.
    -- We look for the following forms of references:
    -- * '[[cur_note_id]]'
    -- * '[[cur_note_id|ALIAS]]'
    -- * '[[cur_note_id\|ALIAS]]' (a wiki link within a table)
    -- * '[ALIAS](cur_note_id)'
    -- And all of the above with relative paths (from the vault root) to the note instead of just the note ID,
    -- with and without the ".md" suffix.
    -- Another possible form is [[ALIAS]], but we don't change the note's aliases when renaming
    -- so those links will still be valid.
    ---@param ref_link string
    ---@return string[]
    local function get_ref_forms(ref_link)
        return {
            "[[" .. ref_link .. "]]",
            "[[" .. ref_link .. "|",
            "[[" .. ref_link .. "\\|",
            "[[" .. ref_link .. "#",
            "](" .. ref_link .. ")",
            "](" .. ref_link .. "#",
        }
    end

    local reference_forms = compat.flatten({
        get_ref_forms(cur_note_id),
        get_ref_forms(cur_note_rel_path),
        get_ref_forms(string.sub(cur_note_rel_path, 1, -4)),
    })
    local replace_with = compat.flatten({
        get_ref_forms(new_note_id),
        get_ref_forms(new_note_rel_path),
        get_ref_forms(string.sub(new_note_rel_path, 1, -4)),
    })

    local executor = AsyncExecutor.new()

    local file_count = 0
    local replacement_count = 0
    local all_tasks_submitted = false

    ---@param path string|obsidian.Path
    ---@return integer
    local function replace_refs(path)
        --- Read lines, replacing refs as we go.
        local count = 0
        local lines = {}
        local f = File.open(tostring(path), "r")
        for line_num, line in enumerate(f:lines(true)) do
            for ref, replacement in zip(reference_forms, replace_with) do
                local n
                line, n = util.string_replace(line, ref, replacement)
                if dryrun and n > 0 then
                    log.info(
                        "Dry run: '"
                            .. tostring(path)
                            .. "':"
                            .. line_num
                            .. " Replacing "
                            .. n
                            .. " occurrence(s) of '"
                            .. ref
                            .. "' with '"
                            .. replacement
                            .. "'"
                    )
                end
                count = count + n
            end
            lines[#lines + 1] = line
        end
        f:close()

        --- Write the new lines back.
        if not dryrun and count > 0 then
            f = File.open(tostring(path), "w")
            f:write_lines(lines)
            f:close()
        end

        return count
    end

    local function on_search_match(match)
        local path = Path.new(match.path.text):resolve({ strict = true })
        file_count = file_count + 1
        executor:submit(replace_refs, function(count)
            replacement_count = replacement_count + count
        end, path)
    end

    search.search_async(
        client.dir,
        reference_forms,
        search.SearchOpts.from_tbl({ fixed_strings = true, max_count_per_file = 1 }),
        on_search_match,
        function(_)
            all_tasks_submitted = true
        end
    )

    -- Wait for all tasks to get submitted.
    vim.wait(2000, function()
        return all_tasks_submitted
    end, 50, false)

    -- Then block until all tasks are finished.
    executor:join(2000)

    local prefix = dryrun and "Dry run: replaced " or "Replaced "
    log.info(prefix .. replacement_count .. " reference(s) across " .. file_count .. " file(s)")

    -- In case the files of any current buffers were changed.
    vim.cmd.checktime()
end

local M = {}
M.setup = function(opts)
    local defaultopts = {
        -- TODO: add more options
    }

    opts = vim.tbl_deep_extend("force", defaultopts, opts)

    local file = require("oil.adapters.files")
    local perform_action = file.perform_action

    local obsidian = require("obsidian")
    local client = obsidian.get_client()
    -- local obrename = require("obsidian.commands.rename")

    file.perform_action = function(action, cb)
        vim.notify("Performing action: " .. action.type)

        if action.type == "move" then
            -- Set the current directory of the buffer.
            local oilname = vim.api.nvim_buf_get_name(0)
            oilname = oilname:gsub("oil://", "")

            -- Check if we're in *any* workspace.
            local workspace = obsidian.Workspace.get_workspace_for_dir(oilname, client.opts.workspaces)
            if not workspace then
                vim.notify("No workspace found for current buffer.")

                -- We're not in a workspace, so just call the original function.
                perform_action(action, cb)

                -- otherwise
                -- fs.recursive_move(action.entry_type, src_path, dest_path, cb)
            else
                local fs = require("oil.fs")

                -- local dest_adapter = assert(config.get_adapter_by_scheme(action.dest_url))
                -- if dest_adapter == M then

                local oilutil = require("oil.util")

                local _, src_path = oilutil.parse_url(action.src_url)
                assert(src_path)
                local _, dest_path = oilutil.parse_url(action.dest_url)
                assert(dest_path)

                src_path = fs.posix_to_os_path(src_path)
                dest_path = fs.posix_to_os_path(dest_path)

                vim.notify("Doing rename")
                obrename(client, {
                    dryrun = false,
                    src = src_path,
                    dst = dest_path,
                })

                -- TODO: check what this does
                cb(nil)

                -- else
                --   -- We should never hit this because we don't implement supported_cross_adapter_actions
                --   cb("files adapter doesn't support cross-adapter move")
                -- end

                -- as a fallback, just call the original function
            end
        else
            -- just call the original function
            perform_action(action, cb)
        end
    end

    package.loaded["oil.adapters.files"] = file
end

return M
