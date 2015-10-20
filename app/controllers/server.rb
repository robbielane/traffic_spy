module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      status, additional_headers, body = SourceParser.call(params)
      status status
      headers \
        additional_headers
      body body
    end

    post '/sources/:identifier/data' do |identifier|
      if !params[:payload]
        status 400
        return "Payload not received"
      end

      if !Source.find_by_identifier(identifier)
        status 403
        return "Application Not Registered"
      end

      payload_data = {
         url: params[:url],
         requested_at: params[:requestedAt],
         responded_in: params[:respondedIn],
         reffered_by: params[:referredBy],
         request_type: params[:requestType],
         event_name: params[:eventName],
         user_agent: params[:userAgent],
         resolution_width: params[:resolutionWidth],
         resolution_height: params[:resolutionHeight],
         ip: params[:ip],
       }

      payload = Payload.new(payload_data)
      # binding.pry
      if Payload.exists?(payload_data)
        status 403
        "Payload already received"
      elsif payload.save
        status 200
      end

    end

    not_found do
      erb :error
    end
  end
end
