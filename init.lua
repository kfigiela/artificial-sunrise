function startup()
    print('Starting')
    dofile("secrets.lc")
    dofile("wifi.lc")
    dofile("ntp.lc")
    -- dofile("telnet.lc")
    dofile("http.lc")
    dofile("leds.lc")
    dofile("rotary.lc")
    dofile("mqtt.lc")
    dofile("dht.lc")
    dofile("sunrise.lc")
    print(wifi.sta.getip())
    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
      print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..T.netmask.."\n\tGateway IP: "..T.gateway)
      startMQTT()
      startNTP()
    end)
    wifi.sta.connect()
end

tmr.alarm(0,5000,0,startup)
print("Starting in 5 seconds")
