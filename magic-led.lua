
local magic = nil
local pendingPayload = nil

stripR = 0
stripG = 0
stripB = 0
stripW = 0

function reconnect()
  print("Connecting")
  magic = net.createConnection(net.TCP, 30)
  magic:on("connection", function(sck,c)
    magic = sck
    print("Connected")
    if pendingPayload ~= nil then
      sck:send(pendingPayload)
      pendingPayload = nil
    end
  end)
  magic:on("reconnection", function(sck,c)
    magic = sck
    print("Reconnected")
  end)
  magic:on("disconnection", function(sck,c)
    print("disconnected")
    magic:close()
    magic = nil
  end)
  magic:connect(5577, "bedroom-led.lan")
end

function setStripColor(r,g,b,w)
    checksum = (0x31 + r + g + b + w + 0x00 + 0x0f + 0x0f) % 256
    payload = string.char(0x31, r, g, b, w, 0x00, 0x0f, 0x0f, checksum)
    -- print(0x31 + r + g + b + w + 0x00 + 0x0f + 0x0f, checksum)
    -- print("r=" .. r .. " g=" .. g .. " b=" .. b .. " w=" .. w)
    stripR = r
    stripG = g
    stripB = b
    stripW = w
    if magic ~= nil then
      magic:send(payload, function(sk)
        -- print("sent", payload)
        -- sendInflux("light,strip=bedroom r=" .. r .. ",g=" .. g .. ",b=" .. b .. ",w=" .. w)
      end)
    else
      pendingPayload = payload
      reconnect()
      print("magic is nil")
    end
end
