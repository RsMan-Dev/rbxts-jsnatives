--!nocheck
local ObjectModule = require(script.Parent.object)
local Object = ObjectModule.Object
local Proxy = {}

Proxy.new = function (target, hooks, raw, metatableDefaults)
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

  metatableDefaults.__keys = function(proxy)
    if hooks.ownKeys then
      return hooks.ownKeys(target, proxy)
    else
      return Object.keys(target)
    end
  end

  metatableDefaults.__index = function(proxy, key)
    if key == "$$KEYS" then -- in case of protected metatable, we need to return the keys of the proxy using this reference
      return metatableDefaults.__keys
    end
    if key == "$$PROXY" then
      return proxy
    end

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
      return false -- even if target is callable, it will not be callable through the proxy
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

  metatableDefaults.__iter = function(proxy)
    if hooks.iter then
      return hooks.iter(target, proxy)
    end
    local keys = metatableDefaults.__keys(proxy)
    local i = 0
    return function(lastKey)
      if lastKey ~= nil and lastKey ~= keys[i] then
        --retrieving the current last key to replace the index
        for j = 1, #keys do
          if keys[j] == lastKey then
            i = j
            break
          end
        end
      end
      i = i + 1
      if i <= #keys then
        return keys[i], proxy[keys[i]]
      end
      return nil
    end, proxy
  end

  return setmetatable(raw, metatableDefaults)
end

return {
  default = Proxy,
}
