class Payload < ActiveRecord::Base
  belongs_to :source
  belongs_to :url
  belongs_to :agent
end
