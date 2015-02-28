  --[[

  Copyright 2015 The Luvit Authors. All Rights Reserved.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS-IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

--]]
local uv = require('uv')
local fs = require('coro-fs')
local json = require('json')
local function watch(path, options, onEvent)
  local handle = uv.new_fs_event()
  uv.fs_event_start(handle, path, options, onEvent)
  return handle
end
local function log(...)
  print('wit: ' .. string.format(...))
end
local data, err = fs.readFile(".witrc")
if err then log(err) ; os.exit(0) end
data = json.parse(data)
assert(data.run, "run not defined")
local pid
local cmd = table.remove(data.run, 1)
watch('.', { recursive = true }, function(err, filename)
  local child
  -- exclude patterns
  if data.exclude then
    for _, pattern in ipairs(data.exclude) do
      if filename:match(pattern) then return end
    end
  end
  if pid then log('killing process') ; uv.kill(pid, "sigterm") end
  log("%s %s", cmd, table.concat(data.run))
  child, pid = uv.spawn(cmd, {
    args = data.run,
    stdio = {0,1,2},
  }, function()
    log('done')
    uv.close(child)
    pid = nil
  end)
end)
