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

syntax match lcamlNumber /\<\d\+\(\.\d\+\)\?\>/
syntax match lcamlBoolean /\<true\>\|\<false\>/
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

local function GetLsPythonPath()
  -- Get the directory of this file (lua/lcaml/init.lua)
  local script_path = debug.getinfo(1, "S").source:sub(2)
  local script_dir = vim.fn.fnamemodify(script_path, ":h")
  local repo_root = vim.fn.fnamemodify(script_dir, ":h:h")
  local lsp_path = repo_root .. "/lcaml_lsp_repo"
  return lsp_path
end

function lcaml.setup(opts)
  vim.filetype.add({
    extension = {
      lml = "lml"
    }
  })
  local command
  if opts.enable_server_logs then
    command = { "python", "-m", "lcaml_ls", "--enable-logs" }
  else
    command = { "python", "-m", "lcaml_ls" }
  end
  local lspconfig = require 'lspconfig'
  local configs = require 'lspconfig.configs'
  if not configs.lcaml_ls then
    configs.lcaml_ls = {
      default_config = {
        cmd = command,
        root_dir = lspconfig.util.root_pattern('.git', 'requirements.json'),
        filetypes = { 'lml' },
        on_new_config = function(new_config, _)
          new_config.cmd_env = vim.tbl_extend(
            "force",
            new_config.cmd_env or {},
            { PYTHONPATH = GetLsPythonPath() }
          )
        end,
      },
    }
  end
  lspconfig.lcaml_ls.setup {}
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" },
    {
      pattern = "*.lml",
      callback = function()
        vim.cmd(highlights)
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
