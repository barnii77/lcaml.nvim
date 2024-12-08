local lcaml = {}

local highlights = [[
" Vim syntax file for the LCaml Programming Language
set nospell
syntax clear

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

syntax match lcamlFunctionCall /\%(^\|[^a-zA-Z0-9_) ]\)\zs\<[a-zA-Z_][a-zA-Z0-9_]*\>\ze\s*\(\(\s[a-zA-Z_0-9]\)\|(\)/

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
]]

function lcaml.setup(opts)
  vim.filetype.add({
    extension = {
      lml = "lml"
    }
  })
  local command -- TODO generalize this command
  if opts.enable_server_logs then
    command = { "python", "-m", "lcaml_ls", "--enable-logs" }
  else
    command = { "python", "-m", "lcaml_ls" }
  end
  local client = vim.lsp.start_client {
    name = "lcaml_ls",
    cmd = command,
    on_init = opts.on_init_callback,
    on_attach = opts.on_attach_callback,
  }
  if not client then
    vim.notify("Failed to start LCaml Language Server", vim.log.levels.ERROR)
    return
  elseif type(client) == "string" then
    vim.notify("Failed to start LCaml Language Server: Failed with error message `" + client + "`", vim.log.levels.ERROR)
    return
  elseif opts.client_create_callback then
    opts.client_create_callback(client)
  end
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" },
    {
      pattern = "*.lml",
      callback = function()
        vim.cmd(highlights)
        vim.lsp.buf_attach_client(0, client)
      end
    })
  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = "*.lml",
    callback = function()
      vim.cmd([[syntax clear]])
    end
  })
end

return lcaml
