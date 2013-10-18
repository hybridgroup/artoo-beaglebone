require 'artoo'

connection :beaglebone, :adaptor => :beaglebone
device :led, :driver => :led, :pin => :P9_21

brightness = 0
fade_amount = 5


work do
  every(0.05) do
    led.brightness(brightness)
    brightness = brightness + fade_amount
    if brightness == 0 or brightness == 60
      fade_amount = -fade_amount
    end
  end
end
