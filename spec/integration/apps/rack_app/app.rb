class App

  def call(env)
    @env = env
    params = env["rack.input"].gets
    @params = MultiJson.load(params || '{}')
    header = {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }

    response = Rack::Response.new(
      json_response(params),
      status,
      header)
    response.finish
  end

  private

  def status
    path = @env['PATH_INFO']
    if path =~ /error$/
      @params['errorCode'] || 500
    else
      200
    end
  end

  def json_response(params)
    hsh_params = @params
    keys = hsh_params.reduce([]) do |result, (key, value)|
      result << key
      if value.is_a?(Hash)
        result << value.keys
      end
      result
    end.flatten
    MultiJson.dump({
                       keys: keys,
                       fakeKey: true,
                       fake_key: false
                   })
  end
end
