local uv, api, lsp, fn = vim.loop, vim.api, vim.lsp, vim.fn
local fmt = {}

local function get_format_opt()
  local file_name = api.nvim_buf_get_name(0)
  local fmt_tools = {
    go = {
      cmd = 'golines',
      args = { '--max-len=100', file_name },
    },
    lua = {
      cmd = 'stylua',
      args = { '-' },
    },
  }

  if fmt_tools[vim.bo.filetype] then
    return fmt_tools[vim.bo.filetype]
  end
  return nil
end

local check_same = function(tbl1, tbl2)
  if #tbl1 ~= #tbl2 then
    return false
  end
  for k, v in ipairs(tbl1) do
    if v ~= tbl2[k] then
      return false
    end
  end
  return true
end

local function safe_close(handle)
  if not uv.is_closing(handle) then
    uv.close(handle)
  end
end

local temp_data = {}

function fmt:format_file(err, data, opt)
  assert(not err, err)
  if data then
    local lines = vim.split(data, '\n')
    if next(temp_data) ~= nil and not temp_data[#temp_data]:find('\n') then
      temp_data[#temp_data] = temp_data[#temp_data] .. lines[1]
      table.remove(lines, 1)
    end

    for _, line in pairs(lines) do
      table.insert(temp_data, line)
    end
    return
  end

  if next(temp_data) == nil then
    return
  end

  if not api.nvim_buf_is_valid(opt.buffer) then
    return
  end

  local curr_changedtick = api.nvim_buf_get_changedtick(opt.buffer)

  if opt.initial_changedtick ~= curr_changedtick then
    return
  end

  if string.len(temp_data[#temp_data]) == 0 then
    table.remove(temp_data, #temp_data)
  end

  local cur_content = api.nvim_buf_get_lines(opt.buffer, 0, -1, false)
  if not check_same(cur_content, temp_data) then
    local view = fn.winsaveview()
    api.nvim_buf_set_lines(opt.buffer, 0, -1, false, temp_data)
    fn.winresetview(view)
  end

  temp_data = {}
end

function fmt:get_buf_contents(bufnr)
  local contents = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, text in pairs(contents) do
    contents[i] = text .. '\n'
  end
  return contents
end

function fmt:new_spawn(opt)
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local stdin = uv.new_pipe(false)

  self.handle, self.pid = uv.spawn(opt.cmd, {
    args = opt.args,
    stdio = { stdin, stdout, stderr },
  }, function(_, _)
    uv.read_stop(stdout)
    uv.read_stop(stderr)
    safe_close(self.handle)
    safe_close(stdout)
    safe_close(stderr)
  end)

  uv.read_start(
    stdout,
    vim.schedule_wrap(function(err, data)
      self:format_file(err, data, opt)
    end)
  )

  uv.read_start(stderr, function(err, _)
    assert(not err, err)
  end)

  if opt.contents then
    uv.write(stdin, opt.contents)
  end

  uv.shutdown(stdin, function()
    safe_close(stdin)
  end)
end

function fmt:formatter()
  local opt = get_format_opt()
  if not opt then
    return
  end

  opt.buffer = api.nvim_get_current_buf()
  opt.initial_changedtick = api.nvim_buf_get_changedtick(opt.buffer)
  if vim.bo.filetype == 'lua' then
    opt.contents = self:get_buf_contents(opt.buffer)
  end
  fmt:new_spawn(opt)
end

local mt = {
  __newindex = function(t, k, v)
    rawset(t, k, v)
  end,
}

fmt = setmetatable(fmt, mt)

local get_lsp_client = function()
  local current_buf = api.nvim_get_current_buf()
  local clients = lsp.get_active_clients({ buffer = current_buf })
  if next(clients) == nil then
    return nil
  end

  for _, client in pairs(clients) do
    local fts = client.config.filetypes
    if
      client.server_capabilities.documentFormattingProvider
      and vim.tbl_contains(fts, vim.bo.filetype)
    then
      return client
    end
  end
end

local format_tool_confs = {
  ['lua'] = '.stylua.toml',
}

local use_format_tool = function(dir)
  if not format_tool_confs[vim.bo.filetype] then
    return false
  end

  if fn.filereadable(dir .. '/' .. format_tool_confs[vim.bo.filetype]) == 1 then
    return true
  end

  return false
end

local group = api.nvim_create_augroup('My format with lsp and third tools', { clear = false })

local function remove_autocmd(bufnr, id)
  api.nvim_create_autocmd('BufDelete', {
    group = group,
    buffer = bufnr,
    callback = function(opt)
      pcall(api.nvim_del_autocmd, id)
      pcall(api.nvim_del_autocmd, opt.id)
    end,
    desc = 'clean the format event',
  })
end

function fmt:event(bufnr)
  local id = api.nvim_create_autocmd('BufWritePre', {
    group = group,
    buffer = bufnr,
    callback = function(opt)
      local fname = opt.match
      if vim.bo.filetype == 'lua' and fname:find('%pspec') then
        return
      end

      if fname:find('neovim/*') then
        return
      end

      local client = get_lsp_client()
      if not client then
        return
      end

      if vim.bo.filetype == 'go' then
        lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
      end

      local root_dir = client.config.root_dir
      if root_dir and use_format_tool(root_dir) then
        self:formatter()
        return
      end

      lsp.buf.format({ async = true })
    end,
    desc = 'My format',
  })
  remove_autocmd(bufnr, id)
end

return fmt
