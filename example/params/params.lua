package.path = "/home/christian/devel/cadet/?.lua;" .. package.path
local Cadet = require("cadet")

Params = {}

function Params.index(env, headers, query)
  local res = Cadet.response

  res.headers["Content-Type"] = "text/plain;charset=ascii"
  res.status = 200

  view = {
    ["env"] = env,
    ["headers"] = headers,
    ["query"] = query,
  }

  body = [[
This is an example!

env: {{env}}
headers: {{headers}}
query: {{query}}

Awesome!
  ]]

  Cadet.write(Cadet.render(body, view))

  return Cadet.finish()
end

httpd.register_handler("index", Params.index)
