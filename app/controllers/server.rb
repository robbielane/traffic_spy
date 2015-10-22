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
      @identifier = identifier
      if !Source.find_by_identifier(identifier)
        erb :identifier_not_found
      else
        @url_count = SourceStatistics.new(identifier).top_urls
        @browser_count = SourceStatistics.new(identifier).browser_breakdown
        @os_count = SourceStatistics.new(identifier).os_breakdown
        @screen_res_count = SourceStatistics.new(identifier).screen_resolutions
        @url_response_times = SourceStatistics.new(identifier).url_response_times
        erb :stats
      end
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @identifier = identifier
      @relative_path = relative_path
      if Source.check_if_path_exists(identifier, relative_path)
        @response_times = SourceStatistics.new(identifier).response_times
        erb :relative_path_stats
      else
        erb :relative_path_not_found
      end
    end

    get '/sources/:identifier/events' do |identifier|
      @identifier = identifier
      @events = SourceStatistics.new(identifier).events
      if @events.empty?
        @error_message = "No events have been defined"
      else
        @error_message = ""
      end
      erb :events
    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      @identifier = identifier
      @event_name = event_name
      @event_hourly_breakdown = SourceStatistics.new(identifier).event_hourly_breakdown(event_name)
      erb :event_details
    end

    not_found do
      erb :error
    end
  end
end
