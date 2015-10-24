require_relative 'source_statistics'

class RelativePathStatistics < SourceStatistics
  def response_times
    { :longest => payloads.maximum(:responded_in),
      :shortest => payloads.minimum(:responded_in),
      :average => payloads.average(:responded_in) }
  end

  def http_verbs
    payloads.select(:request_type).distinct.map(&:request_type)
  end

  def top_user_agents
    source.agents.group(:browser).count
  end
end
