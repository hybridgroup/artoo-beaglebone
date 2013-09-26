require 'artoo'

connection :beaglebone, :adaptor => :beaglebone
device :led, :driver => :led, :pin => {:gpio1 => 28}

work do
  every 1.second do
    led.on? ? led.off : led.on
  end
end