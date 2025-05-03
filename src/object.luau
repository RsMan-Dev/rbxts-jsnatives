---@diagnostic disable: undefined-global
--!nocheck
local HttpService = game:GetService("HttpService")

local KEYS = {}

local function objK(key, value) return key end
local function objV(key, value) return value end
local function objE(key, value) return {key, value} end
local function mapObject(object, withKeys, withValues)
  local assigner = withKeys and withValues and objE or (withKeys and objK or (withValues and objV or nil))
  local res = table.create(#object)
  for k, v in object do
    res[#res + 1] = assigner(k, v)
  end
  return res
end

local function keysFromMeta(object)
  local meta = getmetatable(object)
  local fun = nil
  if meta == false then -- protected metatable
    fun = object[KEYS]
  elseif meta ~= nil then
    fun = meta.__keys
  end
  if fun then -- if the function is not nil, we can use it to get the keys
    return fun(object)
  end
  return nil
end

local function keysFromMetaOrObject(object)
  local keys = keysFromMeta(object)
  if keys ~= nil then
    return keys
  end
  return mapObject(object, true, false) -- we normally map the object otherwise
end

local Object = {}

function Object.create(inherited)
  if type(inherited) ~= "table" and inherited ~= nil then error("Inherited must be an object or nil") end
  if inherited == nil then return {} end
  if type(inherited) ~= "table" then error("Inherited must be an object") end
  local obj = {}
  setmetatable(obj, { __index = inherited })
  return obj
end

function Object.keys(object)
  if type(object) ~= "table" then error("object must be a table") end
  return keysFromMetaOrObject(object)
end

function Object.entries(object)
  if type(object) ~= "table" then error("object must be a table") end
  local keys = keysFromMeta(object)
  if keys ~= nil then
    local entries = table.create(#object)
    for _, k in keys do
      entries[#entries + 1] = { k, object[k] }
    end
    return entries
  else
    return mapObject(object, true, true)
  end
end

function Object.values(object)
  if type(object) ~= "table" then error("object must be a table") end
  local keys = keysFromMeta(object)
  if keys ~= nil then
    local values = table.create(#object)
    for _, k in keys do
      values[#values + 1] = object[k]
    end
    return values
  else
    return mapObject(object, false, true)
  end
end

function Object.fromEntries(entries)
  if type(entries) ~= "table" then error("entries must be a table") end
  local obj = Object.create(#entries)
  for _, k in Object.keys(entries) do
    local entry = entries[k]
    if type(entry) ~= "table" then error("entry must be a table with 1 and 2 keys") end
    obj[entry[1]] = entry[2]
  end
  return obj
end

function Object.assign(target, ...)
  if type(target) ~= "table" then error("target must be a table") end
  for i = 1, select("#", ...) do
    local source = select(i, ...)
    if type(source) ~= "table" then error("source must be a table") end
    for _, k in Object.keys(source) do
      local v = source[k]
      target[k] = v
    end
  end
  return target
end

function Object.hasOwn(object, key)
  if type(object) ~= "table" then error("object must be a table") end
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

-- better thanks to: https://github.com/Roblox/luau-polyfill/blob/main/modules/collections/src/Object/is.lua
function Object.is(a, b)
  if a == b then
    return a ~= 0 or 1 / a == 1 / b
  end
  return a ~= a and b ~= b
end

-- found thanks to https://github.com/Roblox/luau-polyfill/blob/main/modules/collections/src/Object/freeze.lua
function Object.freeze(object, deep)
  if type(object) ~= "table" then return object end
  if deep then
    for _, k in Object.keys(object) do
      object[k] = Object.freeze(object[k], deep)
    end
  end
  return table.freeze(object)
end

function Object.isFrozen(object)
  return table.isfrozen(object)
end



-- tips found thanks to https://github.com/Roblox/luau-polyfill/blob/main/modules/collections/src/Object/preventExtensions.lua
-- as no "configuration" exists in lua, the only things to do is preventing adding properties
function Object.preventExtensions(object)
  if type(object) ~= "table" then return object end
  return setmetatable(object, {
    __newindex = function(_, k) -- with extensions prevented, a property CAN be deleted, but not added
      error("Cannot add new properties to an object that has extensions prevented.")
    end,
    __metatable = false
  })
end

function Object.seal(object)
  if type(object) ~= "table" then return object end
  local keys = {}
  for _, k in Object.keys(object) do
    keys[k] = true
  end
  return setmetatable(object, {
    __index = function(_, k)
      if k == KEYS then
        return keys
      end
      return nil
    end,
    __newindex = function(_, k)
      if not keys[k] then -- a key that was in object before can be set to nil and re-added, we are not considering keys has been deleted
        error("Cannot add new properties to an object that has extensions prevented.")
      end
    end,
    __metatable = false
  })
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

return { 
  Object = Object,
  KEYS = KEYS,
}