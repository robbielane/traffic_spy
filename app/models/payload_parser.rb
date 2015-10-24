class PayloadParser
  #Maybe we should break this into 2 classes? PayloadParser & PayloadResponse?
  def self.call(params, identifier)
    return no_payload if params.nil?
    payload_data = clean_data(params)
    create_response(payload_data, identifier)
  end

  def self.create_response(data, identifier)
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

  def self.insert_url(url)
    Url.find_or_create_by(path: url).id
  end

  def self.insert_user_agent(user_agent_string)
    agent = UserAgent.parse(user_agent_string)
    Agent.find_or_create_by(platform: agent.platform, browser: agent.browser).id
  end

  def self.clean_data(params)
    params = JSON.parse(params)
    {
       url_id: insert_url(params["url"]),
       requested_at: params["requestedAt"],
       responded_in: params["respondedIn"],
       referred_by: params["referredBy"],
       request_type: params["requestType"],
       event_name: params["eventName"],
       agent_id: insert_user_agent(params["userAgent"]),
       resolution_width: params["resolutionWidth"],
       resolution_height: params["resolutionHeight"],
       ip: params["ip"]
     }
  end
end
