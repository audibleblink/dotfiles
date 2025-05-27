return {
    'echasnovski/mini.nvim',
    lazy = false,
    config = function()
        -- Better Around/Inside textobjects
        --
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [']quote
        --  - ci'  - [C]hange [I]nside [']quote
        require('mini.ai').setup { n_lines = 500 }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup({
            mappings = {
                add = 'sa', -- Add surrounding in Normal and Visual modes
                --e.g. gsaiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
                --e.g. gsaa}) - [S]urround [A]dd [A]round [}]Braces [)]Paren
                delete = 'sd',         -- Delete surrounding
                --e.g.    gsd"   - [S]urround [D]elete ["]quotes
                replace = 'sr',        -- Replace surrounding
                --e.g.     gsr)'  - [S]urround [R]eplace [)]Paren by [']quote
                find = 'sf',           -- Find surrounding (to the right)
                find_left = 'sF',      -- Find surrounding (to the left)
                highlight = 'sh',      -- Highlight surrounding
                update_n_lines = 'sn', -- Update `n_lines`
                n_lines = 500,
            }
        })


        require("mini.indentscope").setup({
            symbol = "┃",
            draw = {
                delay = 40,
                priority = 2,
                animation = require("mini.indentscope").gen_animation.exponential({
                    easing = "in-out",
                    duration = 80,
                    unit = "total",
                }),
            },
        })

        local disabled = {
            "help",
            "terminal",
        }

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
                if disabled[vim.bo.filetype] ~= nil or vim.bo.buftype ~= "" then
                    vim.b.miniindentscope_disable = true
                end
            end,
        })

        vim.cmd([[highlight! link MiniIndentscopeSymbol Identifier]])
    end,
}
