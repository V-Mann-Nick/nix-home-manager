require("telescope").setup({
    pickers = {
        find_files = {
            hidden = true,
            no_ignore = true,
            find_command = { "rg", "--files", "-g", "!.git", "--color", "never" },
        },
    },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<Space>p", builtin.find_files, {})
vim.keymap.set("n", "<Space>g", builtin.live_grep, {})
