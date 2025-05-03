-- many elements thanks to https://github.com/howmanysmall/luau-polyfill/blob/main/src/Number

local Number = {}

Number.EPSILON = 2.2204460492503e-16

Number.MAX_SAFE_INTEGER = 9007199254740991
Number.MIN_SAFE_INTEGER = -9007199254740991

Number.MAX_VALUE = 1.7976931348623157e+308
Number.MIN_VALUE = 5e-324

Number.NaN = -(0 / 0)
Number.NegativeNaN = 0 / 0

Number.NEGATIVE_INFINITY = -math.huge
Number.POSITIVE_INFINITY = math.huge

Number.isFinite = function(value: number): boolean
	return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

Number.isInteger = function(value: number): boolean
	return Number.isFinite(value) and value == math.floor(value)
end

Number.isNaN = function(value: number): boolean
	return type(value) == "number" and value ~= value
end

Number.isSafeInteger = function(value: number): boolean
	return Number.isInteger(value) and value >= Number.MIN_SAFE_INTEGER and value <= Number.MAX_SAFE_INTEGER
end

-- in difference of roblox's implementations, toExponential is a prototyme methods, so, we normally are sure that the value is a number
-- we consider a nil fractionDigits as 10, like js, that expands a maximum fractionDigits is undefined
Number.toExponential = function(value: number, fractionDigits: number?): string | nil
	local num = value

  if fractionDigits == nil then fractionDigits = 10 end
  fractionDigits = math.clamp(fractionDigits :: number, 0, 100) --clamping, not crashing, even if js crashes, it avoids unexpected errors

	local formatString
	if fractionDigits == nil then
		formatString = "%e"
	else
		formatString = "%." .. tostring(fractionDigits) .. "e"
	end

	return string.gsub(string.gsub(string.gsub(string.format(formatString, num), "%+0", "+"), "%-0", "-"), "0*e", "e")
end

function extractFloatNumberFromString(value: string): string
  return value:match("^ *[-+]?%d+%.?%d*[eE][-+]?%d+") or value:match("^ *[-+]?%d*%.?%d+")
end


Number.parseFloat = function(value: unknown): number
	if type(value) == "string" then
		return tonumber(extractFloatNumberFromString(value)) or Number.NaN
	elseif type(value) == "number" then
		return value
	end

	return Number.NaN
end

local radix_chars = { "0","1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" }

function extractIntegerNumberFromString(value: string, radix: number?): string
  if radix ~= nil then radix = math.clamp(radix :: number, 2, 36) end
  
  -- extraxt 0x, 0o, 0b prefixes and manages it with radix
  local temp = nil
  if radix == nil or radix == 16 then temp = value:match("^%s*0x(.*)") end
  if temp then 
    if radix == nil then radix = 16 end
    if radix == 16 then value = temp end
  else
    if radix == nil or radix == 8 then temp = value:match("^%s*0o(.*)") end
    if temp then 
      if radix == nil then radix = 8 end
      if radix == 8 then value = temp end
    else
      if radix == nil or radix == 2 then temp = value:match("^%s*0b(.*)") end
      if temp then 
        if radix == nil then radix = 2 end
        if radix == 2 then value = temp end
      end
    end
  end

  if radix == nil then radix = 10 end

  local r = "^%s*([0-"
  if radix < 10 then r = r .. radix_chars[radix :: number] else r = r .. "9" end

  if(radix > 10) then
    r = r .. "a-" .. radix_chars[radix :: number]
    r = r .. "A-" .. radix_chars[radix :: number]:upper()
  end

  r = r .. "]+)"

  return value:match(r), radix
end

Number.parseInt = function(value: unknown, radix: number?): number
	if type(value) == "string" then
		return tonumber(extractIntegerNumberFromString(value, radix)) or Number.NaN
	elseif type(value) == "number" then
		return math.floor(value)
	end

	return Number.NaN
end

Number.toFixed = function(value: number, digits: number?): string
  if type(value) ~= "number" then
    return "nan"
  end

  return string.format("%." .. (digits or 0) .. "f", value)
end

Number.toString = function(value: number, radix: number?): string
  if radix == nil then radix = 10 end
  radix = math.clamp(radix :: number, 2, 36)

  if value == Number.NaN then return "nan" end
  if value == Number.NegativeNaN then return "-nan" end
  if value == Number.NEGATIVE_INFINITY then return "-infinity" end
  if value == Number.POSITIVE_INFINITY then return "infinity" end

  if radix == 10 then return tostring(value) end

  local isNegative = value < 0
  value = math.abs(value)

  local integerPart = math.floor(value)
  local fractionalPart = value - integerPart

  local result = ""
  if isNegative then result = "-" end

  -- integer part
  local intString = ""
  if integerPart == 0 then intString = "0"
  else
    while integerPart > 0 do
      intString = radix_chars[integerPart % radix + 1] .. intString
      integerPart = math.floor(integerPart / radix)
    end
  end

  result = result .. intString

  -- fractional part
  if fractionalPart > 0 then
    result = result .. "."
    local fractionalString = ""
    while fractionalPart > 0 and #fractionalString < 16 do
      fractionalPart = fractionalPart * radix
      local digit = math.floor(fractionalPart)
      fractionalString = fractionalString .. radix_chars[digit + 1]
      fractionalPart = fractionalPart - digit
    end
    result = result .. fractionalString
  end

  return result
end


return setmetatable(Number, {
  __call = function(_, value: unknown)
    if type(value) == "number" then
      return value
    elseif type(value) == "string" then
      return Number.parseFloat(value)
    elseif type(value) == "boolean" then
      return value and 1 or 0
    elseif type(value) == "table" then
      if #value::{any} == 1 then
        return Number.parseFloat((value::{any})[1])
      end
    end

    return Number.NaN
  end
})