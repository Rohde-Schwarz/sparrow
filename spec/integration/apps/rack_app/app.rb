class App

  def call(env)
    params = env["rack.input"].gets
    response = Rack::Response.new
    response['Content-Type'] = 'application/json'
    response.write(json_response(params))
    response.finish
  end

  private

  def json_response(params)
    hsh_params = MultiJson.load(params)
    keys = hsh_params.reduce([]) do |result, (key, value)|
      result << key
      if value.is_a?(Hash)
        result << value.keys
      end
      result
    end
    MultiJson.dump({
                       keys: keys.join(","),
                       fakeKey: true,
                       fake_key: false
                   })
  end
end
