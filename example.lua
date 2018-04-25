require("function_extend")
printclr = require("color-p")

-- =========================================================
-- fact
assert(Y(function(self)
	return function(n)
		if n < 2 then
			return 1
		else
			return n * self(n - 1)
		end
	end
end)(5) == 120, "error in Y combinator")
print("success: Y combinator")

-- =========================================================
local list1 = range(10)
assert(#list1 == 10 and list1[1] == 1 and list1[10] == 10)

local list2 = range(10, 19)
assert(#list2 == 10 and list2[1] == 10 and list2[10] == 19)
local list3 = range(10, 2, 20)
assert(#list3 == 6 and list3[1] == 10 and list3[6] == 20)
print("success: range")

-- =========================================================
local list4 = map(function(x) return x+1 end, range(4))
assert(#list4 == 4 and list4[1] == 2 and list4[4] == 5)
print("success: map")

-- =========================================================
local list5 = filter(function(x) return x < 4 end, range(10))
assert(#list5 == 3 and list5[1] == 1 and list5[3] == 3)

local list6 = filter(function(i, v) return i ~= 4 end, range(10))
assert(list6[10] == 10 and list6[4] == nil)

local list7 = filter_list(function(v) return v ~= 4 end, range(10))
assert(#list7 == 9 and list7[4] == 5)
print("success: filter")

-- =========================================================
local sum = function(x, y)
	return x+y
end

assert(reduce(sum, range(0), nil)==nil)
assert(reduce(sum, range(0), 0)==0)
assert(reduce(sum, range(1), 1)==2)
assert(reduce(sum, range(10), 0)==55)
print("success: reduce")
