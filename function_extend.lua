Y = function(f)
	return (function(g)
		return g(g)
	end)(function(h)
		return function(...)
			return f(h(h))(...)
		end
	end)
end

function map(f, xt)
	local k, v
	local yt = {}
	for k, v in pairs(xt) do
		yt[k] = f(v)
	end
	return yt
end

function filter(f, xt)
	local k, v
	local yt = {}
	for k, v in pairs(xt) do
		if f(k, v) then
			yt[k] = v
		end
	end
	return yt
end

function filter_list(f, xt)
	local i, v
	local yt = {}
	for i, v in pairs(xt) do
		if f(v) then
			yt[#yt + 1] = v
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
