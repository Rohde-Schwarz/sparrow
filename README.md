# Sparrow

A Rack middleware for converting the params keys and JSON response keys of a Rack application.

[![Build Status](https://travis-ci.org/GateprotectGmbH/sparrow.svg?branch=master)](https://travis-ci.org/GateprotectGmbH/sparrow) [![Gem Version](https://badge.fury.io/rb/cp-sparrow.svg)](http://badge.fury.io/rb/cp-sparrow)

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

use Sparrow::RequestMiddleware
use Sparrow::ResponseMiddleware
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

Options may be:

### excluded_routes

> `Array(String|Regexp)`. Default: `[]`

An Array of Strings and/or Regexps defining which paths should not be touched by the middleware. The entries should matchs paths for your application. They should *not* start with a leading slash.

Example:
`config.excluded_routes = ['api/model/certificates']`


### default_json_request_key_transformation_strategy

> `String`. Default: `underscore`

Defines how the middleware should treat incoming parameters via Request. Which means how they get tranformed, i.e. defining _underscore_ here means that incoming parameters get underscore. Possible values are _underscore_ and _camelize_

Example:
`config.default_json_request_key_transformation_strategy = "underscore"`

### default_json_response_key_transformation_strategy

> `String`. Default: `camelize`

Same as **default_json_request_key_transformation_strategy**, but for responses. I.e. this defines to which format the keys get transformed when the response gets sent.

Example:
`config.default_json_response_key_transformation_strategy = "camelize"`

### json_request_format_header

> `String`. Default: `request-json-format`

Defines the HTTP Header key which sets the request transformation strategy as in default_json_request_key_transformation_strategy*. This definition has higher priority than the default definition. Any valid HTTP Header String value is possible. Defaults to `request-json-format`.

Example:
> `config.json_request_format_header = "request-json-format"`


### json_response_format_header

> `String`. Default: `response-json-format`

Same as **json_request_format_header**, but for the response handling. Defaults to `response-json-format`

Example:
`config.json_response_format_header = "response-json-format"`

### camelize_ignore_uppercase_keys

> `Boolean`. Default: `true`

A boolean that indicates to not camelize keys that are all Uppercase, like CountryCodes "EN", etc.

Example:
`config.camelize_ignore_uppercase_keys = true `

### allowed_content_types

> `Array(String)`. Default: `%w[application/json application/x-www-form-urlencoded text/x-json]`

A list of HTTP content types upon which the middleware shall trigger and possibly start  conversion. Defaults to `['application/json', 'application/x-www-form-urlencoded', 'text/x-json']`. If `nil` is present in the list, requests/responses with *no* Content-Type header will be processed as well. Possible values can also be the start of the content-type-header like ```application/``` which matches everything that starts with ```application/``` like ```application/json```

Example:
`config.allowed_content_types = ['application/json', 'text/x-json']`

### allowed_accepts

> `Array(String)`. Default: `['application/json', 'application/x-www-form-urlencoded', 'text/x-json', nil]`

Same as [allowed_content_types], but reacts to the HTTP Accept Header. Applies to the same possible options, behavior. Defaults to the same set of MIME types, but also includes `nil` by default, which ignores checking the Accept header in default configuration

Example:
`config.allowed_accepts = ['application/json', 'text/x-json']`

### enable_logging

> `Boolean`. Default: `false`

Determines logging while the middleware is active. Primary output is which conversion strategy gets chosen upon which request/response.

Example:
`config.enable_logging = true`

### camelize_strategy

> `Symbol`. Default: `:lower`

Defines which strategy to use when camelizing keys. Possible options are `:lower` and `:upper`, which tells the middleware to 
start camelized keys with an uppercased character or with a lowercased character.

Example:
`config.camelize_strategy = :lower`

## Tests

Just run `rake` and you are off to go. This runs the whole suite including
specs for unit- & integrationtests for Rails and Rack including different versions of Rails.

If you want to test a specific version of Rails:

```
export RAILS_VERSION=3.2.17; bundle update; bundle exec rspec
```
