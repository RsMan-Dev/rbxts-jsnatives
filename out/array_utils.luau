--!nocheck
local Object = require(script.Parent.object).Object

local ArrayUtils = {}

-- tips found at https://github.com/Roblox/luau-polyfill/blob/main/modules/collections/src/Array/isArray.lua
-- for me, deepcheck is in most of cases not needed, because roblox-ts's handling of arrays avoid majority of the issues
-- looking for issues to change the behavior, may change deepcheck default in future
function ArrayUtils.isArray(object, deepCheck)
  if type(object) ~= "table" then return false end

  if next(object) == nil then return true end -- empty table is an array

  local length = #object

  if length == 0 then return false end -- non 0 length with next returning something is not an array

  if deepCheck == nil or not deepCheck then
    return true -- avoid expansive calculation if deepCheck is not true or not provided
  end

  local count = 0
  local sum = 0
  for _, key in Object.keys(object) do -- use of object.keys to avoid triggering __index in proxies
    if type(key) ~= "number" then return false end
    if key % 1 ~= 0 or key < 1 or key > length then return false end
    count += 1
    sum += key
  end

  return count == length and sum == length * (length + 1) / 2
end

function ArrayUtils.concat(arrayOrValue, ...)
  local array
  if not ArrayUtils.isArray(arrayOrValue) then 
    array = { arrayOrValue }
  else
    array = Object.dup(arrayOrValue)
  end

  for i=1, select("#", ...) do
    local source = select(i, ...)
    if not ArrayUtils.isArray(source) then 
      source = { source }
    end
    for _, v in source do
      array[#array + 1] = v
    end
  end
  return array
end

function ArrayUtils.flat(array, depth)
  if depth == nil or type(depth) ~= "number" then depth = 1 end
  if not ArrayUtils.isArray(array) then return array end

  if depth < 1 then return array end
  
  local out = {}

  for _, v in array do
    if ArrayUtils.isArray(v) then
      for _, v2 in ArrayUtils.flat(v, depth - 1) do
        out[#out + 1] = v2
      end
    else
      out[#out + 1] = v
    end
  end

  return out
end

function ArrayUtils.flatMap(array, func)
  if type(func) ~= "function" then error("func must be a function") end
  if not ArrayUtils.isArray(array) then error("array must be an array") end

  local out = {}
  for i, v in array do
    out[i] = func(v, i, array)
  end
  return ArrayUtils.flat(out)
end

function ArrayUtils.reverse(array)
  if not ArrayUtils.isArray(array) then error("array must be an array") end

  local endIndex = #array
	local index = 1
	while index < endIndex do
		array[index], array[endIndex] = array[endIndex], array[index]
		index += 1
		endIndex -= 1
	end
	return array
end

function ArrayUtils.toReversed(array)
  if not ArrayUtils.isArray(array) then error("array must be an array") end

  return ArrayUtils.reverse(Object.dup(array))
end

function ArrayUtils.slice(array, start, ends)
  if not ArrayUtils.isArray(array) then error("array must be an array") end

                                                          -- For an array [1, 2, 3, 4, 5]
  if start == nil then start = 0 end                      -- if start is nil, set it to 0
  if type(start) ~= "number" then error("start must be a number") end
  if start < 0 then start = #array - (start * -1) end     -- if start is -2, then it's 3
  if start < 0 then start = 0 end                         -- if start is still negative, set it to 0
  if ends == nil then ends = #array - 1 end               -- if ends is nil, set it to the last index
  if type(ends) ~= "number" then error("ends must be a number") end
  if ends < 0 then ends = #array - (ends * -1) end        -- if ends is -1, then it's 4
  if ends < 0 then ends = 0 end                           -- if ends is still negative, set it to 0
  if ends > #array then ends = #array end                 -- if ends is greater than the last index, set it to the last index
  if start >= ends then return {} end                     -- if start is greater than or equal to ends, return an empty array

  -- convert js indexing to lua indexing
  start += 1
  ends += 1

  local out = {}
  for i=start, ends - 1 do
    out[#out + 1] = array[i]
  end
  return out
end

function ArrayUtils.splice(array, start, count, ...)
  if not ArrayUtils.isArray(array) then error("array must be an array") end

                                                          -- For an array [1, 2, 3, 4, 5]
  if start == nil then start = 0 end                      -- if start is nil, set it to 0
  if type(start) ~= "number" then error("start must be a number") end
  if start < 0 then start = #array - 1 - (start * -1) end -- if start is -2, then it's 3
  if start < 0 then start = 0 end                         -- if start is still negative, set it to 0
  if count == nil then count = #array - start end         -- if count is nil, set it to the difference between the length of the array and start
  if type(count) ~= "number" then error("count must be a number") end
  if count < 0 then count = 0 end                         -- if count is still negative, set it to 0
  if count > #array - start then count = #array - start end -- if count is greater than the difference between the length of the array and start, set it to the difference between the length of the array and start

  local ends = start + count - 1

  -- convert js indexing to lua indexing
  start += 1
  ends += 1

  local deleted = {}
  for i=start, ends do
    deleted[#deleted + 1] = table.remove(array, start)
  end

  for i = select("#", ...), 1, -1 do
    table.insert(array, start, select(i, ...))
  end
  
  return deleted
end


return {
  default = ArrayUtils,
}