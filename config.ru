require 'rack'

class HttpApp
  def call(env)
    [200, {}, ['Cool']]
  end
end

run HttpApp.new
