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
      status, additional_headers, body = PayloadParser.call(params[:payload], identifier)
      status status
      headers \
        additional_headers
      body body
    end

    get '/sources/:identifier' do |identifier|
      if !Source.find_by_identifier(identifier)
        erb :identifier_not_found, locals: {identifier: identifier}
      else
        @root_url = Source.find_by_identifier(identifier).root_url
        @source_statistics = IdentifierStatistics.new(identifier)
        erb :stats
      end
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @relative_path = relative_path
      if Source.check_if_path_exists(identifier, relative_path)
        @relative_path_stats = RelativePathStatistics.new(identifier)
        erb :relative_path_stats
      else
        erb :relative_path_not_found
      end
    end

    get '/sources/:identifier/events' do |identifier|
      @identifier = identifier
      @events = EventStatistics.new(identifier).events
      if @events.empty?
        @error_message = "No events have been defined"
        erb :events_error
      else
        @error_message = ""
      end
      erb :events
    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      @identifier = identifier
      @event_name = event_name
      if Source.event_exists?(identifier, event_name)
        @event_statistics = EventStatistics.new(identifier)
        erb :event_details
      else
        erb :event_detail_error
      end
    end

    not_found do
      erb :error
    end
  end
end
