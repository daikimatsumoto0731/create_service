class Vegetable < ApplicationRecord
  has_many :events, dependent: :destroy

  # 種まき日を基にして関連するイベントの日付を更新するメソッド
  def update_related_event_dates
    events.each do |event|
      case event.name
      when "種まき"
        event.update!(start_date: sowing_date, end_date: sowing_date + 5.days)
      when "発芽期間"
        event.update!(start_date: sowing_date + 5.days, end_date: sowing_date + 25.days)
      when "間引き・雑草抜き・害虫駆除"
        event.update!(start_date: sowing_date + 25.days, end_date: sowing_date + 65.days)
      when "収穫期間"
        event.update!(start_date: sowing_date + 65.days, end_date: sowing_date + 105.days)
      end
    end
  end
end
