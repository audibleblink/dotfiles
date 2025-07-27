return {
  "ThePrimeagen/harpoon",
  enabled = false,
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  init = function()
    local harpoon = require("harpoon")
    harpoon:setup({})
    vim.keymap.set("n", "<leader>ha",
      function() harpoon:list():add() end,
      { desc = "Harpoon Add" }
    )
    vim.keymap.set("n", "<leader>ho",
      function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Harpoon Open" }
    )

    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

    local harpoon_extensions = require("harpoon.extensions")
    harpoon:extend(harpoon_extensions.builtins.navigate_with_number())
  end,
}
