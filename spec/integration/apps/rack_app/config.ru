require File.join(__dir__, "app")
require File.join(__dir__, '..',
                  '..',
                  '..',
                  '..',
                  'lib',
                  'sparrow.rb')

use Sparrow::RequestMiddleware
use Sparrow::ResponseMiddleware

run App.new
