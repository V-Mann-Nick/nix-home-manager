require("telescope").setup({
    pickers = {
        find_files = {
            find_command = { "rg", "--files", "--ignore", "-g", "!.git", "--hidden" },
        },
    },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<Space>p", builtin.find_files, {})
vim.keymap.set("n", "<Space>g", builtin.live_grep, {})
