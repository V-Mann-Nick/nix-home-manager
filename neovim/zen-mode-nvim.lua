require("zen-mode").setup({
    window = {
        backdrop = 0.999999,
    },
    plugins = {
        gitsigns = { enabled = true },
    },
})
vim.keymap.set("n", "<Space>cc", "<Cmd>ZenMode<CR>", { silent = true })
