module TrafficSpy
  class Server < Sinatra::Base
    helpers do
      def link_to_source_statistics(identifier)
        "<a class='waves-effect waves-light btn red lighten-2' href='/sources/<%= identifier %>'><i class='material-icons left'>business</i>Site Statistics</a>"
      end
    end

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
      if Source.find_by_identifier(identifier).nil?
        erb :identifier_not_found, locals: {identifier: identifier}
      else
        @root_url = Source.find_by_identifier(identifier).root_url
        @source_statistics = IdentifierStatistics.new(identifier)
        erb :stats
      end
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @relative_path = relative_path
      @identifier    = identifier
      if Source.check_if_path_exists(identifier, relative_path)
        @relative_path_stats = RelativePathStatistics.new(identifier)
        erb :relative_path_stats
      else
        erb :relative_path_not_found
      end
    end

    get '/sources/:identifier/events' do |identifier|
      @identifier = identifier
      source = Source.find_by_identifier(identifier)
      @events = source.events.group(:event_name).count
      if @events.empty?
        erb :events_error
      else
        erb :events
      end
    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      @event_name = event_name
      @event_statistics = EventStatistics.new(identifier)
      if Source.event_exists?(identifier, event_name)
        erb :event_details
      else
        erb :event_error
      end
    end

    not_found do
      erb :error
    end
  end
end
