require_relative 'source_statistics'

class RelativePathStatistics < SourceStatistics
  def response_times
    { :longest => payloads.maximum(:responded_in),
      :shortest => payloads.minimum(:responded_in),
      :average => payloads.average(:responded_in) }
  end

  def http_verbs
    source.request_types.pluck(:verb)
  end

  def top_user_agents
    source.agents.group(:browser).count
  end
end
