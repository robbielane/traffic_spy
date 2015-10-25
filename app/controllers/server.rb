module TrafficSpy
  class Server < Sinatra::Base
    helpers do
      def link_to_source_statistics(identifier)
        "<a class='waves-effect waves-light btn red lighten-2' href='/sources/#{identifier}'><i class='material-icons left'>business</i>Site Statistics</a>"
      end

      def protected!
        return if authorized?
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized"
      end

      def authorized?
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
      end
    end

    get '/sources/:identifier/events.json' do |identifier|
      content_type :json
      ApiEventStatistics.call(identifier).to_json
    end

    get '/sources/:identifier/urls.json' do |identifier|
      content_type :json
      ApiRelativePathStatistics.call(identifier).to_json
    end

    get '/sources/*.json' do |identifier|
      content_type :json
      ApiIndentifierStatistics.call(identifier).to_json
    end
    
    get '/' do
      redirect '/sources'
    end

    get '/sources' do
      @sources = Source.all
      erb :source_index
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
      protected!
      if Source.find_by_identifier(identifier).nil?
        erb :identifier_not_found, locals: {identifier: identifier}
      else
        @root_url = Source.find_by_identifier(identifier).root_url
        @source_statistics = IdentifierStatistics.new(identifier)
        erb :stats
      end
    end

    get '/sources/:identifier/urls' do |identifier|
      @source = Source.find_by_identifier(identifier)
      @source_statistics = IdentifierStatistics.new(identifier)
      erb :url_index
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @relative_path = relative_path
      @identifier    = identifier
      if Source.check_if_path_exists(identifier, relative_path)
        @relative_path_stats = RelativePathStatistics.new(identifier, relative_path)
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
