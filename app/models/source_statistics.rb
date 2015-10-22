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

  def os_breakdown
    payloads.map { |payload| UserAgent.parse(payload.user_agent) }
            .group_by { |user_agent| user_agent.platform }
            .map { |k, v| {k => v.count } }
  end

  def screen_resolutions
    resolutions = payloads.map { |payload| "#{payload.resolution_width} x #{payload.resolution_height}"}
                          .group_by { |resolution| resolution }

    resolution_count = {}
    resolutions.each { |resolution, count| resolution_count[resolution] = count.count}
    resolution_count
  end

  def url_response_times
    urls = payloads.map { |payload| payload.url }.uniq
    averages = calculate_average_response_times(urls)
    urls.zip(averages).to_h
  end

  def calculate_average_response_times(urls)
    url_responses = urls.map do |url|
      payloads.where(url: url).map do |payload|
        response_time_sums = payload.responded_in
      end
    end
    url_responses.map { |times| (times.reduce(0, :+) / times.count) }
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

  def event_hourly_breakdown(event_name)
    times_requested = payloads.where(event_name: event_name)
                              .map { |payload| DateTime.parse(payload.requested_at).hour }

    times_grouped = times_requested.group_by { |time| time }

    hours_count = {}
    times_grouped.each do |time, occurences|
      hours_count[hours_map.fetch(time)] = occurences.count
    end
    hours_count
  end

  def http_verbs
    payloads.map { |payload| payload.request_type }
            .uniq
  end

  def top_referrers
    payloads.map { |payload| payload.referred_by }
            .group_by { |referrer| referrer }
            .map { |k, v| {k => v.count } }
  end

  def top_user_agents
    payloads.map { |payload| UserAgent.parse(payload.user_agent).browser }
            .group_by { |agent| agent }
            .map { |k, v| {k => v.count } }
  end

  def hours_map
    { 0 => "12 am - 1 am",
      1 => "1 am - 2 am",
      2 => "2 am - 3 am",
      3 => "3 am - 4 am",
      4 => "4 am - 5 am",
      5 => "5 am - 6 am",
      6 => "6 am - 7 am",
      7 => "7 am - 8 am",
      8 => "8 am - 9 am",
      9 => "9 am - 10 am",
      10 => "10 am - 11 am",
      11 => "11 am - 12 pm",
      12 => "12 pm - 1 pm",
      13 => "1 pm - 2 pm",
      14 => "2 pm - 3 pm",
      15 => "3 pm - 4 pm",
      16 => "4 pm - 5 pm",
      17 => "5 pm - 6 pm",
      18 => "6 pm - 7 pm",
      19 => "7 pm - 8 pm",
      20 => "8 pm - 9 pm",
      21 => "9 pm - 10 pm",
      22 => "10 pm - 11 pm",
      23 => "11 pm - 12 am"
    }
  end

  def count_occurences_of(attribute)
    # TODO: use for refactoring in top_urls and browser_breakdown if we can pass in attribute..?
    # all stats methods should be at the same level of abstraction
    payloads.map { |payload| payload.attribute }
            .group_by { |attribute| attribute }
            .map { |k, v| {k => v.count } }
  end
end
