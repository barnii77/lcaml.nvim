local lcaml = {}

local highlights = [[
" Vim syntax file for Your Programming Language

if !exists("b:current_syntax")
  if expand("%:e") == "lml"
    syntax clear

    " Keywords
    syntax keyword lcamlKeyword let return if else while
    syntax keyword lcamlStruct struct
    syntax keyword lcamlType int float bool string list
    syntax keyword lcamlTodo TODO

    syntax match lcamlNumber /\d+\(\.\d+\)?/
    syntax match lcamlLiteral /()\|\(\([0-9a-zA-Z_]\)\>\)\@!\(\d\+.\d\+\)\|\(\([0-9a-zA-Z_]\)\>\)\@!\(\d\+\)/
    syntax match lcamlBoolean /true\|false/

    " syntax match lcamlIdentifier /\(\(true\|false\)\>\)\@!\([a-zA-Z_][a-zA-Z0-9_]*\)/

    syntax match lcamlFunctionDef /|/
    syntax match lcamlOperator /+\|-\|\*\|\/\|%\|==\|!=\|<\|<=\|>\|>=\|&&\|||\|!\|~/

    " Strings and Comments
    syntax region lcamlString start=/"/ end=/"/
    syntax match lcamlComment /--.*\n/

    " Linking
    highlight link lcamlKeyword Statement
    highlight link lcamlType Type
    highlight link lcamlStruct Structure
    highlight link lcamlNumber Constant
    highlight link lcamlLiteral Constant
    highlight link lcamlBoolean Boolean
    " highlight link lcamlIdentifier Function  " Identifier
    highlight link lcamlString String
    highlight link lcamlComment Comment
    highlight link lcamlFunctionDef Operator
    highlight link lcamlOperator Operator
    highlight link lcamlTodo Todo

    let b:current_syntax = "lml"
  endif
endif
]]

function lcaml.setup()
  vim.filetype.add({
    extension = {
      lml = "lml"
    }
  })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" },
    { callback = function(_) vim.cmd(highlights) end })
end

return lcaml
