local Functional = {}

--[[
@desc:	This function support to register an anonymous recursive function,
	typically, used when you're bugged by what the accurate name is.
----------
@input
@f:	function(self)
		return function(args)
			if not check(args) then
				return value
			else
				new_args = do_something()
				return self(new_args)
			end
		end
	end
----------
@output:
@1:	The recursive function.
--]]
Functional.Y = function(f)
	return (function(g)
		return g(g)
	end)(function(h)
		return function(...)
			return f(h(h))(...)
		end
	end)
end

--[[
@desc:	Change the value in input list, iterated by input iterator.
----------
@input
@f:	Mapper fucntion:
	function(value)
		new_value = do_something(value)
		return new_value
	end
@xt:	List or Table
@iterate:
	Iterator for xt, `ipairs` on defalut
----------
@output:
@1	The new list after changing.
--]]
function Functional.map(f, xt, iterate)
	local k, v
	local yt = {}
	local iterate = iterate or ipairs
	for k, v in iterate(xt) do
		yt[k] = f(v)
	end
	return yt
end

--[[
@desc:	Filter the value in list, iterated by iterator, by check-function.
----------
@input
@f:	Filter function:
	function(key, value)
		if do_check(key, value) then
			return true  -- contain
		else
			return false -- drop
		end
	end
@xt:	List or Table
@iterate:
	Iterator for xt, `ipairs` on defalut
----------
@output:
@1	The new list after filtering.
	You should traverse this new list by `pairs` rather than `ipairs`.
--]]
function Functional.filter(f, xt, iterate)
	local k, v
	local yt = {}
	local iterate = iterate or ipairs
	for k, v in iterate(xt) do
		if f(k, v) then
			yt[k] = v
		end
	end
	return yt
end

--[[
@desc:	Filter the value in list, iterated by iterator, by check-function.
	Simmilarly to `filter`, but this function will append the values
	into the result.
----------
@input
@f:	Filter function:
	function(value)
		if do_check(value) then
			return true  -- contain
		else
			return false -- drop
		end
	end
@xt:	List or Table
----------
@output:
@1	The new list after filtering.
	You can traverse this new list by `pairs`
--]]
function Functional.filter_list(f, list)
	local v
	local _list = {}
	for _, v in ipairs(list) do
		if f(v) then
			_list[#_list + 1] = v
		end
	end
	return _list
end

--[[
@desc:	Apply a function of two arguments cumulatively to the items of a sequence,
	from left to right, so as to reduce the sequence to a single value.
----------
@input
@f:	function(first, second)
		return do_something(first, second)
	end
@xt:	List or Table
@init_val:
	The initial value for the function. Sending nil means use the first value
	in the sequence as the initial one.
@iterate:
	Iterator for xt, `ipairs` on defalut
--]]
function Functional.reduce(fun, xt, init_val, iterate)
	local iterate = iterate or ipairs
	local before, current
	local iter_f, t, k = iterate(xt)

	before = init_val
	if before == nil then
		k, before = iter_f(t, k)
		if k == nil then
			return before
		end
	end

	while true do
		k, current = iter_f(t, k)
		if k == nil then
			break
		end
		before = fun(before, current)
	end

	return before
end

--[[
@desc:	Generate a sequence of int.
	For i = n, j = nil, k = nil:
		#res == n
		return {1 ... n}
	For i = n, j = m, k = nil:
		#res == m - n
		return {n, ... m}
	For i = n, j = s, k = m:
		#res == (m - n) / s
		return {n, n + s, n + 2s, .., m}
--]]
function Functional.range(i, j, k)
	local s, e, g = 1, 1, 1
	assert(i, "i is necessart")

	if  (not j) and (not k) then
		e = i
	elseif not k then
		s = i
		e = j
	elseif (i and j and k) then
		s = i
		g = j
		e = k
	else
		error("error args input")
	end

	local l
	local xl = {}
	for l = s, e, g do
		xl[#xl + 1] = l
	end
	return xl
end

return Functional
