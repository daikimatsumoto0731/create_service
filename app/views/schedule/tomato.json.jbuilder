json.array!(@schedules) do |schedule|
  json.extract! schedule, :id, :title, :body
  json.start schedule.start_date
  json.end schedule.end_date
  json.url custom_schedule_path
end
