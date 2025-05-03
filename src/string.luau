-- many tips thanks to https://github.com/howmanysmall/luau-polyfill/blob/main/src/String
--!nocheck
local Number = require(script.Parent.number).default


local String = {}

function String.charCodeAt(str: string, index: (number | string)?): number
  if type(str) ~= "string" then error("str must be a string") end
  if type(index) ~= "number" then index = tonumber(index) end
  if index == nil then error("index must be a number") end

  if index < 0 or index > #str - 1 then return Number.NaN end

  index += 1 -- convert to lua indexing

  local offset = utf8.offset(str, index)

  if offset == nil or offset > #str then return Number.NaN end

  return utf8.codepoint(str, offset) or Number.NaN
end


function String.endsWith(str: string, search: unknown, position: (number | string)?): boolean
  if type(search) ~= "string" then search = tostring(search) end
  if search == nil then error("search must be a string") end
  if search == "" then return true end
  if type(str) ~= "string" then error("str must be a string") end
  if type(position) ~= "number" then position = tonumber(position) or #str end
  if position < #search then return false end
  if position > #str then position = #str end

  local pos = position - #search + 1

  return string.find(str, search, pos, true) == pos
end

function String.startsWith(str: string, search: unknown, position: (number | string)?): boolean
  if type(search) ~= "string" then search = tostring(search) end
  if search == nil then error("search must be a string") end
  if search == "" then return true end
  if type(str) ~= "string" then error("str must be a string") end
  if type(position) ~= "number" then position = tonumber(position) or 0 end
  if position < 0 then position = 0 end
  if position > #str then position = #str end

  position += 1 -- convert to lua indexing

  return string.find(str, search, position, true) == position
end

