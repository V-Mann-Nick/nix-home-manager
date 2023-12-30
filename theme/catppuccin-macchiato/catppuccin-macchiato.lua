require("catppuccin").setup({
    transparent_background = false,
    integrations = {
        treesitter = true,
        gitgutter = true,
        lightspeed = true,
        coc_nvim = true,
        native_lsp = {
            enabled = true,
            underlines = {
                errors = { "undercurl" },
                warnings = { "undercurl" },
                hints = { "undercurl" },
                information = { "undercurl" },
            },
        },
    },
    custom_highlights = function(colors)
        return {
            TabLineFill = { bg = colors.crust, fg = colors.text },
        }
    end,
})
vim.cmd("colorscheme catppuccin-macchiato")
