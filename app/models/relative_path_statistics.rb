require_relative 'source_statistics'

class RelativePathStatistics < SourceStatistics
  attr_reader :relative_path, :source, :url_id

  def initialize(identifier, relative_path)
    @source = Source.find_by_identifier(identifier)
    @url_id = Url.find_by_path("#{source.root_url}/#{relative_path}").id
    @relative_path = source.payloads.where(url_id: url_id)
    @identifier = identifier
  end

  def response_times
    { :longest => relative_path.maximum(:responded_in).round(2),
      :shortest => relative_path.minimum(:responded_in).round(2),
      :average => relative_path.average(:responded_in).round(2) }
  end

  def http_verbs
    relative_path.includes(:request_type).pluck(:verb).uniq
  end

  def top_user_agents
    relative_path.includes(:agent).pluck(:browser)
                 .group_by { |browser| browser }
                 .map { |browser, count| [browser, count.count] }
                 .to_h
  end

  def top_referrers
    relative_path.group(:referred_by).count
  end
end
