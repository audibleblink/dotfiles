local M = {}


M._MyBinds = {
  n = {
    ["<leader>b"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    ["<leader>p"] = { "<cmd> Telescope find_files <CR>", "Find Files" },
    ["<leader><Tab>"] = { "<cmd> b# <CR>", "Previous buffer" },
    ["<leader>z"] = { "<cmd> wincmd | <CR>:windcmd _ <CR>", "Zoom Pane" },
    ["<leader>Z"] = { "<cmd> wincmd = <CR>", "Zoom Pane" },
    ["<Enter>"] = { ":", "Command" },

    ["<C-\\>"] = { "<cmd>TmuxNavigatePrevious<cr>", "Go to the previous pane" } ,
    ["<C-h>"] = { "<cmd>TmuxNavigateLeft<cr>", "Go to the left pane" },
    ["<C-j>"] = { "<cmd>TmuxNavigateDown<cr>", "Go to the down pane" },
    ["<C-k>"] = { "<cmd>TmuxNavigateUp<cr>", "Go to the up pane" },
    ["<C-l>"] = { "<cmd>TmuxNavigateRight<cr>", "Go to the right pane" },
  },

  i = {
    ["jk"] = { "<ESC>", "escape insert mode" , opts = { nowait = true }},
    ["jj"] = { "<ESC>", "escape insert mode" , opts = { nowait = true }},
    ["C-j"] = { 'copilot#Accept("\\<CR>")', "Trigger Copilot" , opts = { nowait = true }},
  }
}

M.disabled = {
  n = {
    ["<leader>pt"] = "",
    ["<C-s>"] = "",
  }
}

return M


