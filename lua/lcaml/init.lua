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
  local lsp_path = repo_root .. "/lcaml_ls"
  return lsp_path
end

function lcaml.setup(opts)
  vim.filetype.add({
    extension = {
      lcaml = { "lml" }
    }
  })
  local command
  if opts.enable_server_logs and opts.log_path then
    if type(opts.log_path) ~= "string" then
      error("opts.log_path must be string")
    end
    command = { "python", "-m", "lcaml_ls", "--enable-logs", "--log-to", opts.log_path }
  elseif opts.enable_server_logs then
    command = { "python", "-m", "lcaml_ls", "--enable-logs" }
  else
    command = { "python", "-m", "lcaml_ls" }
  end
  local python_path
  if opts.manual_python_path then
    python_path = opts.manual_python_path
  else
    python_path = GetLsPythonPath()
  end
  local cmd_env = { PYTHONPATH = python_path }
  local client = vim.lsp.start_client({
    name = "lcaml_ls",
    -- cmd_env = cmd_env,
    cmd = command,
    -- on_init = opts.on_init_callback,
    -- on_attach = opts.on_attach_callback,
  })
  if not client then
    vim.notify("Failed to start lcaml lsp with code " .. tostring(client), vim.log.levels.ERROR)
    return
  else
    vim.notify("language server has client id " .. tostring(client), vim.log.levels.INFO)
  end
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" },
    {
      pattern = "markdown",
      callback = function()
        vim.cmd(highlights)
      end
    })
  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = "markdown",
    callback = function()
      vim.cmd([[syntax clear]])
    end
  })
  vim.api.nvim_create_autocmd({ "FileType" },
    {
      pattern = "markdown",
      callback = function()
        vim.notify("opened markdown file", vim.log.levels.INFO)
        vim.lsp.enable("lcaml_ls")
        vim.lsp.buf_attach_client(0, client)
      end
    })
end

-- function lcaml.setup(opts)
--   -- vim.filetype.add({
--   --   extension = {
--   --     lcaml = { "lml" }
--   --   }
--   -- })
--   local command
--   if opts.enable_server_logs and opts.log_path then
--     if type(opts.log_path) ~= "string" then
--       error("opts.log_path must be string")
--     end
--     command = { "python", "-m", "lcaml_ls", "--enable-logs", "--log-to", opts.log_path }
--   elseif opts.enable_server_logs then
--     command = { "python", "-m", "lcaml_ls", "--enable-logs" }
--   else
--     command = { "python", "-m", "lcaml_ls" }
--   end
--   local python_path
--   if opts.manual_python_path then
--     python_path = opts.manual_python_path
--   else
--     python_path = GetLsPythonPath()
--   end
--   local cmd_env = { PYTHONPATH = python_path }
--   local client = vim.lsp.start_client({
--     cmd_env = cmd_env,
--     name = "lcaml_ls",
--     cmd = command,
--     -- on_init = opts.on_init_callback,
--     -- on_attach = opts.on_attach_callback,
--   })
--   if not client then
--     vim.notify("Failed to start lcaml lsp with code " .. tostring(client), vim.log.levels.ERROR)
--     return
--   else
--     vim.notify("language server has client id " .. tostring(client), vim.log.levels.INFO)
--   end
--   vim.notify("on init called", vim.log.levels.INFO)
--   vim.filetype.add {
--     extension = {
--       lcaml = function(path, bufnr)
--         vim.notify("triggered filetype check thingy", vim.log.levels.INFO)
--         if path:sub(-4) == ".lml" then
--           -- attach ls
--           vim.notify("will try to attach now", vim.log.levels.INFO)
--           local success = vim.lsp.buf_attach_client(bufnr, client)
--           if not success then
--             vim.notify("failed to attach lsp client", vim.log.levels.ERROR)
--           end
--         end
--       end
--     }
--   }
--   -- vim.lsp.config["lcaml_ls"] = {
--   --   cmd_env = cmd_env,
--   --   filetypes = { "lcaml" },
--   --   cmd = command,
--   --   on_init = opts.on_init_callback,
--   --   on_attach = opts.on_attach_callback,
--   -- }
--   -- vim.lsp.enable("lcaml")
--   -- local client = vim.lsp.start_client {
--   --   cmd_env = cmd_env,
--   --   name = "lcaml_ls",
--   --   cmd = command,
--   --   on_init = opts.on_init_callback,
--   --   on_attach = opts.on_attach_callback,
--   -- }
--   -- if not client then
--   --   vim.notify("Failed to start lcaml lsp", vim.log.levels.ERROR)
--   --   return
--   -- end
--   local lspconfig = require 'lspconfig'
--   local configs = require 'lspconfig.configs'
--   if not configs.lcaml_ls then
--     configs.lcaml_ls = {
--       default_config = {
--         cmd = command,
--         root_dir = lspconfig.util.root_pattern('*'),
--         filetypes = { 'lcaml' },
--         on_new_config = function(new_config, _)
--           new_config.cmd_env = vim.tbl_extend(
--             "force",
--             new_config.cmd_env or {},
--             { PYTHONPATH = python_path }
--           )
--         end,
--       },
--     }
--   end
--   lspconfig.lcaml_ls.setup {}
--   vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" },
--     {
--       pattern = "*.lml",
--       callback = function()
--         vim.cmd(highlights)
--         -- vim.notify("please just work", vim.log.levels.INFO)
--         -- vim.lsp.buf_attach_client(0, client)
--       end
--     })
--   -- vim.api.nvim_create_autocmd({ "FileType" },
--   --   {
--   --     pattern = "*.lml",
--   --     callback = function()
--   -- local bufnr = vim.api.nvim_get_current_buf()
--   -- local active_clients = vim.lsp.get_clients({ bufnr = bufnr })
--   -- local all_clients = require 'lspconfig.configs'
--   -- local already_attached = false

--   -- for _, client in pairs(active_clients) do
--   --   if client.name == "lcaml_ls" then
--   --     already_attached = true
--   --     break
--   --   end
--   -- end
--   -- vim.notify("already_attached = " .. tostring(already_attached), vim.log.levels.DEBUG)

--   -- if not already_attached then
--   --   for _, client in pairs(all_clients) do
--   --     if client.name == "lcaml_ls" then
--   --       vim.notify("attaching lcaml lsp client " .. vim.inspect(client) .. " to " .. tostring(bufnr),
--   --         vim.log.levels.DEBUG)
--   --       vim.lsp.buf_attach_client(bufnr, client.id)
--   --       break
--   --     else
--   --       vim.notify("found client with name " .. client.name, vim.log.levels.DEBUG)
--   --     end
--   --   end
--   -- end
--   --   end
--   -- })
--   vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
--     pattern = "*.lml",
--     callback = function()
--       vim.cmd([[syntax clear]])
--     end
--   })
-- end

return lcaml
