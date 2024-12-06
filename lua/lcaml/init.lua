local lcaml = {}

local highlights = [[
" Vim syntax file for the LCaml Programming Language

if expand("%:e") == "lml"
  " Keywords
  syntax keyword lcamlKeyword let return if else while
  syntax keyword lcamlStruct struct
  syntax keyword lcamlType int float bool string list
  syntax keyword lcamlJit jit
  syntax keyword lcamlTodo TODO

  syntax match lcamlNumber /-\?d\+(\.d\+)\?/
  syntax match lcamlBoolean /true\|false/
  syntax match lcamlUnit /()/

  syntax match lcamlOperator /+\|-\|\*\|\/\|\/\/\|%\|==\|!=\|<\|<=\|>\|>=\|&&\|||\|!\|~\|^\|&\||/
  syntax start lcamlFunctionDef /|[a-zA-Z0-9_ ]*|/

  " Strings and Comments
  syntax region lcamlString start=/"/ end=/"/
  syntax match lcamlComment /--.*\n/
  echoerr "gonna link now"

  " Linking
  highlight link lcamlKeyword Statement
  highlight link lcamlType Type
  highlight link lcamlJit Type
  highlight link lcamlStruct Structure
  highlight link lcamlNumber Constant
  highlight link lcamlUnit Constant
  highlight link lcamlBoolean Boolean
  highlight link lcamlString String
  highlight link lcamlComment Comment
  highlight link lcamlOperator Operator
  highlight link lcamlFunctionDef Operator
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
