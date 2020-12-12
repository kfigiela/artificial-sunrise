dhtTimer = tmr.create()
mqttTimer = tmr.create()

temp = nil
humidity = nil

mqttTemp = nil
mqttHumidity = nil

function readDht()
    local retries = 5
    local currentStatus, currentTemp, currentHumidity = nil, nil, nil
    currentStatus, currentTemp, currentHumidity = dht.readxx(1)
    while retries > 0 and currentStatus ~= 0 do
        retries = retries - 1
        print("Failed to read DHT")
        currentStatus, currentTemp, currentHumidity = dht.readxx(1)
    end
    if currentStatus == 0 then
        temp = currentTemp
        humidity = currentHumidity
        mqttTemp = currentTemp
        mqttHumidity = currentHumidity
    end
    print("Temp = " .. currentTemp .. " C, RH=" .. currentTemp .. "%")
end

dhtTimer:register(5000, tmr.ALARM_AUTO, function (t)
    readDht()
end)

mqttTimer:register(60000, tmr.ALARM_AUTO, function (t)
    if mqttTemp ~= nil and mqttHumidity ~= nil then
        mq:publish(MQTT_TEMP_TOPIC, mqttTemp, 0, 0)
        mq:publish(MQTT_HUMIDITY_TOPIC, mqttHumidity, 0, 0)
        print("Pushing DHT to MQTT")
        mqttHumidity = nil
        mqttTemp = nil
    end
end)

dhtTimer:start()
mqttTimer:start()
