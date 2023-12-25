require("catppuccin").setup({
    transparent_background = false,
    integrations = {
        treesitter = true,
        gitgutter = true,
        coc_nvim = true,
        lightspeed = true,
    },
    custom_highlights = function(colors)
        return {
            TabLineFill = { bg = colors.crust, fg = colors.text },
        }
    end,
})
vim.cmd("colorscheme catppuccin-macchiato")
