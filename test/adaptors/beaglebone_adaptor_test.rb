require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/beaglebone'

describe Artoo::Adaptors::Beaglebone do
  before do
    @adaptor = Artoo::Adaptors::Beaglebone.new
  end

  describe "device info interface" do
    it "#firmware_name" do
      @adaptor.firmware_name.must_equal "Beaglebone"
    end

    it "#version" do
      @adaptor.version.must_equal Artoo::Beaglebone::VERSION
    end
  end

  describe "digital GPIO interface" do
    it "#digital_read" do
      @pin = mock('pin')
      @adaptor.expects(:beaglebone_pin).with(:P1_1, "r").returns(@pin)
      @pin.expects(:digital_read).returns(true)
      
      @adaptor.digital_read(:P1_1).must_equal true
    end

    it "#digital_write" do
      @pin = mock('pin')
      @adaptor.expects(:beaglebone_pin).with(:P1_1, "w").returns(@pin)
      @pin.expects(:digital_write).with(true)
      
      @adaptor.digital_write(:P1_1, true)
    end
  end

  describe "i2c interface" do
    it "#i2c_start" do
      @adaptor.expects(:i2c2_file).returns '/a/file'
      @i2c = mock('i2c')
      Artoo::Adaptors::IO::I2c.expects(:new).with('/a/file', 0xFF).returns(@i2c)

      @adaptor.i2c_start 0xFF
    end

    it "#i2c_read" do
      @i2c = mock('i2c')
      @i2c.expects(:read).with(6)
      @adaptor.expects(:i2c).returns @i2c
      
      @adaptor.i2c_read 6
    end

    it "#i2c_write" do
      @i2c = mock('i2c')
      @i2c.expects(:write).with(0x01, 0x03, 0x05)
      @adaptor.expects(:i2c).returns @i2c
      
      @adaptor.i2c_write 0x01, 0x03, 0x05
    end
  end
end
