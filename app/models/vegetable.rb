class Vegetable < ApplicationRecord
  has_many :events, dependent: :destroy

  # 関連するイベントの日付を更新するメソッド
  def update_related_event_dates
    events.each do |event|
      # 各野菜のイベントごとの新しい日付を計算
      new_dates = case name.downcase
                  when 'basil'
                    calculate_basil_event_dates(event.name)
                  when 'carrot'
                    calculate_carrot_event_dates(event.name)
                  when 'tomato'
                    calculate_tomato_event_dates(event.name)
                  end

      # 定義した新しい日付でイベントを更新
      event.update(start_date: new_dates[:start_date], end_date: new_dates[:end_date]) if new_dates
    end
  end

  private

  # バジルのイベント日付を計算
  def calculate_basil_event_dates(event_name)
    case event_name
    when '種まき'
      { start_date: sowing_date, end_date: sowing_date }
    when '発芽期間'
      { start_date: sowing_date, end_date: sowing_date + 20.days }
    when '間引き・雑草抜き・害虫駆除'
      { start_date: sowing_date + 20.days, end_date: sowing_date + 60.days }
    when '収穫期間'
      { start_date: sowing_date + 60.days, end_date: sowing_date + 100.days }
    end
  end

  # にんじんのイベント日付を計算
  def calculate_carrot_event_dates(event_name)
    case event_name
    when '種まき'
      { start_date: sowing_date, end_date: sowing_date }
    when '発芽期間'
      { start_date: sowing_date, end_date: sowing_date + 30.days }
    when '間引き・雑草抜き・害虫駆除'
      { start_date: sowing_date + 30.days, end_date: sowing_date + 80.days }
    when '収穫期間'
      { start_date: sowing_date + 80.days, end_date: sowing_date + 160.days }
    end
  end

  # トマトのイベント日付を計算
  def calculate_tomato_event_dates(event_name)
    case event_name
    when '種まき'
      { start_date: sowing_date, end_date: sowing_date }
    when '発芽期間'
      { start_date: sowing_date, end_date: sowing_date + 30.days }
    when '間引き・雑草抜き・害虫駆除'
      { start_date: sowing_date + 30.days, end_date: sowing_date + 90.days }
    when '収穫期間'
      { start_date: sowing_date + 90.days, end_date: sowing_date + 170.days }
    end
  end
end
