-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local Proxy = TS.import(script, script, "proxy").default
local JSON = TS.import(script, script, "json").default
local Object = TS.import(script, script, "object").Object
local ArrayUtils = TS.import(script, script, "array_utils").default
local Number = TS.import(script, script, "number").default
local Error = TS.import(script, script, "error")
local Symbol = TS.import(script, script, "symbol").default
local SetUtils = TS.import(script, script, "set_utils").default
local String = TS.import(script, script, "string").default
local inspect = TS.import(script, script, "inspect").default
local console = TS.import(script, script, "console").default
local encodeUriComponent = TS.import(script, script, "encodeUriComponent").default
local _timers = TS.import(script, script, "timers")
local setTimeout = _timers.setTimeout
local clearTimeout = _timers.clearTimeout
local setInterval = _timers.setInterval
local clearInterval = _timers.clearInterval
return {
	Proxy = Proxy,
	Object = Object,
	JSON = JSON,
	ArrayUtils = ArrayUtils,
	Number = Number,
	Error = Error,
	Symbol = Symbol,
	String = String,
	inspect = inspect,
	console = console,
	SetUtils = SetUtils,
	encodeUriComponent = encodeUriComponent,
	setTimeout = setTimeout,
	clearTimeout = clearTimeout,
	setInterval = setInterval,
	clearInterval = clearInterval,
}
