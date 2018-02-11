dhtTimer = tmr.create()

local tmpStatus = 0

tmpStatus, temp, humidity = dht.readxx(1)

dhtTimer:register(60000, tmr.ALARM_AUTO, function (t)
    status, temp, humidity = dht.readxx(1)
    if status == 0 then
        mq:publish(MQTT_TEMP_TOPIC, temp, 0, 0)
        mq:publish(MQTT_HUMIDITY_TOPIC, humidity, 0, 0)
        print("Pushing DHT to MQTT")
    else
        print("Failed to read DHT")
    end
end)

dhtTimer:start()
