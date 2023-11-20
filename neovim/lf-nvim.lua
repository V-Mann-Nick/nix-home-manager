require("lf").setup({
    winblend = 0,
    border = "rounded",
    default_file_manager = true,
    highlights = {
        NormalFloat = { link = "Normal" },
    },
})
vim.keymap.set("n", "<Space>r", "<Cmd>Lf<CR>", { nowait = true })
-- vim.api.nvim_create_autocmd("BufEnter", {
--     event = "User",
--     pattern = "LfTermEnter",
--     callback = function(a)
--         vim.api.nvim_buf_set_keymap(a.buf, "t", "q", "q", {nowait = true})
--     end,
-- })
