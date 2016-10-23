mq = mqtt.Client(MQTT_CLIENT, 120, MQTT_USER, MQTT_PASSWORD)

function startMQTT()
  mq:connect(MQTT_HOST, MQTT_PORT, 0, function(client) print("MQTT connected") end, function(client, reason) print("MQTT failed reason: "..reason) end)
end
