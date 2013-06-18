# Triad

[![Build Status](https://travis-ci.org/saturnflyer/triad.png?branch=master)](https://travis-ci.org/saturnflyer/triad)
[![Code Climate](https://codeclimate.com/github/saturnflyer/triad.png)](https://codeclimate.com/github/saturnflyer/triad)
[![Coverage Status](https://coveralls.io/repos/saturnflyer/triad/badge.png)](https://coveralls.io/r/saturnflyer/triad)
[![Gem Version](https://badge.fury.io/rb/triad.png)](http://badge.fury.io/rb/triad)

A Triad is like a Set, or three-part array.

A Triad is a collection of items each with a `key`, `descriptor`, and `value`.

```ruby
user = Object.new

map = Triad.new
map << [:admin, 'Admin', user]

map.keys('Admin') #=> [:admin]
map.values('Admin') #=> [user]
map.descriptors('Admin') #=> ['Admin'] or raise DescriptorNotPresent

map.descriptors(user) #=> ['Admin']
map.keys(user) #=> [:admin]
map.values(user) #=> [user] or raise ValueNotPresent

map.values(:admin) #=> [user]
map.descriptors(:admin) #=> ['Admin']
map.keys(:admin) #=> [:admin] or raise KeyNotPresent

map.each do |key, descriptor, value|
  #...
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'triad'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install triad

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
