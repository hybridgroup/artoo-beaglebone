require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a beaglebone device
    # @see device documentation for more information
    class Beaglebone < Adaptor
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

      def digital_write controller, val
        pin = beaglebone_pin controller, :out
        File.open(value_file(pin), 'w') {|f| f.write(val == :high ? "1" : "0") }
      end

      def digital_read controller
        pin = translate_pin controller
        (File.open(value_file(pin), 'r').read == :high ? "1" : "0")
      end

      private

      def translate_pin controller
        case controller.first[0]
        when :gpio0
          pin = 0 + controller.first[1]
        when :gpio1
          pin = 32 + controller.first[1]
        when :gpio2
          pin = 64 + controller.first[1]
        when :gpio3
          pin = 96 + controller.first[1]
        else
          raise "Not a valid gpio controller"
        end

        return pin
      end

      def beaglebone_pin controller, direction
        pin = translate_pin controller
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

    end
  end
end
