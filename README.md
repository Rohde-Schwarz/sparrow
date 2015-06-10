# Sparrow

A Rack middleware for converting the params keys and JSON response keys of a Rack application.

## Installation

Add this line to your application's Gemfile:

    gem 'cp-sparrow', require: 'sparrow'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cp-sparrow

## Usage

If you're using Rails, that's it. You haven't to do anything more. If you're not using Rails, you will have to add to your config.ru:

```rb
require 'sparrow'

use Sparrow::Middleware
```

## Configuration

There are various configuration options as well as HTTP headers available to
make the middleware act as you want it to.

in your configuration file (such as application.rb if you are using Rails)

```ruby
Sparrow.configure do |config|
  config.excluded_routes = [
    Regexp.new('api/model/certificates')
  ]
end
```

There are several options available

| Option | Example | Meaning |
|---------|---------|----------------------|
| excluded_routes | see above | An Array of Strings and/or Regexps defining which paths should not be touched by the middleware. The entries should matchs paths for your application. They should *not* start with a leading slash. |
| default_json_request_key_transformation_strategy | "underscore" | Defines how the middleware should treat incoming parameters via Request. Which means how they get tranformed, i.e. defining _underscore_ here means that incoming parameters get underscore. Possible values are _underscore_ and _camelize_ |
| default_json_response_key_transformation_strategy | "camelize" | Same as *default_json_request_key_transformation_strategy, but for responses. I.e. this defines to which format the keys get transformed when the response gets sent.
| json_request_format_header| "request-json-format" | Defines the HTTP Header key which sets the request transformation strategy as in default_json_request_key_transformation_strategy*. This definition has higher priority than the default definition. Any valid HTTP Header String value is possible. Defaults to 'request-json-format' |
| json_response_format_header| "response-json-format" | Same as *json_request_format_header*, but for the response handling. Defaults to 'response-json-format' |
| camelize_ignore_uppercase_keys | `true` | A boolean that indicates to not camelize keys that are all Uppercase, like CountryCodes "EN" ... |
| allowed_content_types |`['application/json', 'text/x-json']` | A list of HTTP content types upon which the middleware shall trigger and possibly start  conversion. Defaults to `['application/json', 'application/x-www-form-urlencoded', 'text/x-json']`. If `nil` is present in the list, requests/responses with *no* Content-Type header will be processed as well. Possible values can also be the start of the content-type-header like ```application/``` which matches everything which starts with ```application/``` like ```application/json```  |
| allowed_accepts | `['application/json', 'text/x-json']` | Same as **allowed_content_types**, but reacts to the HTTP Accept Header. Applies to the same possible options, behavior. Defaults to the same set of MIME types, but also includes `nil` by default, which ignores checking the Accept header in default configuration |

## Tests

Just run `rake` and you are off to go. This runs the whole suite including
specs for unit- & integrationtests for Rails and Rack including different versions of Rails.

If you want to test a specific version of Rails:

```
export RAILS_VERSION=3.2.17; bundle update; bundle exec rspec
```
