# Artoo Adaptor For Beaglebone

This repository contains the Artoo (http://artoo.io/) adaptor for the [Beaglebone Black](http://beagleboard.org/Products/BeagleBone+Black/).

Artoo is a open source micro-framework for robotics using Ruby.

For more information about Artoo, check out our repo at https://github.com/hybridgroup/artoo

## Installing

```
gem install artoo-beaglebone
```

## Using

```ruby
require 'artoo'

connection :beaglebone, :adaptor => :beaglebone
device :led, :driver => :led, :pin => :P9_12

work do
  every 1.second do
    led.on? ? led.off : led.on
  end
end
```

## Getting Started

The fastest way to get started with your Beaglebone Black is to use our provided [image](https://github.com/hybridgroup/artoo-beaglebone/wiki/artoo-image-instructions)
