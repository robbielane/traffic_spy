module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      status, additional_headers, body = SourceParser.call(params[:source])
      status status
      headers \
        additional_headers
      body body
    end

    not_found do
      erb :error
    end
  end
end
