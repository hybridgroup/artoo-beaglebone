require 'artoo/adaptors/adaptor'
require 'artoo/adaptors/io'
require 'pwm_pin'

module Artoo
  module Adaptors
    # Connect to a beaglebone device
    # @see device documentation for more information
    class Beaglebone < Adaptor
      include Artoo::Adaptors::IO
      PINS = {
        :P8_3 => 38,
        :P8_4 => 39,
        :P8_5 => 34,
        :P8_6 => 35,
        :P8_7 => 66,
        :P8_8 => 67,
        :P8_9 => 69,
        :P8_10 => 68,
        :P8_11 => 45,
        :P8_12 => 44,
        :P8_13 => 23,
        :P8_14 => 26,
        :P8_15 => 47,
        :P8_16 => 46,
        :P8_17 => 27,
        :P8_18 => 65,
        :P8_19 => 22,
        :P8_20 => 63,
        :P8_21 => 62,
        :P8_22 => 37,
        :P8_23 => 36,
        :P8_24 => 33,
        :P8_25 => 32,
        :P8_26 => 61,
        :P8_27 => 86,
        :P8_28 => 88,
        :P8_29 => 87,
        :P8_30 => 89,
        :P8_31 => 10,
        :P8_32 => 11,
        :P8_33 => 9,
        :P8_34 => 81,
        :P8_35 => 8,
        :P8_36 => 80,
        :P8_37 => 78,
        :P8_38 => 79,
        :P8_39 => 76,
        :P8_40 => 77,
        :P8_41 => 74,
        :P8_42 => 75,
        :P8_43 => 72,
        :P8_44 => 73,
        :P8_45 => 70,
        :P8_46 => 71,
        :P9_11 => 30,
        :P9_12 => 60,
        :P9_13 => 31,
        :P9_14 => 50,
        :P9_15 => 48,
        :P9_16 => 51,
        :P9_17 => 5,
        :P9_18 => 4,
        :P9_19 => 13,
        :P9_20 => 12,
        :P9_21 => 3,
        :P9_22 => 2,
        :P9_23 => 49,
        :P9_24 => 15,
        :P9_25 => 117,
        :P9_26 => 14,
        :P9_27 => 115,
        :P9_28 => 113,
        :P9_29 => 111,
        :P9_30 => 112,
        :P9_31 => 110
      }
      attr_reader :pins, :i2c, :pwm_pins

      # Name of device
      # @return [String]
      def firmware_name
        "Beaglebone"
      end

      # Version of device
      # @return [String]
      def version
        Artoo::Beaglebone::VERSION
      end

      def digital_write pin, val
        pin = beaglebone_pin(pin, "w")
        pin.digital_write(val)
      end

      def digital_read pin
        pin = beaglebone_pin(pin, "r")
        pin.digital_read
      end

      def i2c_start address
         @i2c = I2c.new i2c2_file, address
      end

      def i2c_write *data
        i2c.write *data
      end

      def i2c_read len
        i2c.read len
      end

      def pwm_write(pin, period, duty=0)
        pin = pwm_pin(pin)
        pin.pwm_write(period, duty)
      end

      def release_pwm(pin)
        pin = translate_pin(pin)
        pwm_pins[pin].release
        pwm_pins[pin] = nil
      end

      def release_all_pwm_pins
        pwm_pins.each_value { |pwm_pin| pwm_pin.release }
      end

      private

      def translate_pin pin
        begin
          PINS.fetch(pin.upcase.to_sym)
        rescue Exception => e
          raise "Not a valid pin"
        end
      end

      def beaglebone_pin pin, mode
        @pins = [] if @pins.nil?
        pin = translate_pin pin
        @pins[pin] = DigitalPin.new(pin, mode) if @pins[pin].nil? || @pins[pin].mode != mode
        @pins[pin]
      end

      def pwm_used?(pin)
        (pwm_pins[translate_pin(pin)].nil?) ? false : true
      end

      def pwm_pin(pin)
        translated_pin = translate_pin(pin)
        pwm_pins[translated_pin] = PwmPin.new(pin) if pwm_pins[translated_pin].nil?
        pwm_pins[translated_pin]
      end

      def i2c2_file
        "/dev/i2c-1"
      end
    end
  end
end
