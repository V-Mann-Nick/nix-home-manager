require("zen-mode").setup({
    plugins = {
        gitsigns = { enabled = true },
    },
})
vim.keymap.set("n", "<Space>cc", "<Cmd>ZenMode<CR>", { silent = true })
