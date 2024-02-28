local lcaml = {}

function lcaml.init_syntax()
  vim.notify("debug: init_syntax", vim.log.levels.ERROR)
  local current_syntax = vim.bo["current_syntax"]
  if current_syntax == nil then
    vim.notify("current_syntax is nil", vim.log.levels.ERROR)
    current_syntax = ""
  end

  if vim.bo["filetype"] ~= "lml" or vim.bo["current_syntax"] ~= "" then
    local msg = "filetype" .. vim.bo["filetype"] .. " current_syntax" .. vim.bo["current_syntax"]
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end

  vim.cmd("syntax clear")
  -- Keywords
  vim.cmd("syntax keyword lcamlKeyword let return if else")
  vim.cmd("syntax keyword lcamlStruct struct")
  vim.cmd("syntax keyword lcamlType int float bool string list")
  vim.cmd("syntax keyword lcamlTodo TODO NOTE FIXME")

  vim.cmd("syntax match lcamlLiteral /[()]\\|\\d\\.\\d\\+\\|\\d\\+/")
  vim.cmd("syntax match lcamlBoolean /true\\|false/")

  vim.cmd("syntax match lcamlIdentifier /\\(\\(true\\|false\\)\\>\\)@!\\([a-zA-Z_][a-zA-Z0-9_]*\\)/")

  vim.cmd("syntax match lcamlFunctionDef /|/")
  vim.cmd("syntax match lcamlOperator /+\\|-\\|*\\|\\/\\|%\\|==\\|!=\\|<\\|<=\\|>\\|>=\\|&&\\|\\|\\|\\|!\\|~/")

  -- Strings and Comments
  vim.cmd("syntax region lcamlString start=/\"/ end=/\"/ contains=@Spell")
  vim.cmd("syntax match lcamlComment /--.*\\n/ contains=@Spell")

  -- Linking
  vim.cmd("highlight link lcamlKeyword Statement")
  vim.cmd("highlight link lcamlType Type")
  vim.cmd("highlight link lcamlStruct Structure")
  vim.cmd("highlight link lcamlLiteral Constant")
  vim.cmd("highlight link lcamlBoolean Boolean")
  vim.cmd("highlight link lcamlIdentifier Function") -- Identifier
  vim.cmd("highlight link lcamlString String")
  vim.cmd("highlight link lcamlComment Comment")
  vim.cmd("highlight link lcamlFunctionDef Operator")
  vim.cmd("highlight link lcamlOperator Operator")
  vim.cmd("highlight link lcamlTodo Todo")

  -- vim.bo.current_syntax = "lml"
end

function lcaml:init()
  vim.notify("debug: lcaml.init", vim.log.levels.ERROR)
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" },
    { pattern = { "*.lml" }, command = "lua require('lcaml'):init_syntax()" })
end

function lcaml:setup()
  vim.notify("debug: lcaml.setup", vim.log.levels.ERROR)
  lcaml:init()
end

return lcaml
