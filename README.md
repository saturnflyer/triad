# Triad

A Triad is like a Set, or three-part array.

A Triad is a collection of items each with a `key`, `descriptor`, and `value`.

```ruby
user = Object.new

map = Triad.new
map << [:admin, 'Admin', user]

map.key('Admin') #=> :admin
map.value('Admin') #=> user
map.descriptor('Admin') #=> 'Admin' or raise DescriptorNotPresent

map.descriptor(user) #=> 'Admin'
map.key(user) #=> :admin
map.value(user) #=> user or raise ValueNotPresent

map.value(:admin) #=> user
map.descriptor(:admin) #=> 'Admin'
map.key(:admin) #=> :admin or raise KeyNotPresent

map.each do |key, descriptor, value|
  #...
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'triad'

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
