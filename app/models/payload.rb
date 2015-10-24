class Payload < ActiveRecord::Base
  belongs_to :source
  belongs_to :url
  belongs_to :agent
  belongs_to :request_type
  belongs_to :event
end
