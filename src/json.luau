--!nocheck
local HttpService = game:GetService("HttpService")
local Object = require(script.Parent.object).Object

local JSON = {}

function JSON.stringify(data)
  return Object.toString(data)
end

function JSON.parse(data)
  return HttpService:JSONDecode(data)
end

return {
  default = JSON,
}
