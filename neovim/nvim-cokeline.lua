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
})
vim.keymap.set("n", "<Space>,", "<Plug>(cokeline-focus-prev)", { silent = true })
vim.keymap.set("n", "<Space>.", "<Plug>(cokeline-focus-next)", { silent = true })
vim.keymap.set("n", "<Space><", "<Plug>(cokeline-switch-prev)", { silent = true })
vim.keymap.set("n", "<Space>>", "<Plug>(cokeline-switch-next)", { silent = true })
vim.keymap.set("n", "<Space>w", ":bdelete<Enter>", { silent = true })
for i = 1, 9 do
  vim.keymap.set(
    "n",
    ("<Space>%s"):format(i),
    ("<Plug>(cokeline-focus-%s)"):format(i),
    { silent = true }
  )
end
