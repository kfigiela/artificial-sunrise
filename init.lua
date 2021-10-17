function startup()
    print('Starting')
    dofile("secrets.lc")
    dofile("wifi.lc")
    dofile("ntp.lc")
    dofile("http.lc")
    dofile("leds.lc")
    dofile("magic-led.lc")
    dofile("rotary.lc")
    dofile("mqtt.lc")
    dofile("dht.lc")
    dofile("ds.lc")
    dofile("influx.lc")
    dofile("sunrise.lc")
    print(wifi.sta.getip())
    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
      print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..T.netmask.."\n\tGateway IP: "..T.gateway)
      startMQTT()
      startNTP()
      startInflux()
    end)
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
      print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
      T.BSSID.."\n\tChannel: "..T.channel)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
      print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
      T.BSSID.."\n\treason: "..T.reason)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_AUTHMODE_CHANGE, function(T)
      print("\n\tSTA - AUTHMODE CHANGE".."\n\told_auth_mode: "..
      T.old_auth_mode.."\n\tnew_auth_mode: "..T.new_auth_mode)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, function()
      print("\n\tSTA - DHCP TIMEOUT")
    end)

    wifi.sta.connect()
end

tmr.alarm(0,5000,0,startup)
print("Starting in 5 seconds")
