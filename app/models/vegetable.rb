class Vegetable < ApplicationRecord
  has_many :events, dependent: :destroy

  # 種まき日を基にして関連するイベントの日付を更新するメソッド
  def update_related_event_dates
    events.each do |event|
      start_date, end_date = calculate_event_dates(event.name)

      if end_date < start_date
        puts "Validation Error for #{event.name}: End date (#{end_date}) is before start date (#{start_date})"
      else
        event.update!(start_date: start_date, end_date: end_date)
      end
    end
  end

  private

  # イベント名に基づいて開始日と終了日を計算するメソッド
  def calculate_event_dates(event_name)
    case event_name
    when "種まき"
      [sowing_date, sowing_date + duration_days(event_name)]
    else
      [sowing_date + duration_days(event_name, :start), sowing_date + duration_days(event_name, :end)]
    end
  end

  # イベント名とフェーズ（:start または :end）に基づいて適切な日数を返すメソッド
  def duration_days(event_name, phase = nil)
    case name
    when "バジル"
      case event_name
      when "種まき" then 5.days
      when "発芽期間" then phase == :start ? 5.days : 25.days
      when "間引き・雑草抜き・害虫駆除" then phase == :start ? 25.days : 65.days
      when "収穫期間" then phase == :start ? 65.days : 105.days
      end
    when "にんじん"
      case event_name
      when "種まき" then 10.days
      when "発芽期間" then phase == :start ? 10.days : 40.days
      when "間引き・雑草抜き・害虫駆除" then phase == :start ? 40.days : 90.days
      when "収穫期間" then phase == :start ? 90.days : 170.days
      end
    when "トマト"
      case event_name
      when "種まき" then 5.days
      when "発芽期間" then phase == :start ? 5.days : 35.days
      when "間引き・雑草抜き・害虫駆除" then phase == :start ? 35.days : 95.days
      when "収穫期間" then phase == :start ? 95.days : 175.days
      end
    end
  end
end
