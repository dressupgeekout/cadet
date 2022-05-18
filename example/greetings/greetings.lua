--[[
  greetings.lua - Cadet example
  Charlotte Koch <charlotteNetBSD.org>

  # /etc/inetd.conf:

    8899	stream	tcp	nowait:600	_httpd	/path/to/bozohttpd \
    httpd -L greetings /path/to/greetings.lua \
    /path/to/slashdir
]]

package.path = "/home/charlotte/devel/cadet/?.lua;" .. package.path
local Cadet = require("cadet")

Greetings = {}

function Greetings.index(env, headers, query)
  local res = Cadet.response
  local write = Cadet.write

  res.headers["Content-Type"] = "text/html"
  res.status = 200

  write("<h1>Greetings, Cadet</h1>")
  write([[<img alt="" height="300" src="/WaterfallGarden.jpg"/>]])

  return Cadet.finish()
end

httpd.register_handler("index", Greetings.index)
