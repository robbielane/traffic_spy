class ApiRelativePathStatistics
  def self.call(identifier)
    source = Source.find_by_identifier(identifier)
    urls = source.urls.pluck(:path).uniq
    data = {}
    urls.each do |url|
      relative_path = url.sub("#{source.root_url}/", "")
      data[url] = data_for_url(identifier, relative_path)
    end
    data
  end

  def self.data_for_url(identifier, relative_path)
    relative = RelativePathStatistics.new(identifier, relative_path)
    {response_times: relative.response_times,
     user_agent_breakdown: relative.top_user_agents,
     referrers: relative.count_occurences_of(:referred_by),
     request_types: relative.http_verbs}
   end
end
