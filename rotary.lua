
rotary.setup(0,5,6,7, 1500, 500)

rotary.on(0, rotary.ALL, function (type, pos, when)
  abortSunrise()
end)

lastColor = 0
lastPos = 0

rotary.on(0, rotary.PRESS, function (type, pos, when)
    abortSunrise()
    if lastColor ~= 0 then
        displayColor(0)
    else
        displayColor(20)
    end
end)

rotary.on(0, rotary.LONGPRESS, function (type, pos, when)
    abortSunrise()
    print("long press")
    displayColor(512)
end)

rotary.on(0, rotary.TURN, function (type, pos, when)
    local delta
    delta = lastPos - pos
    lastPos = pos
    if math.abs(delta) < 50 then
      print("Position=" .. pos .. " event type=" .. type .. " time=" .. when .. " delta=" .. delta)

      displayColor(math.min(math.max(0, lastColor - delta), 828))
    end
end)

function displayColor(colorIx)
    local r, g, b, w
    lastColor = colorIx
    if colorIx <= 255 then
        r = colorIx
        g = math.floor(colorIx / 255.0 * 64)
        b = 0
    else
        r = 255
        g = math.min(255, math.floor(64 + (colorIx - 255) / 190 * 126))
        b = math.min(255, math.floor((colorIx - 255) / 190 * 85))
    end
    w = math.min(255, math.max(0, colorIx-256))

    print("color " .. colorIx)
    setStripColor(r,g,b,w)
end
