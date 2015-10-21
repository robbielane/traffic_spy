class SourceStatistics
  def self.create_payloads(identifier)
    source = Source.find_by_identifier(identifier)
    source.payloads
  end

  def self.top_urls(identifier)
    payloads = create_payloads(identifier)
    payloads.map { |payload| payload.url }
            .group_by { |url| url }
            .map { |k, v| {k => v.count} }
  end

  def self.browser_breakdown(identifier)
    payloads = create_payloads(identifier)
    payloads.map { |payload| UserAgent.parse(payload.user_agent) }
            .group_by { |user_agent| user_agent.browser }
            .map { |k, v| {k => v.count } }
  end
end
