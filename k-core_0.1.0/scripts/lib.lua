function lerp(range, t)
  if type(range) == "table" then
    return range[1] + ( t * (range[2] - range[1]) )
  elseif type(range) == "number" then
    return range
  end
  return nil
end

function ticks_to_time_string(ticks)
  if ticks < Time.MINUTE then return math.ceil(ticks/Time.SECOND).."s" end
  if ticks < Time.HOUR then return math.floor(ticks/(Time.MINUTE)).."m" end
  return math.floor(ticks/(Time.HOUR)).."h"
end
