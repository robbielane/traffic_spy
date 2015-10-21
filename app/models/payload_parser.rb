class PayloadParser
  def self.call(params, identifier)
    return no_payload if params.nil?
    payload_data = clean_data(params)
    create_response(payload_data, identifier)
  end

  def self.create_response(data, identifier)
    source = Source.find_by_identifier(identifier)
    if !source
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

  def self.clean_data(params)
    params = JSON.parse(params)
    {
       url: params[:url],
       requested_at: params[:requestedAt],
       responded_in: params[:respondedIn],
       reffered_by: params[:referredBy],
       request_type: params[:requestType],
       event_name: params[:eventName],
       user_agent: params[:userAgent],
       resolution_width: params[:resolutionWidth],
       resolution_height: params[:resolutionHeight],
       ip: params[:ip],
     }
  end
end
