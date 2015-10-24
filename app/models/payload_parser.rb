class PayloadParser
  #Maybe we should break this into 2 classes? PayloadParser & PayloadResponse?
  def self.call(params, identifier)
    return PayloadResponse.no_payload if params.nil?
    payload_data = clean_data(params)
    PayloadResponse.create(payload_data, identifier)
  end

  def self.insert_url(url)
    Url.find_or_create_by(path: url).id
  end

  def self.insert_user_agent(user_agent_string)
    agent = UserAgent.parse(user_agent_string)
    Agent.find_or_create_by(platform: agent.platform, browser: agent.browser).id
  end

  def self.insert_request_type(verb)
    RequestType.find_or_create_by(verb: verb).id
  end

  def self.insert_event(event_name)
    Event.find_or_create_by(event_name: event_name).id
  end

  def self.clean_data(params)
    params = JSON.parse(params)
    {
       url_id: insert_url(params["url"]),
       requested_at: params["requestedAt"],
       responded_in: params["respondedIn"],
       referred_by: params["referredBy"],
       request_type_id: insert_request_type(params["requestType"]),
       event_id: insert_event(params["eventName"]),
       agent_id: insert_user_agent(params["userAgent"]),
       resolution_width: params["resolutionWidth"],
       resolution_height: params["resolutionHeight"],
       ip: params["ip"]
     }
  end
end
