require 'artoo'

connection :beaglebone, :adaptor => :beaglebone
device :led, :driver => :led, :pin => :P9_12

work do
  every 1.second do
    led.on? ? led.off : led.on
  end
end