local lcaml = {}

function lcaml:init()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" },
    { pattern = { "*.lml" }, callback = function() require("lcaml.syntax") end })
end

return lcaml
