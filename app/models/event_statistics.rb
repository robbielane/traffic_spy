require_relative 'source_statistics'

class EventStatistics < SourceStatistics
  def event_hourly_breakdown(event_name)
    payloads.pluck(:event_id, :requested_at)
            .group_by { |event, time| time }
            .map { |time, events| [hours_map.fetch(DateTime.parse(time).hour), events.count] }
            .to_h
  end

  def hours_map
    { 0 => "12 am - 1 am",
      1 => "1 am - 2 am",
      2 => "2 am - 3 am",
      3 => "3 am - 4 am",
      4 => "4 am - 5 am",
      5 => "5 am - 6 am",
      6 => "6 am - 7 am",
      7 => "7 am - 8 am",
      8 => "8 am - 9 am",
      9 => "9 am - 10 am",
      10 => "10 am - 11 am",
      11 => "11 am - 12 pm",
      12 => "12 pm - 1 pm",
      13 => "1 pm - 2 pm",
      14 => "2 pm - 3 pm",
      15 => "3 pm - 4 pm",
      16 => "4 pm - 5 pm",
      17 => "5 pm - 6 pm",
      18 => "6 pm - 7 pm",
      19 => "7 pm - 8 pm",
      20 => "8 pm - 9 pm",
      21 => "9 pm - 10 pm",
      22 => "10 pm - 11 pm",
      23 => "11 pm - 12 am"
    }
  end
end
