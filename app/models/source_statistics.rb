class SourceStatistics
  attr_reader :identifier

  def initialize(identifier)
    @identifier = identifier
  end

  def payloads
    @payloads ||= Source.find_by_identifier(@identifier).payloads
  end

  def source
    Source.find_by_identifier(identifier)
  end

  def count_occurences_of(attribute)
    payloads.group(attribute).count
  end
end
