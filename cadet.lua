--[[
  Cadet - a minimal interface between bozohttpd and Lua

  -----

  Copyright (c) 2014 Christian Koch <cfkoch@sdf.lonestar.org>
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

    1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

-- The main namespace.
local Cadet = {}

Cadet._VERSION = "0.0.0a"

-- The default HTTP response.
Cadet.response = {
  http_version = "1.1",
  content_type = "text/html",
  status = 200,
  body = "",
}

Cadet.status_map = {
  [100] = "Continue",
  [101] = "Switching Protocols",
  [200] = "OK",
  [201] = "Created",
  [202] = "Accepted",
  [203] = "Non-Authoritative Information" ,
  [204] = "No Content" ,
  [205] = "Reset Content",
  [206] = "Partial Content",
  [300] = "Multiple Choices",
  [301] = "Moved Permanently",
  [302] = "Found",
  [303] = "See Other",
  [304] = "Not Modified",
  [305] = "Use Proxy",
  -- [306] is unused,
  [307] = "Temporary Redirect",
  [400] = "Bad Request",
  [401] = "Unauthorized",
  [402] = "Payment Required",
  [403] = "Forbidden",
  [404] = "Not Found",
  [405] = "Method Not Allowed",
  [406] = "Not Acceptable",
  [407] = "Proxy Authentication Required",
  [408] = "Request Timeout",
  [409] = "Conflict",
  [410] = "Gone",
  [411] = "Length Required",
  [412] = "Precondition Failed",
  [413] = "Request Entity Too Large",
  [414] = "Request-URI Too Long",
  [415] = "Unsupported Media Type",
  [416] = "Requested Range Not Satisfiable",
  [500] = "Internal Server Error",
  [501] = "Not Implemented",
  [502] = "Bad Gateway",
  [503] = "Service Unavailable",
  [504] = "Gateway Timeout" ,
  [505] = "HTTP Version Not Supported" ,
}

-- Writes the given string to the standard output, but with CRLF appended.
function Cadet.printcrlf(str)
  io.write(string.format("%s\r\n", str))
end

--[[
  Cadet.before() is a function that is unconditionally executed as the first
  thing when calling Cadet.finish(). By default it does nothing. You are
  free to re-implement it.
]]
Cadet.before = function() end

-- Writes the entire HTTP response to the standard output.
function Cadet.finish()
  local printcrlf = Cadet.printcrlf
  local res = Cadet.response 
  local format = string.format

  Cadet.before()

  printcrlf(format(
    "HTTP/%s %d %s", res.http_version, res.status,
    Cadet.status_map[res.status]
  ))

  printcrlf(format("Content-Type: %s", res.content_type))
  printcrlf(format("Content-Length: %d", string.len(res.body)))
  printcrlf("")
  io.write(res.body)
end


--[[
  Reads the file at the given path and returns its contents. If the file at
  "path" can't be read for whatever reason, then return false.
]]
function Cadet.readfile(path)
  f = io.open(path, "r")
  out = ""

  if f then
    out = f:read("*a")
    f:close()
    return out
  else
    return false
  end
end


--[[
  A simple, logic-less templating engine. "view" is a table. Returns the
  rendered output as a string. To make any use of it, set
  Cadet.response.body to the output of this function.
]]
function Cadet.render(template, view)
  out = template

  for k,v in pairs(view) do
    pattern = string.format("{{%s}}", k)
    out = string.gsub(out, pattern, v)
  end

  return out
end


--[[
  Appends the given string to the Cadet.response's body.
]]
function Cadet.write(string)
  Cadet.response.body = (Cadet.response.body .. string)
end

return Cadet
