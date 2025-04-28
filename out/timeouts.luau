-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local timeouts = setmetatable({}, {
	__mode = "k",
})
local function clearTimeout(sym)
	if not (sym ~= 0 and sym == sym and sym ~= "" and sym) then
		return nil
	end
	local _sym = sym
	local conn = timeouts[_sym]
	if conn then
		conn:Disconnect()
		local _sym_1 = sym
		timeouts[_sym_1] = nil
	end
end
local function setTimeout(cb, ms)
	if ms == nil then
		ms = 0
	end
	local sym = {}
	local t = 0
	local sec = ms / 1000
	local conn = RunService.Heartbeat:Connect(function(dt)
		t += dt
		if t >= sec then
			clearTimeout(sym)
			cb(sym)
		end
	end)
	timeouts[sym] = conn
	return sym
end
local function setInterval(cb, ms)
	if ms == nil then
		ms = 0
	end
	local sym = {}
	local t = 0
	local sec = ms / 1000
	local conn = RunService.Heartbeat:Connect(function(dt)
		t += dt
		if t >= sec then
			t = 0
			local _ = t
			cb(sym)
		end
	end)
	timeouts[sym] = conn
	return sym
end
local function clearInterval(sym)
	clearTimeout(sym)
end
return {
	clearTimeout = clearTimeout,
	setTimeout = setTimeout,
	setInterval = setInterval,
	clearInterval = clearInterval,
}
