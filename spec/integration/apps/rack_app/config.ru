require File.join(File.dirname(__FILE__), "app")
require File.join(File.dirname(__FILE__), '..',
                                          '..',
                                          '..',
                                          '..',
                                          'lib', 
                                          'camel_caser.rb')

use CamelCaser::RequestMiddleware
use CamelCaser::ResponseMiddleware

run App.new
