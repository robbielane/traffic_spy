require './test/test_helper'

class IdentifierStatistics < SourceStatistics
  def top_urls
    source.urls.group(:path).count
  end

  def browser_breakdown
    source.agents.group(:browser).count
  end

  def os_breakdown
    source.agents.group(:platform).count
  end

  def screen_resolutions
    resolutions = payloads.map { |payload| "#{payload.resolution_width} x #{payload.resolution_height}"}
                          .group_by { |resolution| resolution }

    resolution_count = {}
    resolutions.each { |resolution, count| resolution_count[resolution] = count.count}
    resolution_count
  end

  def url_response_times
    urls = source.urls.pluck(:path).uniq
    urls.map { |url| [url, calculate_average_response_time(url)] }.to_h
  end

  def calculate_average_response_time(url)
    url_id = Url.find_by_path(url)
    payloads.where(url_id: url_id).average(:responded_in).to_f
  end
end
