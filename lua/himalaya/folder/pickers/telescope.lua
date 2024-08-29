local M = {}

local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local previewers = require('telescope.previewers')

local function preview_command(entry, bufnr)
  vim.api.nvim_buf_call(bufnr, function()
    local page = 0 -- page 0 for preview
    local account = vim.fn['himalaya#domain#account#current']()
    local success, output = pcall(vim.fn['himalaya#domain#email#list_with'], account, entry.value, page, '')
    if not (success) then
      vim.cmd('redraw')
      vim.bo.modifiable = true
      local errors = vim.fn.split(output, '\n')
      errors[1] = "Errors: "..errors[1]
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, errors)
    end
  end)
end

M.select = function(cb, folders)
  local previewer = nil
  local finder_opts = {
    results = folders,
    entry_maker = function(entry) return {
      value = entry.name,
      display = entry.name,
      ordinal = entry.name,
    } end,
  }
  
  if vim.g.himalaya_folder_picker_telescope_preview then
    previewer = previewers.display_content.new({})
    finder_opts.entry_maker = function(entry) return {
      value = entry.name,
      display = entry.name,
      ordinal = entry.name,
      preview_command = preview_command,
    } end
  end
  
  pickers.new {
    results_title = 'Folders',
    finder = finders.new_table(finder_opts),
    sorter = sorters.get_generic_fuzzy_sorter(),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.fn[cb](selection.display)
      end)

      return true
    end,
    previewer = previewer,
  }:find()
end

return M
