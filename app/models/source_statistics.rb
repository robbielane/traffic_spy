class SourceStatistics
  def initialize(identifier)
    @identifier = identifier
  end

  def payloads
    @payloads ||= Source.find_by_identifier(@identifier).payloads
  end

  def top_urls
    payloads.map { |payload| payload.url }
            .group_by { |url| url }
            .map { |k, v| {k => v.count} }
  end

  def browser_breakdown
    payloads.map { |payload| UserAgent.parse(payload.user_agent) }
            .group_by { |user_agent| user_agent.browser }
            .map { |k, v| {k => v.count } }
  end

  def response_times
    times = payloads.map { |payload| payload.responded_in}
    average = (times.reduce(:+) / times.count)
    { :longest => times.max, :shortest => times.min, :average => average }
  end

  def events
    event_names = payloads.map { |payload| payload.event_name }
                          .group_by { |event_name| event_name }
    event_count = {}
    event_names.each do |event_name, event|
      event_count[event_name] = event.count
    end
    event_count
  end
end
