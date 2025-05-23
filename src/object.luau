---@diagnostic disable: undefined-global
--!nocheck
local HttpService = game:GetService("HttpService")

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
    fun = object["$$KEYS"]
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

function isObjectOrProxyNotAnyClass(object)
  if type(object) ~= "table" then return false end    -- not a table
  if getmetatable(object) == nil then return true end -- not has no meta
  if object["$$PROXY"] ~= nil then return true end    -- has meta but is a proxy
  return false
end

function Object.dup(object, deep, cache)
  if not isObjectOrProxyNotAnyClass(object) then return object end -- cannot duplicate complex objects
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
  local function keysGetter()
    return keys
  end
  return setmetatable(object, {
    __index = function(_, k)
      if k == "$$KEYS" then
        return keysGetter
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

function Object.excludeTypes(value, types, deep)
  if not isObjectOrProxyNotAnyClass(value) then return value end -- cannot exclude types on complex objects
  local nextIndex, nextValue = next(types)
  if nextIndex == nil then return value end
  if type(nextValue) ~= "boolean" then --not a set yet
    local typesArr = types
    types = {}
    for _, t in typesArr do types[t] = true end
  elseif type(nextValue) ~= "string" and type(nextValue) ~= "boolean" then -- not a a transformed set or a string array
    error("types must be an array of strings")
  end
  for _, k in Object.keys(value) do
    local v = value[k]
    if type(v) == "table" and deep then
      value[k] = Object.excludeTypes(v, types, deep)
    end
    if types[type(v)] then
      value[k] = nil
    end
  end
  return value
end

Object.diffDeletedSymbol = {}

function Object.diff(current, other, deep)
  if not isObjectOrProxyNotAnyClass(current) or not isObjectOrProxyNotAnyClass(other) then 
    if current == other then return nil end
    return current
  end
  local diffed = Object.create(nil)
  local set = Object.create(nil)
  for _, k in Object.keys(current) do set[k] = true end
  for _, k in Object.keys(other) do set[k] = true end
  for k in set do
    local cv = current[k]
    local ov = other[k]
    if type(cv) == "table" and type(ov) == "table" and deep then
      local result = Object.diff(cv, ov, deep)
      if not Object.isEmpty(result) then
        diffed[k] = result
      end
    elseif cv == nil and ov ~= nil then
      diffed[k] = Object.diffDeletedSymbol
    elseif cv ~= ov then
      diffed[k] = cv
    end
  end
  return diffed
end

function Object.patch(current, diff, deep)
  if not isObjectOrProxyNotAnyClass(current) or not isObjectOrProxyNotAnyClass(diff) then return current end
  for _, k in Object.keys(diff) do
    local v = diff[k]
    if v == Object.diffDeletedSymbol then
      current[k] = nil
    elseif type(v) == "table" and type(current[k]) == "table" and deep then
      current[k] = Object.patch(current[k], v, deep)
    else
      current[k] = v
    end
  end
  return current
end
return { 
  Object = Object,
}