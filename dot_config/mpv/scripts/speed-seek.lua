function seek(seconds)
  local speed = mp.get_property_number("speed", 1)
  mp.commandv("seek", seconds * speed)
end

mp.add_key_binding('LEFT', 'speed-seek-left', function() seek(-5) end, {repeatable = true})
mp.add_key_binding('WHEEL_DOWN', 'speed-seek-wheel-down', function() seek(-5) end, {repeatable = true})
mp.add_key_binding('RIGHT', 'speed-seek-right', function() seek(5) end, {repeatable = true})
mp.add_key_binding('WHEEL_UP', 'speed-seek-wheel-up', function() seek(5) end, {repeatable = true})
mp.add_key_binding('UP', 'speed-seek-up', function() seek(60) end, {repeatable = true})
mp.add_key_binding('DOWN', 'speed-seek-down', function() seek(-60) end, {repeatable = true})
