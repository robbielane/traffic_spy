class Source < ActiveRecord::Base
  has_many :payloads
  has_many :urls, through: :payloads
  has_many :agents, through: :payloads
  has_many :request_types, through: :payloads
  has_many :events, through: :payloads
  has_many :resolutions, through: :payloads

  validates_presence_of :identifier, :root_url
  validates :identifier, uniqueness: true

  def self.check_if_path_exists(identifier, relative_path)
    source = Source.find_by_identifier(identifier)
    full_path = "#{source.root_url}/#{relative_path}"
    source.urls.exists?(path: full_path)
  end

  def self.event_exists?(identifier, event)
    source = Source.find_by_identifier(identifier)
    source.events.exists?(event_name: event)
  end
end
