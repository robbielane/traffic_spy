class ApiEventStatistics
  def self.call(identifier)
    source = Source.find_by_identifier(identifier)
    events = source.events.pluck(:event_name)
    data = {}
    events.each do |event|
      data[event] = data_for_event(identifier, event)
    end
    data
  end

  def self.data_for_event(identifier, event)
    event_statistics = EventStatistics.new(identifier)
    event_statistics.event_hourly_breakdown(event)
  end
end
