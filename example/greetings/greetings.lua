--[[
  greetings.lua - Cadet example
  Christian Koch <cfkoch@sdf.lonestar.org>

  # /etc/inetd.conf:

    8899	stream	tcp	nowait:600	_httpd	/path/to/bozohttpd \
    httpd -L greetings /path/to/greetings.lua \
    /path/to/slashdir
]]

dofile("/home/christian/devel/cadet/cadet.lua")

Greetings = {}

function Greetings.index(env, headers, query)
  local res = Cadet.response
  local write = Cadet.write

  res.content_type = "text/html"
  res.status = 200

  write("<h1>Greetings, Cadet</h1>")
  write([[<img alt="" height="300" src="/WaterfallGarden.jpg"/>]])

  return Cadet.finish()
end

httpd.register_handler("index", Greetings.index)
