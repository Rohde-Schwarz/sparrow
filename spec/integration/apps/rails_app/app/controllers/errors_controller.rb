class ErrorsController < ApplicationController
  def error
    # let's cause a server error by doing something stupid here
    0 / 0
  end

  def error_507
    render json: {error_code: 507}, status: 507
  end
end
