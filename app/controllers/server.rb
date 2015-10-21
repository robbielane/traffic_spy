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
        @url_count = SourceStatistics.top_urls(identifier)
        @browser_count = SourceStatistics.browser_breakdown(identifier)
        erb :stats
      end
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @identifier = identifier
      @relative_path = relative_path
      erb :relative_path_stats
    end

    not_found do
      erb :error
    end
  end
end
