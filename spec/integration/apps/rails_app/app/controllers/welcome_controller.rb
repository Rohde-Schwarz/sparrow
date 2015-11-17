class WelcomeController < ApplicationController
  def index
    render json: {}
  end

  def show
    render json: {keys: extract_keys, fakeKey: true, fake_key: false}
  end

  def ignore
    render json: {keys: extract_keys, camelCase: false, snake_case: true}
  end

  def non_json_text_response
    render text: "----- BEGIN PUBLIC KEY -----\n#{extract_keys}\n----- END PUBLIC KEY -----"
  end

  def non_json_binary_response
    file = File.join(Rails.root, 'app', 'assets', 'images', 'grumpy-cat.gif')

    send_file(file, filename: "#{params}.gif")
  end

  def posts
    render json: {keys: extract_keys}
  end

  def array_of_elements
    render json:  [
                    {fake_key: "foo"},
                    {fake_key: "bar"}
                  ]
  end

  def upcase_first_name
    name = params[:user_options][:first_name]
    params[:user_options][:first_name] = name.upcase

    render json: params
  end

  private
  def extract_keys
    not_acceptable_keys = %w(controller format default action welcome)
    params.reduce([]) do |result, (key, value)|
      unless key.in?(not_acceptable_keys)
        result << key
        if value.is_a?(Hash)
          result << value.keys
        end
      end
      result
    end.flatten
  end
end
