local lcaml = {}

local highlights = [[
" Vim syntax file for the LCaml Programming Language

if expand("%:e") == "lml"
  " Keywords
  syntax keyword lcamlKeyword let return if else while
  syntax keyword lcamlStruct struct
  syntax keyword lcamlType int float bool string list
  syntax keyword lcamlBuiltin print println input isinstance islike nl set list join get len slice keys values append insert pop import_lcaml import_glob import_py fuse exit sleep panic ord chr time breakpoint jit is_defined abs py_hasattr py_setattr py_getattr py_getattr_exec py_setattr_exec py_exec exec locals id copy deep_copy update_bounds openf closef writef readf readlinef readablef seekf path_exists
  syntax keyword lcamlIntrinsic __compiled __this __vm __interpreter
  syntax keyword lcamlTodo TODO

  syntax match lcamlNumber /\d\+\(\.\d\+\)\?/
  syntax match lcamlBoolean /true\|false/
  syntax match lcamlUnit /()/

  syntax match lcamlOperator /+\|-\|\*\|\/\|\/\/\|%\|==\|!=\|<\|<=\|>\|>=\|&&\|||\|!\|\~\|\^\|&\||/
  syntax match lcamlFunctionDef /|[a-zA-Z0-9_ ]\+|/

  syntax region lcamlString start=/"/ end=/"/
  syntax match lcamlComment /--.*\n/

  syntax match lcamlFunctionCall /\<[a-zA-Z_][a-zA-Z0-9_]*\>\@=\s\+\<[a-zA-Z_][a-zA-Z0-9_]*\|\d\+\|(.*)\>/

  " Linking
  highlight link lcamlKeyword Statement
  highlight link lcamlType Type
  highlight link lcamlBuiltin Special
  highlight link lcamlIntrinsic Special
  highlight link lcamlStruct Structure
  highlight link lcamlNumber Number
  highlight link lcamlUnit Constant
  highlight link lcamlBoolean Boolean
  highlight link lcamlString String
  highlight link lcamlComment Comment
  highlight link lcamlOperator Operator
  highlight link lcamlFunctionDef Function
  highlight link lcamlFunctionCall Function
  highlight link lcamlTodo Todo

  " let b:current_syntax = "lml"
endif
]]

function lcaml.setup()
  vim.filetype.add({
    extension = {
      lml = "lml"
    }
  })
  vim.api.nvim_create_autocmd({ "BufEnter" },
    { callback = function(...) vim.cmd(highlights) end })
end

return lcaml
