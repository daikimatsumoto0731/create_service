json.array!(@schedules) do |schedule|
  json.extract! schedule, :id, :title, :body
  json.start schedule.start_date
  json.end schedule.end_date
  # スケジュールの詳細ページへのリンクが必要な場合は、対応するルーティングを設定し、
  # ここでそのURLを生成します。現在の設定では custom_schedule のパスを使用します。
  json.url custom_schedule_path
end
