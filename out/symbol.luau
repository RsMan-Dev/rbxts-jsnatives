-- all thanks to https://github.com/howmanysmall/luau-polyfill/blob/main/src/Symbol

export type Symbol = typeof(newproxy(true)) & {[string]: any}
local Registry = {} :: {[string]: Symbol}

local isSymbol = nil

local Symbol = {
	new = function(name: string?): Symbol
		local self = newproxy(true) :: any

		local wrappedName = "Symbol()"
		if name then
			wrappedName = string.format("Symbol(%*)", name)
		end

		getmetatable(self).__tostring = function()
			return wrappedName
		end

		getmetatable(self).__index = function(_, key)
			if key == isSymbol then
				return true
			end
			return nil
		end

    getmetatable(self).__metatable = false

		return (self :: any) :: Symbol
	end,

  isSymbol = function(value: any)
    return type(value) == "table" and value[isSymbol] == true
  end,
}

isSymbol = Symbol.new("is-symbol")

Symbol["for"] = function(key: string)
  if Registry[key] == nil then
    Registry[key] = Symbol.new(key)
  end
  return Registry[key]
end

return {
  default = setmetatable(Symbol, {
    __call = function(self, key: string)
      return Symbol.new(key)
    end
  }),
}
