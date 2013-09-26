require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a beaglebone device
    # @see device documentation for more information
    class Beaglebone < Adaptor

      attr_reader :i2c_address
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
      finalizer :finalize

      # Closes connection with device if connected
      # @return [Boolean]
      def finalize
      end

      # Creates a connection with device
      # @return [Boolean]
      def connect
        super
      end

      # Closes connection with device
      # @return [Boolean]
      def disconnect
        super
      end

      # Name of device
      # @return [String]
      def firmware_name
        "beaglebone"
      end

      # Version of device
      # @return [String]
      def version
        Artoo::Beaglebone::VERSION
      end

      def digital_write pin, val
        pin = beaglebone_pin pin, :out
        File.open(value_file(pin), 'w') {|f| f.write(val == :high ? "1" : "0") }
      end

      def digital_read pin
        pin = translate_pin pin
        (File.open(value_file(pin), 'r').read == :high ? "1" : "0")
      end

      def i2c_start address
        @i2c_address = address
        i2c_write @i2c_address, 0x00, 0x00
      end

      def i2c_write *data
        ret = [@i2c_address.pack("v")[0]]
        data.each do |n|
          ret.push([n].pack("v")[0])
          ret.push([n].pack("v")[1])
        end
        File.open(i2c2_file, 'r+') {|f| f.write(*ret)}
      end

      def i2c_read len
        File.open(i2c2_file, 'r') {|f| f.read(len)}
      end 

      private

      def translate_pin pin
        begin
          PINS.fetch(pin.upcase.to_sym) 
        rescue Exception => e
          raise "Not a valid pin"
        end
      end

      def beaglebone_pin pin, direction
        pin = translate_pin pin
        File.open("/sys/class/gpio/export", "w") { |f| f.write("#{pin}") }
        File.open(direction_file(pin), "w") { |f| f.write(direction == :out ? "out" : "in") }
        return pin
      end

      def direction_file pin
        "/sys/class/gpio/gpio#{pin}/direction"
      end

      def value_file pin
        "/sys/class/gpio/gpio#{pin}/value"
      end

      def i2c2_file
        "/dev/i2c-1"
      end

    end
  end
end
