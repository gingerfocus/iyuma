local M = {}

local fn = vim.fn
local prefix = "/tmp/gemivim/"
local bookmarks = os.getenv("HOME") .. "/.local/share/gmni/bookmarks.gmi"

local function error_msg(msg)
    vim.notify(msg, vim.log.levels.ERROR)
end

local function tmp_file_name(url, mime_type)
    local file = url:gsub("gemini://", "")
    if not file:find("/") then
        file = file .. "/"
    end
    file = prefix .. file
    if mime_type == "text/gemini" and file:match("/$") then
        return file .. "index.gmi"
    else
        return file
    end
end

local function ssl_error(output)
    for _, line in ipairs(vim.split(output, "\n")) do
        local code = line:match(".*SSL error (%d+)$")
        if code then
            return tonumber(code)
        end
    end
    return 0
end

local last_url = nil
local default_trust = 'fail'

function M.get(url, trust)
    last_url = url

    -- cache files as static, this can be bad
    local file = tmp_file_name(url, "text/gemini")
    if vim.uv.fs_stat(file) then
        vim.cmd("view " .. file)
        return
    end

    trust = trust or default_trust
    local cmd = { "gmni", "-i", "-j", trust, url }

    if fn.executable("gmni") == 0 then
        error_msg("gmni is not installed. Visit https://sr.ht/~sircmpwn/gmni/")
        return
    end

    -- vim.tohtml
    -- help :source
    --*vim.in_fast_event()*
    local obj = vim.system(cmd, { text = true }):wait()
    local stdout, stderr = obj.stdout, obj.stderr

    if #stderr > 0 and ssl_error(stderr) == 62 then
        local choice = vim.fn.confirm(stderr, "trust always\nonce\nabort", 3)
        -- vim.schedule_wrap(function(choice)
        if choice == 1 then
            vim.schedule(function() M.get(url, "always") end)
        elseif choice == 2 then
            vim.schedule(function() M.get(url, "once") end)
        else
            vim.notify("Aborted", vim.log.levels.INFO)
        end
        return
    end
    -- elseif #stderr > 0 then
    --     error_msg(stderr)
    --     return
    -- end

    local lines = vim.split(stdout, "\n")
    local header = vim.split(lines[1] or "", " ")
    if header[1]:match("1%d") then
        local prompt = table.concat(header, " ", 2) .. ": "

        vim.ui.input({ prompt = prompt }, vim.schedule_wrap(function(input)
            if not input then
                vim.notify("Nevermind", vim.log.levels.INFO)
                return
            end
            return M.get(url .. "?" .. input, trust)
        end))
    elseif header[1]:match("2%d") then
        local mime = vim.split(header[2] or "", ";")[1]
        local tmp_file = tmp_file_name(url, mime)

        local dir = vim.fs.dirname(tmp_file)
        fn.mkdir(dir, "p")
        -- if not vim.fs.exists(dir) then
        -- end

        table.remove(lines, 1)
        fn.writefile(lines, tmp_file)

        vim.cmd("view " .. tmp_file)
    elseif header[1]:match("3%d") then
        return M.get(header[2], trust)
    elseif header[1]:match("[456]%d") then
        error_msg(url .. ": " .. stdout)
    else
        error_msg(url .. ": " .. stdout .. stderr)
    end
end

function M.open()
    vim.ui.input({ prompt = "Open gemini URL: " }, function(url)
        if not url then
            vim.notify("Nevermind", vim.log.levels.INFO)
            return
        end
        if not url:match("^gemini://") then
            url = "gemini://" .. url
        end
        M.get(url)
    end)
end

function M.url()
    if last_url then
        return last_url
    end

    local bufname = fn.bufname()
    local parsed = bufname:gsub("^" .. prefix, "gemini://")
    local url = parsed:gsub("index%.gmi$", "")
    return url
end

function M.gx()
    -- vim.api.nvim_get_current_line()
    local url = fn.expand("<cWORD>")
    if url:match("^gemini://") then
        -- some other site
        M.get(url)
    elseif url:match("^https?://") or url:match("^gopher://") then
        -- some external site
        vim.cmd("! xdg-open " .. url)
    else
        -- some relative site

        local addr = M.url()
        local stripped = addr:gsub("^gemini://", "")
        local sections = vim.split(stripped, "/", { plain = true, trimempty = true })

        if url[0] == "/" then
            -- its a root url
            local root = sections[1]
            M.get("gemini://" .. root .. url)
        else
            -- its a relative url

            -- strip last unless its the root
            local keep
            if #sections > 2 then
                keep = #sections - 1
            else
                keep = 1
            end

            local newurl = ""
            for i = 1, keep do
                newurl = newurl .. sections[i] .. "/"
            end
            url = "gemini://" .. newurl .. url
            M.get(url)
        end
    end
end

function M.edit()
    vim.cmd("edit " .. bookmarks)
end

function M.bookmark()
    local url = M.url()

    -- add to bookmarks logic
    fn.writefile({ "=> " .. url }, bookmarks, "a")

    vim.notify("Added to bookmarks: " .. url, vim.log.levels.INFO)
end

local defaults = {
    keymaps = {
        { mode = "n", lhs = "<leader>go", rhs = M.open, desc = "Open Gemini URL" },
        { mode = "n", lhs = "<leader>ge", rhs = M.edit, desc = "Edit Gemini Bookmarks" },
    },
    gemini = {
        keymaps = {
            { mode = "n", lhs = "gx",         rhs = M.gx,       desc = "Goto link in gemtext" },
            { mode = "n", lhs = "<leader>gb", rhs = M.bookmark, desc = "Add URL to bookmarks" },
        },
    },
    trust = "fail",
}

function M.setup(opts)
    -- vim.tbl_deep_extend("force", defaults, opts or {})
    opts = defaults

    for _, mapping in pairs(opts.keymaps) do
        vim.keymap.set(mapping.mode, mapping.lhs, mapping.rhs, { desc = mapping.desc })
    end
    vim.api.nvim_create_autocmd("BufRead", {
        pattern = prefix .. "*.gmi",
        callback = function()
            for _, mapping in pairs(opts.gemini.keymaps) do
                vim.keymap.set("n", mapping.lhs, mapping.rhs, { desc = mapping.desc, buffer = true })
            end
            -- vim.wo.wrap = true -- Enable line wrap
            -- vim.wo.textwidth = 78 -- Set text width
        end,
    })
    default_trust = opts.trust
end

return M
