class PayloadResponse
  def self.create(data, identifier)
    source = Source.find_by_identifier(identifier)
    if source.nil?
      app_not_registered
    elsif Payload.exists?(data)
      payload_already_recieved
    else
      source.payloads.create(data)
      success
    end
  end

  def self.no_payload
    [400, {}, "Payload not received"]
  end

  def self.app_not_registered
    [403, {}, "Application Not Registered"]
  end

  def self.success
    [200, {}, ""]
  end

  def self.payload_already_recieved
    [403, {}, "Payload already received"]
  end
end
