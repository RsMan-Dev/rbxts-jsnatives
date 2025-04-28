-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local exports = {}
for _k, _v in TS.import(script, script, "natives") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, script, "timeouts") or {} do
	exports[_k] = _v
end
return exports
