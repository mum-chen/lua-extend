Y = function(f)
	return (function(g)
		return g(g)
	end)(function(h)
		return function(...)
			return f(h(h))(...)
		end
	end)
end

function map(f, xt, iterate)
	local k, v
	local yt = {}
	local iterate = iterate or ipairs
	for k, v in iterate(xt) do
		yt[k] = f(v)
	end
	return yt
end

function filter(f, xt, iterate)
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

function range(i, j, k)
	local s, e, g = 1, 1, 1 -- start: 0, end:0, gap:1
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
