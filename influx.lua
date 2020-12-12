influxTimer = tmr.create()

function sendInflux(payload)
  local conn = net.createConnection(net.UDP, 0)
  conn:connect(8089,"10.0.42.148")
  conn:send(payload, function()
    conn:close()
    conn = nil
  end)
end

influxTimer:register(30000, tmr.ALARM_AUTO, function (t)
  sendInflux("climate,room=bedroom dhtTemp=" .. temp .. ",dsTemp=" .. dsTemp .. ",humidity=" .. humidity .. "\n"
      .. "light,strip=bedroom r=" .. stripR .. ",g=" .. stripG .. ",b=" .. stripB .. ",w=" .. stripW .. ",.ix=" .. lastColor .. "\n")
end)

function startInflux()
  influxTimer:start()
end
