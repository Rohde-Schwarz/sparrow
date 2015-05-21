require File.join(File.dirname(__FILE__), "app")
require File.join(File.dirname(__FILE__), '..',
                  '..',
                  '..',
                  '..',
                  'lib',
                  'sparrow.rb')

use Sparrow::RequestMiddleware
use Sparrow::ResponseMiddleware

run App.new
