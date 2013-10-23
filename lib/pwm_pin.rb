class PwmPin
  attr_reader :pin, :pwm_device

  SLOTS = "/sys/devices/bone_capemgr.*"
  def initialize(pin)
    @pin = pin.to_s.upcase
    File.open("#{Dir.glob(SLOTS).first}/slots", "w") { |f|
      f.write("am33xx_pwm")
    }
    File.open("#{Dir.glob(SLOTS).first}/slots", "w") { |f|
      f.write('bone_pwm_' + @pin)
    }
    @pwm_device = Dir.glob(Dir.glob("/sys/devices/ocp.*").first+"/pwm_test_" + @pin + ".*").first
    File.open(@pwm_device + "/run", "w") { |f| f.write(1) }
    pwm_write(0)
  end

  def pwm_write(period, duty=0)
    File.open(@pwm_device + "/period", "w") { |f| f.write(period) }
    File.open(@pwm_device + "/duty", "w") { |f| f.write(duty) }
  end

  def release
    File.open(@pwm_device + "/run", "w") { |f| f.write(0) }
  end
end
