require("no-neck-pain").setup({
    width = 120,
    autocmds = {
        enableOnVimEnter = true,
        enableOnTabEnter = true,
    },
    buffers = {
        wo = {
            fillchars = "eob: ",
        },
    },
})
vim.keymap.set("n", "<Space>cc", "<Cmd>NoNeckPain<CR>", { silent = true })
vim.keymap.set("n", "<Space>c.", "<Cmd>NoNeckPainWidthUp<CR>", { silent = true })
vim.keymap.set("n", "<Space>c,", "<Cmd>NoNeckPainWidthDown<CR>", { silent = true })
