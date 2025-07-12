-- Inspired by callmiy/vim-symlink
local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

local symlink_mappings = {}
local toggle_in_progress = false
local symlink_resolution_disabled = false

local function get_cache_file()
  local cache_dir = vim.fn.stdpath("state") .. "/vim-symlink"
  local sanitized_path = vim.fn.substitute(
    vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h"),
    "[\\/]",
    "%",
    "g"
  )
  if vim.fn.isdirectory(cache_dir) == 0 then
    vim.fn.mkdir(cache_dir, "p")
  end
  return cache_dir .. "/" .. sanitized_path .. ".json"
end

local function save_mappings()
  if vim.tbl_isempty(symlink_mappings) then
    return
  end

  local cache_file = get_cache_file()

  local ok, encoded = pcall(vim.json.encode, symlink_mappings)
  if ok then
    vim.fn.writefile({ encoded }, cache_file)
  end
end

local function save_mappings_async()
  vim.schedule(save_mappings)
end

local function cleanup_stale_mappings(loaded_mappings)
  for key, value in pairs(loaded_mappings) do
    if
      vim.fn.filereadable(key) == 1
      and vim.fn.filereadable(value) == 1
    then
      symlink_mappings[key] = value
      symlink_mappings[value] = key
    end
  end
end

local function load_mappings()
  local cache_file = get_cache_file()

  if vim.fn.filereadable(cache_file) == 0 then
    return
  end

  local ok, lines = pcall(vim.fn.readfile, cache_file)
  if ok and #lines > 0 then
    local decode_ok, loaded_mappings = pcall(vim.json.decode, lines[1])
    if decode_ok then
      cleanup_stale_mappings(loaded_mappings)
    end
  end
end

local function check_directory_symlinks(filepath)
  local cwd = vim.fn.getcwd()
  local relative_path = vim.fn.fnamemodify(filepath, ":.")
  local path_parts = vim.split(relative_path, "/", { plain = true })

  for i = 1, #path_parts - 1 do
    local partial_path = table.concat(vim.list_slice(path_parts, 1, i), "/")
    local full_partial = cwd .. "/" .. partial_path

    if vim.fn.getftype(full_partial) == "link" then
      local resolved_dir = vim.fn.resolve(full_partial)
      local remaining_path =
        table.concat(vim.list_slice(path_parts, i + 1), "/")
      local symlinked_path = full_partial .. "/" .. remaining_path
      local resolved_path = resolved_dir .. "/" .. remaining_path

      symlink_mappings[vim.fn.fnamemodify(symlinked_path, ":p")] =
        vim.fn.fnamemodify(resolved_path, ":p")
      symlink_mappings[vim.fn.fnamemodify(resolved_path, ":p")] =
        vim.fn.fnamemodify(symlinked_path, ":p")
      save_mappings_async()
      return true
    end
  end

  return false
end

local function discover_symlinks_for_file(filepath)
  local found_any = false

  local files = vim.fn.glob(vim.fn.getcwd() .. "/*", false, true)
  for _, path in ipairs(files) do
    if
      vim.fn.getftype(path) == "link"
      and vim.fn.resolve(path) == filepath
    then
      local absolute_path = vim.fn.fnamemodify(path, ":p")
      symlink_mappings[absolute_path] = filepath
      symlink_mappings[filepath] = absolute_path
      found_any = true
    end
  end

  if found_any then
    save_mappings_async()
  end

  return found_any
end

local function on_buf_read_resolve_symlink(filepath)
  if toggle_in_progress then
    return
  end

  if symlink_resolution_disabled then
    return
  end

  if vim.fn.filereadable(filepath) == 0 then
    return
  end

  local resolved = vim.fn.resolve(filepath)
  -- Not a symlink
  if resolved == filepath then
    return
  end

  local absolute_filepath = vim.fn.fnamemodify(filepath, ":p")
  symlink_mappings[absolute_filepath] = resolved
  symlink_mappings[resolved] = absolute_filepath

  save_mappings_async()

  if vim.fn.exists(":Bwipeout") == 2 then
    vim.cmd("silent! Bwipeout")
  else
    if vim.o.diff then
      vim.notify(
        "symlink.nvim: 'moll/vim-bbye' is required in order for this plugin to properly work in diff mode",
        vim.log.levels.ERROR
      )
      return
    end
    vim.cmd("enew")
    vim.cmd("bwipeout #")
  end

  vim.cmd("edit " .. vim.fn.fnameescape(resolved))

  if vim.g.symlink_redraw___ebnis___ == 1 then
    vim.cmd("redraw")
  end
