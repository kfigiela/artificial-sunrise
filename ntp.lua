function startNTP ()
 print("Syncing RTC clock with NTP...")
 sntp.sync('193.219.28.147', -- ICM server
   function(sec,usec,server)
     print('RTC synced', sec, usec, server)
     tm = rtctime.epoch2cal(rtctime.get())
     print(string.format("Time: %04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
   end,
   function()
    print('RTC failed to sync')
   end
 )
end
