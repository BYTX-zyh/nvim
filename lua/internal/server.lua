local client_capabilities = {}
local projects = {}

local Trie = {}
function Trie.new()
  return {
    children = {},
    is_end = false,
    frequency = 0,
  }
end

function Trie.insert(root, word)
  local node = root
  for i = 1, #word do
    local char = word:sub(i, i)
    node.children[char] = node.children[char] or Trie.new()
    node = node.children[char]
  end
  local was_new = not node.is_end
  node.is_end = true
  node.frequency = node.frequency + 1
  return was_new
end

function Trie.search_prefix(root, prefix)
  local node = root
  for i = 1, #prefix do
    local char = prefix:sub(i, i)
    if not node.children[char] then
      return {}
    end
    node = node.children[char]
  end

  local results = {}
  local function collect_words(current_node, current_word)
    if current_node.is_end then
      table.insert(results, {
        word = current_word,
        frequency = current_node.frequency,
      })
    end

    for char, child in pairs(current_node.children) do
      collect_words(child, current_word .. char)
    end
  end

  collect_words(node, prefix)
  return results
end

local dict = {
  trie = Trie.new(),
  word_count = 0,
  max_words = 50000,
  min_word_length = 2,
}

-- LRU cache
local LRUCache = {}
function LRUCache:new(max_size)
  local obj = {
    cache = {},
    order = {},
    max_size = max_size or 100,
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function LRUCache:find_index(key)
  for i = 1, #self.order do
    if self.order[i] == key then
      return i
    end
  end
  return nil
end

function LRUCache:get(key)
  local item = self.cache[key]
  if item then
    local idx = self:find_index(key)
    if idx then
      local value = table.remove(self.order, idx)
      table.insert(self.order, value)
    end
    return item.value
  end
  return nil
end

function LRUCache:put(key, value)
  if self.cache[key] then
    self.cache[key].value = value
    local idx = self:find_index(key)
    if idx then
      local new_value = table.remove(self.order, idx)
      table.insert(self.order, new_value)
    end
  else
    while #self.order >= self.max_size do
      local oldest = table.remove(self.order, 1)
      self.cache[oldest] = nil
    end
    self.cache[key] = { value = value }
    table.insert(self.order, key)
  end
end

local scan_cache = LRUCache:new(100)

local async = {}

function async.throttle(fn, delay)
  local timer = nil
  return function(...)
    local args = { ... }
    if timer and not timer:is_closing() then
      timer:stop()
      timer:close()
    end
    timer = assert(vim.uv.new_timer())
    timer:start(
      delay,
      0,
      vim.schedule_wrap(function()
        timer:stop()
        timer:close()
        fn(unpack(args))
      end)
    )
  end
end

local server = {}

local function get_root(filename)
  local data
  for r, item in pairs(projects) do
    if vim.startswith(filename, r) then
      data = item
      break
    end
  end
  return data
end

local function schedule_result(callback, items)
  vim.schedule(function()
    callback(nil, { isIncomplete = false, items = items or {} })
  end)
end

local function scan_dir_async(path, callback)
  local cached = scan_cache:get(path)
  if cached and (vim.uv.now() - cached.timestamp) < 5000 then
    schedule_result(callback, cached.results)
    return
  end

  local co = coroutine.create(function(resolve)
    local handle = vim.uv.fs_scandir(path)
    if not handle then
      resolve({})
      return
    end

    local results = {}
    local batch_size = 1000 -- enough ?
    local current_batch = {}

    while true do
      local name, type = vim.uv.fs_scandir_next(handle)
      if not name then
        if #current_batch > 0 then
          vim.list_extend(results, current_batch)
        end
        break
      end

      local is_hidden = name:match('^%.')
      if type == 'directory' and not name:match('/$') then
        name = name .. '/'
      end

      table.insert(current_batch, {
        name = name,
        type = type,
        is_hidden = is_hidden,
      })

      if #current_batch >= batch_size then
        vim.list_extend(results, current_batch)
        current_batch = {}
        coroutine.yield()
      end
    end

    scan_cache:put(path, {
      timestamp = vim.uv.now(),
      results = results,
    })
    resolve(results)
  end)

  coroutine.resume(co, callback)
end

-- async cleanup low frequency from dict
local function cleanup_dict()
  if dict.word_count <= dict.max_words then
    return
  end

  local co = coroutine.create(function()
    local words = {}
    local function collect_words(node, current_word)
      if node.is_end then
        table.insert(words, {
          word = current_word,
          frequency = node.frequency,
        })
      end
      -- yield when collect 100 words
      if #words % 100 == 0 then
        coroutine.yield()
      end
      for char, child in pairs(node.children) do
        collect_words(child, current_word .. char)
      end
    end

    collect_words(dict.trie, '')
    coroutine.yield()

    table.sort(words, function(a, b)
      return a.frequency > b.frequency
    end)
    coroutine.yield()

    local new_trie = Trie.new()
    local new_count = 0

    -- rebuild Trie
    for i = 1, dict.max_words do
      if words[i] then
        Trie.insert(new_trie, words[i].word)
        new_count = new_count + 1
      end
      if i % 100 == 0 then
        coroutine.yield()
      end
    end

    dict.trie = new_trie
    dict.word_count = new_count
  end)

  local function resume()
    local ok = coroutine.resume(co)
    if ok and coroutine.status(co) ~= 'dead' then
      vim.schedule(resume)
    end
  end

  vim.schedule(resume)
end

local update_dict = async.throttle(function(lines)
  local processed = 0
  local batch_size = 1000

  local function process_batch()
    local end_idx = math.min(processed + batch_size, #lines)
    local new_words = 0

    for i = processed + 1, end_idx do
      local line = lines[i]
      for word in line:gmatch('[^%s%.%_]+') do
        if not tonumber(word) and #word >= dict.min_word_length then
          if Trie.insert(dict.trie, word) then -- increase when is new word
            new_words = new_words + 1
          end
        end
      end
    end

    dict.word_count = dict.word_count + new_words
    processed = end_idx

    if processed < #lines then
      vim.schedule(process_batch)
    elseif dict.word_count > dict.max_words then
      vim.schedule(function()
        cleanup_dict()
      end)
    end
  end

  vim.schedule(process_batch)
end, 100)

local function collect_completions(prefix)
  local results = Trie.search_prefix(dict.trie, prefix)
  table.sort(results, function(a, b)
    return a.frequency > b.frequency
  end)

  return vim.tbl_map(function(item)
    return {
      label = item.word,
      filterText = item.word,
      kind = 1,
      sortText = string.format('%09d', 999999999 - item.frequency),
    }
  end, results)
end

local function find_last_occurrence(str, pattern)
  local reversed_str = string.reverse(str)
  local start_pos, end_pos = string.find(reversed_str, pattern)
  if start_pos then
    return #str - end_pos + 1
  else
    return nil
  end
end

function server.create()
  return function()
    local srv = {}

    function srv.initialize(params, callback)
      local client_id = params.processId
      if params.rootPath and not projects[params.rootPath] then
        projects[params.rootPath] = {}
      end
      client_capabilities[client_id] = params.capabilities
      callback(nil, {
        capabilities = {
          completionProvider = {
            triggerCharacters = { '/' },
            resolveProvider = false,
          },
          textDocumentSync = {
            openClose = true,
            change = 1,
          },
        },
      })
    end

    function srv.completion(params, callback)
      local uri = params.textDocument.uri
      local position = params.position
      local filename = uri:gsub('file://', '')
      local root = get_root(filename)

      if not root then
        schedule_result(callback)
        return
      end

      local line = root[filename][position.line + 1]
      if not line then
        schedule_result(callback)
        return
      end

      local char_at_cursor = line:sub(position.character, position.character)
      if char_at_cursor == '/' then
        local prefix = line:sub(1, position.character)
        local has_literal = find_last_occurrence(prefix, '"')
        if has_literal then
          prefix = prefix:sub(has_literal + 1, position.character)
        end
        local has_space = find_last_occurrence(prefix, '%s')
        if has_space then
          prefix = prefix:sub(has_space + 1, position.character)
        end
        local dir_part = prefix:match('^(.*/)[^/]*$')

        if not dir_part then
          schedule_result(callback)
          return
        end

        local expanded_path = vim.fs.normalize(vim.fs.abspath(dir_part))

        scan_dir_async(expanded_path, function(results)
          local items = {}
          local current_input = prefix:match('[^/]*$') or ''

          for _, entry in ipairs(results) do
            local name = entry.name
            if vim.startswith(name:lower(), current_input:lower()) then
              local kind = entry.type == 'directory' and 19 or 17
              local label = name
              if entry.type == 'directory' then
                label = label:gsub('/$', '')
              elseif entry.type == 'file' and name:match('^%.') then
                label = label:gsub('^.', '')
              end

              table.insert(items, {
                label = label,
                kind = kind,
                insertText = label,
                filterText = label,
                detail = entry.is_hidden and '(Hidden)' or nil,
                sortText = string.format('%d%s', entry.is_hidden and 1 or 0, label:lower()),
              })
            end
          end

          schedule_result(callback, items)
        end)
      else
        local prefix = line:sub(1, position.character):match('[%w_]*$')
        if not prefix or #prefix == 0 then
          schedule_result(callback)
          return
        end

        local items = collect_completions(prefix)
        schedule_result(callback, items)
      end
    end

    srv['textDocument/completion'] = srv.completion

    srv['textDocument/didOpen'] = function(params)
      local filename = params.textDocument.uri:gsub('file://', '')
      local data = get_root(filename)
      if not data then
        return
      end
      data[filename] = vim.split(params.textDocument.text, '\n')
      update_dict(data[filename])
    end

    srv['textDocument/didChange'] = function(params)
      local filename = params.textDocument.uri:gsub('file://', '')
      local root = get_root(filename)
      if not root then
        return
      end
      root[filename] = vim.split(params.contentChanges[1].text, '\n')
      update_dict(root[filename])

      if dict.word_count > dict.max_words then
        cleanup_dict()
      end
    end

    function srv.shutdown(params, callback)
      callback(nil, nil)
    end

    return {
      request = function(method, params, callback)
        if srv[method] then
          srv[method](params, callback)
        else
          callback('Method not found: ' .. method)
        end
      end,
      notify = function(method, params)
        if srv[method] then
          srv[method](params)
        end
      end,
      is_closing = function()
        return false
      end,
      terminate = function()
        client_capabilities = {}
      end,
    }
  end
end

return server
