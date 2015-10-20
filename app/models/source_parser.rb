class SourceParser
  def self.call(params)
    params = clean_data(params)
    source = Source.new(params)
    return success(source) if source.save
    return forbidden(source) if Source.exists?(params)
    return bad_request(source)
  end

  def self.clean_data(params)
    {:root_url => params[:rootUrl], :identifier => params[:identifier]}
  end

  def self.success(source)
    [200, {"identifier" => source.identifier}, "Success"]
  end

  def self.forbidden(source)
    [403, {}, source.errors.full_messages.join(", ")]
  end

  def self.bad_request(source)
    [400, {}, source.errors.full_messages.join(", ")]
  end

end
