require("nightfox").setup({
    options = {
        styles = {
            types = "NONE",
            numbers = "NONE",
            strings = "NONE",
            comments = "italic",
            keywords = "bold,italic",
            constants = "NONE",
            functions = "italic",
            operators = "NONE",
            variables = "NONE",
            conditionals = "italic",
            virtual_text = "NONE",
        },
    },
})
vim.cmd("colorscheme nordfox")
