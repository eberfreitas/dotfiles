return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      chat = {
        adapter = "qwen",
      },
      inline = {
        adapter = "qwen",
      },
      agent = {
        adapter = "qwen",
      },
    },
    adapters = {
      qwen = function()
        return require("codecompanion.adapters").extend("ollama", {
          name = "qwen",
          schema = {
            model = {
              default = "qwen3:latest",
            },
          },
        })
      end,
    },
  },
}
