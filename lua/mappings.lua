require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>cx", function()
  require("nvchad.tabufline").closeAllBufs()
end, { desc = "Close All Buffers" })

map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find Todo" })
map("n", "\\", "<cmd>:vsplit <CR>", { desc = "Vertical Split" })

-- Git
map("n", "<leader>gl", ":Flog<CR>", { desc = "Git Log" })
map("n", "<leader>gf", ":DiffviewFileHistory<CR>", { desc = "Git File History" })
map("n", "<leader>gc", ":DiffviewOpen HEAD~1<CR>", { desc = "Git Last Commit" })
map("n", "<leader>gt", ":DiffviewToggleFile<CR>", { desc = "Git File History" })
map("n", "<leader>gh", ":BlameToggle<CR>", { desc = "Git File inline History" })
map("n", "<leader>gk", ":Floggit<CR>", { desc = "Open Commit options" })
map("n", "<leader>gfa",":Git fetch origin --recurse-submodules=no --progress --prune<CR>")
map("n", "<leader>gp",":Git push<CR>", { desc = "git push"})
map("n", "<leader>gP",":Git push --force<CR>", { desc = "git push with force option"})
map("n", "<leader>gC",":Telescope conventional_commits<CR>", { desc = "git conventional commit"})

-- Terminal
map("n", "<C-]>", function()
  require("nvchad.term").toggle { pos = "vsp", size = 0.4 }
end, { desc = "Toogle Terminal Vertical" })
map("n", "<C-\\>", function()
  require("nvchad.term").toggle { pos = "sp", size = 0.4 }
end, { desc = "Toogle Terminal Horizontal" })
map("t", "<C-]>", function()
  require("nvchad.term").toggle { pos = "vsp" }
end, { desc = "Toogle Terminal Vertical" })
map("t", "<C-\\>", function()
  require("nvchad.term").toggle { pos = "sp" }
end, { desc = "Toogle Terminal Horizontal" })
map("t", "<C-f>", function()
  require("nvchad.term").toggle { pos = "float" }
end, { desc = "Toogle Terminal Float" })
map("n", "<leader>q", ":q<CR>", { desc = "quit" })
map("n", "<leader>qq", ":q!<CR>", { desc = "!quit" })
map("n", "<leader>fd", function()
  -- print("Путь в leader fd",vim.fn.expand("%:p:h"))
  require("telescope.builtin").live_grep { cwd = vim.fn.expand("%:p:h") }
end, { desc = "Telescope find in current directory" }
)

map("n", "<leader>fif", function()
  local cwd = require("nvim-tree.api").tree.get_node_under_cursor().absolute_path
  -- print(cwd, pwd, result)
  require("telescope.builtin").live_grep { cwd = cwd }
end, { desc = "find at cursor directory" }
)

--
-- TODO Сделай чтобы нормально работало
-- map("n", "<C-F>",
--   -- ':echo "Ctrl + Shift + F Pressed"<CR>',
--   function()
--     local cwd = require("nvim-tree.api").tree.get_node_under_cursor().absolute_path
--     -- print(cwd, pwd, result)
--     require("telescope.builtin").live_grep { cwd = cwd }
--   end,
--   { desc = "find at cursor directory" }
-- )

-- Basic

-- map("i", "jj", "<ESC>")
-- map("i", "<C-g>", function()
--   return vim.fn["codeium#Accept"]()
-- end, { expr = true })
--
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
