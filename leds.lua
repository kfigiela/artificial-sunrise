ws2812.init()
ws2812.write(string.char(0, 0, 255, 0, 0, 255))


nLeds = 107

buffer = ws2812.newBuffer(nLeds, 3)
buffer:fill(0, 0, 0)
ws2812.write(buffer)

s=net.createServer(net.UDP)
s:on("receive",function(s,c)
       print(c)
       r, g, b = string.match(c, "(%d+) (%d+) (%d+)")
       if(r ~= nil and g ~= nil and b ~= nil) then
         buffer:fill(tonumber(g), tonumber(r), tonumber(b))
         ws2812.write(buffer)
       end
   end)
s:listen(8888)


