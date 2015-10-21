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
      source = Source.find_by_identifier(identifier)
      payloads = source.payloads

      urls = payloads.map do |payload|
        payload.url
      end

      @url_count = urls.group_by { |url| url }
                       .map { |k, v| {k => v.count} }

      erb :stats_page
    end

    not_found do
      erb :error
    end
  end
end
