local lcaml = {}

local function enable_syntax_highlighting()
  require("lcaml.syntax")
end

function lcaml.init()
  vim.api.nvim_create_autocmd(
    {
      "BufEnter", "BufWinEnter"
    },
    {
      pattern = { "*.lml" },
      callback = enable_syntax_highlighting,
    }
  )
end

return lcaml
