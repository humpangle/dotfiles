local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

local utils = require("utils")

return {
  {
    -- "ldelossa/gh.nvim",
    "cosmicbuffalo/gh.nvim", -- use this one fixes https://github.com/ldelossa/gh.nvim/issues/94
    commit = "73a8bd7",
    dependencies = {
      {
        "ldelossa/litee.nvim",
      },
    },
    cmd = {
      "GH",
      "GHAddLabel",
      "GHApproveReview",
      "GHCloseCommit",
      "GHClosePR",
      "GHCloseReview",
      "GHCollapseCommit",
      "GHCollapsePR",
      "GHCollapseReview",
      "GHCreateThread",
      "GHDeleteReview",
      "GHExpandCommit",
      "GHExpandPR",
      "GHExpandReview",
      "GHNextThread",
      "GHNotifications",
      "GHOpenDebugBuffer",
      "GHOpenIssue",
      "GHOpenPR",
      "GHOpenToCommit",
      "GHOpenToPR",
      "GHPRDetails",
      "GHPopOutCommit",
      "GHPopOutPR",
      "GHPreviewIssue",
      "GHRefresh",
      "GHRefreshComments",
      "GHRefreshIssues",
      "GHRefreshNotifications",
      "GHRefreshPR",
      "GHRemoveLabel",
      "GHRequestedReview",
      "GHReviewed",
      "GHSearchIssues",
      "GHSearchPRs",
      "GHStartReview",
      "GHSubmitReview",
      "GHToggleThreads",
      "GHToggleViewed",
      "GHViewWeb",
    },
    config = function()
      vim.cmd("FzfLua register_ui_select")

      require("litee.lib").setup({
        debug_logging = true,
        panel = {
          orientation = "right",
          panel_size = 30,
        },
      })

      require("litee.gh").setup({
        icon_set = "nerd",
        keymaps = {
          -- CONVO BUFFER KEYMAPS
          -- Open actions that can be performed
          actions = "gA",
          submit_comment = "gS",
          resolve_thread = "gR",
          -- /END CONVO BUFFER KEYMAPS
        },
      })

      local keys = {
        {
          "<leader>gh",
          group = "Github",
        },
        -- COMMITS
        {
          "<leader>ghc",
          group = "Commits",
        },
        {
          "<leader>ghcc",
          "<cmd>GHCloseCommit<cr>",
          {
            desc = "Close",
          },
        },
        {
          "<leader>ghce",
          "<cmd>GHExpandCommit<cr>",
          {
            desc = "Expand",
          },
        },
        {
          "<leader>ghco",
          "<cmd>GHOpenToCommit<cr>",
          {
            desc = "Open To",
          },
        },
        {
          "<leader>ghcp",
          "<cmd>GHPopOutCommit<cr>",
          {
            desc = "Pop Out",
          },
        },
        {
          "<leader>ghcz",
          "<cmd>GHCollapseCommit<cr>",
          {
            desc = "Collapse",
          },
        },
        -- END COMMITS

        -- START ISSUES
        {
          "<leader>ghi",
          group = "Issues",
        },
        {
          "<leader>ghip",
          "<cmd>GHPreviewIssue<cr>",
          {
            desc = "Preview",
          },
        },
        -- END ISSUES

        -- START LITEE
        {
          "<leader>ghl",
          group = "Litee",
        },
        {
          "<leader>ghlt",
          "<cmd>LTPanel<cr>",
          {
            desc = "Toggle Panel",
          },
        },
        -- END LITEE

        {
          "<leader>ghr",
          group = "Review",
        },

        {
          "<leader>ghrb",
          "<cmd>GHStartReview<cr>",
          {
            desc = "Begin",
          },
        },
        {
          "<leader>ghrc",
          "<cmd>GHCloseReview<cr>",
          {
            desc = "Close",
          },
        },
        {
          "<leader>ghrd",
          "<cmd>GHDeleteReview<cr>",
          {
            desc = "Delete",
          },
        },
        {
          "<leader>ghre",
          "<cmd>GHExpandReview<cr>",
          {
            desc = "Expand",
          },
        },
        {
          "<leader>ghrs",
          "<cmd>GHSubmitReview<cr>",
          {
            desc = "Submit",
          },
        },
        {
          "<leader>ghrz",
          "<cmd>GHCollapseReview<cr>",
          {
            desc = "Collapse",
          },
        },
        {
          "<leader>ghp",
          group = "Pull Request",
        },
        {
          "<leader>ghpc",
          "<cmd>GHClosePR<cr>",
          {
            desc = "Close",
          },
        },
        {
          "<leader>ghpd",
          "<cmd>GHPRDetails<cr>",
          {
            desc = "Details",
          },
        },
        {
          "<leader>ghpe",
          "<cmd>GHExpandPR<cr>",
          {
            desc = "Expand",
          },
        },
        {
          "<leader>ghpo",
          "<cmd>GHOpenPR<cr>",
          {
            desc = "Open",
          },
        },
        {
          "<leader>ghpp",
          "<cmd>GHPopOutPR<cr>",
          {
            desc = "PopOut",
          },
        },
        {
          "<leader>ghpr",
          "<cmd>GHRefreshPR<cr>",
          {
            desc = "Refresh",
          },
        },
        {
          "<leader>ghpt",
          "<cmd>GHOpenToPR<cr>",
          {
            desc = "Open To",
          },
        },
        {
          "<leader>ghpz",
          "<cmd>GHCollapsePR<cr>",
          {
            desc = "Collapse",
          },
        },
        {
          "<leader>ght",
          group = "Threads",
        },
        {
          "<leader>ghtc",
          "<cmd>GHCreateThread<cr>",
          {
            desc = "Create",
          },
        },
        {
          "<leader>ghtn",
          "<cmd>GHNextThread<cr>",
          {
            desc = "Next",
          },
        },
        {
          "<leader>ghtt",
          "<cmd>GHToggleThread<cr>",
          {
            desc = "Toggle",
          },
        },
        {
          "<leader>ghhd",
          "<cmd>GHOpenDebugBuffer<cr>",
          {
            desc = "Github Debug",
          },
        },
        {
          "<leader>gh1",
          function()
            local search_text = " commented on "

            local count = vim.v.count

            if count == 1 then
              search_text = "\\[pending\\]"
            end

            vim.fn.setreg("/", search_text)
            vim.cmd("set hlsearch")
            pcall(vim.cmd, "normal! n")
          end,
          {
            desc = "GH highlight comment",
          },
        },
      }

      local wk_ok, wk = pcall(require, "which-key")

      if wk_ok then
        -- register with which key if available.
        wk.add(keys)
      else
        for _, key in ipairs(keys) do
          if not key.group then
            utils.map_key("n", key[1], key[2], key[3])
          end
        end
      end
    end,
  },
}
