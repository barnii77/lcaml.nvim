local lcaml = {}

function lcaml.setup()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" },
    { pattern = { "*.lml" }, callback = function() require("lcaml.syntax") end })
end

return lcaml
