return {
    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({
                filetype = { 'markdown', 'conf' }
            })
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
    -- set keybinds to open and close markdown
    vim.keymap.set("n", "<leader>m", function()
        require("peek").open()
    end, { desc = "Peek Open" }),
    vim.keymap.set("n", "<leader>c", function()
        require("peek").close()
    end, { desc = "Peek Close" }),
}
