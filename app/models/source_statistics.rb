class SourceStatistics
  attr_reader :identifier

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

  def count_occurences_of(attribute)
    # TODO: use for refactoring in top_urls and browser_breakdown if we can pass in attribute..?
    # all stats methods should be at the same level of abstraction
    payloads.map { |payload| payload.attribute }
            .group_by { |attribute| attribute }
            .map { |k, v| {k => v.count } }
  end
end
