return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  init = function()
    vim.api.nvim_create_autocmd("BufNewFile", {
      pattern = {
        vim.fn.expand("~/Docs/Notes") .. "/*.md",
        vim.fn.expand("~/Docs/Notes") .. "/**/*.md",
      },
      callback = function(args)
        vim.schedule(function()
          local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
          if #lines == 1 and lines[1] == "" then
            vim.cmd("ObsidianTemplate Note")
          end
        end)
      end,
    })
  end,
  keys = {
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian note" },
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian App" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian Backlinks" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian Template" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian notes" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch Obsidian notes" },
    { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian Today (Daily Note)" },
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    frontmatter = {
      enabled = false,
    },
    legacy_commands = false, -- this will be removed in 4.0.0

    workspaces = {
      {
        name = "personal",
        path = "~/Docs/Notes",
      },
    },

    daily_notes = {
      folder = "Daily", -- папка внутри ~/Docs/Notes
      date_format = "%Y-%m-%d",
    },

    templates = {
      subdir = "Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {},
    },

    picker = {
      name = "snacks.pick",
    },
  },
}
