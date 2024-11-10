return {
    "jxm35/livecode.nvim",
    config = function()
        -- get current username
        local git_username = vim.fn.system("git config user.name")
        git_username = git_username:gsub("\n", "") -- remove \n

        -- enable livecode
        require("livecode").setup({
            username = git_username,
        })
    end,
}
