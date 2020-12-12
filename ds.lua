-- 18b20 Example
-- 18b20 Example
local pin = 3
ow.setup(pin)
local addr = ow.reset_search(pin)
local addr = ow.search(pin)

dsTemp = nil

if addr == nil then
  print("No device detected.")
else
  local crc = ow.crc8(string.sub(addr,1,7))
  if crc == addr:byte(8) then
    if (addr:byte(1) == 0x10) or (addr:byte(1) == 0x28) then
      tmr.create():alarm(5000, tmr.ALARM_AUTO, function()
          ow.reset(pin)
          ow.select(pin, addr)
          ow.write(pin, 0x44, 1) -- convert T command
          tmr.create():alarm(750, tmr.ALARM_SINGLE, function()
              ow.reset(pin)
              ow.select(pin, addr)
              ow.write(pin,0xBE,1) -- read scratchpad command
              local data = ow.read_bytes(pin, 9)
              local crc = ow.crc8(string.sub(data,1,8))
              if crc == data:byte(9) then
                 local t = (data:byte(1) + data:byte(2) * 256) * 625
                 dsTemp = t / 10000.0
              end
          end)
      end)
    else
      print("Device family is not recognized.")
    end
  else
    print("CRC is not valid!")
  end
end
