class SourceParser
  def self.call(params)
    source_data = clean_data(params)
    create_response(source_data)
  end

  def self.create_response(params)
    source = Source.new(params)
    if source.save
      success(source)
    elsif Source.exists?(params)
      forbidden(source)
    else
      bad_request(source)
    end
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
