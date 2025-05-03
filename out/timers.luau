-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local Symbol = TS.import(script, script.Parent, "symbol").default
local timeouts = setmetatable({}, {
	__mode = "k",
})
local intervals = setmetatable({}, {
	__mode = "k",
})
local function clearTimeout(sym)
	local _condition = sym ~= nil
	if _condition then
		local _sym = sym
		local _result = timeouts[_sym]
		if _result ~= nil then
			_result = _result()
		end
		_condition = _result == false
	end
	if _condition then
		local _sym = sym
		timeouts[_sym] = nil
	end
end
local function setTimeout(cb, ms)
	if ms == nil then
		ms = 0
	end
	local sym = Symbol("timeout")
	local active = true
	task.delay(ms / 1000, function()
		if not active then
			return nil
		end
		cb(sym)
	end)
	timeouts[sym] = function()
		active = false
		return active
	end
	return sym
end
local function setInterval(cb, ms)
	if ms == nil then
		ms = 0
	end
	local sym = Symbol("interval")
	local active = true
	local run
	run = function()
		return task.delay(ms / 1000, function()
			if not active then
				return nil
			end
			cb(sym)
			run()
		end)
	end
	intervals[sym] = function()
		active = false
		return active
	end
	return sym
end
local function clearInterval(sym)
	local _condition = sym ~= nil
	if _condition then
		local _sym = sym
		local _result = intervals[_sym]
		if _result ~= nil then
			_result = _result()
		end
		_condition = _result == false
	end
	if _condition then
		local _sym = sym
		intervals[_sym] = nil
	end
end
return {
	clearTimeout = clearTimeout,
	setTimeout = setTimeout,
	setInterval = setInterval,
	clearInterval = clearInterval,
}
