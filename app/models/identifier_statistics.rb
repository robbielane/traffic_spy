require './test/test_helper'

class IdentifierStatistics < SourceStatistics
  # def top_urls
  #   payloads.map { |payload| payload.url }
  #           .group_by { |url| url }
  #           .map { |k, v| {k => v.count} }
  #   # payloads.group(:url).count
  #   # pass in key to count_occurences_of
  # end

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
end
