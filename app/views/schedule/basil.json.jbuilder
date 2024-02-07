json.array!(@schedules) do |schedule|
  json.title schedule.title
  json.start schedule.start_date.strftime('%Y-%m-%dT%H:%M:%S')
  json.end schedule.end_date.strftime('%Y-%m-%dT%H:%M:%S')
end