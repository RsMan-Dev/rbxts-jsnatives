-- all thanks to https://github.com/howmanysmall/luau-polyfill/blob/main/src/Console/makeConsoleImpl.luau
--!nocheck
local inspect = require(script.Parent.inspect)

local GetService = game.GetService
local attemptedGetButFailed = false
local cached: LogService? = nil

local function GetLogService(): LogService?
	if cached or attemptedGetButFailed then
		return cached
	end

	local success, value = pcall(GetService, game, "LogService")
	if not success then
		attemptedGetButFailed = true
		return nil
	end

	cached = value
	return value
end

local INDENT = "  "

local console = {}
local indentDepth = 0

local function indent()
  return string.rep(INDENT, indentDepth)
end

function console.rawLog(content, ...)
  print(content, ...)
end

function console.log(content, ...)
  local message
  if type(content) == "string" then
    message = string.format(content, ...)
  else
    message = inspect(content)
  end
  print(indent() .. message)
end

function console.debug(content, ...)
  local message
  if type(content) == "string" then
    message = string.format(content, ...)
  else
    message = inspect(content)
  end
  print(indent() .. message)
end

function console.info(content, ...)
  local message
  if type(content) == "string" then
    message = string.format(content, ...)
  else
    message = inspect(content)
  end
  print(indent() .. message)
end

function console.warn(content, ...)
  local message
  if type(content) == "string" then
    message = string.format(content, ...)
  else
    message = inspect(content)
  end
  warn(indent() .. message)
end

function console.error(content, ...)
  -- JS' `console.error` doesn't interrupt execution like Lua's `error`,
  -- which is more similar to throwing an exception in JS.
  local message
  if type(content) == "string" then
    message = string.format(content, ...)
  else
    message = inspect(content)
  end
  warn(indent() .. message)
end

function console.group(content, ...)
  local message
  if type(content) == "string" then
    message = string.format(content, ...)
  else
    message = inspect(content)
  end
  print(indent() .. message)
  indentDepth = indentDepth + 1
end

function console.groupCollapsed(content, ...)
  return console.group(content, ...)
end

function console.groupEnd()
  if indentDepth > 0 then
    indentDepth = indentDepth - 1
  end
end

local startTimes: {[string]: number} = {}
function console.time(label: string?)
  local trueLabel = label or "default"
  if startTimes[trueLabel] ~= nil then
    console.warn(`Timer '{trueLabel}' already exists`)
    return
  end

  startTimes[trueLabel] = os.clock()
end
function console.timeEnd(label: string?)
  local trueLabel = label or "default"
  local finishTime = os.clock()
  local startTime = startTimes[trueLabel]

  if startTime == nil then
    console.warn(`Timer '{trueLabel}' does not exist`)
    return
  end

  console.log(`{trueLabel}: {(finishTime - startTime) * 1000} ms`)
  startTimes[trueLabel] = nil
end

function console.clear()
  local logService = GetLogService()
  if logService then
    pcall(function()
      logService:ClearOutput()
    end)
  end
end

return {
  default = console,
}