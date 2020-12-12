local sunriseTimer = tmr.create()

local colorIx = 0

gpio.mode(2,gpio.INPUT,gpio.PULLUP)

sunriseTimer:register(1000, tmr.ALARM_AUTO, function (t)
    colorIx = colorIx + 1
    displayColor(colorIx)
    if colorIx > numColors then
        abortSunrise()
    end
end)

function startSunrise()
    colorIx = 0
    sunriseTimer:start()
    sunriseInProgress = true
end

function abortSunrise()
    sunriseTimer:stop()
    sunriseInProgress = false
end


alarmH = 6
alarmM = 30

if file.open("sunrise.conf", "r") then
    alarmH = tonumber(file.readline())
    alarmM = tonumber(file.readline())
    file.close()
end

function setAlarm(h, m)
    if file.open("sunrise.conf", "w") then
        file.writeline(tostring(h))
        file.writeline(tostring(m))
        alarmH = h
        alarmM = m
        file.close()
    end
end

local sunriseInProgress = false

local alarmClock = tmr.create()
alarmClock:register(10000, tmr.ALARM_AUTO, function (t)
    tm = rtctime.epoch2cal(rtctime.get())
    alarmEnabled = 1 - gpio.read(2)
    if tm["hour"] == alarmH and tm["min"] == alarmM and sunriseInProgress == false then
        if alarmEnabled == 1 then
            startSunrise()
        end
    elseif tm["hour"] == (alarmH + 2) and tm["min"] == alarmM then
        displayColor(0)
    end

    if ntpSyncedStatus == 0 and alarmEnabled == 1 then
        ws2812.write(string.char(0, 0, 2))
    end
    -- print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
end)
alarmClock:start()
