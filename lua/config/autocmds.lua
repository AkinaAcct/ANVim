-- 获取 Neovim 版本信息
local nvim_version = vim.version()

-- 检查主要版本和次要版本
if nvim_version.major < 0 or (nvim_version.major == 0 and nvim_version.minor < 10) then
    -- 显示错误信息
    vim.api.nvim_err_writeln("[FATAL]: Neovim version 0.10 or higher is required!")

    -- 等待用户按回车键
    print("Press Enter to exit Neovim...")
    vim.fn.input("")

    -- 退出 Neovim
    vim.cmd("qa!") -- 立即退出 Neovim
end
