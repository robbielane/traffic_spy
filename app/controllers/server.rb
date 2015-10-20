module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      source = Source.new(params[:source])
      if source.save
        headers \
          "identifier" => source.identifier
        body "Success"
      else
        status 400
        body source.errors.full_messages.join(", ")
      end
    end

    not_found do
      erb :error
    end
  end
end
