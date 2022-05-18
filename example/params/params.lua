package.path = "/home/charlotte/devel/cadet/?.lua;" .. package.path
local Cadet = require("cadet")

Params = {}

function printtable(tayble)
  s = ""

  for k,v in pairs(tayble) do
    s = s .. string.format("%s = %s\n", k, v)
  end

  return s
end

function Params.index(env, headers, query)
  local res = Cadet.response

  res.headers["Content-Type"] = "text/plain;charset=ascii"
  res.status = 200

  view = {
    ["env"] = printtable(env),
    ["headers"] = printtable(headers),
    ["query"] = printtable(query),
  }

  body = [[
This is an example!

env:

{{env}}

-----

headers:

{{headers}}

-----

query:

{{query}}

Awesome!
  ]]

  Cadet.write(Cadet.render(body, view))

  return Cadet.finish()
end

httpd.register_handler("index", Params.index)
