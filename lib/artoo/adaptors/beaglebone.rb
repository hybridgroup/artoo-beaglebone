require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a beaglebone device
    # @see device documentation for more information
    class Beaglebone < Adaptor
      finalizer :finalize
      attr_reader :device

      # Closes connection with device if connected
      # @return [Boolean]
      def finalize
        disconnect if connected?
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
      def name
        "beaglebone"
      end

      # Version of device
      # @return [String]
      def version
        Artoo::Beaglebone::VERSION
      end

      # Uses method missing to call device actions
      # @see device documentation
      def method_missing(method_name, *arguments, &block)
        device.send(method_name, *arguments, &block)
      end
    end
  end
end
