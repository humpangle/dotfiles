local map_key = require("utils").map_key

local M = {}

M.on_attach = function(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return {
      desc = "Nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  -- BEGIN_DEFAULT_ON_ATTACH

  -- map_key("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))

  -- map_key("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))

  -- map_key("n", "y", api.fs.copy.filename, opts("Copy Name"))

  -- map_key("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))

  map_key("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))

  map_key(
    "n",
    "<C-e>",
    api.node.open.replace_tree_buffer,
    opts("Open: In Place")
  )

  map_key("n", "<C-k>", api.node.show_info_popup, opts("Info"))
  map_key("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))

  map_key("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))

  map_key(
    "n",
    "<C-x>",
    api.node.open.horizontal,
    opts("Open: Horizontal Split")
  )

  map_key(
    "n",
    "<BS>",
    api.node.navigate.parent_close,
    opts("Close Directory")
  )

  map_key("n", "<CR>", api.node.open.edit, opts("Open"))
  map_key("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
  map_key("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))

  map_key("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))

  map_key("n", ".", api.node.run.cmd, opts("Run Command"))
  map_key("n", "-", api.tree.change_root_to_parent, opts("Up"))
  map_key("n", "a", api.fs.create, opts("Create File Or Directory"))
  map_key("n", "bd", api.marks.bulk.delete, opts("Delete Bookmarked"))
  map_key("n", "bt", api.marks.bulk.trash, opts("Trash Bookmarked"))
  map_key("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))

  map_key(
    "n",
    "B",
    api.tree.toggle_no_buffer_filter,
    opts("Toggle Filter: No Buffer")
  )

  map_key("n", "c", api.fs.copy.node, opts("Copy"))

  map_key(
    "n",
    "C",
    api.tree.toggle_git_clean_filter,
    opts("Toggle Filter: Git Clean")
  )

  map_key("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
  map_key("n", "]c", api.node.navigate.git.next, opts("Next Git"))
  map_key("n", "d", api.fs.remove, opts("Delete"))
  map_key("n", "D", api.fs.trash, opts("Trash"))
  map_key("n", "E", api.tree.expand_all, opts("Expand All"))
  map_key("n", "e", api.fs.rename_basename, opts("Rename: Basename"))

  map_key(
    "n",
    "]e",
    api.node.navigate.diagnostics.next,
    opts("Next Diagnostic")
  )

  map_key(
    "n",
    "[e",
    api.node.navigate.diagnostics.prev,
    opts("Prev Diagnostic")
  )

  map_key("n", "F", api.live_filter.clear, opts("Live Filter: Clear"))
  map_key("n", "f", api.live_filter.start, opts("Live Filter: Start"))
  map_key("n", "g?", api.tree.toggle_help, opts("Help"))

  map_key("n", "ge", api.fs.copy.basename, opts("Copy Basename"))

  map_key(
    "n",
    "H",
    api.tree.toggle_hidden_filter,
    opts("Toggle Filter: Dotfiles")
  )

  map_key(
    "n",
    "I",
    api.tree.toggle_gitignore_filter,
    opts("Toggle Filter: Git Ignore")
  )

  map_key("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
  map_key("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))

  map_key(
    "n",
    "L",
    api.node.open.toggle_group_empty,
    opts("Toggle Group Empty")
  )

  map_key(
    "n",
    "M",
    api.tree.toggle_no_bookmark_filter,
    opts("Toggle Filter: No Bookmark")
  )

  map_key("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
  map_key("n", "o", api.node.open.edit, opts("Open"))

  map_key(
    "n",
    "O",
    api.node.open.no_window_picker,
    opts("Open: No Window Picker")
  )

  map_key("n", "p", api.fs.paste, opts("Paste"))
  map_key("n", "P", api.node.navigate.parent, opts("Parent Directory"))
  map_key("n", "q", api.tree.close, opts("Close"))
  map_key("n", "r", api.fs.rename, opts("Rename"))
  map_key("n", "R", api.tree.reload, opts("Refresh"))
  map_key("n", "s", api.node.run.system, opts("Run System"))
  map_key("n", "S", api.tree.search_node, opts("Search"))
  map_key("n", "u", api.fs.rename_full, opts("Rename: Full Path"))

  map_key(
    "n",
    "U",
    api.tree.toggle_custom_filter,
    opts("Toggle Filter: Hidden")
  )

  map_key("n", "W", api.tree.collapse_all, opts("Collapse"))
  map_key("n", "x", api.fs.cut, opts("Cut"))

  map_key("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
  map_key("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))

  -- END_DEFAULT_ON_ATTACH

  -- custom mappings
  map_key("n", "yy", function()
    local count = vim.v.count

    if count == 0 then
      api.fs.copy.filename()
      return
    end

    if count == 1 then
      api.fs.copy.relative_path()
      return
    end

    if count == 2 then
      api.fs.copy.absolute_path()
      return
    end
  end, opts("Copy Name"))

  map_key("n", "t", api.node.open.tab, opts("Open: New Tab"))
end

return M
