-- tm = rtctime.epoch2cal(rtctime.get())
-- print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
--

sunriseTimer = tmr.create()

NUM_LEDS = nLeds
NUM_COLORS = 255 + 190

local substateIx = 1
local colorIx = 0
local r, g, b = 1, 0, 0

gpio.mode(2,gpio.INPUT,gpio.PULLUP)

sunriseTimer:register(40, tmr.ALARM_AUTO, function (t)
    buffer:set(substateIx, g, r, b)
    ws2812.write(buffer)
    if substateIx == NUM_LEDS then
        substateIx = 1
        colorIx = colorIx + 1
        if colorIx <= 255 then
            r = colorIx
            g = math.floor(colorIx / 255.0 * 64)
            b = 0
        else
            r = 255
            g = math.floor(64 + (colorIx - 255) / 190 * 126)
            b = math.floor((colorIx - 255) / 190 * 85)
        end
        if colorIx == NUM_COLORS then
            abortSunrise()
        else
            lastColor = colorIx
        end
    else
        substateIx = substateIx + 1
    end
    end)

function startSunrise()
    substateIx = 1
    colorIx    = 0
    r, g, b = 1, 0, 0
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

sunriseInProgress = false

alarmClock = tmr.create()
alarmClock:register(10000, tmr.ALARM_AUTO, function (t)
    tm = rtctime.epoch2cal(rtctime.get())
    alarmEnabled = 1 - gpio.read(2)
    if tm["hour"] == alarmH and tm["min"] == alarmM and sunriseInProgress == false then
        if alarmEnabled == 1 then
            startSunrise()
        end
    elseif tm["hour"] == (alarmH + 2) and tm["min"] == alarmM then
        buffer:fill(0, 0, 0)
        ws2812.write(buffer)
    end

    if ntpSyncedStatus == 0 and alarmEnabled == 1 then
        ws2812.write(string.char(0, 0, 30))
    end
    -- print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
end)
alarmClock:start()

refreshTimer = tmr.create()
refreshTimer:register(1000, tmr.ALARM_AUTO, function (t)
    ws2812.write(buffer)
end)
refreshTimer:start()
