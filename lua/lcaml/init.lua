local lcaml = {}

function lcaml:init()
  local callback = function(_) require("lcaml.syntax") end
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNewFile" },
    { pattern = { "*.lml" }, callback = callback })
end

return lcaml
