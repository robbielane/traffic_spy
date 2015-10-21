class Source < ActiveRecord::Base
  has_many :payloads

  validates_presence_of :identifier, :root_url
  validates :identifier, uniqueness: true

  def self.check_if_path_exists(identifier, relative_path)
    source = Source.find_by_identifier(identifier)
    payloads = source.payloads

    full_path = "#{source.root_url}/#{relative_path}"

    urls = payloads.map { |payload| payload.url }
    urls.include?(full_path)
  end
end
