
local REPEAT_FOREVER = -1

local class = class(GA.Time, "Timer")

function class:ctor()
    self:init()
end

function class:init()
    self._elapsed = 0
    self._everyFrame = false
    self._forever = false
    self._timesExecuted = 0
    self._timePassed = 0
    self._repeatCount = 0 
    self._interval = 0
    self._end = false
end

function class:setup(timerID, interval, repeatCount, duration, delay, callback, finishCall, ignoreBigInterval, ...)
    self:init()

    self._timerID = timerID
    self._callback = callback
    self._finishCall = finishCall
    self._ignoreBigInterval = ignoreBigInterval

    self._interval = interval
    self._repeatCount = repeatCount
    self._duration = duration
    self._realInterval = interval + delay
    self._duration = duration
    self._delay = delay
    
    self._args = {...}

    if self._repeatCount == REPEAT_FOREVER then
        self._forever = true
        if self._interval == 0 and self._delay == 0 then
            self._everyFrame = true
        end
    end
end

function class:tick(deltaTime)
    if self._end then
        return
    end

    if self._everyFrame then
        if next(self._args) then
            local rstTable = table.copy(self._args)
            table.insert(rstTable, 0)
            table.insert(rstTable, deltaTime)
            self._callback(table.unpack(rstTable))
        else
            self._callback(self._timePassed, deltaTime)
        end
        return
    end
    if self._ignoreBigInterval then
        deltaTime = math.clamp(deltaTime, 0, 0.15)
    end

    self._elapsed = self._elapsed + deltaTime
    self._timePassed = self._timePassed + deltaTime

    if self._elapsed > self._realInterval then
        if next(self._args) then
            local rstTable = table.copy(self._args)
            table.insert(rstTable, self._timePassed)
            table.insert(rstTable, deltaTime)
            self._callback(table.unpack(rstTable))
        else
            self._callback(self._timePassed, deltaTime)
        end
        self._timesExecuted = self._timesExecuted + 1
        self._elapsed = self._elapsed - self._realInterval
        self._realInterval = self._interval
    end

    if self._forever ~= true then
        -- 如果持续时间大于0，等待持续时间到后停止定时器
        -- 否则根据执行次数处理停止逻辑
        if self._duration > 0 then
            if self._timePassed > self._duration + self._delay then
                if self._finishCall then
                    self._finishCall(table.unpack(self._args))
                end
                self._end = true
            end
        else
            if self._timesExecuted > self._repeatCount then
                if self._finishCall then
                    self._finishCall(table.unpack(self._args))
                end
                self._end = true
            end
        end
    end
end

function class:callFinishCall()
    if self._finishCall then
        self._finishCall(table.unpack(self._args))
    end
end

function class:checkEnd()
    return self._end
end

function class:cancel()
    self._end = true
end