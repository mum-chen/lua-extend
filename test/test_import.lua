print = require("color-p")
local Import = require("import")

assert(map == nil)
local Functional = Import:import("functional", {"map"})
assert(map == Functional.map)
print("success: import with expose")

assert(filter == nil)
local Functional = Import:import_as("functional", {filter = "_filter"})
assert(filter == nil)
assert(_filter == Functional.filter)

print("success: import with expose_as")

local _M1 = {
	__FuncA = function() end;
	__FuncB = function() end;
	__FuncC = function() end;

	_FuncA = function() end;
	_FuncB = function() end;
	_FuncC = function() end;

	FuncA = function() end;
	FuncB = function() end;
	FuncC = function() end;
}

local scope_test = {
	public_f = {"FuncA", "FuncB", "FuncC"},
	protected_f = {"_FuncA", "_FuncB", "_FuncC"},
	private_f = {"__FuncA", "__FuncB", "__FuncC"},
}

local function check_scope_mather(scope)
	local scope_list = scope_test[("%s_f"):format(scope)]
	local f
	for _, f in ipairs(scope_list) do
		assert(_G[f] == nil)
	end

	Import:expose(_M1, Import:scope_matcher(scope))
	for _, f in ipairs(scope_list) do
		assert(_G[f] == _M1[f])
	end
end

local scope
for _, scope in ipairs({"public", "protected", "private"}) do
	check_scope_mather(scope)
	print(("success: import with scope_matcher(%s)"):format(scope))
end
