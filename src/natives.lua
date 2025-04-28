---@diagnostic disable: undefined-global
local HttpService = game:GetService("HttpService")

local function objectKeys(object)
  local keys = table.create(#object)
  for k in object do
    keys[#keys + 1] = k
  end
  return keys
end

local function objectEntries(object)
  local entries = table.create(#object)
  for k, v in object do
    entries[#entries + 1] = { k, v }
  end
  return entries
end

local function objectValues(object)
  local values = table.create(#object)
  for _, v in object do
    values[#values + 1] = v
  end
  return values
end


local Module = {}
local Proxy = {}
local Object = {}

--implements javascript's proxy
-- This module provides a proxy function that allows for hooks to be defined for getting, setting, and calling properties on a target object.
-- The proxy function takes a target object and a set of hooks, and returns a new object that behaves like the target but with the hooks applied.
-- The hooks can be used to intercept property access, modification, and function calls on the target object.
-- hooks defined: (not always the same as javascript)
-- get: function(target, key, proxy) - Called when a property is accessed on the proxy.
-- set: function(target, key, value, proxy) - Called when a property is set on the proxy.
-- call: function(target, ...) - Called when the proxy is called as a function.
-- len: function(target, proxy) - Called when the proxy is used with the # operator.
-- iter: function(target, proxy) - Called when the proxy is iterated over (e.g., in a for loop).
-- delete: function(target, key, proxy) - Called when a property is deleted from the proxy.

local function proxy(target, hooks, raw, metatableDefaults)
  if(type(target) ~= "table") then error("Target must be a table") end
  if(type(hooks) ~= "table") then error("Hooks must be a table") end
  if(type(raw) ~= "table" and raw ~= nil) then error("Raw must be a table or nil") end
  if(type(metatableDefaults) ~= "table" and metatableDefaults ~= nil) then error("Metatable defaults must be a table or nil") end

  if raw == nil then
    raw = {}
  end

  if metatableDefaults == nil then
    metatableDefaults = {}
  end

  metatableDefaults.__index = function(proxy, key)
    if hooks.get then
      return hooks.get(target, key, proxy)
    else
      return target[key]
    end
  end

  metatableDefaults.__newindex = function(proxy, key, value)
    if hooks.set then
      local success = hooks.set(target, key, value, proxy)
      if not success then
        error("[PROXYERROR] Failed to set value on target object")
      end
    else
      target[key] = value
    end
  end

  metatableDefaults.__callable = function()
    if hooks.apply then
      return true
    else
      return Object.isCallable(target)
    end
  end

  metatableDefaults.__call = function(proxy, ...)
    if hooks.apply then
      return hooks.apply(target, proxy, ...)
    else
      return target(...)
    end
  end

  metatableDefaults.__len = function(proxy)
    if hooks.len then
      return hooks.len(target, proxy)
    else
      return #target
    end
  end

  metatableDefaults.__keys = function(proxy)
    if hooks.ownKeys then
      return hooks.ownKeys(target, proxy)
    else
      return objectKeys(target)
    end
  end

  metatableDefaults.__iter = function(proxy)
    if hooks.iter then
      return hooks.iter(target, proxy)
    end
    local keys = Object.keys(proxy)
    local i = 0
    return function()
      i = i + 1
      if i <= #keys then
        return keys[i], proxy[keys[i]]
      end
      return nil
    end
  end

  return setmetatable(raw, metatableDefaults)
end

Proxy.new = proxy
Module.Proxy = Proxy

function Object.isArray(object)
  return type(object) == "table" and (#object > 0 or next(object) == nil)
end

function Object.create(inherited)
  if type(inherited) ~= "table" and inherited ~= nil then error("Inherited must be an object or nil") end
  if inherited == nil then return {} end
  if type(inherited) ~= "table" then error("Inherited must be an object") end
  local obj = {}
  setmetatable(obj, { __index = inherited })
  return obj
end

function Object.keys(object)
  if type(object) ~= "table" then error("Object must be an object") end
  local meta = getmetatable(object)
  if meta ~= nil and meta.__keys then
    return meta.__keys(object)
  else
    return objectKeys(object)
  end
end

function Object.entries(object)
  if type(object) ~= "table" then error("Object must be an object") end
  local meta = getmetatable(object)
  if meta ~= nil and meta.__keys then
    local entries = table.create(#object)
    for _, k in meta.__keys(object) do
      entries[#entries + 1] = { k, object[k] }
    end
    return entries
  else
    return objectEntries(object)
  end
end

function Object.values(object)
  if type(object) ~= "table" then error("Object must be an object") end
  local meta = getmetatable(object)
  if meta ~= nil and meta.__keys then
    local values = table.create(#object)
    for _, k in meta.__keys(object) do
      values[#values + 1] = object[k]
    end
    return values
  else
    return objectValues(object)
  end
end

function Object.fromEntries(entries)
  if Object.isArray(entries) then error("Entries must be an array") end
  local obj = Object.create(#entries)
  for _, k in Object.keys(entries) do
    local entry = entries[k]
    if Object.isArray(entry) ~= true then error("Entry must be an array") end
    obj[entry[1]] = entry[2]
  end
  return obj
end

function Object.assign(target, ...)
  if type(target) ~= "table" then error("Target must be an object") end
  for i = 1, select("#", ...) do
    local source = select(i, ...)
    if type(source) ~= "table" then error("Source must be an object") end
    for _, k in Object.keys(source) do
      local v = source[k]
      target[k] = v
    end
  end
  return target
end

function Object.hasOwn(object, key)
  if type(object) ~= "table" then error("Object must be a table") end
  return object[key] ~= nil and object[key] ~= Object[key]
end

function Object.dup(object, deep, cache)
  if type(object) ~= "table" then return object end
	local result = table.create(#object)
	for _, k in Object.keys(object) do
    local v = object[k]
    if deep and type(v) == "table" then
      if cache == nil then cache = {} end
      if cache[v] ~= nil then
        result[k] = cache[v]
      else
        local copy = Object.dup(v, deep, cache)
        cache[v] = copy
        result[k] = copy
      end
    else
      result[k] = v
    end
	end
	return result
end

function Object.is(a, b)
  if a == b then return true end
  return false
end

function Object.equals(a, b, deep)
	-- a[k] == b[k]
	for _, k in Object.keys(a) do
		local av = a[k]
		local bv = b[k]
		if av ~= bv then -- same table references dont need to be compared 
      if type(av) == "table" and type(bv) == "table" and deep then
        -- deeply compare the tables if deep is true
        local result = Object.equals(av, bv, deep)
        if not result then
          return false
        end
      else
        return false
      end
		end
	end

	-- extra keys in b
	for _, k in Object.keys(b) do
		if a[k] == nil then return false end
	end

	return true
end

function Object.toString(data)
	return HttpService:JSONEncode(Object.dup(data, true))
end

function Object.isEmpty(object)
	return next(object) == nil
end

function Object.isCallable(object)
  return type(object) == "function" or (
    type(object) == "table" and
    getmetatable(object) ~= nil and 
    type(getmetatable(object).__call) == "function" and (
      getmetatable(object).__callable == nil or getmetatable(object).__callable()
    )
  )
end

Module.Object = Object

local JSON = {}

function JSON.stringify(data)
  return Object.toString(data)
end

function JSON.parse(data)
  return HttpService:JSONDecode(data)
end

Module.JSON = JSON

return Module