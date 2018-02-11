local function connect (conn, data)
    local query_data

    conn:on ("receive",
       function (cn, req_data)
            newH, newM = string.match(req_data, "GET /%?h=(%d+)&m=(%d+) HTTP")
            if newH and newM then
                setAlarm(tonumber(newH), tonumber(newM))
            end
            print (req_data)
            cn:send ("HTTP/1.0 200 OK\nContent-Type: text/html; charset=utf-8\n\n<form method='GET' action='/'><input type='number' name='h' value='" .. tostring(alarmH) .."'> : <input type='number' name='m' value='" .. tostring(alarmM) .. "'> <br> <button type='submit'>Save</button></form>")
            -- Close the connection for the request
            cn:close ( )
       end)
 end


 -- Create the httpd server
 svr = net.createServer (net.TCP, 30)

 -- Server listening on port 80, call connect function if a request is received
 svr:listen (80, connect)
