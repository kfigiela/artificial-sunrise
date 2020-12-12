fallbackTemplate = "HTTP/1.0 200 OK\nContent-Type: text/html; charset=utf-8\n\n<form method='GET' action='/'><input type='number' name='h' value='[HOUR]'> : <input type='number' name='m' value='[MINUTE]'> <br> <button type='submit'>Save</button></form>"

function loadTemplate ()
    if file.open("template.html", "r") then
        local template = ""
        local chunk = file.read(512)
        while chunk do
            template = template .. chunk
            chunk = file.read(512)
        end
        file.close()
        return template
    else
        return fallbackTemplate
    end
end

template = loadTemplate()

local function connect (conn, data)
    local query_data

    conn:on ("receive",
       function (cn, req_data)
            newH, newM = string.match(req_data, "GET /%?h=(%d+)&m=(%d+) HTTP")
            if newH and newM then
                setAlarm(tonumber(newH), tonumber(newM))
            end
            print (req_data)

            local msg = template
            msg = string.gsub(msg, 'HOUR', tostring(alarmH))
            msg = string.gsub(msg, 'MINUTE', tostring(alarmM))
            msg = string.gsub(msg, 'TEMPERATURE', tostring(temp))
            msg = string.gsub(msg, 'HUMIDITY', tostring(humidity))
            msg = string.gsub(msg, 'ALARM_ON', tostring(1 - gpio.read(2)))

            cn:send(msg)
            -- Close the connection for the request
            cn:close ( )
       end)
 end



 -- Create the httpd server
 svr = net.createServer (net.TCP, 30)

 -- Server listening on port 80, call connect function if a request is received
 svr:listen (80, connect)
