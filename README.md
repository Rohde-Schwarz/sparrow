# CamelCaser

A Rack middleware for converting the params keys and JSON response keys of a Rack application.

## Installation

Add this line to your application's Gemfile:

    gem 'camel_caser'

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

## Configuration

There are various configuration options as well as HTTP headers available to
make the middleware act as you want it to.

in your configuration file (such as application.rb if you are using Rails)

```
CamelCaser.configure do |config|
  config.excluded_routes = [
    Regexp.new('api/model/certificates')
  ]
end
```

There are several options available

| Option | Example | Meaning |
|--------|---------|----------------------|
| **excluded_routes** | see above | An Array of Strings an/or Regexps defining which paths should not be touched by the middleware. The entries should matchs paths for your application. They should *not* start with a leading slash. |
|**default_json_request_key_transformation_strategy**|underscore|Defines how the middleware should treat incoming parameters via Request. Which means how they get tranformed, i.e. defining _underscore_ here means that incoming parameters get underscore. Possible values are _underscore_ and _camelize_|
|**default_json_response_key_transformation_strategy**|camelize|Same as *default_json_request_key_transformation_strategy, but for responses. I.e. this defines to which format the keys get transformed when the response gets sent.
|**json_request_format_header**|request-json-format|Defines the HTTP Header key which sets the request transformation strategy as in *default_json_request_key_transformation_strategy*. This definition has higher priority than the default definition. Possible values for this Header are the same as for *default_json_request_key_transformation_strategy*|
|**json_response_format_header**|response-json-format|Same as *json_request_format_header*, but for the response handling|
|**camelize_ignore_uppercase_keys** | true | don´t camelize Keys that are all Uppercase, like CountryCodes "EN" ... |

## Tests

Just run `rspec` and you are off to go. This runs the whole suite including
specs for unit- & integrationtests for Rails and Rack.