function searchInit(str: string, search: string, position: number, reverse: boolean): number
  if type(search) ~= "string" then search = tostring(search) or "" end
  if type(position) ~= "number" then position = tonumber(position) end
  if position == nil then position = if reverse then #str else 0 end
	if search == "" then return math.clamp(position, 0, #str) end
  position += 1 -- convert to lua indexing

  if reverse then
    if position > #str then position = #str end
    if position < 1 then return -1 end
  else
    if position < 1 then position = 1 end
    if position > #str then return -1 end
  end

  return str, search, position
end

function String.indexOf(str: string, _search: unknown, _position: (string | number)?): number
  local strOrReturnPos, search, position = searchInit(str, _search, _position, false)
  if strOrReturnPos ~= str then return strOrReturnPos end

	for i = position, #str do
		if string.sub(str, i, i + #search - 1) == search then return i - 1 end
	end

	return -1
end

function String.lastIndexOf(str: string, _search: unknown, _position: (string | number)?): number
  local strOrReturnPos, search, position = searchInit(str, _search, _position, true)
  if strOrReturnPos ~= str then return strOrReturnPos end

	for i = position, 1, -1 do
		if string.sub(str, i, i + #search - 1) == search then return i - 1 end
	end

	return -1
end

function String.findOr(str: string, patternTable: {string}, position: (string | number)?): (number | nil, string | nil)
  if type(str) ~= "string" then error("str must be a string") end
  if type(patternTable) ~= "table" then error("patternTable must be a table") end
  if type(position) ~= "number" then position = tonumber(position) or 0 end
  position += 1 -- convert to lua indexing

	local foundString = nil
  local lowestIndexFound = #str
	for _, value in patternTable do
		local start, ends = string.find(str, value, position)
		if start ~= nil then
      if start < lowestIndexFound then
        foundString = string.sub(str, start, ends)
        lowestIndexFound = start
      end
		end
	end

  return lowestIndexFound - 1, foundString
end

function String.includes(str: string, substring: unknown, position: (string | number)?): boolean
  return String.indexOf(str, substring, position) ~= -1
end

function String.slice(str: string, start: (number | string)?, ends: (number | string)?): string
  if type(str) ~= "string" then error("str must be a string") end
  if type(start) ~= "number" then start = tonumber(start) or 0 end
  if type(ends) ~= "number" then ends = tonumber(ends) or #str - 1 end

  if start < 0 then start = #str - (start * -1) end
  if ends < 0 then ends = #str - 1 - (ends * -1) end
 
  start = math.clamp(start, 0, #str-1)
  ends = math.clamp(ends, 0, #str-1)

  if start > ends then return "" end

  return string.sub(str, start + 1, ends + 1)
end

function String.substring(str: string, start: (number | string)?, length: (number | string)?): string
  if type(str) ~= "string" then error("str must be a string") end
  if type(start) ~= "number" then start = tonumber(start) or 0 end
  if type(length) ~= "number" then length = tonumber(length) or #str - start end

  return string.sub(str, start + 1, start + length)
end

function String.split(str: string, separator: unknown, limit: (number | string)?): {string}
  if type(str) ~= "string" then error("str must be a string") end
  if type(separator) ~= "string" then separator = tostring(separator) end
  if type(limit) ~= "number" then limit = tonumber(limit) or Number.MAX_SAFE_INTEGER end
  if separator == nil then return {str} end
  if limit <= 0 then return {} end
  local result = {}

  if separator == "" then 
    for v in str:gmatch(".") do
      table.insert(result, v)
    end
    return result
  end

  repeat
    local start, ends = string.find(str, separator)
    if start ~= nil then
      table.insert(result, string.sub(str, 1, start - 1))
      str = string.sub(str, ends + 1)
    end
  until #result >= limit or start == nil

  table.insert(result, str)

  return result
end

function String.trimEnd(str: string): string
  if type(str) ~= "string" then error("str must be a string") end
  return (string.gsub(str, "[%s]+$", ""))
end

function String.trimStart(str: string): string
  if type(str) ~= "string" then error("str must be a string") end
  return (string.gsub(str, "^[%s]+", ""))
end

function String.trim(str: string): string
  return String.trimEnd(String.trimStart(str))
end

function String.replaceAll(str: string, search: unknown, replace: unknown | ((string) -> string) | {[string]: string}, limit: (number | string)?): string  
  if type(str) ~= "string" then error("str must be a string") end
  if type(search) ~= "string" then search = tostring(search) end
  if search == nil then error("search must be a string") end
  if type(replace) ~= "string" and type(replace) ~= "function" and type(replace) ~= "table" then replace = tostring(replace) end
  if replace == nil then error("replace must be a string or a function or a table") end
  if type(limit) ~= "number" then limit = tonumber(limit) end -- can be nil, so no need to check

  return (string.gsub(str, search, replace, limit))
end

function String.replace(str: string, search: unknown, replace: unknown | ((string) -> string) | {[string]: string}): string
  return String.replaceAll(str, search, replace, 1)
end

String.rep = string.rep

function String.search(str: string, pattern: unknown): number
  if type(pattern) ~= "string" then pattern = tostring(pattern) end
  if pattern == nil then error("pattern must be a string") end
  return (string.find(str, pattern) or -1)
end

function String.at(str: string, index: (number | string)): string
  if type(index) ~= "number" then index = tonumber(index) end
  if index == nil then error("index must be a number") end
  if index < 0 then index = #str + index end
  if index < 0 then return "" end
  if index > #str then return "" end
  index += 1 -- convert to lua indexing
  return string.sub(str, index, index)
end

function String.concat(...: unknown): string
  local result = ""
  for i=1, select("#", ...) do
    local value = select(i, ...)
    if type(value) ~= "string" then value = tostring(value) or "" end
    result = result .. value
  end
  return result
end

function padInit(str: string, length: unknown, fillString: string): string
  if type(length) ~= "number" then length = tonumber(length) or 0 end
  if type(fillString) ~= "string" then fillString = tostring(fillString) or " " end
  if length <= #str then return str end
  local generateLength = length - #str
  return string.sub(string.rep(fillString, math.ceil(generateLength / #fillString)), 1, generateLength)
end

function String.padEnd(str: string, length: unknown, fillString: string): string
  local strOrFillString = padInit(str, length, fillString)
  if strOrFillString == str then return str end
  return str .. strOrFillString
end

function String.padStart(str: string, length: unknown, fillString: string): string
  local strOrFillString = padInit(str, length, fillString)
  if strOrFillString == str then return str end
  return strOrFillString .. str
end

function String.padBoth(str: string, length: unknown, fillString: string): string
  local strOrFillString = padInit(str, length, fillString)
  if strOrFillString == str then return str end
  local side = str.sub(strOrFillString, 1, math.floor(#strOrFillString / 2))
  return side .. str .. side
end

String.toLowerCase = string.lower
String.toUpperCase = string.upper

function String.toCamelCase(str: string): string
  return (str:gsub("[%s%-_]+(%w)", string.upper):gsub("^%u", string.lower))
end

function String.toPascalCase(str: string): string
  return (str:gsub("[%s%-_]+(%w)", string.upper):gsub("^%l", string.upper))
end

function String.toSnakeCase(str: string): string
  return str:gsub("%u", function(c) return "_" .. c end):gsub("[%s%-_]+(%w)", function(c) return "_" .. c end):gsub("^_+", ""):lower()
end

function String.toKebabCase(str: string): string
  return str:gsub("%u", function(c) return "-" .. c end):gsub("[%s%-_]+(%w)", function(c) return "-" .. c end):gsub("^-+", ""):lower()
end

function String.toTitleCase(str: string): string
  return (str:gsub("%u", function(c) return " " .. c:upper() end):gsub("[%s%-_]+(%w)", function(c) return " " .. c:upper() end):gsub("^%s+(%l)", string.upper))
end

function String.toSentenceCase(str: string): string
  return (str:gsub("%u", function(c) return " " .. c:lower() end):gsub("[%s%-_]+(%w)", function(c) return " " .. c:lower() end):gsub("^%s+(%l)", string.upper))
end

return {
  default = String,
}
