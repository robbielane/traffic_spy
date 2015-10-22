require_relative 'source_statistics'

class RelativePathStatistics < SourceStatistics
  def response_times
    times = payloads.map { |payload| payload.responded_in}
    average = (times.reduce(:+) / times.count)
    { :longest => times.max, :shortest => times.min, :average => average }
  end

  def http_verbs
    payloads.map { |payload| payload.request_type }
            .uniq
  end

  def top_user_agents
    payloads.map { |payload| UserAgent.parse(payload.user_agent).browser }
            .group_by { |agent| agent }
            .map { |k, v| {k => v.count } }
  end
end
