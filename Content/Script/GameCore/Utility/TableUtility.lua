local class = class(GA.Utility, "TableUtility")
-- local _Debug = true

local tempTable = {}
local tempArray = {}

-- array begin
function class.ArrayShallowCopy(target, source)
	-- if _Debug then
	-- 	Debug_Assert(#source == table.maxn(source), "Array Size Bug!!!")
	-- end
	for i=1, #source do
		target[i] = source[i]
	end
end
function class.ArrayShallowCopyWithCount(target, source, count)
	for i=1, count do
		target[i] = source[i]
	end
end
function class.ArrayClear(array)
	-- if _Debug then
	-- 	Debug_Assert(#array == table.maxn(array), "Array Size Bug!!!")
	-- end
	for i = #array, 1, -1  do
		array[i] = nil
	end
end
function class.ArrayClearWithCount(array, count)
	for i = count, 1, -1  do
		array[i] = nil
	end
end
function class.ArrayClearByDeleter(array, deleter, ...)
	for i = #array, 1, -1  do
		deleter(array[i], ...)
		array[i] = nil
	end
end

function class.ArrayPushBack(array, obj)
	table.insert(array, obj)   
	--array[#array+1] = obj
end
function class.ArrayPopBack(array)
	local len = #array
	if 0 >= len then
		return nil
	end
	local obj = array[len]
	array[len] = nil
	return obj
end

function class.ArrayPushFront(array, obj)
	table.insert(array, 1, obj)
end

function class.ArrayPopFront(array)
	if #array == 0 then
		return nil
	end
	local obj = array[1]
	table.remove(array, 1)
	return obj
end

function class.ArrayFindIndex(array, obj)
	for i=1, #array do
		if array[i] == obj then
			return i
		end
	end
	return 0
end

function class.ArrayFindByPredicate(array, predicate, args)
	for i=1, #array do
		if predicate(array[i], args) then
			return array[i], i
		end
	end
	return nil, 0
end
function class.ArrayRemove(array, obj)
	for i=1, #array do
		if array[i] == obj then
			table.remove(array, i)
			return i
		end
	end
	return 0
end
function class.ArrayRemoveByPredicate(array, predicate, args)
	for i=1, #array do
		if predicate(array[i], args) then
			local retVal = array[i]
			table.remove(array, i)
			return retVal, i
		end
	end
	return nil, 0
end
function class.ArrayRemoveAllByPredicate(array, predicate, ...)
	local count = 0
	for i = #array, 1, -1 do
		if predicate(array[i], ...) then
			table.remove(array, i)
			count = count + 1
		end
	end
	return count
end
function class.ArrayUnique(array)
	for i=1, #array do
		if nil ~= tempTable[array[i]] then
			tempArray[#tempArray+1] = i
		else
			tempTable[array[i]] = 1
		end
	end
	for i=#tempArray, 1, -1 do
		table.remove(array, tempArray[i])
		tempArray[i] = nil
	end
	class.TableClear(tempTable)
	return 0
end

function class.ArrayWalk(array, walker, ...)
	for i = 1, #array do
		walker(array[i], i, ...)
	end
end

function class.ArrayUnrepeat(array, walker)
end
-- array end

-- table begin
function class.TableShallowCopy(target, source)
	for k,v in pairs(source) do
		target[k] = v
	end
end
function class.TableClear(t)
	for k,_ in pairs(t) do
		t[k] = nil
	end
end
function class.TableClearByDeleter(t, deleter)
	for k,v in pairs(t) do
		deleter(v)
		t[k] = nil
	end
end
function class.TableFindKey(t, obj)
	for k,v in pairs(t) do
		if v == obj then
			return k
		end
	end
end
function class.TableFindByPredicate(t, predicate, args)
	for k,v in pairs(t) do
		if predicate(k, v, args) then
			return v, k
		end
	end
end
function class.TableRemove(t, obj)
	for k,v in pairs(t) do
		if v == obj then
			t[k] = nil
			return k
		end
	end
	return nil
end
function class.TableRemoveByPredicate(t, predicate, args)
	for k,v in pairs(t) do
		if predicate(k, v, args) then
			t[k] = nil
			return k
		end
	end
	return nil
end
-- table end

function class.ArrayInsertSort( t, v, sortFunc )
	if(#t == 0)then
		t[1] = v;
		return 1;
	end

	local inserted, index;
	for i=1,#t do
		if(sortFunc( t[i], v))then
			table.insert(t, i, v);
			return i;
		end
	end
	table.insert(t, v)
	return #t;
end
