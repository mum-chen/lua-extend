local Tuple = {}
local unpack = unpack or table.unpack

local mt = {}
setmetatable(Tuple, mt)

function Tuple:__init__(...)
	local _t = {}
	local inner = {...}
	setmetatable(_t, {
		__index = inner,
		__call = function(t)
			return unpack(inner)
		end,
		__newindex = function(t)
			error("you shouldn't modify value in tuple", 2)
		end,
	})
	return _t
end
mt.__call = Tuple.__init__

local TEST = false
if TEST then
	local t = Tuple(10, 20, 30, 40)
	print(t())
	t[10] = 1
end

return Tuple
