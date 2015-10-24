class ApiIndentifierStatistics
  def self.call(identifier)
    identifier_stats = IdentifierStatistics.new(identifier)
    {top_urls: identifier_stats.top_urls,
     browser_breakdown: identifier_stats.browser_breakdown,
     os_breakdown: identifier_stats.os_breakdown,
     screen_resolutions: identifier_stats.screen_resolutions,
     average_response_times: identifier_stats.url_response_times}
  end
end