end

local function do_symlink(opts)
  local args = vim.fn.trim(opts.args)
  if args == "abort" then
    symlink_resolution_disabled = true
    vim.notify("Symlink resolution disabled", vim.log.levels.INFO)
    return
  elseif args == "enable" then
    symlink_resolution_disabled = false
    vim.notify("Symlink resolution enabled", vim.log.levels.INFO)
    return
  elseif args == "status" then
    local status = symlink_resolution_disabled and "disabled" or "enabled"
    vim.notify("Symlink resolution is " .. status, vim.log.levels.INFO)
    return
  elseif args ~= "" then
    vim.notify(
      "Unknown argument: "
        .. args
        .. ". Use 'abort', 'enable', or 'status'",
      vim.log.levels.ERROR
    )
    return
  end

  local current_file = vim.fn.expand("%:p")

  if vim.fn.filereadable(current_file) == 0 then
    vim.notify("Current file is not readable", vim.log.levels.WARN)
    return
  end

  local target = symlink_mappings[current_file]

  if target then
    if vim.fn.filereadable(target) == 0 then
      vim.notify(
        "Target file no longer exists: " .. target,
        vim.log.levels.WARN
      )
      return
    end
  else
    -- Try loading from cache first
    load_mappings()

    if symlink_mappings[current_file] then
      target = symlink_mappings[current_file]
      if vim.fn.filereadable(target) == 0 then
        vim.notify(
          "Target file no longer exists: " .. target,
          vim.log.levels.WARN
        )
        return
      end
    else
      -- Fallback: scan directory for symlinks
      -- Also check for directory symlinks
      if
        not (
          discover_symlinks_for_file(current_file)
          or check_directory_symlinks(current_file)
        )
      then
        vim.notify(
          "No symlinks found pointing to this file",
          vim.log.levels.WARN
        )
        return
      end

      target = symlink_mappings[current_file]
    end
  end

  if vim.fn.exists(":Bwipeout") == 2 then
    vim.cmd("silent! Bwipeout")
  else
    if vim.o.diff then
      vim.notify(
        "symlink.lua: 'moll/vim-bbye' is required in order for this plugin to properly work in diff mode",
        vim.log.levels.ERROR
      )
      return
    end
    vim.cmd("enew")
    vim.cmd("bwipeout #")
  end

  toggle_in_progress = true
  vim.cmd("edit " .. vim.fn.fnameescape(target))
  toggle_in_progress = false

  if vim.g.symlink_redraw___ebnis___ == 1 then
    vim.cmd("redraw")
  end
end

return {
  "moll/vim-bbye",
  lazy = false,
  init = function()
    -- Set default values
    vim.g.symlink_redraw___ebnis___ = vim.g.symlink_redraw___ebnis___ or 1

    vim.api.nvim_create_user_command("Symlink", do_symlink, {
      nargs = "?",
      complete = function()
        return {
          "abort",
          "enable",
          "status",
        }
      end,
    })

    local augroup =
      vim.api.nvim_create_augroup("symlink_plugin", { clear = true })

    vim.api.nvim_create_autocmd("VimEnter", {
      group = augroup,
      callback = load_mappings,
    })

    vim.api.nvim_create_autocmd("VimLeave", {
      group = augroup,
      callback = save_mappings,
    })

    vim.api.nvim_create_autocmd("BufRead", {
      group = augroup,
      nested = true,
      callback = function(args)
        on_buf_read_resolve_symlink(args.file)
      end,
    })
  end,
}
