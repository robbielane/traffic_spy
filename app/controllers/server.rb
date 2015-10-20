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
      elsif Source.exists?(params[:source])
        status 403
        body source.errors.full_messages.join(", ")
      else
        status 400
        body source.errors.full_messages.join(", ")
      # elsif source.errors.messages[:identifier].first == "has already been taken"
      end
    end

    not_found do
      erb :error
    end
  end
end
