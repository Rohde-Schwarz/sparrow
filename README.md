# CamelCaser

A POC to have a Rack middleware parsing the params keys into underscore if a
request header is configured properly:

```
 {'json-format': 'underscore'}  
```

## Installation

Add this line to your application's Gemfile:

    gem 'camel_caser', github: 'dsci/camel_caser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install camel_caser

## Usage

If you're using Rails, that's it. You haven't to do anything more. If you're not using Rails, you will have to add to your config.ru:

```rb
require 'camel_caser'

use CamelCaser::Middleware
```

## Tests

You have to run Rack and Rails tests separate:

```
rspec spec/rack
```

and

```
rspec spec/rails
```


## Contributing

1. Fork it ( http://github.com/dsci/camel_caser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
