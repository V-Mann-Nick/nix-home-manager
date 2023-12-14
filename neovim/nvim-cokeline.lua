vim.opt.mousemoveevent = true

local get_hl_attr = require("cokeline.hlgroups").get_hl_attr

require("cokeline").setup({
    buffers = {
        -- Filter out directory buffers
        filter_valid = function(buf)
            local path = vim.fn.getbufinfo(buf.number)[1].name
            local is_directory = vim.fn.isdirectory(path) == 1
            return not is_directory
        end,
    },
    sidebar = {
        components = {
            {
                text = " ",
            },
        },
    },
    default_hl = {
        fg = function(buffer)
            return buffer.is_focused and get_hl_attr("ColorColumn", "bg") or get_hl_attr("Normal", "fg")
        end,
        bg = function(buffer)
            return buffer.is_focused and get_hl_attr("Normal", "fg") or get_hl_attr("TabLineFill", "bg")
        end,
    },
    components = {
        {
            text = " ",
            bg = get_hl_attr("TabLineFill", "bg"),
        },
        {
            text = "",
            fg = function(buffer)
                return buffer.is_focused and get_hl_attr("Normal", "fg") or get_hl_attr("TabLineFill", "bg")
            end,
            bg = get_hl_attr("TabLineFill", "bg"),
        },
        {
            text = function(buffer)
                return " " .. buffer.devicon.icon
            end,
            fg = function(buffer)
                return buffer.devicon.color
            end,
        },
        {
            text = function(buffer)
                return buffer.unique_prefix
            end,
            fg = function()
                return get_hl_attr("Comment", "fg")
            end,
            italic = true,
        },
        {
            text = function(buffer)
                return buffer.filename
            end,
            underline = function(buffer)
                if buffer.is_hovered and not buffer.is_focused then
                    return true
                end
            end,
        },
        {
            text = " ",
        },
        -- Don't think this is supported for coc. Not sure ????
        -- {
        --     -- Show diagnostics for the current buffer
        --     -- if error then error, else warning, else info, else nothing
        --     text = function(buffer)
        --         diagnostics = buffer.diagnostics
        --         if diagnostics.errors > 0 then
        --             return " "
        --         elseif diagnostics.warnings > 0 then
        --             return " "
        --         elseif diagnostics.infos > 0 then
        --             return " "
        --         elseif diagnostics.hints > 0 then
        --             return " "
        --         end
        --         return ""
        --     end,
        --     fg = function(buffer)
        --         diagnostics = buffer.diagnostics
        --         if diagnostics.errors > 0 then
        --             return get_hl_attr("DiagnosticError", "fg")
        --         elseif diagnostics.warnings > 0 then
        --             return get_hl_attr("DiagnosticWarn", "fg")
        --         elseif diagnostics.infos > 0 then
        --             return get_hl_attr("DiagnosticInfo", "fg")
        --         elseif diagnostics.hints > 0 then
        --             return get_hl_attr("DiagnosticHint", "fg")
        --         end
        --     end,
        -- },
        {
            ---@param buffer Buffer
            text = function(buffer)
                if buffer.is_modified then
                    return ""
                end
                if buffer.is_hovered then
                    return "󰅙"
                end
                return "󰅖"
            end,
            on_click = function(_, _, _, _, buffer)
                buffer:delete()
            end,
        },
        {
            text = " ",
        },
        {
            text = "",
            -- fg = get_hl_attr('ColorColumn', 'bg'),
            fg = function(buffer)
                return buffer.is_focused and get_hl_attr("Normal", "fg") or get_hl_attr("TabLineFill", "bg")
            end,
            bg = get_hl_attr("TabLineFill", "bg"),
        },
    },
})

vim.keymap.set("n", "<Space>,", "<Plug>(cokeline-focus-prev)", { silent = true })
vim.keymap.set("n", "<Space>.", "<Plug>(cokeline-focus-next)", { silent = true })
vim.keymap.set("n", "<Space><", "<Plug>(cokeline-switch-prev)", { silent = true })
vim.keymap.set("n", "<Space>>", "<Plug>(cokeline-switch-next)", { silent = true })
vim.keymap.set("n", "<Space>w", ":bdelete<Enter>", { silent = true })
-- vim.keymap.set("n", "<Space>w", function ()
--     local current_buffer = vim.api.nvim_get_current_buf()
--     require("cokeline.utils").buf_delete(current_buffer)
-- end, { silent = true })
for i = 1, 9 do
    vim.keymap.set("n", ("<Space>%s"):format(i), ("<Plug>(cokeline-focus-%s)"):format(i), { silent = true })
end
