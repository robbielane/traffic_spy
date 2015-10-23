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

  # SHOULD BE DELETED (I didn't wanna change anything in the views while you're working on them)
  def top_referrers
    payloads.map { |payload| payload.referred_by }
            .group_by { |referrer| referrer }
            .map { |k, v| {k => v.count } }
  end

  def top_user_agents
    payloads.map { |payload| UserAgent.parse(payload.user_agent).browser }
            .group_by { |agent| agent }
            .map { |k, v| {k => v.count } }
  end
end
