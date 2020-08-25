local table = table

function table.isempty(t)
    return _G.next(t) == nil
end

function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function table.keys(tbl)
	if (tbl == nil) then
		return {}
	end

	local keys = {}
	for k, v in pairs(tbl) do
		table.insert(keys, k)
	end
	return keys
end

function table.values(hashtable)
    local values = {}
    for k, v in pairs(hashtable) do
        values[#values + 1] = v
    end
    return values
end

function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

function table.insertto(dest, src, begin)
    begin = checkint(begin)
    if begin <= 0 then
        begin = #dest + 1
    end

    local len = #src
    for i = 0, len - 1 do
        dest[i + begin] = src[i + 1]
    end
end

function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then return i end
    end
    return 0
end

function table.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then return k end
    end
    return nil
end

function table.removeByValue(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then break end
        end
        i = i + 1
    end
    return c
end

function table.getElementIndexByKeyValue(array, key, value)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i][key] == value then
            return i
        end
        i = i + 1
    end
    return -1
end

function table.removeByElementKeyValue(array, key, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i][key] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then break end
        end
        i = i + 1
    end
    return c
end

function table.map(t, fn)
    for k, v in pairs(t) do
        t[k] = fn(v, k)
    end
end

function table.walk(t, fn)
    for k,v in pairs(t) do
        fn(v, k)
    end
end

function table.filter(t, fn)
    for k, v in pairs(t) do
        if not fn(v, k) then t[k] = nil end
    end
end

function table.unique(t, bArray)
    local check = {}
    local n = {}
    local idx = 1
    for k, v in pairs(t) do
        if not check[v] then
            if bArray then
                n[idx] = v
                idx = idx + 1
            else
                n[k] = v
            end
            check[v] = true
        end
    end
    return n
end

function table.len(_table)
	local count = 0
	for _ in pairs(_table) do 
		count = count + 1 
	end
	return count
end

function table.containsValue(_table, _value)
	if not _table	
	or (type(_table) ~= "table" )
	or (not next(_table))
	then
		return false
	end	
	for k,v in pairs(_table) do
		if v == _value then
			return true
		end
	end
	return false
end

function table.sortList(srcTbl, sortActionList)
    local function sortAction(a, b)
        local actionIndex = 1
        for k,v in ipairs(sortActionList) do
            local res = v(a, b)
            if res == true or res == false then
                return res
            end
        end
        return false
    end
    table.sort(srcTbl, sortAction)
end

--------------------------------------------------------------------------------
-- 比较两个table的值是否一样
--------------------------------------------------------------------------------
function table.compare(table1, table2)
    for k, v in pairs(table1 or {}) do
        if table2 == nil then
            return false
        end
        if v ~= table2[k] then
            return false
        end
    end
    for k, v in pairs(table2 or {}) do
        if table1 == nil then
            return false
        end
        if v ~= table1[k] then
            return false
        end
    end
    return true
end

--------------------------------------------------------------------------------
-- 浅拷贝table方法
--------------------------------------------------------------------------------
table.copy = function(src)
	local function copy(src, dst)
        for k, v in pairs(src or {}) do
        	dst[k] = v
        end
    end
 
    local dst = {}
    copy(src, dst)
    return dst
end

--------------------------------------------------------------------------------
-- 深拷贝table方法
--------------------------------------------------------------------------------
table.deepCopy = function(src)
	local function copy(src, dst)
        for k, v in pairs(src) do
            if type(v) ~= "table" then
                dst[k] = v
            else
                dst[k] = {}
                copy(v, dst[k])
            end
        end
    end
 
    local dst = {}
    copy(src, dst)
    return dst
end

--------------------------------------------------------------------------------
-- 扩展table方法，合并table
-- 需要注意的是，该方法在合并Array形式的table时会有问题
--------------------------------------------------------------------------------
table.append = function(dst, src)
	if dst == nil then
		dst = {}
	end

	if src == nil then
		return dst
	end

	for k, v in pairs(src) do
		if type(v) == "table" and dst[k] ~= nil then
			table.append(dst[k], v)
		else
			dst[k] = v
		end
	end
	return dst
end

table.iappend = function(dst, src)
	if dst == nil then
		dst = {}
	end

	if src == nil then
		return dst
	end

	for k, v in ipairs(src) do
		table.insert(dst, v)
	end
	return dst
end

table.intkeys = function(tbl)
	local intkeys = {}
	for k, v in pairs(tbl) do
		if (type(k) == type(1)) then
			table.insert(intkeys, k)
		end
	end
	return intkeys
end

--------------------------------------------------------------------------------
-- 扩展table方法
-- 获取array元素下标
--------------------------------------------------------------------------------
table.findindex = function(array,fitem)
	local local_item = fitem
	local index = 0
	for i,item in ipairs(array) do
		if(local_item == item)then 
			index = i
		end
	end
	return index
end

--------------------------------------------------------------------------------
-- 扩展table方法
-- 获取array元素下标
--------------------------------------------------------------------------------
table.icontains = function(table, item)
	for k,v in ipairs(table) do
		if v == item then
			return true
		end
	end
	return false
end
--------------------------------------------------------------------------------
-- 扩展table方法
-- 以Json形式打印table
--------------------------------------------------------------------------------
local noLogStr = "logLua is closed!!"

table.tostring = function(tbl)
    return dumper.block(tbl)
end

table.getprt = function(tbl)
    return string.ltrim(string.split(tostring(tbl), ":")[2])
end

--------------------------------------------------------------------------------
-- 扩展table方法
-- 指定table中所有正数key值中最大的key值. 如果不存在key值为正数的元素, 则返回0
--------------------------------------------------------------------------------
table.maxn = function(tbl)
	local mn = nil
	for k, v in pairs(tbl) do
		if type(k) == "number" then
			if(mn == nil) then
				mn = k
			end
			if mn < k then
				mn = k
			end
		end
	end
	return mn or 0
end

--------------------------------------------------------------------------------
-- 扩展table方法
-- 获取table中的元素个数
--------------------------------------------------------------------------------
table.size = function(tbl)
	local count = 0
	for k, v in pairs(tbl) do
		count = count + 1
	end
	return count
end

--------------------------------------------------------------------------------
-- 构造枚 让程序编写起来舒服点
--------------------------------------------------------------------------------
table.createEnum = function (initTable)
	local retEnum = {}
	for i = 1, #initTable do
		local v = initTable[i]
		retEnum[v] = v
	end
	return retEnum
end

--------------------------------------------------------------------------------
-- 递归设置metatable
-- skillLvUp的配置需要覆盖effect的配置时需要用到
--------------------------------------------------------------------------------
table.setMetaTableRecursively = function(t, meta)
    if not t or not meta then
        return
    end

    setmetatable(t, {__index = meta})
    for k, v in pairs(t) do
        if type(v) == "table" then
            table.setMetaTableRecursively(v, meta[k])
        end
    end
end

table.iClear = function(t)
    local rawset = rawset
    local count = #t
    for i = 1, count do
        rawset(t, i, nil)
    end
end

table.clear = function(t)
    local next = next
    local k = next(t)
    while k ~= nil do
        rawset(t, k, nil)
        k = next(t, k)
    end
end