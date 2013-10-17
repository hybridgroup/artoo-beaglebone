  class PwmPin

  attr_reader :pin

  SLOTS = "/sys/devices/bone_capemgr.*/slots"
  PWM_DEVICE "/sys/devices/ocp.*"
  def initialize(pin)
    @pin = pin.to_s.upcase
    File.open("#{SLOTS}", "w") { |f| 
      f.write("am33xx_pwm") 
      f.write('bone_pwm_' + @pin)
    }
    File.open("#{PWM_DEVICE}/pwm_test_" + @pin + ".*/run", "w") { |f| f.write(1) }
    pwm_write(0)
  end

  def pwm_write(period, duty=0)
    File.open("#{PWM_DEVICE}/pwm_test_" + @pin + ".*/period", "w") { |f| f.write(period) }
    File.open("#{PWM_DEVICE}/pwm_test_" + @pin + ".*/duty", "w") { |f| f.write(duty) }
  end

  def release
    File.open("#{PWM_DEVICE}/pwm_test_" + @pin + ".*/run", "w") { |f| f.write(0) }
  end
end
