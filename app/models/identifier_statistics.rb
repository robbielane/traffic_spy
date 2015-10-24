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
    source.resolutions.group(:width, :height).count
  end

  def url_response_times
    urls = source.urls.pluck(:path).uniq
    urls.map { |url| [url, calculate_average_response_time(url)] }.to_h
  end

  def calculate_average_response_time(url)
    url_id = Url.find_by_path(url)
    payloads.where(url_id: url_id).average(:responded_in).to_f.round(2)
  end
end
