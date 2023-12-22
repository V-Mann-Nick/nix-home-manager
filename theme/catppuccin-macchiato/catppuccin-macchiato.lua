require("catppuccin").setup({
    transparent_background = true,
    integrations = {
        treesitter = true,
    },
    custom_highlights = function(colors)
        return {
            TabLineFill = { bg = colors.crust, fg = colors.text },
        }
    end,
})
vim.cmd("colorscheme catppuccin-macchiato")
