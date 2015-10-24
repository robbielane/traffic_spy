class ApiRelativePathStatistics
  def self.call(identifier)
    relative = RelativePathStatistics.new(identifier)
    {response_times: relative.response_times,
     user_agent_breakdown: relative.top_user_agents,
     referrers: relative.count_occurences_of(:referred_by),
     request_types: relative.http_verbs}
  end
end
