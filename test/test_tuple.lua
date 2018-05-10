printclr = require("color-p")
local Tuple = require("tuple")

local function assert_error(f)
	assert(false == pcall(f))
end

local t = Tuple(10, 20, 30, 40)
assert(t[1] == 10)
assert(t[4] == 40)
printclr("success: index with tuple")

local a, b, c, d = t()
assert(a == 10, b == 20, c == 30, d == 40)
printclr("success: get vlaue of tuple")

assert_error(function()
	t[1] = 10
end)
printclr("success: raise error when change value")
