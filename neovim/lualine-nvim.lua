require("lualine").setup({
    options = {
        theme = "nordfox",
        extensions = { "fzf", "nvim-tree", "fugitive" },
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
    },
})
