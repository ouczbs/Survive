local class = class(GA.Time, "Scheduler")
local Timer = GA.Time.Timer
local TableUtility = GA.Utility.TableUtility
function class:ctor()
    self._timers = {}
    self._toAddTimers = {}
    self._inTick = false
    self.REPEAT_FOREVER = REPEAT_FOREVER
end
function class:init()

end
local function tickWalker(timer, index, deltaTime)
    class:tick(deltaTime)
end

local function tickRemove(timer)
    if timer._end then
        --log("[Schedule][remove schedule] ID : " .. timer._timerID)
        return true
    end
    return false
end

local function tickAdd(timer, timerArray)
    TableUtility.ArrayPushBack(timerArray, timer)
end

function class:_tick(deltaTime)
    self._inTick = true
    
    TableUtility.ArrayWalk(self._timers, tickWalker, deltaTime)
    TableUtility.ArrayRemoveAllByPredicate(self._timers, tickRemove)
    TableUtility.ArrayClearByDeleter(self._toAddTimers, tickAdd, self._timers)

    self._inTick = false
end

function class:tick(deltaTime)
    self:_tick(deltaTime)
    self._inTick = false
end

local function FindTimerByID(timer, id)
    if timer._timerID == id then
        return true
    end
    return false
end

local function FindTimerByCallback(timer, callback)
    if timer._callback == callback then
        return true
    end
    return false
end

local nextSchedulerID = 0
--[[
    @desc: 启动定时器
    author:{author}
    time:2019-01-28 12:35:27
	--@interval: 调用间隔
	--@repeatCount: 重复次数
	--@delay: 首次调用的延迟
	--@callback: 回调方法
	--@args: 回调参数
    @return:
]]
function class:schedule(interval, repeatCount, duration, delay, callback, finishCall, ignoreBigInterval, ...)
    local timer = Timer.new()
    nextSchedulerID = nextSchedulerID + 1
    timer:setup(nextSchedulerID, interval, repeatCount, duration, delay, callback, finishCall, ignoreBigInterval, ...)
    if self._inTick then
        TableUtility.ArrayPushBack(self._toAddTimers, timer)
    else
        TableUtility.ArrayPushBack(self._timers, timer)
    end
    return nextSchedulerID
end

--[[
    @desc: 启动一次性定时器
    author:{author}
    time:2019-01-28 12:36:02
    --@key:
	--@delay:
	--@callback:
	--@args: 
    @return:
]]
function class:scheduleOnce(delay, callback, ...)
    return self:schedule(0, 0, 0, delay, callback, nil, false, ...)
end

function class:scheduleOnceIgnoreBigInterval(delay, callback, ...)
    return self:schedule(0, 0, 0, delay, callback, nil, true, ...)
end

--[[
    @desc: 等待一帧的定时器
    author:{author}
    time:2019-01-28 12:40:08
    --@key:
	--@callback:
	--@args: 
    @return:
]]
function class:scheduleNextFrame(callback, ...)
    return self:schedule(0, 0, 0, 0, callback, nil, false, ...)
end

--[[
    @desc: timeline
]]
function class:scheduleTimeLine(duration, callback, finishCall, ignoreBigInterval, ...)
    return self:schedule(0, 0, duration, 0, callback, finishCall, ignoreBigInterval, ...)
end

--[[
    @desc: update定时器
    author:{author}
    time:2019-01-28 12:40:23
    --@key:
	--@callback:
	--@args: 
    @return:
]]
function class:scheduleUpdate(callback, ...)
    return self:schedule(0, REPEAT_FOREVER, 0, 0, callback, nil, false, ...)
end

--[[
    @desc: 移除定时器
    author:{author}
    time:2019-01-28 12:41:14
    --@id_or_callback: 定时器ID或方法
    @return:
]]
function class:unschedule(id_or_callback, callFinish)
    if not id_or_callback then return end

    local findfunc = nil
    if type(id_or_callback) == "number" then
        findfunc = FindTimerByID
    elseif type(id_or_callback) == "function" then
        findfunc = FindTimerByCallback
    end

    if not findfunc then return end

    local val0, index0 = TableUtility.ArrayRemoveByPredicate(self._toAddTimers, findfunc, id_or_callback)
    if callFinish and val0 then
        val0:callFinishCall()
    end
    if index0 == 0 then
        if self._inTick then
            local val1, index1 = TableUtility.ArrayFindByPredicate(self._timers, findfunc, id_or_callback)
            if val1 ~= nil then
                if callFinish then
                    val1:callFinishCall()
                end
                val1:cancel()
            end
        else
            local val1, index1 = TableUtility.ArrayRemoveByPredicate(self._timers, findfunc, id_or_callback)
            if callFinish and val1 then
                val1:callFinishCall()
            end
        end
    end
end

--------------------------------------------------------------------------------
-- 更改定时器的间隔 ...
-- inIDOrCallback 已存在的定时器ID或回调
-- inInterval 需要设定的间隔
--------------------------------------------------------------------------------
function class:setInterval(inIDOrCallback, inInterval)
    if not inIDOrCallback then return end
    local tFindfunc = nil
    if type(inIDOrCallback) == "number" then
        tFindfunc = FindTimerByID
    elseif type(inIDOrCallback) == "function" then
        tFindfunc = FindTimerByCallback
    end
    if not tFindfunc then return end
    local tScheduler, tTableIndex = TableUtility.ArrayFindByPredicate(self._timers, tFindfunc, inIDOrCallback)
    if not tScheduler then
        tScheduler, tTableIndex = TableUtility.ArrayFindByPredicate(self._toAddTimers, tFindfunc, inIDOrCallback)
    end
    if tScheduler then
        tScheduler._interval = inInterval
    end
end


local function FindTimerByTarget(timer, target)
    local args = timer._args
    if args and #args > 0 and args[1] == target then
        return true
    end
    return false
end

--[[
    @desc: 移除指定对象的所有定时器
    author:liuxiaoyi
    time:2019-07-29 21:24:20
    --@target: [lua table] lua对象引用
    @return:
]]
function class:unscheduleAllWithTarget(target)
    if not target then return end

    TableUtility.ArrayRemoveAllByPredicate(self._toAddTimers, FindTimerByTarget, target)
    if self._inTick then
        local count = #self._timers
        for i = 1, count do
            local timer = self._timers[i]
            local args = timer._args
            if args and #args > 0 and args[1] == target then
                class:cancel()
            end
        end
    else
        TableUtility.ArrayRemoveAllByPredicate(self._timers, FindTimerByTarget, target)
    end
end

function class:Destroy()
    TableUtility.ArrayClear(self._timers)
    TableUtility.ArrayClear(self._toAddTimers)
end