Import = {
	SRC_TOP = ".",
	VERBOSE = false,
}

function Import:__new_global_itme(k, v)
	assert(type(k) == "string", "global key must be string")
	assert(type(k) ~= "nil", "global item must not be nil")
	local ori = _G[k]
	if self.VERBOSE then
		print("the already existed key %s will be overrided")
	end
	_G[k] = v
end

function Import:ADD_CLIB(relative_path)
	local lib_path
	if not relative_path then
		lib_path = self.SRC_TOP
	else
		lib_path = ("%s/%s"):format(self.SRC_TOP, relative_path)
	end
	package.cpath = ("%s/?.so;%s"):format(lib_path, package.cpath)
end

function Import:ADD_LUALIB(relative_path)
	local lib_path
	if not relative_path then
		lib_path = self.SRC_TOP
	else
		lib_path = ("%s/%s"):format(self.SRC_TOP, relative_path)
	end
	package.path = ("%s/?.lua;%s"):format(lib_path, package.path)
end

--[[
keys = {key1, key2, ...}
--]]
function Import:_expose_by_list(m, keys)
	for _, k in ipairs(keys) do
		local v = m[k]
		assert(v, ("Not found key:%s in tables"):format(k))
		self:__new_global_itme(k, v)
	end
end

--[[
keys = {key1 = new_key1, key2 = new_key2, ...}
--]]
function Import:_expose_by_table(m, keys)
	for k, new_k in pairs(keys) do
		local v = m[k]
		assert(v, ("Not found key:%s in tables"):format(k))
		self:__new_global_itme(new_k, v)
	end
end

--[[
filter(k, v)
	return true | false
end
--]]
function Import:_expose_by_filter(m, filter)
	for k, v in pairs(m) do
		if filter(k, v) then
			self:__new_global_itme(k, v)
		end
	end
end

--[[
map(k, v)
	return new_k(string) | else
end
--]]
function Import:_expose_by_map(m, map)
	for k, v in pairs(m) do
		local new_k, new_v = map(k, v)
		if type(new_k) == "string" then
			self:__new_global_itme(new_k, new_v)
		end
	end
end

function Import:expose(m, keys)
	local t = type(keys)
	if t == "table" then
		self:_expose_by_list(m, keys)
	elseif t == "function" then
		self:_expose_by_filter(m, keys)
	else
		error("only support keys as table or function", 2)
	end
end

function Import:expose_as(m, keys)
	local t = type(keys)
	if t == "table" then
		self:_expose_by_table(m, keys)
	elseif t == "function" then
		self:_expose_by_map(m, keys)
	else
		error("only support keys as table or function", 2)
	end
end

function Import:import(name, keys)
	local m = require(name)
	if keys then
		self:expose(m, keys)
	end
	return m
end

function Import:import_as(name, key_map)
	local m = require(name)
	if key_map then
		self:expose_as(m, key_map)
	end
	return m
end

function Import:discriminate_scope(s)
	local prefix, content, suffix = string.match(s, "^(_*)([^%s]-)(_*)$")
	if #content == 0 then
		return "illegal"
	elseif #prefix == 0 then
		return "public"
	elseif #prefix == 1 then
		return "protected"
	elseif #prefix >= 2 and #suffix >= 2 then
		return "attribute"
	else
		return "private"
	end
end

function Import:scope_matcher(scope)
	assert(scope, "Scope is necessary")
	return function(v)
		return self:discriminate_scope(v) == scope and v or nil
	end
end

return Import
