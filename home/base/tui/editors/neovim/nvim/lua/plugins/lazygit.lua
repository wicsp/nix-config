return {
    "kdheepak/lazygit.nvim",
    lazy = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>lg", "<cmd>LazyGit<CR>", desc = "Toggle Lazygit" },
    },
}
