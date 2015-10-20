module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      status 400
      body "RootUrl can't be blank"
    end

    not_found do
      erb :error
    end
  end
end
