vim.g.mapleader = "{{leader}}"

-- Enable wider color range
vim.opt.termguicolors = true
-- Enable mouse support
vim.opt.mouse = "a"
-- Enable system clipboard syncing
vim.opt.clipboard:append({ "unnamedplus" })
-- Disable search highlighting
vim.opt.hlsearch = false
-- Maximum items in popup menu
vim.opt.pumheight = 10
-- Enable relative line numbering
vim.opt.relativenumber = true
-- Disable auto commenting on new lines
vim.opt.formatoptions:remove({ "c", "r", "o" })
-- No sign column flickering
vim.opt.signcolumn = "yes:1"

-- Search for the visual selection
vim.keymap.set("v", "//", "y/<C-R>0<CR>", { noremap = true })

-- Insert line without going into insert
vim.keymap.set("n", "mo", "o<Esc>k", { noremap = true })
vim.keymap.set("n", "mO", "O<Esc>j", { noremap = true })

-- Shortcut for search and replace
vim.keymap.set("n", "<leader>S", ":%s//g<Left><Left>", { noremap = true })

-- Shortcutting split navigation, saving a keypress:
vim.keymap.set("n", "<Space>h", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<Space>j", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<Space>k", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<Space>l", "<C-w>l", { noremap = true })

-- Ctrl + alt to resize windows
vim.keymap.set("n", "<C-M-j>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-M-k>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-M-h>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-M-l>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Default tab behavior
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Python tab behavior
vim.api.nvim_create_autocmd("FileType", {
    pattern = ".py",
    callback = function()
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
    end,
})

-- Lua tab behavior
vim.api.nvim_create_autocmd("FileType", {
    pattern = ".lua",
    callback = function()
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
    end,
})
