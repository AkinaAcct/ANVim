return {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = function()
        return {
            library = {
                uv = "luvit-meta/library",
                lazyvim = "LazyVim",
            },
        }
    end,
}

