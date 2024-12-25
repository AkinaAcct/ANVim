-- get Neovim version
local nvim_version = vim.version()

-- check version
-- if lower than 0.10, then exit
if nvim_version.major < 0 or (nvim_version.major == 0 and nvim_version.minor < 10) then
    -- show err msg
    vim.api.nvim_err_writeln("[FATAL]: Neovim version 0.10 or higher is required!")

    -- wait Enter
    print("Press Enter to exit Neovim...")
    vim.fn.input("")

    -- exit Neovim
    vim.cmd("qa!")
end

-- This file is automatically loaded by lazyvim.config.init.

local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        (vim.hl or vim.highlight).on_yank()
    end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = augroup("resize_splits"),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "PlenaryTestPopup",
        "checkhealth",
        "dbout",
        "gitsigns-blame",
        "grug-far",
        "help",
        "lspinfo",
        "neotest-output",
        "neotest-output-panel",
        "neotest-summary",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set("n", "q", function()
                vim.cmd("close")
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, {
                buffer = event.buf,
                silent = true,
                desc = "Quit buffer",
            })
        end)
    end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("man_unlisted"),
    pattern = { "man" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
    end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup("json_conceal"),
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Automatically insert a file header when creating a new file
local function insert_file_header()
    -- Check if border char is set
    if not vim.g.header_border_char or vim.g.header_border_char == "" then
        vim.notify(
            "Warning: `vim.g.header_border_char` is not set. Using default border `#`. Set it in `lua/config/option.lua`.",
            vim.log.levels.WARN
        )
        vim.g.header_border_char = "#" -- Set the default border char
    end

    local filename = vim.fn.expand('%:t')
    local date = os.date('%Y-%m-%d %H:%M')

    local author = vim.fn.system("git config user.name")
    author = author:gsub("\n", "")

    local header_lines = {
        string.format("File: %s", filename),
        string.format("Author: %s", author),
        string.format("Date: %s", date),
        "Description: "
    }

    local max_length = 0
    for _, line in ipairs(header_lines) do
        if #line > max_length then
            max_length = #line
        end
    end

    -- Dynamically obtain border char
    local border_char = vim.g.header_border_char or "#"
    local border_length = max_length + 2 -- 1 for space, 1 for border_char
    local border_line = string.rep(border_char, border_length)

    local header = border_line .. "\n"
    for _, line in ipairs(header_lines) do
        local padded_line = border_char .. " " .. line
        header = header .. padded_line .. "\n"
    end
    header = header .. border_line .. "\n"

    vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(header, '\n'))
end

-- Check whether automatic file header insertion is enabled
if vim.g.enable_file_header then
    vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = "*",
        callback = insert_file_header,
    })
end

