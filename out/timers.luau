-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local Symbol = TS.import(script, script.Parent, "symbol").default
local timeouts = setmetatable({}, {
	__mode = "k",
})
local intervals = setmetatable({}, {
	__mode = "k",
})
local function tryCancelThread(thread)
	if thread then
		local status = coroutine.status(thread)
		if status ~= "dead" and status ~= "running" then
			TS.try(function()
				task.cancel(thread)
			end, function(_) end)
		end
	end
end
--[[
	*
	 * Clears a timeout.
	 * @param sym - The symbol of the timeout to clear.
	 
]]
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
--[[
	*
	 * Sets a timeout.
	 * @param cb - The callback to execute after the timeout.
	 * @param ms - The timeout in milliseconds.
	 * @returns The symbol of the timeout.
	 
]]
local function setTimeout(cb, ms)
	if ms == nil then
		ms = 0
	end
	local active = true
	local sym
	local sym = Symbol("timeout")
	local thread = task.delay(ms / 1000, function()
		if not active then
			return nil
		end
		cb(sym)
	end)
	timeouts[sym] = function()
		tryCancelThread(thread)
		active = false
		return active
	end
	return sym
end
--[[
	*
	 * Sets an interval.
	 * @param cb - The callback to execute after the interval.
	 * @param ms - The interval in milliseconds.
	 * @returns The symbol of the interval.
	 
]]
local function setInterval(cb, ms)
	if ms == nil then
		ms = 0
	end
	local sym = Symbol("interval")
	local active = true
	local clean
	local run
	run = function()
		if not active then
			return nil
		end
		if clean ~= nil then
			clean()
		end
		local thread = task.delay(ms / 1000, function()
			if not active then
				return nil
			end
			cb(sym)
			run()
		end)
		clean = function()
			clean = nil
			tryCancelThread(thread)
			active = false
			return active
		end
	end
	run()
	intervals[sym] = function()
		local _result
		if clean ~= nil then
			_result = clean()
		else
			active = false
			_result = active
		end
		return _result
	end
	return sym
end
--[[
	*
	 * Clears an interval.
	 * @param sym - The symbol of the interval to clear.
	 
]]
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
