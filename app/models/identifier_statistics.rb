require './test/test_helper'

class IdentifierStatistics < SourceStatistics
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
    urls = payloads.map(&:url).uniq
    averages = calculate_average_response_times(urls)
    urls.zip(averages).to_h
  end

  def calculate_average_response_times(urls)
    url_responses = urls.map do |url|
      payloads.where(url: url).map { |payload| payload.responded_in }
    end
    url_responses.map { |times| (times.reduce(0, :+) / times.count) }
  end
end
